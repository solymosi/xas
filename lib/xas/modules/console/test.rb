module XAS::Modules::Console
	module Test
		extend self
		
		def run!
			env = XAS::Environment
			core = XAS::Modules::Core
			hun = XAS::Modules::Hun
			ifrs = XAS::Modules::Ifrs
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
			
			log "Creating Hun::CreatePolicy event..."
			hunp = hun::CreatePolicy.new
			hunp.date = Time.utc(2014, 01, 01)
			hunp.policy.build
			hunp.book_currency = c.currency
			reg.save hunp
			log "Created Hun::CreatePolicy event."
			
			log "Creating Ifrs::CreatePolicy event..."
			ifrsp = ifrs::CreatePolicy.new
			ifrsp.date = Time.utc(2014, 01, 01)
			ifrsp.policy.build
			ifrsp.book_currency = c.currency
			reg.save ifrsp
			log "Created Ifrs::CreatePolicy event."
		ensure
			binding.pry
		end
		
		def log(message)
			puts
			puts "*** #{message}"
		end
	end
end