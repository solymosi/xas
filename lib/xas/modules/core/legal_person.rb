module XAS::Modules::Core
	class LegalPerson < Person
		field :short_name, String
		field :tax_id, String
	end
end