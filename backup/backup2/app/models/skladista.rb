class Skladista < ApplicationRecord
    validates :skladiste, presence: true, length: { maximum: 30 }, uniqueness: {case_sensitive: false}
end