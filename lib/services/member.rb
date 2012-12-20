module GGAServices
	class Member
		def initialize
			@client = Savon.client(wsdl: 'http://webservices.legis.ga.gov/GGAServices/Members/Service.svc?wsdl')
		end

		def get_members_by_session(session_id)
			message = { session_id: session_id }
			@client.call(:get_members_by_session, message: message)
		end
	end
end