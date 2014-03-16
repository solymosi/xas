module XAS::Modules::Core
	module Events
		class RegisterCurrency < XAS::Event
			reference :currency, Items::Currency
			
			creates :currency
			
			field :name, String
			field :code, String
			
			validate :name, :presence
			validate :presence
			validate :name do |field, value|
				field.add_error :csibesz, :c => :d
			end
			
			validate do |model|
				model.add_error :modelerror, :a => :b
			end
			

			
			field_array :numbers, Integer
			field_hash :texts, String
			validate :texts, :presence
			validate :texts do |field, value|
				field.add_error :fuck_you unless value == "NO!"
			end
			
			validate :numbers, :opt => :ions do |field, value|
				field.add_error :less_than_ten if value < 10
			end
			
			field_group :sub do
				field :one, String
				field :two, Integer
				validate :two, :presence
				
				field_group_hash :sub2 do
					field_group :arr do
						field :huhu, Integer
						
						field_group_array :asdf do
							field_group_array :xyz do
								field :eee, Time
								validate :eee, :presence
							end
						end
					end
					
					field :test, String
					validate :test, :presence
				end
			end
			
			def apply(cache)
				c = cache.create references[:currency], date
				c.name = name
				c.code = code
				cache.save c
			end
		end
	end
end