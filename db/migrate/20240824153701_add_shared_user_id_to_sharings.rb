class AddSharedUserIdToSharings < ActiveRecord::Migration[7.0]
  def change
    add_column :sharings, :shared_user_id, :integer
    add_index :sharings, :shared_user_id
  end
end
