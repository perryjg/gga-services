module GGAServices
	class Member
		attr_accessor :response
		def initialize
			@client = Savon.client(
				wsdl: 'http://webservices.legis.ga.gov/GGAServices/Members/Service.svc?wsdl',
				convert_request_keys_to: :camelcase
			)
		end

		def method_missing(m, message)
			@reponse = @client.call(m.to_sym, message: message)
		end
	end
end