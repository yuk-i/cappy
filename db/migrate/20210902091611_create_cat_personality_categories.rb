class CreateCatPersonalityCategories < ActiveRecord::Migration[5.2]
  def change
    create_table :cat_personality_categories do |t|
      t.string :name
      t.timestamps
    end
  end
end
