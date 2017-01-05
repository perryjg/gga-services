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
			@response = @client.call(:get_members_by_session, message: { session_id: session_id })
			data = @response.body[:get_members_by_session_response][:get_members_by_session_result][:member_listing]
			data.each do |d|
				# convert time to UTC format
				d[:date_vacated] = d[:date_vacated].blank? ? '' : d[:date_vacated].strftime("%a, %B %d, %Y %H:%M:%S UTC")
			end
		rescue Savon::Error => error
			puts "Error: #{error.message}"
			return error
		end

		def get_members_by_type_and_session( session_id, member_type )
			@response = @client.call(:get_members_by_type_and_session, message: { type: member_type, session_id: session_id })
			return @response.body[:get_members_by_type_and_session_response][:get_members_by_type_and_session_result][:member_listing]

		rescue Savon::Error => error
			puts "Error: #{error.message}"
			return error
		end

		def get_member(member_id)
			@response = @client.call(:get_member, message: {member_id: member_id})
			data = @response.body[:get_member_response][:get_member_result]

			# standardize the structure: make it an ara\ray even if there's only one
			if data[:sessions_in_service][:legislative_service].class == Hash
				data[:sessions_in_service][:legislative_service] = [data[:sessions_in_service][:legislative_service]]
			end

			# get rid of the xml namespace crap
			data.keys.grep(/@xmlns/).each do |key|
				data.delete(key)
			end

			return data

		rescue Savon::Error => error
			puts "Error: #{error.message}"
			return error
		end

		def method_missing(m, message)
			@reponse = @client.call(m.to_sym, message: message)
			return @response.body

		rescue Savon::Error => error
			puts "Error: #{error.message}"
			return error
		end
	end
end