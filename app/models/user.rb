class User < ApplicationRecord
  acts_as_commontator

  enum role: [:user, :legal, :admin]
  after_initialize :set_default_role, :if => :new_record?

  def set_default_role
    self.role ||= :user
  end

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :marketing_requests, foreign_key: :submitted_by_id

  def to_s
    name || email
  end
end
