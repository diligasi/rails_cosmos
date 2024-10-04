# frozen_string_literal: true

require "rails/generators/named_base"

module RailsCosmos
  module Generators
    # This generator creates a new operation class within the `app/operations` directory.
    # Optionally, you can specify a namespace, and it will create a subdirectory based on that namespace.
    #
    # Example usage:
    #
    #   rails generate operation NAME NAMESPACE
    #
    # If a namespace is provided, the generated operation will be placed inside a folder corresponding to
    # the namespace within `app/operations`. If no namespace is provided, the operation will be created
    # directly within the `app/operations` directory.
    #
    # This generator also creates a test file for the operation. If RSpec is detected, the test will be
    # placed under `spec/operations`, and if MiniTest is detected, it will be placed under `test/operations`.
    # If neither test framework is detected, the test generation will be skipped with a warning.
    #
    # Arguments:
    #   NAME        - The name of the operation (required).
    #   NAMESPACE   - The namespace for the operation (optional).
    #
    # Example:
    #
    #   rails generate rails_cosmos:operation create_user admin
    #
    # This will generate:
    #
    #   app/operations/admin/create_user.rb
    #   spec/operations/admin/create_user_spec.rb (if RSpec is used)
    #   or
    #   test/operations/admin/create_user_test.rb (if MiniTest is used)
    #
    class OperationGenerator < Rails::Generators::NamedBase
      source_root File.expand_path("../templates", __dir__)

      argument :namespace, type: :string, optional: true, desc: "Optional namespace for the operation"

      def create_operation_file
        operation_directory = operation_directory_path
        operation_file = "#{operation_directory}/#{file_name}.rb"

        empty_directory operation_directory
        template "operation_template.rb.tt", operation_file
      end

      def create_test_file
        if rspec_installed?
          create_rspec_test_file
        elsif minitest_installed?
          create_minitest_test_file
        else
          say_status("warning", "No supported test framework found. Skipping test file generation.", :yellow)
        end
      end

      private

      def file_name
        name.underscore
      end

      def operation_directory_path
        namespace ? File.join("app/operations", namespace.underscore) : "app/operations"
      end

      def test_directory_path
        if namespace
          namespace_dir = namespace.underscore
          rspec_installed? ? File.join("spec/operations", namespace_dir) : File.join("test/operations", namespace_dir)
        else
          rspec_installed? ? "spec/operations" : "test/operations"
        end
      end

      def rspec_installed?
        File.exist?(File.join(destination_root, "spec/spec_helper.rb"))
      end

      def minitest_installed?
        File.exist?(File.join(destination_root, "test/test_helper.rb"))
      end

      def create_rspec_test_file
        empty_directory test_directory_path
        template "rspec_operation_test.rb.tt", File.join(test_directory_path, "#{file_name}_spec.rb")
      end

      def create_minitest_test_file
        empty_directory test_directory_path
        template "minitest_operation_test.rb.tt", File.join(test_directory_path, "#{file_name}_test.rb")
      end
    end
  end
end
