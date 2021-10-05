class CreateCatPersonalities < ActiveRecord::Migration[5.2]
  def change
    create_table :cat_personalities do |t|
      t.references :cat
      t.references :cat_personality_category

      t.timestamps
    end
  end
end
