class Broken::PetsController < ApplicationController
  def index
    render json: Pet.all
  end

  def create
    @pet = Pet.new(pet_params)
    if @pet.save
      render json: @pet, status: :created
    else
      render json: @pet.errors, status: 422
    end
  end

  def show
    render json: pet
  end

  def update
    if pet.update(pet_params)
      render json: @pet
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
