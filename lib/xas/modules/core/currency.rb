module XAS::Modules::Core
	class Currency < XAS::Item
		field :name, String
		validate :name, :presence
		
		field :code, String
		validate :code, :presence
	end
end