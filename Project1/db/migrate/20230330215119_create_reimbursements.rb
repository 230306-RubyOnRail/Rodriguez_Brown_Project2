class CreateReimbursements < ActiveRecord::Migration[7.0]
  def change
    create_table :reimbursements, if_not_exists: true do |t|
      t.integer :amount, null: false
      t.string :description, null: false
      t.integer :status, default: 1
      t.belongs_to :user, foreign_key: true

      t.timestamps
    end
  end
end
