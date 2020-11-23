class Admin::CertificatesController < ApplicationController
  before_action :authenticate_admin!

  def index
    @certificates = Certificate.all.order(date: :desc)
  end

  def show
    @certificate = Certificate.find(params[:id])
    @rus_template = @certificate.rus_template
    @eng_template = @certificate.eng_template

  end

  def new
    @certificate = Certificate.new
    @certificate.build_rus_template
    @certificate.build_eng_template
  end

  def create
    @certificate = Certificate.create(certificate_params)

    if @certificate.save
      flash[:success] = "New Certificate successfully created!"
      redirect_to admin_certificate_path(@certificate)
    else
      flash[:danger] = "Ooops! Something went wrong! #{@certificate.errors.full_messages.to_sentence}"
      render :new
    end
  end

  def destroy
    @certificate = Certificate.find(params[:id])
    if @certificate.destroy
      flash[:success] = "Certificate was successfully deleted!"
      redirect_to admin_certificates_path
    else
      flash[:danger] = "Ooops! Something went wrong! #{@certificate.errors.full_messages.to_sentence}"
      render action: :show
    end
  end

  def edit
    @certificate = Certificate.find(params[:id])
  end

  def update
    @certificate = Certificate.find(params[:id])
    if @certificate.update(certificate_params)
      flash[:success] = "Certificate updated!"
      redirect_to admin_certificate_path(@certificate)
    else
      flash.now[:danger] = "Ooops! Something went wrong! #{@certificate.errors.full_messages.to_sentence}"
      render action: :edit
    end
  end



  private

# Use strong_parameters for attribute whitelisting
# Be sure to update your create() and update() controller methods.

  def certificate_params
    #params.require(:certificate).permit(:name, :speaker, :description, :date, :language, :xpos, :ypos, :template)
    params.require(:certificate).permit(:name, :speaker, :description, :date, :speaker_eng, :description_eng,
                                        rus_template_attributes: [:xpos, :ypos, :font_size, :font_color, :pdf_file],
                                        eng_template_attributes: [:xpos, :ypos, :font_size, :font_color, :pdf_file])
  end

end