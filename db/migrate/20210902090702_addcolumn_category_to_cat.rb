class AddcolumnCategoryToCat < ActiveRecord::Migration[5.2]
  def change
    add_reference :cats, :cat_category, index: true
    add_reference :cats, :cat_sand_category, index: true
  end
end
