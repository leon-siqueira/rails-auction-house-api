class Api::V1::ArtsController < ApplicationController
  before_action :set_art, only: %i[show update destroy]
  before_action :authenticate_user!, only: %i[create update destroy]

  # GET /arts
  def index
    @arts = Art.all

    render json: @arts
  end

  # GET /arts/1
  def show
    render json: @art
  end

  # POST /arts
  def create
    @art = Art.new(art_params)
    @art.user = current_user

    if @art.save
      render :create, status: :created
    else
      render json: @art.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /arts/1
  def update
    if @art.update(art_params)
      render json: @art
    else
      render json: @art.errors, status: :unprocessable_entity
    end
  end

  # DELETE /arts/1
  def destroy
    if @art.user == current_user
      @art.destroy
    else
      render json: :unauthorized, status: :unauthorized
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_art
    @art = Art.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def art_params
    params.require(:art).permit(:title, :author, :year, :description)
  end
end
