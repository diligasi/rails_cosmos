# frozen_string_literal: true

RSpec.describe RailsCosmos do
  it "has a version number" do
    expect(RailsCosmos::VERSION).not_to be nil
  end

  it "defines Http as an alias for RailsCosmos::Http" do
    expect(RailsCosmos::Http).to eq(RailsCosmos::Http)
  end

  it "Http alias works correctly" do
    expect(Http).to eq(RailsCosmos::Http)
  end
end
