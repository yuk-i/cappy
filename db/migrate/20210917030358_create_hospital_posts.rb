class CreateHospitalPosts < ActiveRecord::Migration[5.2]
  def change
    create_table :hospital_posts do |t|
      t.references :cat, foreign_key: true
      t.references :user, foreign_key: true
      t.string :title
      t.text :content
      t.references :hospital_post_type, foreign_key: true

      t.timestamps
    end
  end
end
