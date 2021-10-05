class CreateDailyRecords < ActiveRecord::Migration[5.2]
  def change
    create_table :daily_records do |t|
      t.references :cat, foreign_key: true
      t.references :user, foreign_key: true
      t.date :target_date
      t.references :daily_record_type, foreign_key: true
      t.integer :count
      t.integer :amount
      t.string :status
      t.float :weight
      t.string :memo

      t.timestamps
    end
  end
end
