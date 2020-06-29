# RspecContracts

1. Do you have an API with an OpenAPI3 schema?
2. Do you test your API with Rspec request tests?
3. Do you want to make sure your API conforms to your schema?

If you answered "yes" to all three, you want contract testing. Since we couldn't find a contract testing plugin for Rspec that we liked, we built our own.


## Installation
Add this line to your application's Gemfile:

```ruby
gem 'rspec_contracts'
```

And then execute:
```bash
$ bundle
```

Or install it yourself as:
```bash
$ gem install rspec_contracts
```

## Usage

If you write Rspec request tests, you'll recognize this:

```ruby
  let(:api_call) { get pets_path }
```

It's a simple `get` request, performed within Rspec. Adding contract testing is as simple as this:

```ruby
  let(:file) { "spec/fixtures/petstore.yaml" }
  let(:contract) { RspecContracts::Contract.new(YAML.load_file(file)) }

  let(:api_call) { get pets_path, api_operation: contract["findPets"] } # 'findPets' is the operation ID for this path
```

When the API call is actually made, RspecContracts will automatically validate the specified operation against the path, POST body (if one exists), and the response. Any validation errors will raise an exception, halting your tests and telling you that you've broken your API.

## Configuration

In `rails_helper.rb`:

```ruby
RSpec.configure do |config|
  config.before(:each) do
    # These are all the default values. Nothing to do if you want to accept the defaults
    RspecContracts.config.base_path = "" 
    RspecContracts.config.request_validation_mode = :raise # Valid modes are `raise`, `log`, and `ignore`
    RspecContracts.config.response_validation_mode = :raise # Valid modes are `raise`, `log`, and `ignore`
    RspecContracts.config.path_validation_mode = :raise # Valid modes are `raise`, `log`, and `ignore`
    RspecContracts.config.logger = Rails.logger 
  end
end
```

Each of these configuration values can be changed for a specific test. EG:

```ruby
  before { RspecContracts.config.request_validation_mode = :ignore }
  after { RspecContracts.config.request_validation_mode = :raise } # Don't forget to set it back to the default
```

## Versioning

Sometimes, you'll be developing an API endpoint that doesn't officially exist yet, and you don't want contract validation errors to halt your test suite. That's where semantic version matching saves the day.

RspecContracts will automatically determine the version of the API schema, which you can use to gate certain API operations.

For example, let's say you're adding a new API endpoint, and it doesn't officially exist in your public documentation yet.

In this example, the schema version is `"1.0.0"`, but the new endpoint won't exist until `"1.1.0"`:

```ruby
  let(:file) { "spec/fixtures/petstore.yaml" }
  let(:contract) { RspecContracts::Contract.new(YAML.load_file(file)) }

  let(:api_call) { get pets_path, api_operation: contract["findPets"], api_version: ">= 1.1.0" }

```

Because the schema is only at version `"1.0.0"`, RspecContracts will skip validating the contract for this API call.

Version constraints accept the same format as bundler in your Gemfile, so all of these would be valid:

```ruby
  let(:api_call) { get pets_path, api_operation: contract["findPets"], api_version: "~> 1.1.0" }
  let(:api_call) { get pets_path, api_operation: contract["findPets"], api_version: ">= 1.1.0, < 2" }
  let(:api_call) { get pets_path, api_operation: contract["findPets"], api_version: "1.1.0" }
```

This is useful for deprecated API endpoints & new API endpoints.

#### Caveat about version matching

It is recommended to always load whatever the canonical version of your public-facing API schema into the test suite for your CI pipeline on production deployments. How you do this will change depending on how your CI pipeline is configured and how you distribute your API schema.

In general, an API schema meant for 3rd-party development use _should_ be public anyway, which will make this step easier.

## Raised exceptions, explained

### `RspecContracts::Error::OperationLookup`

This exception means the contract you've loaded does not have a definition for the operation you're trying to test

### `RspecContracts::Error::PathValidation`

The operation you're trying to test does not match either the HTTP method, or the path for the API request.

### `RspecContracts::Error::RequestValidation`

The POST body (if one is present) does not match the schema for a valid request as defined by the given operation.

### `RspecContracts::Error::ResponseValidation`

The response body does not match the schema for a valid response as defined by the given operation.


## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
