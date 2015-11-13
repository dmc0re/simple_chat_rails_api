class AddUserRefToMessages < ActiveRecord::Migration
  def change
    add_reference :messages, :user, index: true, foreign_key: { on_update: :restrict, on_delete: :restrict }
  end
end
