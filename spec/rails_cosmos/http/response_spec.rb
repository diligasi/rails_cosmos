require_relative "../../spec_helper"
require "rails_cosmos/http/response"

RSpec.describe RailsCosmos::Http::Response do
  let(:status) { 200 }
  let(:body) { { "message" => "success" }.to_json }
  let(:response_double) { instance_double("Faraday::Response", body: body, status: status) }

  subject(:http_response) { described_class.new(response_double) }

  describe "#initialize" do
    context "when the response has a body" do
      it "assigns the parsed body to @body" do
        expect(http_response.body).to eq("message" => "success")
      end

      it "assigns the raw body to @raw_body" do
        expect(http_response.raw_body).to eq(body)
      end

      it "assigns the status to @status" do
        expect(http_response.status).to eq(status)
      end
    end

    context "when the response body is nil" do
      let(:body) { nil }

      it "assigns an empty hash to @body" do
        expect(http_response.body).to eq({})
      end

      it "assigns an empty hash to @raw_body" do
        expect(http_response.raw_body).to eq({})
      end
    end

    context "when the response body is empty" do
      let(:body) { "" }

      it "assigns an empty hash to @body" do
        expect(http_response.body).to eq({})
      end

      it "assigns an empty hash to @raw_body" do
        expect(http_response.raw_body).to eq({})
      end
    end
  end

  describe "#success?" do
    context "when the status code is in the 2xx range" do
      it "returns true" do
        expect(http_response.success?).to be true
      end
    end

    context "when the status code is not in the 2xx range" do
      let(:status) { 404 }

      it "returns false" do
        expect(http_response.success?).to be false
      end
    end
  end
end
