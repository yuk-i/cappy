class Invitation < ApplicationRecord
  belongs_to :family
  
  validates :email,{presence: true, uniqueness: true}
end
