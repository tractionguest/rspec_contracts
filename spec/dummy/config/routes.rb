# frozen_string_literal: true

Rails.application.routes.draw do
  mount RspecContracts::Engine => "/rspec_contracts"
end
