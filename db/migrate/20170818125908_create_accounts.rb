class CreateAccounts < ActiveRecord::Migration[5.1]
  def change
    create_table :accounts do |t|
      t.string        :username
      t.string        :password
      t.boolean       :is_active,               default: true
      t.integer       :joined_time
      t.integer       :login_time
      t.string        :language
      t.string        :email,                   null: true
      t.string        :joined_ip,               null: true
      t.string        :logged_ip,               null: true
      t.integer       :inviter,                 null: true

      t.string        :first_name
      t.string        :last_name
      t.integer       :gender,                  limit: 1
      t.date          :birthday

      t.timestamps
    end
    add_index :accounts, :email,                unique: true
    add_index :accounts, :username,             unique: true
  end
end
