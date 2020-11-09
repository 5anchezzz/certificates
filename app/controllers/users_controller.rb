require('zip')
class UsersController < ApplicationController

  def index
    @users = User.all
  end

  def new
    @user = User.new
  end

  def create
    @user = User.create(user_params)

    if @user.save
      flash[:success] = "New User successfully created!"
      redirect_to users_path
    else
      flash[:danger] = "Ooops! Something went wrong! #{@user.errors.full_messages.to_sentence}"
      render :new
    end
  end

  def show
    @user = User.find_by_email(params[:email]) || not_found
  end

  def download_pdf
    #user = User.find_by_email(params[:user_email])
    #send_data(user.combine_pdf_cert(params[:type]), :filename => "#{params[:type]}_cert.pdf", :type => "application/pdf")
    user = User.find_by_email(params[:user_email])
    certificate = Certificate.find(params[:certificate_id])
    send_data(user.combine_pdf_cert(certificate), :filename => "#{certificate.name}_cert.pdf", :type => "application/pdf")
  end


  def download_zip
    user = User.find_by_email(params[:user_email])
    filename = 'all_certs_archive.zip'
    temp_file = Tempfile.new(filename)
    begin
      Zip::OutputStream.open(temp_file) { |zos| }
      Zip::File.open(temp_file.path, Zip::File::CREATE) do |zip|
        Certificate.scope_by_language(user.language).each do |type|
          cert = Tempfile.new("#{type.name}-#{user.email}.pdf")
          cert.binmode
          cert.write(user.combine_pdf_cert(type))
          cert.rewind
          zip.add("#{type.name}-#{user.email}.pdf", cert.path)
          cert.close
        end
      end
      zip_data = File.read(temp_file.path)
      send_data(zip_data, type: 'application/zip', disposition: 'attachment', filename: filename)
    ensure # important steps below
      temp_file.close
      temp_file.unlink
    end
  end

  def edit
    @user = User.find(params[:email])
  end

  def update
    @user = User.find(params[:email])
    if @user.update(user_params)
      flash[:success] = "User updated!"
      redirect_to users_path()
    else
      flash.now[:danger] = "Ooops! Something went wrong! #{@user.errors.full_messages.to_sentence}"
      render action: :edit
    end
  end




  #def download_zip
  #  user = User.find_by_email(params[:user_email])
  #  zipfile_name = Tempfile.new(["#{Rails.root}/tmp/factures", '.zip'])
  #  Zip::File.open(zipfile_name, Zip::File::CREATE) do |zipfile|
  #    ALL_CERTS.each do |bill|
  #      temp_pdf = Tempfile.new(["basic_questions_#{Time.now.to_i}", '.pdf'])
  #      temp_pdf.binmode
  #      temp_prawn_pdf = user.combine_pdf_cert(bill)
  #      temp_pdf.write temp_prawn_pdf
  #      temp_pdf.rewind
  #      zipfile.add("web_#{bill}.pdf", "#{temp_pdf.path}")
  #      temp_pdf.close
  #    end
  #  end
  #
  #  path = File.join(Rails.root, "public", "pdfs")
  #  send_file File.join(path, "factures.zip")
  #  ensure
  #  zipfile_name.close
  #
  #end











  private
  def user_params
    params.require(:user).permit(:firstname, :lastname, :email, :language)
  end



  #def generate_pdf
  #  Prawn::Document.new do
  #    text "Hello Stackoverflow"
  #  end.render
  #end



  #def combine_pdf
  #  fonts = CombinePDF.new(Rails.root.join('public','font-montserrat.pdf')).fonts(true)
  #  CombinePDF.register_font_from_pdf_object :montserrat, fonts[0]
  #
  #  template_pdf = CombinePDF.load(Rails.root.join('public','main.pdf'))
  #
  #  template_pdf.pages[0].textbox("РУССКИЙ", { font: :montserrat })
  #  template_pdf.save Rails.root.join('public','main-new.pdf')
  #end


end









#РАБОТАЕТ РАБОТАЕТ РАБОТАЕТ

#def download_zip
#  user = User.find_by_email(params[:user_email])
#  filename = 'all_certs_archive.zip'
#  temp_file = Tempfile.new(filename)
#  begin
#    Zip::OutputStream.open(temp_file) { |zos| }
#    Zip::File.open(temp_file.path, Zip::File::CREATE) do |zip|
#      ALL_CERTS.each do |type|
#        cert = Tempfile.new("#{type}-#{user.email}.pdf")
#        cert.binmode
#        cert.write(user.combine_pdf_cert(type))
#        cert.rewind
#        zip.add("#{type}-#{user.email}.pdf", cert.path)
#        cert.close
#      end
#    end
#    zip_data = File.read(temp_file.path)
#    send_data(zip_data, type: 'application/zip', disposition: 'attachment', filename: filename)
#  ensure # important steps below
#    temp_file.close
#    temp_file.unlink
#  end
#end
