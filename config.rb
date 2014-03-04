set :modules, [:core, :console, :mongo_storage]

group :storage do
	group :default do
		set :module, :mongo_storage
		set :host, nil
		set :port, nil
		set :database, "xas"
	end
end

group :core do
	group :registry do
		set :storage, :default
		set :collection, "registry"
	end
	
	group :item_cache do
		set :storage, :default
		set :collection, "item_cache"
	end
end