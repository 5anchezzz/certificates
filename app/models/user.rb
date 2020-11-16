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
    language == 'rus' ? using_template = certificate.rus_template : using_template = certificate.eng_template
    color = using_template.font_color.split(',').map(&:to_i)
    start_pos = using_template.xpos - ((name_width * using_template.font_size * 0.95 / 15) / 2)

    prawn_text_pdf = Prawn::Document.new :page_size => [using_template.pdf_height, using_template.pdf_width], :margin => 0 do |pdf|
      pdf.fill_color color[0], color[1], color[2], color[3]
      pdf.font Rails.root.join('public','Montserrat-Medium.ttf')
      pdf.draw_text name_to_paste, :at => [start_pos, using_template.ypos], :size => using_template.font_size * 0.7
    end

    pdf_data = prawn_text_pdf.render
    combine_text_pdf = CombinePDF.parse(pdf_data).pages[0]

    cert_pdf = CombinePDF.load using_template.pdf_file.path
    cert_pdf.pages[0] << combine_text_pdf
    cert_pdf.to_pdf

  end

  private

  def set_name_width
    label = Magick::Draw.new
    label.font Rails.root.join('public','Montserrat-Medium.ttf')
    width = label.get_type_metrics(name_to_paste).width
    self.name_width = width if self.name_width != width
  end

end
