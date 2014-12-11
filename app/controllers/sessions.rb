
get '/sessions/new'do
	@signingIn = true
	erb :"sessions/new"
end 

post '/sessions' do
	@user = User.authenticate(params[:email], params[:password])
	if @user
		session[:user_id] = @user.id
		session[:peep_id] = nil
		redirect to '/'
	else
		flash[:errors] = ["The email or password is incorrect."]
		erb:"sessions/new"
	end
end


delete '/sessions' do
  flash[:notice] = "Good bye!"
  session[:user_id] = nil
  redirect to('/')
end