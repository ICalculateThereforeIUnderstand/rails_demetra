class Autori < ApplicationRecord
    validates :autor, presence: true, length: { maximum: 30 }, uniqueness: {case_sensitive: false}
end