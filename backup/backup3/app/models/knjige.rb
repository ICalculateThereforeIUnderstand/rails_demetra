class Knjige < ApplicationRecord
    #belongs_to:biblioteke
    #validates :slika, attached: true, content_type: ['image/jpg', 'image/jpeg'], size: { between: 1.kilobyte..64.kilobytes , message: 'File is of wrong size, maximum is 64KB' }
    #validates :slika, attached: true, content_type: [:png, :jpg, :jpeg]
    #validates :slika, content_type: [:png, :jpg, :jpeg]
    validates :naslov, presence: true
    validates :cijena, numericality: { only_integer: true }, allow_nil: true
    validates :brojstranica, numericality: { only_integer: true }, allow_nil: true
end