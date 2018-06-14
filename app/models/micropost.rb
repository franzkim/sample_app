class Micropost < ApplicationRecord
  # 마이크로포스트와 유저의 관계는 1대1
  belongs_to :user
  default_scope -> { order(created_at: :desc) }
  validates :user_id, presence: true
  validates :content, presence: true, length: {maximum: 140}
end
