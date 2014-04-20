module XAS::Modules::Core
	class RegisterPerson < XAS::Event
		field :name, String
		validate :name, :presence
		
		reference :address, Address
		
		def apply(cache)
			p = cache.create person, date
			p.name = name
			p.address = address
			yield p if block_given?
			cache.save p
		end
	end
end