class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.string  :text, null: false

      t.timestamps null: false

      t.references :channel, index: true,  foreign_key: { on_update: :restrict, on_delete: :restrict }
    end
  end
end
