class ApplicationController < ActionController::Base
  protect_from_forgery

  include  SessionsHelper

  # Forced sign out to handle CSRF attack

  def handle_unverified_request
  	sign_out 
  	super
  end
end
