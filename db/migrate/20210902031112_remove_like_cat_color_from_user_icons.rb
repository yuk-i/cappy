class RemoveLikeCatColorFromUserIcons < ActiveRecord::Migration[5.2]
  def change
    remove_column :user_icons, :like_cat_color, :string
  end
end
