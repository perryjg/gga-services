module GGAServices
	class LegislationText
		attr_accessor :response
		def initialize
			@client = Savon.client(
				wsdl: 'http://webservices.legis.ga.gov/GGAServices/LegislationText/Service.svc?wsdl',
				convert_request_keys_to: :camelcase
			)
		end

		def get_legislation_text(legislation_text_id)
			message = { legislation_text_id: legislation_text_id }
			@summary_response = @client.call(:get_legislation_text, message: message)
		end
	end
end
