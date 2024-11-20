# frozen_string_literal: true

module RailsCosmos
  module Http
    # RailsCosmos::Http::Response
    #
    # A wrapper around HTTP responses to provide a consistent interface for handling
    # API responses. This class parses JSON responses and provides helper methods to
    # check response success.
    #
    # @example Creating a response instance
    #   response = RailsCosmos::Http::Response.new(faraday_response)
    #
    # @example Accessing response attributes
    #   response.status # => 200
    #   response.body   # => { "key" => "value" }
    #   response.success? # => true
    #
    # @attr_reader [Hash] body The parsed response body as a Hash.
    # @attr_reader [Integer] status The HTTP status code.
    # @attr_reader [String, nil] raw_body The raw response body as a string, or nil if absent.
    class Response
      attr_reader :body, :status, :raw_body

      def initialize(response)
        @raw_body = response.body.present? ? response.body : {}
        @body = response.body.present? ? JSON.parse(response.body) : {}
        @status = response.status
      end

      def success?
        (200..299).include?(status)
      end
    end
  end
end
