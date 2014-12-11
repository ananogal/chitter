class Reply
  include DataMapper::Resource
 
  belongs_to :answer, 'Peep', :key => true
  belongs_to :target, 'Peep', :key => true

  def self.getAnwserIds()
  	replies = Reply.all()
		ids = []
		replies.each {|reply| ids << reply.answer_id }	
		return ids
  end

  def self.getAwswerForPeep(peep_id)
  	Reply.all(:target_id => peep_id, :order => [:answer_id.desc])
  end
 end