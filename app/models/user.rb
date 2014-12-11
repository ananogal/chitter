require 'bcrypt'

class User 
	include DataMapper::Resource

	attr_reader :password
	attr_accessor :password_confirmation

	property :id, Serial
	property :email, String,  :required => true, :unique => true, :format   => :email_address, 
			:messages => {
			      :presence  => "The email is mandatory",
			      :is_unique => "This email is already taken.",
			      :format    => "Doesn't look like an email address to me ..."
			    }
	property :name, String,  :required => true,:message => "The name is mandatory" 
	property :username, String,  :required => true, :unique => true, :messages => {
			      :presence  => "The username is mandatory",
			      :is_unique => "This username is already taken."
			    }
	property :password_digest, Text
	property :password_token, Text
	property :password_token_timestamp, Time

	has n, :peeps

	validates_confirmation_of :password
	validates_presence_of :password, :message => "The password is mandatory"

	def password=(password)
		@password = password
  	self.password_digest = BCrypt::Password.create(password)
	end

	def self.authenticate(email, password)
		user = first(:email => email)
		if user && BCrypt::Password.new(user.password_digest) == password
			user
		else
			nil
		end
	end

	def self.createTokenForEmail(email)
		user = first(:email => email)
		return nil if !user

		user.password_token = (1..64).map{('A'..'Z').to_a.sample}.join
    user.password_token_timestamp = Time.now
    user.save
    return user
  end

  def self.resetPasswordForToken(token, password, password_conf)
		user = first(:password_token => token)
		if user
			user.password = password
			user.password_confirmation = password_conf
			user.save
			return user
		else
			return nil
		end
  end	
end