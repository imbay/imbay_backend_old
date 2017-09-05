class CreateDialogs < ActiveRecord::Migration[5.1]
  def change
    create_table :dialogs do |t|
      t.belongs_to    :account, index: true
      t.timestamps

      t.string        :title
      t.integer       :time
      t.boolean       :is_anon, default: false
      t.string        :last_message, null: true
      t.belongs_to    :last_writer, index: true
    end
  end
end
