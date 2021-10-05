class AddChangeCatIdCategoryToCatPersonality < ActiveRecord::Migration[5.2]
  def change
    remove_reference :cat_personalities, :cat 
    remove_reference :cat_personalities, :cat_personality_category
    
    add_reference :cat_personalities, :cat, foreign_key: true
    add_reference :cat_personalities, :cat_personality_category, foreign_key: true
  end
end
