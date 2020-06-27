class PetsController < ApplicationController
  before_action -> { ActiveModel::Serializer.config.adapter = :attributes }
  def index
    render json: Pet.all, each_serializer: $serializer
  end

  def create
    @pet = Pet.new(pet_params)
    if @pet.save
      render json: @pet, serializer: $serializer
    else    
      render json: @pet.errors.messages, status: 422, serializer: ErrorSerializer, root: false
    end
  end

  def show
    render json: pet, serializer: $serializer
  end

  def update
    if pet.update(pet_params)
      render json: @pet, serializer: $serializer
    else
      render json: @pet.errors, status: 422
    end
  end

  def destroy
    if pet.destroy
      head :no_content
    else
      render json: @pet.errors, status: 422
    end
  end

  private

  def pet_params
    params.permit(:name, :tag)
  end
  
  def pet
    @pet ||= Pet.find(params[:id])
  end
end
