class Veze1 < ApplicationRecord
    self.table_name = "veze1"
    validates :kolicina, numericality: { only_integer: true, greater_than: -1 }
    validates :kodadrese, numericality: { only_integer: true, greater_than: -1 }
    validates :kodknjige, numericality: { only_integer: true, greater_than: -1 }
end