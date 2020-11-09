class Admin::AdminController < ApplicationController
  before_action :authenticate_admin!

  def dashboard
    @all_tables_count = Table.count
    @all_users_count = User.count
    @all_certificates_count = Certificate.count
  end

end