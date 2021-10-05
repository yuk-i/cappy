class CreateHospitalPostTypes < ActiveRecord::Migration[5.2]
  def change
    create_table :hospital_post_types do |t|
      t.string :image

      t.timestamps
    end
  end
end
