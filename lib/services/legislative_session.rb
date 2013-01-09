module GGAServices
	class LegislativeSession
		attr_accessor :response
		def initialize
			@client = Savon.client(
				wsdl: 'http://webservices.legis.ga.gov/GGAServices/Session/Service.svc?wsdl',
				convert_request_keys_to: :camelcase
			)
		end

		def method_missing(m)
			@response = @client.call(m.to_sym)
		end
	end
end