module XAS::Modules::Core
	class RegisterLegalPerson < RegisterPerson
		reference :person, LegalPerson
		validate :person, :presence
		
		field :short_name, String
		field :tax_id, String
		
		def apply(cache)
			p = super
			p.short_name = short_name
			p.tax_id = tax_id
			cache.save p
		end
	end
end