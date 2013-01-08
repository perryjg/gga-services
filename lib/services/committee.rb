module GGAServices
	class Committee
		def initialize
			@client = Savon.client(
				wsdl: 'http://webservices.legis.ga.gov/GGAServices/Committees/Service.svc?wsdl',
				convert_request_keys_to: :camelcase
			)
		end

		def get_committees_by_session(session_id)
			message = { session_id: session_id }
			@client.call(:get_committees_by_session, message: message)
		end

		def get_committees_by_type_and_session(type, session_id)
			message = { type: type, session_id: session_id }
			@client.call(:get_committees_by_type_and_session, message: message)
		end

		def get_committee(committee_id)
			message = { committee_id: committee_id }
			@client.call(:get_committee, message: message)
		end

		def get_committee_for_session(committee_id, session_id)
			message = { committee_id: committee_id, session_id: session_id }
			@client.call(:get_committee_for_session, message: message)
		end
	end
end
