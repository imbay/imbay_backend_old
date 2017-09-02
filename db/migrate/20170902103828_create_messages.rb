class CreateMessages < ActiveRecord::Migration[5.1]
  def change
    create_table :messages do |t|
      t.belongs_to    :account, index: true
      t.belongs_to    :dialog, index: true
      t.string        :text
      t.integer       :time
      t.timestamps
    end
  end
end
