class Api::V1::ArtsController < ApplicationController
  before_action :set_art, only: %i[show update destroy]
  before_action :authenticate_user!, only: %i[create update destroy]

  # GET api/v1/arts
  def index
    @arts = Art.all

    render :index
  end

  # GET api/v1/arts/1
  def show
    render :show
  end

  # POST api/v1/arts
  def create
    @art = Art.new(art_params)
    @art.assign_attributes(owner: current_user, creator: current_user)
    if @art.save
      render :show, status: :created
    else
      render json: @art.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT api/v1/arts/1
  def update
    if @art.update(art_params)
      render json: @art
    else
      render json: @art.errors, status: :unprocessable_entity
    end
  end

  # DELETE api/v1/arts/1
  def destroy
    if @art.creator == current_user && @art.owner == current_user
      if @art.destroy
        render json: { success: true, message: 'Art deleted' }
      else
        render json: { success: false, message: @art.errors }
      end
    elsif @art.creator != current_user || @art.owner != current_user
      render json: { success: false, message: "Only the art's creator that is also its owner can delete it" },
             status: :unauthorized
    end
  end

  private

  def set_art
    @art = Art.find(params[:id])
  end

  def art_params
    params.require(:art).permit(:title, :author, :year, :description)
  end
end
