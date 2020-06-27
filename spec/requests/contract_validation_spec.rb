require "rails_helper"

describe 'API contract validation', type: :request do
  let(:file) { "spec/fixtures/petstore.yaml" }
  let(:contract) { RspecContracts::Contract.new(YAML.load_file(file)) }

  describe "operation lookup errors" do
    subject(:api_call) { get pets_path, api_operation: contract["undefinedOperation"] }

    it { expect { api_call }.to raise_error(RspecContracts::Error::OperationLookup) }
  end

  context "when request has a request body" do
    subject(:api_call) { post pets_path, params: post_params, as: :json, api_operation: contract["addPet"] }

    context "when everything conforms to the spec" do
      let(:post_params) { attributes_for :pet }

      it { expect { api_call }.not_to raise_error }
    end
  end
end
