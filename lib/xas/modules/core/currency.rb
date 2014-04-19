module XAS::Modules::Core
	class Currency < Item
		field :name, String
		validate :name, :presence
		
		field :code, String
		validate :code, :presence
	end
end