class AddColumnToEvent < ActiveRecord::Migration[7.1]
  def change
    add_column :events, :action, :string
    add_column :events, :quantity, :integer
  end
end
