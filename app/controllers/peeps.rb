get '/peep/new' do
	if params[:peep_id] 
		session[:peep_id] = params[:peep_id]
	end
	erb :"peeps/new"
end

post '/peep/new' do
	if session[:peep_id]
		@parent_peep = Peep.get(session[:peep_id])
		if @parent_peep
			@new_peep = Peep.create(:message =>params[:message], :created_at => DateTime.now, :user_id => session[:user_id])
			if @new_peep
				@peep = Reply.create(:answer_id => @new_peep.id, :target_id => @parent_peep.id)
			end
		end
	else
		@peep = Peep.create(:message =>params[:message], :created_at => DateTime.now, :user_id => session[:user_id])
	end
	if @peep
		redirect to '/'
	end
end