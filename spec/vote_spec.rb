require 'spec_helper'
require 'savon/mock/spec_helper'

describe GGAServices::Vote do
	include Savon::SpecHelper
	before(:all) { savon.mock! }
	after(:all)  { savon.unmock! }

	describe "#get_votes" do
		it "should return vote list" do
			fixture = File.read('spec/fixtures/votes_get_votes.xml')
			message = { branch: 'House', session_id: 21 }
			savon.expects(:get_votes).with(message: message).returns(fixture)

			votes = GGAServices::Vote.new
			expect( votes.get_votes('House', 21) ).to be_successful
		end
	end
end
