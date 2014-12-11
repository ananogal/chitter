get '/' do
	@peeps = Peep.findOnlyPeeps(Reply.getAnwserIds)
	erb :index
end