module XAS::Modules::Core
	class CreatePolicy < XAS::Event
		reference :policy, Policy
		validate :policy, :presence
		
		reference :book_currency, Currency
		validate :book_currency, :presence
		
		reference :presentation_currency, Currency
		
		def apply(cache)
			p = cache.create policy, date
			p.book_currency = book_currency
			p.presentation_currency = presentation_currency || book_currency
			yield p if block_given?
			cache.save p
		end
	end
end