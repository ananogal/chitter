
get '/users/new' do
	erb :"users/new"
end

post '/users' do
	@user = User.create(:email => params[:email], 
						:username => params[:username],
						:name => params[:name],
						:password =>params[:password],
						:password_confirmation =>params[:password_confirmation])

	if @user.save
		session[:user_id] = @user.id
		redirect to'/'
	else
		flash.now[:errors] = @user.errors.full_messages	
		erb :"users/new"
	end
end

get '/users/forgotten' do
	erb :"users/forgotten"
end

post '/users/forgotten' do
	puts "params[:email] = #{params[:email]}"
	@user = User.first(:email => params[:email])
	if @user
		@user.password_token = (1..64).map{('A'..'Z').to_a.sample}.join
        @user.password_token_timestamp = Time.now
        @user.save
        send_message(@user)
        flash[:notice] = "We've just send you an email confirmation."
	else
		flash.now[:errors] = ["The email you enter is not correct."]
	end
	erb :"users/forgotten"
end