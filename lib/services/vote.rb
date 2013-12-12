module GGAServices
	class Vote
		attr_accessor :response

		def initialize
			@client = Savon.client(
				wsdl: 'http://webservices.legis.ga.gov/GGAServices/Votes/Service.svc?wsdl',
				convert_request_keys_to: :camelcase
			)
		end

		def get_vote(id)
			@response = @client.call(:get_vote, message: { vote_id: id })
			return @response.body[:get_vote_response][:get_vote_result]

		rescue Savon::Error => error
			puts "Error: #{error.message}"
			return error
		end

		def method_missing(m, message)
			@response = @client.call(m.to_sym, message: message)
		end
	end
end
