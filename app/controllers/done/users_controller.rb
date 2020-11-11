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

  private
  def user_params
    params.require(:user).permit(:firstname, :lastname, :email, :language)
  end

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
