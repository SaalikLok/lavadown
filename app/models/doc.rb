class Doc < ApplicationRecord
  validates :title, presence: true
  validates :slug, uniqueness: true
end
