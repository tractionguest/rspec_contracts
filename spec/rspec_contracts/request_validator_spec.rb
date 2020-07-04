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

  context "when request is a delete request" do
    let(:pet) { Pet.create(name: "pet") }
    subject(:api_call) { delete pet_path(id: pet.id), params: "",  as: :json, api_operation: contract["deletePet"] }

    it { expect { api_call }.not_to raise_error }

    context "and when not raising request body validation errors" do
      before { RspecContracts.config.request_validation_mode = :warn }

      it { expect { api_call }.not_to raise_error }
    end
  end

  context "when request does not have a request body" do
    subject(:api_call) { get pets_path, as: :json, api_operation: contract["findPets"] }

    it { expect { api_call }.not_to raise_error }

    context "and when not raising request body validation errors" do
      before { RspecContracts.config.request_validation_mode = :warn }

      it { expect { api_call }.not_to raise_error }
    end
  end
end
