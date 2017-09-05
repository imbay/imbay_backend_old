class CreateBlacklists < ActiveRecord::Migration[5.1]
  def change
    create_table :blacklists do |t|
      t.belongs_to    :account, index: true
      t.belongs_to    :user, index: true
      t.integer       :time
      t.timestamps
    end
  end
end
