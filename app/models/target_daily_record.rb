class TargetDailyRecord < ApplicationRecord
    belongs_to :cat
    belongs_to :user
    
    has_many :daily_records
    accepts_nested_attributes_for :daily_records
end
