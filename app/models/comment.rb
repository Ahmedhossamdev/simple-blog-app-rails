class Comment < ApplicationRecord
  belongs_to :article


  VALID_STATUSES = [ "public", "private", "archived" ]

  validates :status, inclusion: { in: VALID_STATUSES }

  validates :commenter, presence: true
  validates :body, presence: true

  before_create :ensure_created_at

  private

  def ensure_created_at
    self.created_at ||= Time.current
  end

  def archived?
    status == "archived"
  end
end
