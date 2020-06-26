require "rails_helper"

describe 'Pets API' do
  describe "#index" do
    let!(:pets) { create_list :pet, 3 }    
    subject(:api_call) { get pets_path, api_operation: pets }

    it { expect { api_call }.not_to raise_error }
  end

  describe "#show" do
  end

  describe "#create" do
  end

  describe "#destroy" do
  end
end
