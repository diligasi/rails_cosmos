# frozen_string_literal: true

require "rails_cosmos"

module RailsMocks
  def stub_rails_filter_parameters(params)
    mock_config = double("Config", filter_parameters: params)
    mock_application = double("Application", config: mock_config)
    allow(Rails).to receive(:application).and_return(mock_application)
  end

  def stub_faraday_connection(client, stubs)
    client.instance_variable_set(:@conn, Faraday.new { |faraday| faraday.adapter :test, stubs })
  end
end

RSpec.configure do |config|
  tmp_dir = File.join(Dir.pwd, "spec", "tmp")
  FileUtils.rm_rf(tmp_dir) if Dir.exist?(tmp_dir)

  config.include RailsMocks

  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
