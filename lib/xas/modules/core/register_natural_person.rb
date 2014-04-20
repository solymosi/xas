module XAS::Modules::Core
	class RegisterNaturalPerson < RegisterPerson
		reference :person, NaturalPerson
		validate :person, :presence
		
		field :tax_id, String
		
		def apply(cache)
			super do |p|
				p.tax_id = tax_id
				yield p if block_given?
			end
		end
	end
end