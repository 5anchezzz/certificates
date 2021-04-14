class UsersCreater
  include Sidekiq::Worker
  sidekiq_options retry: false

  def perform(table_id)
    table = Table.find(table_id)
    table.update(logs: "#{table.logs}Success: #{DateTime.now.strftime('%d.%m.%y %H:%M')} - Users creating was started;")
    table.create_users
  end

end