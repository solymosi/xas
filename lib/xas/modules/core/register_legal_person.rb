module XAS::Modules::Core
	class RegisterLegalPerson < RegisterPerson
		reference :person, LegalPerson
		validate :person, :presence
		
		field :short_name, String
		field :tax_id, String
		
		def apply(cache)
			super do |p|
				p.short_name = short_name
				p.tax_id = tax_id
				yield p if block_given?
			end
		end
	end
end