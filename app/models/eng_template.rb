class EngTemplate < ApplicationRecord
  belongs_to :certificate

  validates :xpos, presence: true, numericality: { only_integer: true }
  validates :ypos, presence: true, numericality: { only_integer: true }
  validates :font_size, presence: true, numericality: { only_integer: true }
  validates :font_color, presence: true
  validates_format_of :font_color, with: /\A^([0-1]?\d?\d|2[0-4]\d|25[0-5]),([0-1]?\d?\d|2[0-4]\d|25[0-5]),([0-1]?\d?\d|2[0-4]\d|25[0-5])$\z/i, on: [:create, :update]

  has_attached_file :pdf_file, styles: { :thumb => ["200x200>", :png], :medium => ["500x500>", :png] }
  validates_attachment :pdf_file, presence: true,
                       content_type: { content_type: ['application/pdf'] },
                       message: 'Only PDF files are allowed'

end
