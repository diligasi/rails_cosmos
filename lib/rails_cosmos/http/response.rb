# frozen_string_literal: true

module RailsCosmos
  module Http
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
