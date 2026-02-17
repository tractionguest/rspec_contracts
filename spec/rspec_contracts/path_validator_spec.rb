# frozen_string_literal: true

require "rails_helper"

describe "API contract path validation", type: :request do
  subject(:api_call) { post pets_path, params: post_params, as: :json, api_operation: contract["addPet"] }

  let(:file) { "spec/fixtures/petstore.yaml" }
  let(:contract) { RspecContracts::Contract.new(YAML.safe_load_file(file, permitted_classes: [Symbol, Date, Time])) }

  context "when path does not match the operation" do
    subject(:api_call) { post "/bad_create_route", params: post_params, as: :json, api_operation: contract["addPet"] }

    let(:post_params) { attributes_for :pet }

    context "when raising path validation errors" do
      it { expect { api_call }.to raise_error(RspecContracts::Error::PathValidation) }
    end

    context "when not raising path validation errors" do
      before { RspecContracts.config.path_validation_mode = :warn }

      it { expect { api_call }.not_to raise_error }
    end
  end
end
