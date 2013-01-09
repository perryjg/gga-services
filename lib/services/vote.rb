module GGAServices
	class Vote
		attr_accessor :response

		def initialize
			@client = Savon.client(
				wsdl: 'http://webservices.legis.ga.gov/GGAServices/Votes/Service.svc?wsdl',
				convert_request_keys_to: :camelcase
			)
			@response = nil
		end

		def get_votes(branch, session_id)
			message = { branch: branch, session_id: session_id }
			@response = @client.call(:get_votes, message: message)
		end

		def get_votes_for_legislation(legislation_id)
			message = { legislation_id: legislation_id }
			@response = @client.call(:get_votes_for_legislation, message: message)
		end

		def get_vote(vote_id)
			message = { vote_id: vote_id }
			@response = @client.call(:get_vote, message: message)
		end
	end
end
