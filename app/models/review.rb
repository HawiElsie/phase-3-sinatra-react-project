class Review < ActiveRecord::Base
    belongs_to :pokemon

    validates :text, presence: true
    validates :rating, presence: true
end