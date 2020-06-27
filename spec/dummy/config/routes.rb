# frozen_string_literal: true

Rails.application.routes.draw do
  resources :pets
  match '/bad_create_route' => 'pets#create', via: [:post]
end
