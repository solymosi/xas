module XAS::Modules::Core
	class RegisterCurrency < XAS::Event
		reference :currency, Currency
		validate :currency, :presence

		field :name, String
		validate :name, :presence
		
		field :code, String
		validate :code, :presence
		
		def apply(cache)
			c = cache.create currency, date
			c.name = name
			c.code = code
			cache.save c
		end
	end
end