require 'spec_helper'
require 'savon/mock/spec_helper'

describe GGAServices::Committee do
	include Savon::SpecHelper
	before(:all) { savon.mock! }
	after(:all)  { savon.unmock! }

	describe "#get_committees_by_session" do
		it "should return committee list" do
			fixture = File.read('spec/fixtures/committees_get_committees_by_session.xml')
			message = { session_id: 22 }
			savon.expects(:get_committees_by_session).with(message: message).returns(fixture)

			committees = GGAServices::Committee.new
			expect( committees.get_committees_by_session(message) ).to be_successful
		end
	end

	describe "#get_committees_by_type_and_session" do
		it "should return committee list" do
			fixture = File.read('spec/fixtures/committees_get_committees_by_type_and_session.xml')
			message = { type: 'House', session_id: 22 }
			savon.expects(:get_committees_by_type_and_session).with(message: message).returns(fixture)

			committees = GGAServices::Committee.new
			expect( committees.get_committees_by_type_and_session(message) ).to be_successful
		end
	end

	describe "#get_committee" do
		it "should return committee record" do
			fixture = File.read('spec/fixtures/committees_get_committee.xml')
			message = { committee_id: 75 }
			savon.expects(:get_committee).with(message: message).returns(fixture)

			committees = GGAServices::Committee.new
			expect( committees.get_committee(message) ).to be_successful
		end
	end

	describe "#get_committee_for_session" do
		it "should return committee record for session" do
			fixture = File.read('spec/fixtures/committees_get_committee_for_session.xml')
			message = { session_id: 21, committee_id: 75 }
			savon.expects(:get_committee_for_session).with(message: message).returns(fixture)

			committees = GGAServices::Committee.new
			expect( committees.get_committee_for_session(message) ).to be_successful
		end
	end
end
