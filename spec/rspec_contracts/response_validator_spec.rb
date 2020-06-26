require "rails_helper"

describe 'API contract validation', type: :request do
  let(:file) { "spec/fixtures/petstore.yaml" }
  let(:contract) { RspecContracts::Contract.new(YAML.load_file(file)) }

  describe "operation lookup errors" do
    subject(:api_call) { get pets_path, api_operation: contract["undefinedOperation"] }

    it { expect { api_call }.to raise_error(RspecContracts::Error::OperationLookup) }
  end

  context "when request has a request body", :focus do
    subject(:api_call) { post pets_path, params: post_params, as: :json, api_operation: contract["addPet"] }

    context "when everything conforms to the spec" do
      let(:post_params) { attributes_for :pet }

      it { expect { api_call }.not_to raise_error }
    end


    context "and when response does not match the operation", :focus do   
      let(:post_params) { attributes_for :pet }

      subject(:api_call) { post pets_path, params: post_params, as: :json, api_operation: contract["addPet"] }

      context "and when raising request body validation errors" do
        it { expect { api_call }.to raise_error(RspecContracts::Error::ResponseValidation) }
      end

      context "and when not raising request body validation errors" do
        before { RspecContracts.config.response_validation_mode = :warn }
        it { expect { api_call }.not_to raise_error }
      end
    end

    context "and when request body does not match the operation", skip: "Not working yet" do   
      let(:post_params) { attributes_for :pet, name: nil }

      subject(:api_call) { post pets_path, params: post_params, as: :json, api_operation: contract["addPet"] }

      context "and when raising request body validation errors" do
        xit { expect { api_call }.to raise_error(RspecContracts::Error::RequestValidation) }
      end

      context "and when not raising request body validation errors" do
        before { RspecContracts.config.request_validation_mode = :warn }
        xit { expect { api_call }.not_to raise_error }
      end
    end
  end
end
