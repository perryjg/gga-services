module GGAServices
	class Legislation
		attr_accessor :response

		def initialize
			@client = Savon.client(
				wsdl: 'http://webservices.legis.ga.gov/GGAServices/Legislation/Service.svc?wsdl',
				convert_request_keys_to: :camelcase
			)
		end

		def method_missing(m, message)
			@response = @client.call(m.to_sym, message: message)
		end
	end
end
