module GGAServices
	class LegislationText
		attr_accessor :response
		def initialize
			@client = Savon.client(
				wsdl: 'http://webservices.legis.ga.gov/GGAServices/LegislationText/Service.svc?wsdl',
				convert_request_keys_to: :camelcase
			)
		end

		def get_legislation_text( id )
			@response = @client.call(:get_legislation_text, message: { legislation_text_id: id })
			return @response.body[:get_legislation_text_response][:get_legislation_text_result]
		end

		def method_missing(m, message)
			@summary_response = @client.call(m.to_sym, message: message)
		end
	end
end
