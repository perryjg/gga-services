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

	describe "#get_members_by_type_and_session" do
		it "should return member list" do
			fixture = File.read('spec/fixtures/members_get_members_by_type_and_session.xml')
			message = { type: 'Senator', session_id: 22 }
			savon.expects(:get_members_by_type_and_session).with(message: message).returns(fixture)

			members = GGAServices::Member.new
			expect( members.get_members_by_type_and_session('Senator', 22) ).to be_successful
		end
	end

	describe "#get_member" do
		it "should return a member" do
			fixture = File.read('spec/fixtures/members_get_member.xml')
			message = { member_id: 165 }
			savon.expects(:get_member).with(message: message).returns(fixture)

			members = GGAServices::Member.new
			expect( members.get_member(165) ).to be_successful
		end
	end
end
