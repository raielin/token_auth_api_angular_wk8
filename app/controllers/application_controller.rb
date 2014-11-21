class ApplicationController < ActionController::API
  # This is expanding the Rails API app to include additional Rails methods & classes.
	include ActionController::HttpAuthentication::Token::ControllerMethods

  # Protected method - all other controllers that inherit from this have access to it.
	protected
    # This is a helper method. It's better to put this here as opposed to like
    # a comments model or something. You might need it in another controller and all
    # other controllers inherit from this controller.
	  def authenticate
      # This is a method that takes the do-block as its argument, i.e. we pass functions
      # as arguments in javascript. So token and options are like its local variables.
      # Either authenticate or request with http_token. If it finds a user with this token,
      # if so, return it and say this is the user, if not, request a new token. Returns
      # truthy or falsey / or a user if true.
	    authenticate_or_request_with_http_token do |token, options|
	      User.find_by(token: token)
	    end
	  end
end
