require 'spec_helper'
require_relative 'helpers/sessions'
require_relative 'helpers/peeps'

include SessionHelpers
include PeepsHelper

feature "To post a peep" do

	before(:each) do
		User.create(:email => "test@test.com",
					:name =>"Test",
					:username => "test",
					:password => "test",
					:password_confirmation => "test")
	end

	scenario "user must be sign in" do
		visit '/'
		expect(page).not_to have_content("New peep")
		sign_in("test@test.com", "test")
		expect(page).to have_content("New peep")
	end

	scenario "user can access page to peep" do
		sign_in("test@test.com", "test")
		click_link 'New peep'
		expect(page).to have_content("Tell us what's on your mind!")
	end

	scenario "user enters a text" do
		create_peep("test@test.com", "test", "My first peep")
		expect(Peep.first.message).to eq("My first peep")
	end

	scenario "user enter peep and goes to homepage" do
		create_peep("test@test.com", "test", "My first peep")
		expect(page).to  have_content("What's going on...")
	end
end

feature "User browses the list of peeps" do
	
	before(:each) {
			User.create(:email => "test@test.com",
					:name =>"Test",
					:username => "test",
					:password => "test",
					:password_confirmation => "test")
			User.create(:email => "ana@test.com",
					:name =>"Ana",
					:username => "ana",
					:password => "ana",
					:password_confirmation => "ana")

			create_peep("test@test.com", "test", "Test first peep")
			create_peep("ana@test.com", "ana", "Ana first peep")
			create_peep("test@test.com", "test", "Test second peep")
			create_peep("ana@test.com", "ana", "Ana second peep")
		}

	scenario "when enter the homepage" do
		visit '/'
		expect(page).to have_content("What's going on...")
	end

	scenario "user sees peeps order chronologically" do
		sleep(2)
		create_peep("ana@test.com", "ana", "Ana\'s last peep")
		expect(page.body.index("Ana\'s last peep")).to be < (page.body.index("Ana second peep"))
	end

end

feature "To reply to a peep" do

	before(:each) {
		User.create(:email => "test@test.com",
				:name =>"Test",
				:username => "test",
				:password => "test",
				:password_confirmation => "test")
		User.create(:email => "ana@test.com",
				:name =>"Ana",
				:username => "ana",
				:password => "ana",
				:password_confirmation => "ana")

		create_peep("test@test.com", "test", "Test first peep")
		sleep(1)
		create_peep("ana@test.com", "ana", "Ana first peep")
		sleep(1)
		create_peep("test@test.com", "test", "Test second peep")
		sleep(1)
		create_peep("ana@test.com", "ana", "Ana second peep")
	}

	scenario "user enters a text" do
		reply
		expect(Reply.count).to eq(1)
	end

	scenario "reply should be visible under peep" do
		reply
		expect(page.body.index("Reply to another user")).to be > (page.body.index("Test second peep"))
	end

	def reply
		visit '/'
		first(:button, 'Reply').click
		fill_in :message, :with => "Reply to another user"
		click_button 'Peep'
	end
end




