module GGAServices
	class Member
		attr_accessor :response
		def initialize
			@client = Savon.client(
				wsdl: 'http://webservices.legis.ga.gov/GGAServices/Members/Service.svc?wsdl',
				convert_request_keys_to: :camelcase
			)
		end

		def get_members_by_session( session_id )
			@response = @client.call(:get_members_by_session, message: { session_id: session_id }).body[:get_members_by_session_response][:get_members_by_session_result][:member_listing]
		end

		def method_missing(m, message)
			@reponse = @client.call(m.to_sym, message: message)
		end
	end
end