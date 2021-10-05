class Cat < ApplicationRecord
    
    belongs_to :cat_category
    belongs_to :cat_sand_category
    belongs_to :family
    
    has_many :hospital_posts
    has_many :target_daily_records
    has_many :cat_personalities
    accepts_nested_attributes_for :cat_personalities
    
    # 1枚だけ写真を紐づける
    has_one_attached :image
    
    
    with_options presence: true do
        validates :name, length: {maximum: 10}
        validates :birthday
        validates :gender
        validates :cat_category_id
        validates :weight, numericality: true #数値のみOK
        validates :food_amount, numericality: { only_integer: true } #数値(整数)のみOK
        validates :pee_count, inclusion: { in: 0..10 } #数字0-10までOK
        validates :poop_count, inclusion: { in: 0..10 }
        validates :cat_sand_category_id
        with_options length: {maximum: 50} do
            validates :favorite_snack
            validates :favorite_toy
            validates :hospital
            validates :characteristic
        end
    end
    validates_length_of :memo, maximum: 140
    
end
