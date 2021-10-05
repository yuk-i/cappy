class CreateUserIcons < ActiveRecord::Migration[5.2]
  def change
    create_table :user_icons do |t|
      t.string :like_cat_color
      t.string :images

      t.timestamps
    end
  end
end
