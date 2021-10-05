class CreateCatSandCategories < ActiveRecord::Migration[5.2]
  def change
    create_table :cat_sand_categories do |t|
      t.string :name
      t.timestamps
    end
  end
end
