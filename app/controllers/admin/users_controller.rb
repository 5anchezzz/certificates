#require('zip')
class Admin::UsersController < ApplicationController
  before_action :authenticate_admin!, except: [:download_one_pdf, :download_all_pdfs]

  def index
    @marathons = Marathon.all

    if params[:from_marathon]
      @q = User.includes(:marathon).of_one_marathon(params[:from_marathon]).ransack(params[:q])
    else
      @q = User.includes(:marathon).ransack(params[:q])
    end

    # @q = User.ransack(params[:q])
    @users = @q.result.page(params[:page]).per(100)
  end

  def new
    @marathons = Marathon.all
    @user = User.new
  end

  def create
    @marathons = Marathon.all
    @user = User.create(user_params)

    if @user.save
      flash[:success] = "New User successfully created!"
      redirect_to admin_users_path
    else
      flash.now[:danger] = "Ooops! Something went wrong! #{@user.errors.full_messages.to_sentence}"
      render :new
    end
  end

  def show
    @user = User.find(params[:id])
  end

  def edit
    @user = User.find(params[:id])
    @marathons = Marathon.all
  end

  def update
    @user = User.find(params[:id])
    @marathons = Marathon.all
    if @user.update(user_params)
      flash[:success] = "User updated!"
      redirect_to admin_user_path(@user)
    else
      flash.now[:danger] = "Ooops! Something went wrong! #{@user.errors.full_messages.to_sentence}"
      render action: :edit
    end
  end

  def destroy
    @user = User.find(params[:id])
    if @user.destroy
      flash[:success] = "User was successfully deleted!"
      redirect_to admin_users_path
    else
      flash[:danger] = "Ooops! Something went wrong! #{@user.errors.full_messages.to_sentence}"
      render action: :show
    end
  end

  def download_one_pdf
    @user = User.find(params[:id])
    @lecture = Lecture.find(params[:lecture_id])
    send_data(@user.generate_one_cert(@lecture), filename: "#{@lecture.file_name}_cert.pdf", type: 'application/pdf')
  end

  def download_all_pdfs
    @user = User.find(params[:id])
    filename = 'all_certs_archive.zip'
    certs_files = @user.generate_all_certs_new
    certs_files.rewind
    send_data(certs_files.read, type: 'application/zip', disposition: 'attachment', filename: filename)
    @user.update(state: 'done')
  end

  private
  def user_params
    params.require(:user).permit(:firstname, :lastname, :email, :language, :marathon_id)
  end

end