require "spec_helper"
require "generator_spec"
require "generators/rails_cosmos/install_generator"

RSpec.describe RailsCosmos::Generators::InstallGenerator, type: :generator do
  destination File.expand_path("../../tmp", __FILE__)

  before(:all) do
    prepare_destination
    run_generator
  end

  it "creates the operation directory and file" do
    expect(1).to eq 1
    expect(File).to exist("#{destination_root}/app/operations/application_operation.rb")
  end
end
