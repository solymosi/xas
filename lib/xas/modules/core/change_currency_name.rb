module XAS::Modules::Core
	class ChangeCurrencyName < XAS::Event
		reference :currency, Currency
		
		requires :currency
		changes :currency, :name
		
		field :new_name, String
		
		validate :new_name, :presence
		
		def apply(cache)
			c = cache.get references.currency, date
			c.name = new_name
			cache.save c
		end
	end
end