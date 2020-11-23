class Table < ApplicationRecord
  has_many :users, dependent: :destroy

  validates :name, presence: true
  validates :description, presence: true

  has_attached_file :doc
                    #:url => "/attach/:basename.:extension",
                    #:path => ":rails_root/public/attach/:basename.:extension"

  validates_attachment :doc, presence: true,
                       content_type: { content_type: [ "application/vnd.ms-excel",
                                                       "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
                       ]
                       },
                       message: ' Only EXCEL files are allowed.'

  def create_users
    xlsx = Roo::Spreadsheet.open(doc.path)
    number_of_users = xlsx.info.split("Last row: ").last.split("\n").first.to_i - 1
    row_number = 2
    result_hash = { :success_count => 0 }
    success_count = 0
    xlsx.each_row_streaming(offset: 1, pad_cells: true) do |row|
      begin
        set_lastname = row[1].to_s.downcase.capitalize if row[1].present?
        users.create!(firstname: row[0].to_s.downcase.capitalize,
                      lastname: set_lastname,
                      email: row[2].to_s.downcase,
                      language: row[3].to_s.downcase)
        success_count += 1
        row_number += 1
      rescue => error
        result_hash[:errors_row] = [] unless result_hash[:errors_row]
        result_hash[:errors_row] << row_number
        update(logs: "#{logs}Error: #{DateTime.now.strftime('%d.%m.%y %H:%M')} - No user has been created for row ##{row_number} (#{error.message});")
        row_number += 1
      end
    end
    result_hash[:success_count] = success_count
    success_count == number_of_users ? text = "All (#{success_count}) users have been successfully created;" : text = "#{success_count} users out of #{number_of_users} were created."
    update(logs: "#{logs}Success: #{DateTime.now.strftime('%d.%m.%y %H:%M')} - #{text}")
    result_hash
  end


end