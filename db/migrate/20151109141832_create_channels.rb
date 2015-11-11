class CreateChannels < ActiveRecord::Migration
  def change
    enable_extension 'citext'

    create_table :channels do |t|
      t.citext  :name, null: false

      t.timestamps null: false

      t.index :name, unique: true
    end
  end
end
