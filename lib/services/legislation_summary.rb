module GGAServices
	class Legislation
		attr_accessor :response
		def initialize
			@client = Savon.client(
				wsdl: 'http://webservices.legis.ga.gov/GGAServices/Legislation/Service.svc?wsdl',
				convert_request_keys_to: :camelcase
			)
		end

		def get_legislation_for_session(session_id)
			message = { session_id: session_id }
			@summary_response = @client.call(:get_legislation_for_session, message: message)
		end
	end
end
