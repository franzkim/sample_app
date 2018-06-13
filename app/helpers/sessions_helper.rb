module SessionsHelper

  # 전달된 사용자로 로그인
  def log_in(user)
    session[:user_id] = user.id
  end

  # 유저의 세션을 영구적으로 지속시키는 리멤버 함수
  def remember(user)
    user.remember
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end

  # 전달된 유저가 로그인 된 유저라면 True를 반환
  def current_user?(user)
    user == current_user
  end

  # 현재 로그인중인 사용자를 반환 (있는 경우)
  def current_user
    if (user_id = session[:user_id])
      @current_user ||= User.find_by(id: user_id)
    elsif (user_id = cookies.signed[:user_id])
      user = User.find_by(id: user_id)
      if user && user.authenticated?(:remember, cookies[:remember_token])
        log_in user
        @current_user = user
      end
    end
  end

  # 사용자가 로그인 하고 있으면 True이고, 다르면 False를 반환
  def logged_in?
    !current_user.nil?
  end

  # 영구세션을 파기시키는 메소드
  def forget(user)
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end

  def log_out
    forget(current_user)
    session.delete(:user_id)
    @current_user = nil
  end

  # 記憶したURL (もしくはデフォルト値) にリダイレクト
  def redirect_back_or(default)
    redirect_to(session[:forwarding_url] || default)
    session.delete(:forwarding_url)
  end

  # アクセスしようとしたURLを覚えておく
  def store_location
    session[:forwarding_url] = request.original_url if request.get?
  end

end
