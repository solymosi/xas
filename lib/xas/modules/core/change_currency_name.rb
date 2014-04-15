module XAS::Modules::Core
	class ChangeCurrencyName < XAS::Event
		reference :currency, Currency
		validate :currency, :presence
		
		field :new_name, String
		validate :new_name, :presence
		
		def apply(cache)
			c = cache.get currency, date
			c.name = new_name
			cache.save c
		end
	end
end