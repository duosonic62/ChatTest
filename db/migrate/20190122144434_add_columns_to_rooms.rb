class AddColumnsToRooms < ActiveRecord::Migration[5.1]
  def change
    add_column :rooms, :room_id, :string
  end
end
