module XAS::Modules::Console
	module Test
		extend self
		
		def run!
			env = XAS::Environment
			core = XAS::Modules::Core
			reg = env.registry
			cache = env.item_cache
			
			log "Removing all events..."
			reg.storage.event_collection.remove
			log "Removed all events."
			
			log "Creating RegisterCurrency event..."
			c = core::RegisterCurrency.new
			c.date = Time.utc(2014, 01, 01)
			c.currency.build
			c.name = "Hungarian Forint"
			c.code = "HUF"
			reg.save c
			log "Created RegisterCurrency event."
			
			log "Creating RegisterAddress event..."
			a = core::RegisterAddress.new
			a.date = Time.utc(2014, 01, 01)
			a.address.build
			a.country = "Hungary"
			a.postal_code = "1093"
			a.city = "Budapest"
			a.street = "Fovam ter 8"
			reg.save a
			log "Created RegisterAddress event."
			
			log "Creating RegisterNaturalPerson event..."
			p = core::RegisterNaturalPerson.new
			p.date = Time.utc(2014, 01, 01)
			p.person.build
			p.name = "Mate Solymosi"
			p.address = a.address
			reg.save p
			log "Created RegisterNaturalPerson event."
		ensure
			binding.pry
		end
		
		def log(message)
			puts
			puts "*** #{message}"
		end
	end
end