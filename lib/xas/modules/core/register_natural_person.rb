module XAS::Modules::Core
	class RegisterNaturalPerson < RegisterPerson
		reference :person, NaturalPerson
		validate :person, :presence
		
		field :tax_id, String
		
		def apply(cache)
			p = super
			p.tax_id = tax_id
			cache.save p
		end
	end
end