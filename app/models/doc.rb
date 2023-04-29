class Doc < ApplicationRecord
  validates :slug, uniqueness: true
end
