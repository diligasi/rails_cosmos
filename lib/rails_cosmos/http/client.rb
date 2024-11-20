# frozen_string_literal: true

require "faraday"
require "faraday_middleware"

module RailsCosmos
  module Http
    # RailsCosmos::Http::Client
    #
    # A wrapper around Faraday for making HTTP requests with enhanced logging and
    # error handling. This class provides a simple interface for sending requests
    # to external APIs and logging request/response details for observability.
    #
    # @example Creating a client instance
    #   client = RailsCosmos::Http::Client.new(
    #     url: "https://api.example.com",
    #     service: "ExampleService",
    #     adapter: :typhoeus
    #   )
    #
    # @example Making a GET request
    #   response = client.get("/endpoint", headers: { "Authorization" => "Bearer token" })
    #
    # @example Making a POST request with a payload
    #   response = client.post(
    #     "/endpoint",
    #     payload: { key: "value" },
    #     headers: { "Content-Type" => "application/json" }
    #   )
    #
    # @attr_reader [String] url The base URL for the HTTP client.
    # @attr_reader [String] service The name of the service for logging purposes.
    # @attr_reader [Symbol] adapter The Faraday adapter to use for making requests.
    class Client
      def initialize(url:, service:, adapter: :typhoeus)
        @url = url
        @service = service
        @adapter = adapter
        @conn = build_connection
      end

      def request(method, endpoint, payload: {}, headers: {})
        start_at = Time.zone.now
        response = @conn.send(method, endpoint) do |req|
          req.headers = headers
          req.body = payload.to_json if %i[post put patch delete].include?(method)
          log_request(method: method, url: req.path, headers: headers, payload: payload)
        end

        response_time = Time.zone.now - start_at

        log_response(
          method: method, success: response.success?,
          time: response_time, status: response.status, url: endpoint,
          headers: response.headers, body: response.body
        )

        Response.new(response)
      end

      # Shorthand methods
      %i[get post put patch delete].each do |http_method|
        define_method(http_method) do |endpoint, payload: {}, headers: {}|
          request(http_method, endpoint, payload: payload, headers: headers)
        end
      end

      private

      def build_connection
        Faraday.new(url: @url) do |conn|
          conn.request :json
          conn.response :json, content_type: /\bjson$/
          conn.use FaradayMiddleware::FollowRedirects, limit: 5
          conn.adapter @adapter
        end
      end

      def log_request(method:, url:, headers:, payload:)
        Rails.logger.info "HTTP Request | #{@service} -- method=#{method} url=#{url} headers=#{headers} payload=#{filter_sensitive_data(payload)}"
      end

      def log_response(success:, time:, status:, method:, url:, headers:, body:)
        Rails.logger.info "HTTP Response | #{@service} -- success=#{success} status=#{status} time=#{time} method=#{method} url=#{url} headers=#{headers} body=#{body}"
      end

      def filter_sensitive_data(payload)
        return payload unless payload.is_a?(Hash)

        payload.each_with_object({}) do |(key, value), result|
          result[key] = if value.is_a?(Hash)
                          filter_sensitive_data(value)
                        elsif Rails.application.config.filter_parameters.include?(key)
                          "[FILTERED]"
                        else
                          value
                        end
        end
      end
    end
  end
end
