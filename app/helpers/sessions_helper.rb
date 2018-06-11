module SessionsHelper

  # 전달된 사용자로 로그인
  def log_in(user)
    session[:user_id] = user.id
  end

  # 현재 로그인중인 사용자를 반환 (있는 경우)
  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end

  # 사용자가 로그인 하고 있으면 True이고, 다르면 False를 반환
  def logged_in?
    !current_user.nil?
  end
end
