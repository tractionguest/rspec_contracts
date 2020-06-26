require "rails_helper"

describe 'API contract path validation', type: :request do
  let(:file) { "spec/fixtures/petstore.yaml" }
  let(:contract) { RspecContracts::Contract.new(YAML.load_file(file)) }

  subject(:api_call) { post pets_path, params: post_params, as: :json, api_operation: contract["addPet"] }

  context "and when path does not match the operation" do   
    let(:post_params) { attributes_for :pet }

    subject(:api_call) { post pets_path, params: post_params, as: :json, api_operation: contract["findPets"] }

    context "and when raising path validation errors" do
      it { expect { api_call }.to raise_error(RspecContracts::Error::PathValidation) }
    end

    context "and when not raising path validation errors" do
      before {RspecContracts.config.path_validation_mode = :warn }
      it { expect { api_call }.not_to raise_error }
    end
  end
end
