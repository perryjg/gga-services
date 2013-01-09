module GGAServices
	class LegislativeSession
		attr_accessor :response
		def initialize
			@client = Savon.client(
				wsdl: 'http://webservices.legis.ga.gov/GGAServices/Session/Service.svc?wsdl',
				convert_request_keys_to: :camelcase
			)
		end

		def get_sessions
			@response = @client.call(:get_sessions)
		end

		def get_years
			@response = @client.call(:get_years)
		end

		def get_session_schedule
			@response = @client.call(:get_session_schedule)
		end
	end
end