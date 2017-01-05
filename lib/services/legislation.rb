module GGAServices
	class Legislation
		attr_accessor :response

		def initialize
			@client = Savon.client(
				wsdl: 'http://webservices.legis.ga.gov/GGAServices/Legislation/Service.svc?wsdl',
				convert_request_keys_to: :camelcase
			)
		end

		def get_legislation_for_session( session_id )
			@response = @client.call(:get_legislation_for_session, message: { session_id: session_id })
			return @response.body[:get_legislation_for_session_response][:get_legislation_for_session_result][:legislation_index]
		end

		def get_legislation_detail( legislation_id )
			@response = @client.call(:get_legislation_detail, message: { legislation_id: legislation_id })
			data = response.body[:get_legislation_detail_response][:get_legislation_detail_result]
			return munge_detail_response(data)
		end

		# def get_legislation_detail_by_description( document_type, number, session_id )
		# 	@response = @client.call(:get_legislation_detail, message: { document_type: document_type, number: number, session_id: session_id })
		# 	data = response.body[:get_legislation_detail_by_description_response][:get_legislation_detail_by_description_result]
		# 	return munge_detail_response(data)

		# rescue Savon::Error => error
		# 	return error
		# end

		# def method_missing(m, message)
		# 	@response = @client.call(m.to_sym, message: message)
		# end

		private

			def munge_detail_response(bill)
				if bill[:authors] && bill[:authors][:sponsorship].kind_of?(Hash)
					bill[:authors][:sponsorship] = [bill[:authors][:sponsorship]]
				end

				if bill[:committees] && bill[:committees][:committe_listing].kind_of?(Hash)
					bill[:committees][:committe_listing] = [bill[:committees][:committe_listing]]
				end

				if bill[:status_history] && bill[:status_history][:status_listing].kind_of?(Hash)
					bill[:status_history][:status_listing] = [bill[:status_history][:status_listing]]
				end

				if bill[:versions] && bill[:versions][:document_description].kind_of?(Hash)
					bill[:versions][:document_description] = [bill[:versions][:document_description]]
				end

				if bill[:votes] && bill[:votes][:vote_listing].kind_of?(Hash)
					bill[:votes][:vote_listing] = [bill[:votes][:vote_listing]]
				end

				bill.keys.grep(/@xmlns/).each do |key|
					bill.delete(key)
				end

				return bill
			end
	end
end
