class CreateTargetDailyRecords < ActiveRecord::Migration[5.2]
  def change
    create_table :target_daily_records do |t|
      t.references :cat, foreign_key: true
      t.references :user, foreign_key: true
      t.date :target_date
      

      t.timestamps
    end
  end
end
