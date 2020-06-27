require "rails_helper"

describe 'API contract validation', type: :request do
  let(:file) { "spec/fixtures/petstore.yaml" }
  let(:contract) { RspecContracts::Contract.new(YAML.load_file(file)) }

  context "when request has a request body" do
    subject(:api_call) { post pets_path, params: post_params, as: :json, api_operation: contract["addPet"] }


    context "and when request body does not match the operation" do   
      let(:post_params) { {} }

      it { expect { api_call }.to raise_error(RspecContracts::Error::RequestValidation) }

      context "and when not raising request body validation errors" do
        before { RspecContracts.config.request_validation_mode = :warn }
        it { expect { api_call }.not_to raise_error }
      end
    end
  end
end
