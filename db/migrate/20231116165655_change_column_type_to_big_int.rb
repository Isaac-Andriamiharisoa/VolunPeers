class ChangeColumnTypeToBigInt < ActiveRecord::Migration[7.1]
  def change
    change_column :users, :contact, :bigint
  end
end
