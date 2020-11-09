class EngTemplatesController < ApplicationController


  def new
    @certificate = Certificate.find(params[:certificate_id])
    @eng_template = @certificate.build_eng_template
  end

  def create
    @certificate = Certificate.find(params[:eng_template][:certificate_id])
    @eng_template = @certificate.create_eng_template(eng_template_params)

    if @eng_template.save
      flash[:success] = "New Template successfully created!"
      redirect_to certificate_path(@certificate)
    else
      flash[:danger] = "Ooops! Something went wrong! #{@eng_template.errors.full_messages.to_sentence}"
      render :new
    end
  end

  def destroy
    @eng_template = EngTemplate.find(params[:id])
    certificate = @eng_template.certificate
    if @eng_template.destroy
      flash[:success] = "Eng template was successfully deleted!"
      redirect_to certificate_path(certificate)
    else
      flash[:danger] = "Ooops! Something went wrong! #{@eng_template.errors.full_messages.to_sentence}"
      redirect_to certificate_path(certificate)
    end
  end

  def edit
    @eng_template = EngTemplate.find(params[:id])
  end

  def update
    @eng_template = EngTemplate.find(params[:id])
    certificate = @eng_template.certificate
    if @eng_template.update(eng_template_params)
      flash[:success] = "Eng template updated!"
      redirect_to certificate_path(certificate)
    else
      flash.now[:danger] = "Ooops! Something went wrong! #{@eng_template.errors.full_messages.to_sentence}"
      render action: :edit
    end
  end

  private
  def eng_template_params
    params.require(:eng_template).permit(:xpos, :ypos, :font_size, :font_color, :pdf_file)
  end
end