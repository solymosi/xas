module XAS::Modules::Core
	class RegisterCurrency < XAS::Event
		reference :currency, Currency

		field :name, String
		field :code, String
		
		field_group :hehe do
			reference :c, Currency
		end
		
		field_group_array :haha do
			reference :c, Currency
			
			field_group_hash :hes do
				reference :d, Currency
				
				field_group :xxx do
					reference :e, Currency
				end
				
				field_array :yyy, Currency
			end
		end
		
		def apply(cache)
			c = cache.create references.currency, date
			c.name = name
			c.code = code
			cache.save c
		end
	end
end