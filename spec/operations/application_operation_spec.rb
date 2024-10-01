require_relative "../spec_helper"
require "generators/templates/application_operation"

RSpec.describe ApplicationOperation, type: :operation do
  # Dummy operation classes for testing
  class SuccessOperation < ApplicationOperation
    def initialize(param, log_uuid: nil)
      super(log_uuid: log_uuid)
      @param = param
    end

    def call
      success("Success message", additional_data: @param)
    end
  end

  class FailingOperation < ApplicationOperation
    def initialize(param, log_uuid: nil)
      super(log_uuid: log_uuid)
      @param = param
    end

    def call
      raise StandardError, "Intentional error"
    end
  end

  let(:logger) { instance_double("Logger", info: nil, error: nil) }

  before do
    allow(Rails).to receive(:logger).and_return(logger)
    allow(Time).to receive(:zone).and_return(Time)
  end

  describe ".call" do
    context "when the operation succeeds" do
      it "returns a successful response with additional data" do
        result = SuccessOperation.call("test_param")

        expect(result[0]).to eq(true)
        expect(result[1]).to eq("Success message")
        expect(result[2]).to eq(additional_data: "test_param")
      end

      it "logs the success" do
        allow(Rails.logger).to receive(:info)
        SuccessOperation.call("test_param")

        expect(Rails.logger).to have_received(:info).with(/Started/)
        expect(Rails.logger).to have_received(:info).with(/Completed/)
      end
    end

    context "when the operation fails" do
      it "returns a failure response with an error" do
        result = FailingOperation.call("test_param")

        expect(result[0]).to eq(false)
        expect(result[1]).to be_a(StandardError)
        expect(result[1].message).to eq("Intentional error")
      end

      it "logs the failure" do
        allow(Rails.logger).to receive(:error)
        FailingOperation.call("test_param") rescue nil

        expect(Rails.logger).to have_received(:info).with(/Started/)
        expect(Rails.logger).to have_received(:error).with(/Failed with error/)
      end
    end
  end
end
