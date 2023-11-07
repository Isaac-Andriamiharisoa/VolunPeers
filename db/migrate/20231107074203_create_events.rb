class CreateEvents < ActiveRecord::Migration[7.1]
  def change
    create_table :events do |t|
      t.string :title
      t.string :description
      t.float :latitude
      t.float :longitude
      t.timestamp :start_date
      t.timestamp :end_date

      t.timestamps
    end
  end
end
