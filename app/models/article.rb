class Article < ApplicationRecord
  has_many :comments, dependent: :destroy
  has_rich_text :body

  validates :title, presence: true
  validates :body, presence: true, length: { minimum: 10 }
end
