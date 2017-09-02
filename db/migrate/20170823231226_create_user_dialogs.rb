class CreateUserDialogs < ActiveRecord::Migration[5.1]
  def change
    create_table :user_dialogs do |t|
      t.belongs_to    :account, index: true
      t.belongs_to    :dialog, index: true
      t.integer       :new_messages_count, default: 0
      t.timestamps
    end
  end
end
