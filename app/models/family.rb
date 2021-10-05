class Family < ApplicationRecord
    
    has_many :users
    has_many :cats
    has_many :invitations
    
    with_options presence: true do
        validates :name, length: { maximum: 20 }
        validates :family_unique_id, uniqueness: true, length: { in: 6..12 },
                                    format: { with: /\A[a-z0-9]+\z/i } #半角英数字のみ
    end
   
end
