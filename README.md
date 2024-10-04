# RailsCosmos

![Gem Version](https://img.shields.io/gem/v/rails_cosmos.svg)
![GitHub Actions Workflow Status](https://img.shields.io/github/actions/workflow/status/diligasi/rails_cosmos/main.yml)
![GitHub top language](https://img.shields.io/github/languages/top/diligasi/rails_cosmos)
![GitHub code size in bytes](https://img.shields.io/github/languages/code-size/diligasi/rails_cosmos)
[![License](https://img.shields.io/github/license/diligasi/rails_cosmos.svg)](https://github.com/diligasi/rails_cosmos/blob/main/LICENSE)

`rails_cosmos` is a Ruby on Rails gem designed to streamline and promote the use of the COSMOS architecture (Controller, Operation, Service, Model, and Serializer) in Rails projects. This gem provides a set of generators and utilities that assist in setting up and maintaining the architecture, making it easier to follow clean, maintainable, and scalable design patterns.

## Table of Contents

- [Installation](#installation)
- [Usage](#usage)
    - [Generators](#generators)
        - [Operation Generator](#operation-generator)
    - [Testing Framework Support](#testing-framework-support)
- [Architecture Overview](#architecture-overview)
    - [COSMOS in Rails](#cosmos-in-rails)
- [Contributing](#contributing)
- [License](#license)

## Installation

Add the gem to your `Gemfile`:

```ruby
gem 'rails_cosmos'
```

Then, run:

```bash
bundle install
```

After installing, you can run the install generator to set up base files for COSMOS:

```bash
rails generate rails_cosmos:install
```

This will generate the necessary base files, including the `ApplicationOperation` class, which serves as the foundation for your operations.

## Usage

### Generators

The core functionality of `rails_cosmos` revolves around its generators. These generators help to quickly scaffold various parts of your COSMOS architecture.

#### Operation Generator

You can create a new operation by running:

```bash
rails generate rails_cosmos:operation OPERATION_NAME [NAMESPACE]
```

- **OPERATION_NAME**: The name of the operation you want to create.
- **NAMESPACE** (optional): If you want the operation to be placed under a namespace (e.g., `User`, `Admin`), you can specify it here.

For example, if you want to create a `CreateUser` operation under the `Admin` namespace:

```bash
rails generate rails_cosmos:operation create_user admin
```

This will generate:

- `app/operations/admin/create_user.rb`
- A corresponding test file (RSpec or MiniTest) based on the detected testing framework.

##### Operation Template

Each generated operation follows a simple template that inherits from `ApplicationOperation`:

```ruby
module Admin
  class CreateUser < ApplicationOperation
    def initialize(log_uuid: nil)
      super(log_uuid:)
    end

    def call
      # Add your business logic here
      success
    end
  end
end
```

### Testing Framework Support

`rails_cosmos` detects the testing framework in use (RSpec or MiniTest) and automatically generates test files for your operations:

- If **RSpec** is detected, test files will be generated under the `spec/operations` directory.
- If **MiniTest** is detected, test files will be generated under the `test/operations` directory.
- If neither is detected, test generation is skipped with a warning.

## Architecture Overview

### COSMOS in Rails

The COSMOS architecture is a modular approach to organizing Rails applications. It separates concerns into five key components:

1. **Controller**: Responsible for handling HTTP requests and routing them to the appropriate operation or service.
2. **Operation**: Contains the core business logic. This is the entry point for any action that the system performs.
3. **Service**: Used for interacting with external services or complex internal logic that doesn't belong in an operation.
4. **Model**: Represents the database entities, typically the ActiveRecord models.
5. **Serializer**: Transforms the model data into the desired JSON or XML format for API responses.

By using this architecture, you can achieve a clean, maintainable, and scalable codebase. Each part of the system has a clear responsibility, promoting SOLID principles and testability.

### ApplicationOperation

At the core of the `rails_cosmos` gem is the `ApplicationOperation`, which serves as the base class for all operations. This class provides common functionality, such as logging, error handling, and success/failure result tracking.

You can customize and extend `ApplicationOperation` to suit your project’s needs.

## Contributing

We welcome contributions to the `rails_cosmos` gem!

To contribute:

1. Fork the repository.
2. Create a new feature branch.
3. Make your changes and add tests where necessary.
4. Ensure all tests pass.
5. Submit a pull request with a detailed explanation of your changes.

Make sure to follow our [contribution guidelines](CONTRIBUTING.md) (placeholder).

Bug reports and pull requests are welcome on GitHub at https://github.com/diligasi/rails_cosmos.

### Running Tests

To run the test suite:

```bash
bundle exec rspec
```

Or, if you're using MiniTest:

```bash
bundle exec rake test
```

## Code of Conduct

Everyone interacting in the RailsCosmos project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/diligasi/rails_cosmos/blob/main/CODE_OF_CONDUCT.md).

## License

`rails_cosmos` is open-source software licensed under the [MIT License](https://opensource.org/licenses/MIT).
