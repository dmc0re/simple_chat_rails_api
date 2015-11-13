class AddUserRefToChannels < ActiveRecord::Migration
  def change
    add_reference :channels, :user, index: true, foreign_key: { on_update: :restrict, on_delete: :restrict }
  end
end
