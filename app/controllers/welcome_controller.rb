require('zip')
class WelcomeController < ApplicationController

  def index
    if params[:email]
      #redirect_to user_path(params[:email])
      user = User.find_by_email(params[:email])
      if user
        redirect_to result_path(email: params[:email])
      else
        flash.now[:danger] = 'Ooops! Are you sure you entered the correct email address?'
        render action: :index
      end
    end
  end

  def result
    @user = User.find_by_email(params[:email])
  end

  def download_pdf
    user = User.find_by_email(params[:user_email])
    certificate = Certificate.find(params[:certificate_id])
    send_data(user.combine_pdf_cert(certificate), filename: "#{certificate.name}_cert.pdf", type: 'application/pdf')
  end

  def download_zip
    user = User.find_by_email(params[:user_email])
    filename = 'all_certs_archive.zip'
    temp_file = Tempfile.new(filename)
    arr_for_temps = []
    begin
      Zip::OutputStream.open(temp_file) { |zos| }
      Zip::File.open(temp_file.path, Zip::File::CREATE) do |zip|
        Certificate.scope_by_language(user.language).each do |type|
          cert = Tempfile.new("#{type.name}-#{user.email}.pdf")
          ObjectSpace.undefine_finalizer(cert)
          arr_for_temps << cert
          cert.binmode
          cert.write(user.combine_pdf_cert(type))
          cert.rewind
          zip.add("#{type.name}-#{user.email}.pdf", cert.path)
          cert.close
        end
      end
      zip_data = File.read(temp_file.path)
      send_data(zip_data, type: 'application/zip', disposition: 'attachment', filename: filename)
    ensure
      arr_for_temps.map(&:unlink)
      temp_file.close
      temp_file.unlink
    end
  end

end