class Admin::TablesController < ApplicationController
  before_action :authenticate_admin!

  def index
    @tables = Table.all
  end

  def new
    @table = Table.new
  end

  def create
    table_head = ["firstname", "lastname", "email", "language"]

    temp_doc = Roo::Spreadsheet.open(table_params[:doc].to_path)

    if temp_doc.sheet(0).row(1).map(&:downcase) != table_head
      @table = Table.new(table_params)
      flash[:danger] = "Mismatch table head. Check column of input file."
      render :new
      return
    end

    unless temp_doc.sheet(0).row(2).any?
      @table = Table.new(table_params)
      flash[:danger] = "File is empty or has empty rows"
      render :new
      return
    end

    @table = Table.create(table_params)

    if @table.save
      #number_of_rows = temp_doc.info.split("Last row: ").last.split("\n").first.to_i - 1
      @table.update(state: 'new', logs: "Success: #{DateTime.now.strftime('%d.%m.%y %H:%M')} - Data table was loaded successfully;")
      flash[:success] = "New Table successfully created!"
      redirect_to admin_tables_path
    else
      flash[:danger] = "Something went wrong!"
      render :new
    end
  end

  def show
    @table = Table.find(params[:id])
  end

  def create_users
    @table = Table.find(params[:id])
    result_hash = @table.create_users
    @table = Table.find(params[:id])

    if result_hash[:errors_row]
      @table.update!(state: 'warning')
      flash[:danger] = "#{result_hash[:errors_row].size} users were not created. Check logs"
      redirect_to admin_table_path
    else
      @table.update!(state: 'success')
      flash[:success] = 'All users have been successfully created'
      redirect_to admin_table_path
    end
  end

  def destroy
    @table = Table.find(params[:id])
    if @table.destroy
      flash[:success] = "Table was successfully deleted!"
      redirect_to admin_tables_path
    else
      flash[:danger] = 'Ooops! Something went wrong!'
      render action: :show
    end
  end

  def edit
    @table = Table.find(params[:id])
  end

  def update
    @table = Table.find(params[:id])
    if @table.update(update_table_params)
      flash[:success] = "Table updated!"
      redirect_to admin_table_path(@table)
    else
      flash.now[:danger] = "Ooops! Something went wrong! #{@table.errors.full_messages.to_sentence}"
      render action: :edit
    end
  end



  private

# Use strong_parameters for attribute whitelisting
# Be sure to update your create() and update() controller methods.

  def table_params
    params.require(:table).permit(:name, :description, :doc)
  end

  def update_table_params
    params.require(:table).permit(:name, :description)
  end


end