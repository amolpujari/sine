class User < ApplicationRecord
  devise :database_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable

  enum role: [:user, :legal, :admin]

  acts_as_commontator

  has_many :marketing_requests, foreign_key: :submitted_by_id
  has_many :assets, foreign_key: :uploaded_by_id

  validates :name, presence: true, length: { minimum: 3, maximum: 32 }

  before_save :ensure_reset_password_token_is_not_blank
  after_initialize :set_default_role, :if => :new_record?

  def set_default_role
    self.role ||= :user
  end

  def ensure_reset_password_token_is_not_blank
    self.reset_password_token = nil if self.reset_password_token.blank?
  end

  def to_s
    name || email
  end
end
