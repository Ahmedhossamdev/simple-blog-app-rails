class Article < ApplicationRecord
  has_many :comments, dependent: :destroy
  has_rich_text :body

  VALID_STATUSES = [ "public", "private", "archived" ]

  validates :status, inclusion: { in: VALID_STATUSES }
  validates :title, presence: true
  validates :body, presence: true, length: { minimum: 10 }


  def archived?
    status == "archived"
  end
end
