require "rails_helper"

describe 'API contract validation', type: :request do
  let(:file) { "spec/fixtures/petstore.yaml" }
  let(:contract) { RspecContracts::Contract.new(YAML.load_file(file)) }

  subject(:api_call) { post pets_path, params: post_params, as: :json, api_operation: contract["addPet"] }

  context "and when response does not match the operation" do
    before { $serializer = BrokenPetSerializer }
    after { $serializer = PetSerializer }
    let(:post_params) { attributes_for :pet }

    subject(:api_call) { post pets_path, params: post_params, as: :json, api_operation: contract["addPet"] }

    context "and when raising response validation errors" do
      it { expect { api_call }.to raise_error(RspecContracts::Error::ResponseValidation) }
    end

    context "and when not raising response validation errors" do
      before { RspecContracts.config.response_validation_mode = :warn }
      it { expect { api_call }.not_to raise_error }
    end
  end

end
