class User < ApplicationRecord
  # 유저는 여러개의 포스트를 가질수 있다. 1 대 다
  has_many :microposts, dependent: :destroy
  has_many :active_relationships, class_name:  "Relationship",
           foreign_key: "follower_id",
           dependent:   :destroy
  has_many :passive_relationships, class_name: "Relationship",
           foreign_key: "followed_id",
           dependent: :destroy
  has_many :following, through: :active_relationships, source: :followed
  has_many :followers, through: :passive_relationships, source: :follower
  attr_accessor :remember_token, :activation_token, :reset_token
  before_save :downcase_email
  before_create :create_activation_digest
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
  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end

  # 유저 로그인 정보를 파기하는 메소드
  def forget
    update_attribute(:remember_digest, nil)
  end

  # アカウントを有効にする
  def activate
    update_attribute(:activated,    true)
    update_attribute(:activated_at, Time.zone.now)
  end

  # 有効化用のメールを送信する
  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  def create_reset_digest
    self.reset_token = User.new_token
    update_attribute(:reset_digest, User.digest(reset_token))
    update_attribute(:reset_sent_at, Time.zone.now)
  end

  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  # 패스워드 재설정의 기한시간이 끝난 경우 트루값을 반환
  def password_reset_expired?
    reset_sent_at < 2.hours.ago
  end

  # ユーザーのステータスフィードを返す
  def feed
    following_ids = "SELECT followed_id FROM relationships
                     WHERE follower_id = :user_id"
    Micropost.where("user_id IN (#{following_ids})
                     OR user_id = :user_id", user_id: id)
  end

  def follow(other_user)
    active_relationships.create(followed_id: other_user.id)
  end

  def unfollow(other_user)
    active_relationships.find_by(followed_id: other_user.id).destroy
  end

  def following?(other_user)
    following.include?(other_user)
  end

  private

  # メールアドレスをすべて小文字にする
  def downcase_email
    self.email = email.downcase
  end

  # 有効化トークンとダイジェストを作成および代入する
  def create_activation_digest
    self.activation_token  = User.new_token
    self.activation_digest = User.digest(activation_token)
  end

end
