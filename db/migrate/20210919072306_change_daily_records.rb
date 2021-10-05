class ChangeDailyRecords < ActiveRecord::Migration[5.2]
  def change
    remove_reference :daily_records, :cat
    remove_reference :daily_records, :user
    remove_column :daily_records, :target_date, :date
    
    add_reference :daily_records, :target_daily_record, foreign_key: true
    
  end
end
