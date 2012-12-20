require 'spec_helper'
require 'savon/mock/spec_helper'

describe GGAServices::LegislativeSession do
	include Savon::SpecHelper
	before(:all) { savon.mock! }
	after(:all)  { savon.unmock! }

	describe "#get_sessions" do
		it "should return session list" do
			fixture = File.read('spec/fixtures/get_sessions.xml')
			savon.expects(:get_sessions).returns(fixture)

			sessions = GGAServices::LegislativeSession.new
			expect(sessions.get_sessions).to be_successful
		end
	end

	describe "#get_years" do
		it "should return sessions by year list" do
			fixture = File.read('spec/fixtures/get_years.xml')
			savon.expects(:get_years).returns(fixture)
			
			sessions = GGAServices::LegislativeSession.new
			expect(sessions.get_years).to be_successful
		end
	end

	describe "#get_session_schedule" do
		it "should return sessions schedule" do
			fixture = File.read('spec/fixtures/get_years.xml')
			savon.expects(:get_session_schedule).returns(fixture)
			
			sessions = GGAServices::LegislativeSession.new
			expect(sessions.get_session_schedule).to be_successful
		end
	end
end
