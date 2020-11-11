class Certificate < ApplicationRecord

  validates :name, presence: true
  validates :speaker, presence: true
  validates :description, presence: true
  validates :date, presence: true

  has_one :rus_template, dependent: :destroy
  accepts_nested_attributes_for :rus_template, reject_if: :all_blank
  validates_associated :rus_template

  has_one :eng_template, dependent: :destroy
  accepts_nested_attributes_for :eng_template, reject_if: :all_blank
  validates_associated :eng_template

  scope :rus, -> { joins(:rus_template) }
  scope :eng, -> { joins(:eng_template) }
  scope :no_templates, -> { includes(:rus_template,:eng_template).where(rus_templates: { id: nil }, eng_templates: { id: nil }) }

  #validates :language, presence: true, inclusion: %w(rus eng)
  #validates :xpos, presence: true, numericality: { only_integer: true }
  #validates :ypos, presence: true, numericality: { only_integer: true }
  #
  #has_attached_file :template, styles: { :thumb => ["200x200>", :png], :medium => ["500x500>", :png] }
  #validates_attachment :template, presence: true,
  #                     content_type: { content_type: ['application/pdf'] },
  #                     message: ' Only PDF files are allowed.'


  def self.scope_by_language(language)
    joins(:"#{language}_template").order(date: :desc)
  end


end


