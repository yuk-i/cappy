class HospitalPost < ApplicationRecord
    belongs_to :cat
    belongs_to :user
    belongs_to :hospital_post_type
    
    validates :title, length: {maximum: 30}
    validates :content, length: {maximum: 140}
    validates :hospital_post_type_id, presence: true
    
    
end
