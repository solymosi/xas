set :modules, [:core, :console, :mongo_backend]

group :backend do
	group :default do
		set :module, :mongo_backend
	end
end