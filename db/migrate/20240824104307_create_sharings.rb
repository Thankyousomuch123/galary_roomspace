class CreateSharings < ActiveRecord::Migration[7.0]
  def change
    create_table :sharings do |t|
      t.references :shareable, polymorphic: true, null: false
      t.references :user, null: false, foreign_key: true
      t.datetime :shared_at

      t.timestamps
    end
  end
end
