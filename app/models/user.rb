# frozen_string_literal: true
class User < ApplicationRecord
  belongs_to :table, optional: true

  validates :firstname, presence: true
  #validates :lastname, presence: true
  validates :language, presence: true
  validates :email, uniqueness: { case_sensitive: false }

  validates_format_of :email, with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i, on: :create

  before_save :set_name_width

  def name_to_paste
    firstname.upcase + (" #{lastname.upcase}" if lastname).to_s
  end


  def combine_pdf_cert(certificate)
    language == 'rus' ? using_template = certificate.rus_template : using_template = certificate.eng_template
    fonts = CombinePDF.new(Rails.root.join('public','font-montserrat.pdf')).fonts(true)
    CombinePDF.register_font_from_pdf_object :montserrat, fonts[0]
    template_pdf = CombinePDF.load(using_template.pdf_file.path)
    #template_pdf.pages[0].textbox("#{firstname} #{lastname}", { font: :montserrat,
    template_pdf.pages[0].textbox(name_to_paste, { font: :montserrat,
                                                                font_color: using_template.font_color.split(',').map(&:to_i),
                                                                font_size: using_template.font_size,
                                                                x: using_template.xpos,
                                                                y: using_template.ypos })
    template_pdf.to_pdf
  end



  #def combine_pdf_cert(type)
  #  type == 'main' ? position = {:x => 0, :y => -420} : position = {:x => 680, :y => 190}
  #
  #  fonts = CombinePDF.new(Rails.root.join('public','font-montserrat.pdf')).fonts(true)
  #  CombinePDF.register_font_from_pdf_object :montserrat, fonts[0]
  #  template_pdf = CombinePDF.load(Rails.root.join('public',"#{type}.pdf"))
  #  template_pdf.pages[0].textbox("#{firstname} #{lastname}", { font: :montserrat, font_color: [255,250,250], font_size: 82, x: position[:x], y: position[:y]})

                  #template_pdf.save Rails.root.join('public','main-new.pdf')

  #  template_pdf.to_pdf
  #end


  def generate_cert_with_prawn(certificate)
    #hhh = 800
    #left = 914
    #length = 948

    language == 'rus' ? using_template = certificate.rus_template : using_template = certificate.eng_template
    name_width > 180 ? width_koeff = 180.0/name_width : width_koeff = 1.0
    color = using_template.font_color.split(',').map(&:to_i)
    #start_pos = using_template.xpos - ((name_width * using_template.font_size * 1.71) / 2)
    start_pos = using_template.xpos - ((name_width * using_template.font_size * width_koeff * 1.76 / 15) / 2)

    prawn_text_pdf = Prawn::Document.new :page_size => [using_template.pdf_height, using_template.pdf_width], :margin => 0 do |pdf|
      pdf.fill_color color[0], color[1], color[2], color[3]
      pdf.font Rails.root.join('public','Montserrat-Medium.ttf')
      pdf.draw_text name_to_paste, :at => [start_pos, using_template.ypos], :size => using_template.font_size * width_koeff * 0.7 * 2

      #pdf.text_box name_to_paste,
      #             size: using_template.font_size * 0.7 * 2,
      #             at: [left, hhh + using_template.font_size * 0.8 * 2],
      #             align: :center,
      #             valign: :top,
      #             width: length

    end

    pdf_data = prawn_text_pdf.render
    combine_text_pdf = CombinePDF.parse(pdf_data).pages[0]

    cert_pdf = CombinePDF.load using_template.pdf_file.path
    cert_pdf.pages[0] << combine_text_pdf
    cert_pdf.to_pdf

  end

  def generate_all_certs
    name_width > 180 ? width_koeff = 180.0/name_width : width_koeff = 1.0

    main_cert = Certificate.where(name: 'main').first
    speaker_cert = Certificate.where.not(name: 'main').first

    main_template = main_cert.rus_template
    speaker_template = speaker_cert.rus_template

    main_start_pos = main_template.xpos - ((name_width * main_template.font_size * width_koeff * 1.76 / 15) / 2)
    main_color = main_template.font_color.split(',').map(&:to_i)
    main_text_pdf = Prawn::Document.new :page_size => [main_template.pdf_height,
                                                       main_template.pdf_width],
                                        :margin => 0 do |pdf|
      pdf.fill_color main_color[0], main_color[1], main_color[2], main_color[3]
      pdf.font Rails.root.join('public','Montserrat-Medium.ttf')
      pdf.draw_text name_to_paste, :at => [main_start_pos, main_template.ypos], :size => main_template.font_size * width_koeff * 0.7 * 2
    end
    main_text_pdf = main_text_pdf.render
    combine_main = CombinePDF.parse(main_text_pdf).pages[0]
    main_text_pdf = nil

    speaker_start_pos = speaker_template.xpos - ((name_width * speaker_template.font_size * width_koeff * 1.76 / 15) / 2)
    speaker_color = speaker_template.font_color.split(',').map(&:to_i)
    speaker_text_pdf = Prawn::Document.new :page_size => [speaker_template.pdf_height,
                                                          speaker_template.pdf_width],
                                        :margin => 0 do |pdf|
      pdf.fill_color speaker_color[0], speaker_color[1], speaker_color[2], speaker_color[3]
      pdf.font Rails.root.join('public','Montserrat-Medium.ttf')
      pdf.draw_text name_to_paste, :at => [speaker_start_pos, speaker_template.ypos], :size => speaker_template.font_size * width_koeff * 0.7 * 2
    end
    speaker_text_pdf = speaker_text_pdf.render
    combine_speaker = CombinePDF.parse(speaker_text_pdf).pages[0]
    speaker_text_pdf = nil

    case language
    when 'rus'
      all_templates = RusTemplate.all.includes(:certificate)
    when 'eng'
      all_templates = EngTemplate.all.includes(:certificate)
    end

    filename = "#{email}_all_certs.zip"
    zip_file = Tempfile.new(filename)

    all_templates.each do |type|
      cert = Tempfile.new("#{type.certificate.name}-#{email}.pdf")
      cert.binmode
      type.certificate.name == 'main' ? combine_text_pdf = combine_main : combine_text_pdf = combine_speaker
      cert_pdf = CombinePDF.load type.pdf_file.path
      cert_pdf.pages[0] << combine_text_pdf
      one_cert = cert_pdf.to_pdf
      cert.write(one_cert)
      Zip::File.open(zip_file.path, Zip::File::CREATE) do |zip|
        zip.add("#{type.certificate.name}-#{email}.pdf", cert.path)
      end
      cert.close
      cert.unlink
    end

    result = File.read(zip_file.path)
    zip_file.close
    zip_file.unlink
    result
  end

  def generate_cert_by_template(template)
    name_width > 180 ? width_koeff = 180.0/name_width : width_koeff = 1.0
    color = template.font_color.split(',').map(&:to_i)
    start_pos = template.xpos - ((name_width * template.font_size * width_koeff * 1.76 / 15) / 2)
    prawn_text_pdf = Prawn::Document.new :page_size => [template.pdf_height, template.pdf_width], :margin => 0 do |pdf|
      pdf.fill_color color[0], color[1], color[2], color[3]
      pdf.font Rails.root.join('public','Montserrat-Medium.ttf')
      pdf.draw_text name_to_paste, :at => [start_pos, template.ypos], :size => template.font_size * width_koeff * 0.7 * 2
    end
    pdf_data = prawn_text_pdf.render
    combine_text_pdf = CombinePDF.parse(pdf_data).pages[0]
    cert_pdf = CombinePDF.load template.pdf_file.path
    cert_pdf.pages[0] << combine_text_pdf
    cert_pdf.to_pdf
  end


  private

  def set_name_width
    label = Magick::Draw.new
    label.font = Rails.root.join('public','Montserrat-Medium.ttf').to_s
    width = label.get_type_metrics(name_to_paste).width
    self.name_width = width if self.name_width != width
  end

end
