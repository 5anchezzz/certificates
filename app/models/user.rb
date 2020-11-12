class User < ApplicationRecord
  belongs_to :table, optional: true

  validates :firstname, presence: true
  #validates :lastname, presence: true
  validates :language, presence: true
  validates :email, uniqueness: { case_sensitive: false }

  validates_format_of :email, with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i, on: :create


  def combine_pdf_cert(certificate)
    language == 'rus' ? using_template = certificate.rus_template : using_template = certificate.eng_template
    fonts = CombinePDF.new(Rails.root.join('public','font-montserrat.pdf')).fonts(true)
    CombinePDF.register_font_from_pdf_object :montserrat, fonts[0]
    template_pdf = CombinePDF.load(using_template.pdf_file.path)
    template_pdf.pages[0].textbox("#{firstname} #{lastname}", { font: :montserrat,
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




end
