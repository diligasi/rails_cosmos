# frozen_string_literal: true

require "rails/generators"

module RailsCosmos
  module Generators
    class InstallGenerator < ::Rails::Generators::Base # :nodoc:
      source_root File.expand_path("../templates", __dir__)

      def create_operation_base
        operations_dir = "app/operations"

        empty_directory(operations_dir) unless Dir.exist?(operations_dir)

        template "application_operation.rb", "#{operations_dir}/application_operation.rb",
                 force: file_exists_prompt("#{operations_dir}/application_operation.rb")
      end

      private

      def file_exists_prompt(file)
        return true unless File.exist?(file)

        yes?("File #{file} already exists. Do you want to overwrite it?")
      end
    end
  end
end
