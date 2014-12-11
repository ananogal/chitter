class Peep
	include DataMapper::Resource

	property :id, Serial
	property :message, String, :length => 140, :required => true
	property :created_at, DateTime

	belongs_to :user

	has n, :replies, :child_key => [ :answer_id ]
 	has n, :comments, self, :through => :replies, :via => :target

 	def self.findOnlyPeeps(ids)
		Peep.all(:id.not => ids ,:order => [:created_at.desc])
 	end
end

