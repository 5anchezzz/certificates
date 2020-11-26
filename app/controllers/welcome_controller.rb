require('zip')
class WelcomeController < ApplicationController

  def index
    if params[:email]
      #redirect_to user_path(params[:email])
      user = User.find_by_email(params[:email].to_s.downcase)
      if user
        redirect_to result_path(email: params[:email].to_s.downcase)
      else
        flash.now[:danger] = 'Ooops! Are you sure you entered the correct email address?'
        render action: :index
      end
    end
  end

  def result
    @user = User.find_by_email(params[:email])

    if @user.language == 'rus'
      @hi =           'Привет'
      @chose =        'Здесь ты можешь выбрать тот сертификат, который тебе нужен или скачать их все сразу'
      @speaker =      'Спикер'
      @description =  'Описание'
      @date =         'Дата'
      @download =     'Скачать'
      @no_certs =     'Нет доступных сертификатов. Пожалуста, обратитесь в службу поддержки.'
      @main =         'На главную'
      @download_all = 'Скачать все'
    else
      @hi =           'Hi'
      @chose =        'Here you can choose the certificate you need or download them all at once'
      @speaker =      'Speaker'
      @description =  'Description'
      @date =         'Date'
      @download =     'Download'
      @no_certs =     'No certificates available. Please contact support.'
      @main =         'Back to Main'
      @download_all = 'Download all'
    end

  end

  def download_pdf
    user = User.find_by_email(params[:user_email])
    certificate = Certificate.find(params[:certificate_id])
    send_data(user.generate_cert_with_prawn(certificate), filename: "#{certificate.name}_cert.pdf", type: 'application/pdf')
  end

  def download_zip
    user = User.find_by_email(params[:user_email])
    filename = 'all_certs_archive.zip'
    zip_file = Tempfile.new(filename)
    begin
      Certificate.scope_by_language(user.language).each do |type|
        cert = Tempfile.new("#{type.name}-#{user.email}.pdf")
        cert.binmode
        cert.write(user.generate_cert_with_prawn(type))
        Zip::File.open(zip_file.path, Zip::File::CREATE) do |zip|
          zip.add("#{type.name}-#{user.email}.pdf", cert.path)
        end
        cert.close
        cert.unlink
      end
      zip_data = File.read(zip_file.path)
      zip_file.unlink
      send_data(zip_data, type: 'application/zip', disposition: 'attachment', filename: filename)
    end
  end

  def zip_zip
    user = User.find_by_email(params[:user_email])
    filename = 'all_certs_archive.zip'
    certs_files = user.generate_all_certs
    certs_files.rewind
    send_data(certs_files.read, type: 'application/zip', disposition: 'attachment', filename: filename)
  end

end