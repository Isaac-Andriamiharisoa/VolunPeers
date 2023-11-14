class ChangeColumnType < ActiveRecord::Migration[7.1]
  def change
    change_column :events, :start_date, :date
    change_column :events, :end_date, :date
    add_column :events, :start_time, :time
    add_column :events, :end_time, :time
    add_column :events, :country, :string
    add_column :events, :address, :string
    add_column :events, :contact, :integer
    add_column :events, :time_zone, :integer
    remove_column :events, :latitude, :float
    remove_column :events, :longitude, :float
  end
end
