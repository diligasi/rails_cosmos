require "spec_helper"
require "generator_spec"
require "generators/rails_cosmos/install_generator"

RSpec.describe RailsCosmos::Generators::OperationGenerator, type: :generator do
  destination File.expand_path("tmp/generators", __dir__)

  before do
    prepare_destination
  end

  describe "without a namespace" do
    it "creates an operation file in the app/operations directory" do
      run_generator %w[CreateUser]

      assert_file "app/operations/create_user.rb", /class CreateUser < ApplicationOperation/
    end

    it "creates an RSpec test file if RSpec is detected" do
      allow(File).to receive(:exist?).with(anything).and_call_original
      allow(File).to receive(:exist?).with(File.join(destination_root, "spec/spec_helper.rb")).and_return(true)

      run_generator %w[CreateUser]

      assert_file "spec/operations/create_user_spec.rb", /RSpec.describe CreateUser, type: :operation do/
    end

    it "skips test file creation if no test framework is detected" do
      allow(File).to receive(:exist?).with(anything).and_call_original
      allow(File).to receive(:exist?).with(File.join(destination_root, "spec/spec_helper.rb")).and_return(false)
      allow(File).to receive(:exist?).with(File.join(destination_root, "test/test_helper.rb")).and_return(false)

      run_generator %w[CreateUser]

      expect(destination_root).not_to have_structure {
        directory "spec/operations" do
          file "create_user_spec.rb"
        end
        directory "test/operations" do
          file "create_user_test.rb"
        end
      }
    end
  end

  describe "with a namespace" do
    it "creates an operation file in the appropriate namespace directory" do
      run_generator %w[CreateUser Admin]

      assert_file "app/operations/admin/create_user.rb", /module Admin\r\n  class CreateUser < ApplicationOperation/
    end

    it "creates an RSpec test file in the appropriate namespace directory if RSpec is detected" do
      allow(File).to receive(:exist?).with(anything).and_call_original
      allow(File).to receive(:exist?).with(File.join(destination_root, "spec/spec_helper.rb")).and_return(true)

      run_generator %w[CreateUser Admin]

      assert_file "spec/operations/admin/create_user_spec.rb", /RSpec.describe Admin::CreateUser, type: :operation do/
    end
  end
end
