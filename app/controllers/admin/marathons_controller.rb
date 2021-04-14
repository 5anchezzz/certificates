class Admin::MarathonsController < ApplicationController
  before_action :authenticate_admin!

  def index
    @marathons = Marathon.all
  end

  def new
    @marathon = Marathon.new
  end

  def create
    @marathon = Marathon.create(marathon_params)

    if @marathon.save
      flash[:success] = "New Marathon successfully created!"
      redirect_to admin_marathons_path
    else
      flash.now[:danger] = "Ooops! Something went wrong! #{@marathon.errors.full_messages.to_sentence}"
      render :new
    end
  end

  def show
    @marathon = Marathon.find(params[:id])
    @tables = @marathon.tables
    @lectures = @marathon.lectures
  end

  def edit
    @marathon = Marathon.find(params[:id])
  end

  def destroy
    @marathon = Marathon.find(params[:id])
    if @marathon.destroy
      flash[:success] = "Marathon was successfully deleted!"
      redirect_to admin_marathons_path
    else
      flash[:danger] = 'Ooops! Something went wrong!'
      render action: :show
    end
  end

  def update
    @marathon = Marathon.find(params[:id])
    if @marathon.update(marathon_params)
      flash[:success] = "Marathon updated!"
      redirect_to admin_marathon_path(@marathon)
    else
      flash.now[:danger] = "Ooops! Something went wrong! #{@marathon.errors.full_messages.to_sentence}"
      render action: :edit
    end
  end

  def delete_all_users
    @marathon = Marathon.find(params[:id])
    @marathon.users.destroy_all
    flash.now[:success] = "Yeeeaahh! All users were successfully deleted!"
    @tables = @marathon.tables
    @lectures = @marathon.lectures
    redirect_to admin_marathon_path(@marathon)
  rescue StandardError => error
    flash.now[:danger] = "Ooops! Something went wrong! #{error.to_sentence}"
    render action: :show
  end

  private

  def marathon_params
    params.require(:marathon).permit(:name, :x_pos, :y_pos, :font_size, :font_color, :pdf_width,
                                     :pdf_height, :description, :logo)
  end

end