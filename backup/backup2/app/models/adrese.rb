class Adrese < ApplicationRecord
    self.table_name = "adrese"
    validates :adresa, presence: true, length: { maximum: 30 }, uniqueness: {case_sensitive: false}
end