class Marathon < ApplicationRecord
  has_many :tables, dependent: :destroy
  has_many :users, dependent: :destroy
  has_many :lectures, dependent: :destroy

  validates :pdf_height, presence: true, numericality: { only_integer: true }
  validates :pdf_width, presence: true, numericality: { only_integer: true }
  validates :x_pos, presence: true, numericality: { only_integer: true }
  validates :y_pos, presence: true, numericality: { only_integer: true }
  validates :font_size, presence: true, numericality: { only_integer: true }
  validates :font_color, presence: true
  validates_format_of :font_color, with: /\A^(\d{1,2}|100),(\d{1,2}|100),(\d{1,2}|100),(\d{1,2}|100)$\z/i, on: [:create, :update]

  after_save :update_users_name_pdf

  has_attached_file :logo, styles: { :medium => ["500x500>", :png] }
  validates_attachment :logo, presence: true,
                       size: { in: 0..1000.kilobytes },
                       content_type: { content_type: [ 'image/gif', 'image/png', 'image/x-png', 'image/jpeg', 'image/pjpeg', 'image/jpg' ] },
                       message: 'Only Image files are allowed'


  def get_resolution
    "#{pdf_width}х#{pdf_height}"
  end

  def get_percent_done
    return 0 if users.empty?
    (users.already_done.count * 100.0 / users.count).round(2)
  end

  private

  def update_users_name_pdf
    return if (saved_changes.keys & %w[x_pos y_pos font_size font_color pdf_width pdf_height]).empty?
    users.map(&:generate_name_pdf)
  end

end

