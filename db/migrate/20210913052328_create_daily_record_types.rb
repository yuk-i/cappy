class CreateDailyRecordTypes < ActiveRecord::Migration[5.2]
  def change
    create_table :daily_record_types do |t|
      t.string :image

      t.timestamps
    end
  end
end
