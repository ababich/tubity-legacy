class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :predefine_background
  before_filter :set_locale

  private

  def predefine_background
    colors = [
      '#669933',
      '#4577c3',
      '#9900cc',
      '#d18b00'
    ]

    @background_color = colors.sample
  end

  def set_locale
    I18n.locale = session[:locale] || I18n.default_locale
  end
end
