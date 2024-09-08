class Comment < ApplicationRecord
  belongs_to :article


  include Visible


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
