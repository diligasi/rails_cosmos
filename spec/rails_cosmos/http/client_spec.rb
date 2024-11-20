require_relative "../../spec_helper"
require "rails_cosmos/http/client"

RSpec.describe RailsCosmos::Http::Client do
  let(:url) { "https://api.example.com" }
  let(:service) { "ExampleService" }
  let(:adapter) { :test }
  let(:client) { described_class.new(url: url, service: service, adapter: adapter) }
  let(:logger) { instance_double("Logger", info: nil, error: nil) }

  before do
    allow(Rails).to receive(:logger).and_return(logger)
    allow(Time).to receive(:zone).and_return(Time)
  end

  shared_examples "a shorthand HTTP method" do |http_method|
    it "defines a shorthand method for ##{http_method}" do
      expect(client).to respond_to(http_method)
    end

    it "calls #request with the correct method for ##{http_method}" do
      allow(client).to receive(:request)

      client.public_send(http_method, "/test", payload: { key: "value" }, headers: { "Header" => "Value" })

      expect(client).to have_received(:request).with(http_method, "/test", payload: { key: "value" }, headers: { "Header" => "Value" })
    end
  end

  describe "#initialize" do
    it "initializes with correct attributes" do
      expect(client.instance_variable_get(:@url)).to eq(url)
      expect(client.instance_variable_get(:@service)).to eq(service)
      expect(client.instance_variable_get(:@adapter)).to eq(adapter)
      expect(client.instance_variable_get(:@conn)).to be_a(Faraday::Connection)
    end
  end

  describe "#request" do
    let(:method) { :post }
    let(:endpoint) { "/test" }
    let(:payload) { { key: "value" } }
    let(:headers) { { "Authorization" => "Bearer token" } }
    let(:response_body) { { message: "success" }.to_json }
    let(:response_status) { 200 }

    before do
      stub_rails_filter_parameters([:password])
      stubs = Faraday::Adapter::Test::Stubs.new do |stub|
        stub.send(method, endpoint) { [response_status, { "Content-Type" => "application/json" }, response_body] }
      end
      stub_faraday_connection(client, stubs)
    end

    it "sends an HTTP request and returns a Response object" do
      response = client.request(method, endpoint, payload: payload, headers: headers)

      expect(response).to be_a(RailsCosmos::Http::Response)
      expect(response.status).to eq(response_status)
      expect(response.body).to eq(JSON.parse(response_body))
    end

    it "logs the request and response" do
      client.request(method, endpoint, payload: payload, headers: headers)

      expect(Rails.logger).to have_received(:info).with(/HTTP Request | ExampleService -- method=#{method}/)
      expect(Rails.logger).to have_received(:info).with(/HTTP Response | ExampleService -- success=true status=#{response_status}/)
    end
  end

  describe "shorthand methods" do
    it_behaves_like "a shorthand HTTP method", :get
    it_behaves_like "a shorthand HTTP method", :post
    it_behaves_like "a shorthand HTTP method", :put
    it_behaves_like "a shorthand HTTP method", :patch
    it_behaves_like "a shorthand HTTP method", :delete
  end

  describe "#filter_sensitive_data" do
    let(:payload) { { password: "secret", username: "user", deep_hash: { token: "also a secret", foo: "bar" } } }

    before do
      stub_rails_filter_parameters([:password, :token])
    end

    it "filters sensitive data in the payload" do
      filtered_payload = client.send(:filter_sensitive_data, payload)

      expect(filtered_payload[:password]).to eq("[FILTERED]")
      expect(filtered_payload[:username]).to eq("user")
      expect(filtered_payload[:deep_hash]).to be_a(Hash)
      expect(filtered_payload.dig(:deep_hash, :token)).to eq("[FILTERED]")
      expect(filtered_payload.dig(:deep_hash, :foo)).to eq("bar")
    end
  end
end
