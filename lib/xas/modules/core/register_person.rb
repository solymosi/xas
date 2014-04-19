module XAS::Modules::Core
	class RegisterPerson < XAS::Event
		field :name, String
		validate :name, :presence
		
		reference :address, Address
		
		def apply(cache)
			p = cache.create person, date
			p.name = name
			p.address = address
			p
		end
	end
end