class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users, if_not_exists: true do |t|
      t.string :username, null: false, limit: 16
      t.string :password_digest, null: false
      t.boolean :admin, null: false

      t.timestamps
    end
  end
end
