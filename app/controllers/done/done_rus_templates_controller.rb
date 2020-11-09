class RusTemplatesController < ApplicationController


  def new
    @certificate = Certificate.find(params[:certificate_id])
    @rus_template = @certificate.build_rus_template
  end

  def create
    @certificate = Certificate.find(params[:rus_template][:certificate_id])
    @rus_template = @certificate.create_rus_template(rus_template_params)

    if @rus_template.save
      flash[:success] = "New Template successfully created!"
      redirect_to certificate_path(@certificate)
    else
      flash[:danger] = "Ooops! Something went wrong! #{@rus_template.errors.full_messages.to_sentence}"
      render :new
    end
  end

  def destroy
    @rus_template = RusTemplate.find(params[:id])
    certificate = @rus_template.certificate
    if @rus_template.destroy
      flash[:success] = "Rus template was successfully deleted!"
      redirect_to certificate_path(certificate)
    else
      flash[:danger] = "Ooops! Something went wrong! #{@rus_template.errors.full_messages.to_sentence}"
      redirect_to certificate_path(certificate)
    end
  end

  def edit
    @rus_template = RusTemplate.find(params[:id])
  end

  def update
    @rus_template = RusTemplate.find(params[:id])
    certificate = @rus_template.certificate
    if @rus_template.update(rus_template_params)
      flash[:success] = "Rus template updated!"
      redirect_to certificate_path(certificate)
    else
      flash.now[:danger] = "Ooops! Something went wrong! #{@rus_template.errors.full_messages.to_sentence}"
      render action: :edit
    end
  end


  private
  def rus_template_params
    params.require(:rus_template).permit(:xpos, :ypos, :font_size, :font_color, :pdf_file)
  end
end