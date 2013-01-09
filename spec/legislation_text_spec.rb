require 'spec_helper'
require 'savon/mock/spec_helper'

describe GGAServices::LegislationText do
	include Savon::SpecHelper
	before(:all) { savon.mock! }
	after(:all)  { savon.unmock! }

	describe "#get_legislation_text" do
		it "should return legislation text" do
			fixture = File.read('spec/fixtures/legislation_text_get_legislation_text.xml')
			message = { legislation_text_id: 127646 }
			savon.expects(:get_legislation_text).with(message: message).returns(fixture)

			legislation_text = GGAServices::LegislationText.new
			expect( legislation_text.get_legislation_text(127646) ).to be_successful
		end
	end
end
