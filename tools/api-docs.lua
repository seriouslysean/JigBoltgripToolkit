-- Loads Blizzard_APIDocumentationGenerated as the client does: each file hands its table to
-- APIDocumentation:AddDocumentationTable, so running it against a stand-in captures the table and nothing else.
--   local docs = dofile("tools/api-docs.lua")("<Interface/AddOns dir>")
-- Returns { functions = { [key] = entry }, events = { [LiteralName] = entry }, tables = { [Name] = entry },
-- systems = { [key] = file } }, where a function's key is Namespace.Name, Name, or Object:Name for a script object.
return function(addons)
	local dir = addons .. "/Blizzard_APIDocumentationGenerated"
	local files = {}
	for file in assert(io.popen(("ls %q"):format(dir))):lines() do
		if file:find("%.lua$") then files[#files + 1] = file end
	end
	-- A constant read from another table (Enum.X.Y, Constants.X.Y) stands in as its own path, so it compares as text.
	local paths, path = {}, nil
	local function op(symbol)
		return function(a, b) return path(("(%s %s %s)"):format(tostring(a), symbol, tostring(b))) end
	end
	path = function(name)
		if not paths[name] then
			paths[name] = setmetatable({}, { __index = function(_, k) return path(name .. "." .. k) end,
				__tostring = function() return name end, __add = op("+"), __sub = op("-"), __mul = op("*"),
				__div = op("/"), __unm = function(a) return path("-" .. tostring(a)) end })
		end
		return paths[name]
	end
	local docs = { functions = {}, events = {}, tables = {}, systems = {} }
	for _, file in ipairs(files) do
		local captured = {}
		local env = setmetatable({ APIDocumentation = { AddDocumentationTable = function(_, t) captured[#captured + 1] = t end } },
			{ __index = function(_, k) return path(k) end })
		local chunk = assert(loadfile(dir .. "/" .. file))
		setfenv(chunk, env)
		chunk()
		for _, system in ipairs(captured) do
			for _, fn in ipairs(system.Functions or {}) do
				local key
				if system.Type == "ScriptObject" then
					key = system.Name .. ":" .. fn.Name
				else
					key = system.Namespace and (system.Namespace .. "." .. fn.Name) or fn.Name
				end
				fn.file, fn.scriptObject = file, system.Type == "ScriptObject"
				docs.functions[key] = fn
			end
			for _, event in ipairs(system.Events or {}) do
				event.file = file
				docs.events[event.LiteralName or event.Name] = event
			end
			for _, t in ipairs(system.Tables or {}) do
				t.file = file
				docs.tables[t.Name] = t
			end
			docs.systems[system.Namespace or system.Name or file] = file
		end
	end
	return docs
end
