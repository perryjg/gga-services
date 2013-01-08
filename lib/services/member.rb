module GGAServices
	class Member
		attr_accessor :response
		def initialize
			@client = Savon.client(
				wsdl: 'http://webservices.legis.ga.gov/GGAServices/Members/Service.svc?wsdl',
				convert_request_keys_to: :camelcase
			)
		end

		def get_members_by_session(session_id)
			message = { session_id: session_id }
			@reponse = @client.call(:get_members_by_session, message: message)
		end

		def get_members_by_type_and_session(type, session_id)
			message = { type: type, session_id: session_id }
			@reponse = @client.call(:get_members_by_type_and_session, message: message)
		end

		def get_member(member_id)
			message = { member_id: member_id }
			@reponse = @client.call(:get_member, message: message)
		end
	end
end