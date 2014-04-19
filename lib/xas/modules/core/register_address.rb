module XAS::Modules::Core
	class RegisterAddress < XAS::Event
		reference :address, Address
		validate :address, :presence

		field :country, String
		validate :country, :presence
		
		field :postal_code, String
		
		field :city, String
		validate :city, :presence
		
		field :street, String
		validate :street, :presence
		
		def apply(cache)
			a = cache.create address, date
			a.country = country
			a.postal_code = postal_code unless postal_code.nil?
			a.city = city
			a.street = street
			cache.save a
		end
	end
end