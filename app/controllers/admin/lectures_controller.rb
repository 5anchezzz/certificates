class Admin::LecturesController < ApplicationController
  before_action :authenticate_admin!

  def new
    @marathon = Marathon.find(params[:marathon_id])
    @lecture = Lecture.new(marathon: @marathon)
  end

  def show
    @lecture = Lecture.find(params[:id])
  end

  def create
    @marathon = Marathon.find(params[:lecture][:marathon_id])
    @lecture = Lecture.create(lecture_params.merge(marathon: @marathon))

    if @lecture.save
      flash[:success] = "New Lecture successfully created!"
      redirect_to admin_marathon_path(@marathon)
    else
      flash[:danger] = "Ooops! Something went wrong! #{@lecture.errors.full_messages.to_sentence}"
      render :new
    end
  end

  def destroy
    @lecture = Lecture.find(params[:id])
    marathon = @lecture.marathon
    if @lecture.destroy
      flash[:success] = "Lecture was successfully deleted!"
      redirect_to admin_marathon_path(marathon)
    else
      flash[:danger] = "Ooops! Something went wrong! #{@lecture.errors.full_messages.to_sentence}"
      redirect_to admin_marathon_path(marathon)
    end
  end

  def edit
    @marathons = Marathon.all
    @lecture = Lecture.find(params[:id])
  end

  def update
    @lecture = Lecture.find(params[:id])
    # certificate = @rus_template.certificate
    if @lecture.update(lecture_params)
      flash[:success] = "Lecture updated!"
      redirect_to admin_lecture_path(@lecture)
    else
      flash.now[:danger] = "Ooops! Something went wrong! #{@lecture.errors.full_messages.to_sentence}"
      render action: :edit
    end
  end


  private
  def lecture_params
    params.require(:lecture).permit(:name, :speaker, :date, :description, :marathon_id, :certificate, :file_name)
  end
end