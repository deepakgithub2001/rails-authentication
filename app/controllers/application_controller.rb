class ApplicationController < ActionController::API
	include JsonWebToken
	before_action :authenticate_request

    private

   def current_user
   	header = request.headers["Authorization"] || params[:Authorization]
		header = header.split(" ").last if header
		begin
			decoded = jwt_decode(header)
			return @current_user if defined?(@current_user)
			@current_user = User.find_by_id(decoded[:user_id])
			# unless @current_user
			  # return render json: {message: "Please login agian"}
			# end
		rescue JWT::ExpiredSignature
	    return render json: { errors: "Token has expired" }, status: :unauthorized
	  rescue JWT::DecodeError => e
	    return render json: { errors: e.message }, status: :unauthorized
	  end
   end

	def authenticate_request
		unless current_user
			return render json: {message: "Please login agian"}
		end
	end
end
