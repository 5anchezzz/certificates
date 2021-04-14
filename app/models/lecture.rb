class Lecture < ApplicationRecord
  belongs_to :marathon

  validates :name, presence: true
  validates :speaker, presence: true
  validates :description, presence: true
  validates :date, presence: true
  validates :file_name, presence: true

  has_attached_file :certificate, styles: { :thumb => ["200x200>", :png], :medium => ["500x500>", :png] }
  validates_attachment :certificate, presence: true,
                       size: { in: 0..500.kilobytes },
                       content_type: { content_type: ['application/pdf'] },
                       message: 'Only PDF files are allowed'

  after_commit :set_resolution, on: [:create, :update]

  default_scope { order(date: :asc) }

  def get_resolution
    "#{pdf_width}х#{pdf_height}"
  end

  private

  def set_resolution
    resolution = Paperclip::Geometry.from_file(self.certificate).to_s.split('x')
    pdf_width = resolution.first.to_i
    pdf_height = resolution.last.to_i
    if self.pdf_width != pdf_width || self.pdf_height != pdf_height
      self.update(pdf_width: pdf_width, pdf_height: pdf_height)
    end
  end
end
