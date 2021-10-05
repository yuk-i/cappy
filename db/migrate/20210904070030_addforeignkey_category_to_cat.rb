class AddforeignkeyCategoryToCat < ActiveRecord::Migration[5.2]
  def change
    remove_reference :cats, :cat_category, index: true
    remove_reference :cats, :cat_sand_category, index: true
    
    add_reference :cats, :cat_category, foreign_key: true
    add_reference :cats, :cat_sand_category, foreign_key: true
  end
end
