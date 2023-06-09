class Pokemon < ActiveRecord::Base
    has_many :reviews

    validates :name, uniqueness: true
end
