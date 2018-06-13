class User < ApplicationRecord
  attr_accessor :remember_token
  before_save { self.email = email.downcase }
  validates :name, presence: true, length: { maximum: 50}
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255},
            format: { with: VALID_EMAIL_REGEX},
            uniqueness: { case_sensitive: false }
  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true

  # 전달된 문자의 해시값 반환
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
               BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  # 랜덤 토큰을 반환
  def User.new_token
    SecureRandom.urlsafe_base64
  end

  # 영구 세션을 위한 유저를 데이터베이스에 저장
  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  # 전달된 토큰이 다이제스트와 일치하면 트루값을 반환
  def authenticated?(remember_token)
    return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end

  # 유저 로그인 정보를 파기하는 메소드
  def forget
    update_attribute(:remember_digest, nil)
  end
end
