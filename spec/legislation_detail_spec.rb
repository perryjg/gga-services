require 'spec_helper'
require 'savon/mock/spec_helper'

describe GGAServices::Legislation do
	include Savon::SpecHelper
	before(:all) { savon.mock! }
	after(:all)  { savon.unmock! }

	describe "#get_legislation_detail" do
		it "should return vote list" do
			fixture = File.read('spec/fixtures/legislation_get_legislation_detail.xml')
			message = { legislation_id: 33209 }
			savon.expects(:get_legislation_detail).with(message: message).returns(fixture)

			legislation = GGAServices::Legislation.new
			expect( legislation.get_legislation_detail(message) ).to be_successful
		end
	end
end
