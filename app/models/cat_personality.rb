class CatPersonality < ApplicationRecord
    
    belongs_to :cat_personality_category
    belongs_to :cat
    
    # serialize :cat_personality_category_id, JSON
    
    validates :cat_id, {presence: true} 
    validates :cat_personality_category_id, presence: true
    
end
