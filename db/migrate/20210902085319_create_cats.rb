class CreateCats < ActiveRecord::Migration[5.2]
  def change
    create_table :cats do |t|
      t.references :family
      t.string :name
      t.date :birthday
      t.string :gender
      t.float :weight
      t.integer :food_amount
      t.integer :pee_count
      t.integer :poop_count
      t.string :favorite_snack
      t.string :favorite_toy
      t.string :hospital
      t.string :characteristic
      t.text :memo

      t.timestamps
    end
  end
end
