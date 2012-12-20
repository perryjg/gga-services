require 'spec_helper'
require 'savon/mock/spec_helper'

describe GGAServices::Member do
	include Savon::SpecHelper
	before(:all) { savon.mock! }
	after(:all)  { savon.unmock! }


	describe "#get_members_by_session" do
		it "should return member list" do
			fixture = File.read('spec/fixtures/members_get_members_by_session.xml')
			message = { session_id: 22 }
			savon.expects(:get_members_by_session).with(message: message).returns(fixture)

			members = GGAServices::Member.new
			expect( members.get_members_by_session(22) ).to be_successful
		end
	end
end
