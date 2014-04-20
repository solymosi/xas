module XAS::Modules::Hun
	class CreatePolicy < XAS::Modules::Core::CreatePolicy
		reference :policy, Policy
		validate :policy, :presence
		
		def apply(cache)
			super
		end
	end
end