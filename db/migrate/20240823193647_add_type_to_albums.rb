class AddTypeToAlbums < ActiveRecord::Migration[7.0]
  def change
    add_column :albums, :album_type, :string
  end
end
