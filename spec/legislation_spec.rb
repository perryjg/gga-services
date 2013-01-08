require 'spec_helper'
require 'savon/mock/spec_helper'

describe GGAServices::Legislation do
	include Savon::SpecHelper
	before(:all) { savon.mock! }
	after(:all)  { savon.unmock! }

	describe "#get_legislation_for_session" do
		it "should return vote list" do
			fixture = File.read('spec/fixtures/legislation_get_legislation_for_session.xml')
			message = { session_id: 21 }
			savon.expects(:get_legislation_for_session).with(message: message).returns(fixture)

			votes = GGAServices::Legislation.new
			expect( votes.get_legislation_for_session(21) ).to be_successful
		end
	end

	describe "#get_legislation_detail" do
		it "should return vote list" do
			fixture = File.read('spec/fixtures/legislation_get_legislation_detail.xml')
			message = { legislation_id: 33209 }
			savon.expects(:get_legislation_detail).with(message: message).returns(fixture)

			votes = GGAServices::Legislation.new
			expect( votes.get_legislation_detail(33209) ).to be_successful
		end
	end
end
