class EngTemplate < ApplicationRecord
  belongs_to :certificate

  validates :xpos, presence: true, numericality: { only_integer: true }
  validates :ypos, presence: true, numericality: { only_integer: true }
  validates :font_size, presence: true, numericality: { only_integer: true }
  validates :font_color, presence: true
  #validates_format_of :font_color, with: /\A^([0-1]?\d?\d|2[0-4]\d|25[0-5]),([0-1]?\d?\d|2[0-4]\d|25[0-5]),([0-1]?\d?\d|2[0-4]\d|25[0-5])$\z/i, on: [:create, :update]
  validates_format_of :font_color, with: /\A^(\d{1,2}|100),(\d{1,2}|100),(\d{1,2}|100),(\d{1,2}|100)$\z/i, on: [:create, :update]

  after_commit :set_resolution, on: [:create, :update]

  has_attached_file :pdf_file, styles: { :thumb => ["200x200>", :png], :medium => ["500x500>", :png] }
  validates_attachment :pdf_file, presence: true,
                       size: { in: 0..500.kilobytes },
                       content_type: { content_type: ['application/pdf'] },
                       message: 'Only PDF files are allowed'

  private

  def set_resolution
    resolution = Paperclip::Geometry.from_file(self.pdf_file).to_s.split('x')
    pdf_width = resolution.first.to_i
    pdf_height = resolution.last.to_i
    if self.pdf_width != pdf_width || self.pdf_height != pdf_height
      self.update(pdf_width: pdf_width, pdf_height: pdf_height)
    end
  end


end
