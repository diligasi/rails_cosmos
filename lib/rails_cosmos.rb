# frozen_string_literal: true

require_relative "rails_cosmos/version"
require_relative "rails_cosmos/http/client"
require_relative "rails_cosmos/http/response"
require_relative "generators/rails_cosmos/install_generator"
require_relative "generators/rails_cosmos/operation_generator"

module RailsCosmos
  class Error < StandardError; end
end

Http = RailsCosmos::Http
