-- Writes sections 2 to 5 of the client-update report (tools/client-audit.sh runs it): the API diff, the deprecated and
-- global-strings lists against ours, where our code meets what changed, and the notes to re-measure.
--   lua tools/client-audit.lua old=<AddOns dir> new=<AddOns dir> source=<repo> from=<ref> to=<ref>
--     changed=<file of changed paths> kit=<dir> [deprecated=<file>] [strings=<file>] <module dir>...
local opt, modules = {}, {}
for _, a in ipairs(arg) do
	local k, v = a:match("^(%w+)=(.*)$")
	if k then opt[k] = v else modules[#modules + 1] = a end
end
local here = arg[0]:match("^(.*)/[^/]*$") or "."
local loadDocs = dofile(here .. "/api-docs.lua")

local function lines(command)
	local found = {}
	for line in assert(io.popen(command)):lines() do found[#found + 1] = line end
	return found
end
local function sorted(set)
	local list = {}
	for k in pairs(set) do list[#list + 1] = k end
	table.sort(list)
	return list
end
local function say(...) io.write(...) io.write("\n") end

-- Scalar fields are a function's flags (HasRestrictions, SecretArguments, IsProtectedFunction and the rest).
local SKIP = { Name = true, Type = true, Documentation = true, file = true, scriptObject = true, LiteralName = true }
local function flags(entry)
	local out = {}
	for k, v in pairs(entry) do
		if not SKIP[k] and type(v) ~= "table" then out[k] = tostring(v) end
	end
	return out
end
local function signature(list)
	local parts = {}
	for _, p in ipairs(list or {}) do
		parts[#parts + 1] = ("%s: %s%s"):format(p.Name, p.Type, p.Nilable and "?" or "")
	end
	return table.concat(parts, ", ")
end
local function serialize(v)
	if type(v) ~= "table" or getmetatable(v) then return tostring(v) end
	local keys, parts = {}, {}
	for k in pairs(v) do if k ~= "file" then keys[#keys + 1] = k end end
	table.sort(keys, function(a, b) return tostring(a) < tostring(b) end)
	for _, k in ipairs(keys) do parts[#parts + 1] = tostring(k) .. "=" .. serialize(v[k]) end
	return "{" .. table.concat(parts, ",") .. "}"
end
local function flagChanges(a, b)
	local fa, fb, out = flags(a), flags(b), {}
	local all = {}
	for k in pairs(fa) do all[k] = true end
	for k in pairs(fb) do all[k] = true end
	for _, k in ipairs(sorted(all)) do
		if fa[k] ~= fb[k] then out[#out + 1] = ("%s %s → %s"):format(k, fa[k] or "unset", fb[k] or "unset") end
	end
	return out
end
local function cell(text) return (text:gsub("|", "\\|")) end

-- Section 2: the API diff.
local old, new = loadDocs(opt.old), loadDocs(opt.new)
local touched = { functions = {}, events = {} } -- key -> what changed, for section 4
local function diffKind(kind, label, describe)
	local added, removed, changed = {}, {}, {}
	for key in pairs(new[kind]) do if not old[kind][key] then added[#added + 1] = key end end
	for key in pairs(old[kind]) do if not new[kind][key] then removed[#removed + 1] = key end end
	for key, entry in pairs(new[kind]) do
		local before = old[kind][key]
		if before then
			local what = describe(before, entry)
			if #what > 0 then changed[#changed + 1] = { key, what, entry.file } end
		end
	end
	table.sort(added)
	table.sort(removed)
	table.sort(changed, function(a, b) return a[1] < b[1] end)
	say(("### %s: %d added, %d removed, %d changed"):format(label, #added, #removed, #changed))
	say()
	if #added > 0 then say("Added: ", "`" .. table.concat(added, "`, `") .. "`") say() end
	if #removed > 0 then say("Removed: ", "`" .. table.concat(removed, "`, `") .. "`") say() end
	if #changed > 0 then
		say("| Name | Change | Doc file |")
		say("|---|---|---|")
		for _, c in ipairs(changed) do say(("| `%s` | %s | %s |"):format(c[1], cell(table.concat(c[2], "; ")), c[3])) end
		say()
	end
	if touched[kind] then
		for _, key in ipairs(removed) do touched[kind][key] = "removed" end
		for _, c in ipairs(changed) do touched[kind][c[1]] = table.concat(c[2], "; ") end
	end
end

say("## 2. API (Blizzard_APIDocumentationGenerated)")
say()
diffKind("functions", "Functions", function(a, b)
	local what = flagChanges(a, b)
	local sa, sb = signature(a.Arguments), signature(b.Arguments)
	if sa ~= sb then what[#what + 1] = ("arguments (%s) → (%s)"):format(sa, sb) end
	sa, sb = signature(a.Returns), signature(b.Returns)
	if sa ~= sb then what[#what + 1] = ("returns (%s) → (%s)"):format(sa, sb) end
	return what
end)
diffKind("events", "Events", function(a, b)
	local what = flagChanges(a, b)
	local sa, sb = signature(a.Payload), signature(b.Payload)
	if sa ~= sb then what[#what + 1] = ("payload (%s) → (%s)"):format(sa, sb) end
	return what
end)
diffKind("tables", "Tables (enums, structures, constants)", function(a, b)
	return serialize(a) ~= serialize(b) and { a.Type .. " contents" } or {}
end)

-- Section 3: the generated lists against ours.
local function loadList(path)
	local ok, t = pcall(dofile, path)
	return ok and type(t) == "table" and t or nil
end
local function diffList(label, current, fresh, regenerate)
	local ours = loadList(current)
	local theirs = fresh and loadList(fresh)
	if not theirs then
		say(("### %s: not regenerated (%s)"):format(label, regenerate))
		say()
		return {}
	end
	local added, removed, changed = {}, {}, {}
	for k, v in pairs(theirs) do
		if ours[k] == nil then added[#added + 1] = k elseif ours[k] ~= v then changed[#changed + 1] = k end
	end
	for k in pairs(ours) do if theirs[k] == nil then removed[#removed + 1] = k end end
	table.sort(added)
	table.sort(removed)
	table.sort(changed)
	say(("### %s: %d added, %d removed, %d changed"):format(label, #added, #removed, #changed))
	say()
	for _, part in ipairs({ { "Added", added }, { "Removed", removed }, { "Changed", changed } }) do
		if #part[2] > 0 then say(part[1], ": `", table.concat(part[2], "`, `"), "`") say() end
	end
	if #added + #removed + #changed > 0 then say("Regenerate: ", regenerate) say() end
	local hit = {}
	for _, k in ipairs(removed) do hit[k] = "removed" end
	for _, k in ipairs(changed) do hit[k] = "text changed" end
	return hit
end

say("## 3. Deprecations and global strings")
say()
diffList("tests/deprecated.lua", opt.kit .. "/tests/deprecated.lua", opt.deprecated,
	"`lua tools/deprecated.lua <source>/Interface/AddOns \"<client label>\"` at the new ref")
local stringHits = diffList("tests/globalstrings.lua", opt.kit .. "/tests/globalstrings.lua", opt.strings,
	"pass `--strings` (reads Ketho/BlizzardInterfaceResources over the network), then `lua tools/global-strings.lua <commit>`")

-- Our files: tracked, outside Libs/ (the embedded kit copies and vendored Ace3).
local repos = { opt.kit }
for _, m in ipairs(modules) do repos[#repos + 1] = m end
-- The generated lists are Blizzard's names, not our uses.
local GENERATED = { ["tests/deprecated.lua"] = true, ["tests/globalstrings.lua"] = true }
local function tracked(repo, patterns)
	local files = {}
	for _, f in ipairs(lines(("git -C %q ls-files -- %s"):format(repo, patterns))) do
		if not f:find("^Libs/") and not GENERATED[f] then files[#files + 1] = f end
	end
	return files
end
local function name(repo) return repo:match("([^/]+)/?$") end

-- Section 4: our exposure.
say("## 4. Our exposure")
say()
local globals, methods, cNames = {}, {}, {}
for key, what in pairs(touched.functions) do
	local fn = new.functions[key] or old.functions[key]
	if fn.scriptObject then
		methods[fn.Name] = methods[fn.Name] or {}
		methods[fn.Name][#methods[fn.Name] + 1] = key .. ": " .. what
	elseif key:find("%.") then
		cNames[key] = what
	else
		globals[key] = what
	end
end

local uses, hooks = {}, {}
for _, repo in ipairs(repos) do
	for _, file in ipairs(tracked(repo, "'*.lua'")) do
		local n = 0
		for line in assert(io.open(repo .. "/" .. file)):lines() do
			n = n + 1
			local code = line:gsub("%-%-.*$", "")
			local at = ("%s/%s:%d"):format(name(repo), file, n)
			local function use(what, why) uses[#uses + 1] = { at, what, why } end
			for c in code:gmatch("C_[%w_]+%.[%w_]+") do if cNames[c] then use(c, cNames[c]) end end
			for g in code:gmatch("%f[%w_.:]([%a_][%w_]*)%s*%(") do if globals[g] then use(g, globals[g]) end end
			for m in code:gmatch(":([%a_][%w_]*)%s*%(") do
				if methods[m] then use(":" .. m, table.concat(methods[m], "; ")) end
			end
			for e in code:gmatch("%f[%w_]([A-Z][A-Z0-9_]+)%f[^%w_]") do
				if touched.events[e] then use(e, "event " .. touched.events[e])
				elseif stringHits[e] then use(e, "global string " .. stringHits[e]) end
			end
			local target = code:match("hooksecurefunc%(%s*\"([%w_]+)\"")
			if target then hooks[#hooks + 1] = { at, nil, target } end
			local tbl, method = code:match("hooksecurefunc%(%s*([%w_.]+)%s*,%s*\"([%w_]+)\"")
			if tbl then hooks[#hooks + 1] = { at, tbl, method } end
		end
	end
end

local changed, changedList = {}, lines(("cat %q"):format(opt.changed))
for _, path in ipairs(changedList) do changed[path] = true end

say(("### Calls into changed or removed API: %d"):format(#uses))
say()
if #uses > 0 then
	say("| Our line | Name | Change |")
	say("|---|---|---|")
	for _, u in ipairs(uses) do say(("| %s | `%s` | %s |"):format(u[1], u[2], cell(u[3]))) end
	say()
end

-- A hook target is found where Blizzard defines it at the new ref, on the table or a mixin named after it; an engine
-- function has no Lua definition.
local function definitions(tbl, method)
	local leaf = tbl and tbl:match("([%w_]+)$")
	local pattern = tbl and ("(function [A-Za-z_]*%s[A-Za-z_]*[.:]%s\\(|%s\\.%s *=)"):format(leaf, method, leaf, method)
		or ("(function %s\\(|^%s *=)"):format(method, method)
	local files, seen = {}, {}
	for _, hit in ipairs(lines(("git -C %q grep -n -E %q %s -- Interface 2>/dev/null"):format(opt.source, pattern, opt.to))) do
		local file = hit:match("^[^:]+:Interface/AddOns/([^:]+)")
		if file and not seen[file] then seen[file], files[#files + 1] = true, file end
	end
	return files
end
say(("### Hooks: %d"):format(#hooks))
say()
say("| Our line | Target | Defined in (new ref) | Changed |")
say("|---|---|---|---|")
for _, h in ipairs(hooks) do
	local target = h[2] and (h[2] .. "." .. h[3]) or h[3]
	local api = new.functions[h[2] and (h[2] .. "." .. h[3]) or h[3]]
	local where, state
	if api then
		where = "API doc " .. api.file
		state = touched.functions[h[2] and (h[2] .. "." .. h[3]) or h[3]] or "no"
	else
		local files, hit = definitions(h[2], h[3]), {}
		for _, file in ipairs(files) do
			if changed["Interface/AddOns/" .. file] then hit[#hit + 1] = file end
		end
		where = #files > 0 and table.concat(files, ", ") or "not found by name (engine function or set by hand)"
		state = #files == 0 and "find by hand" or #hit > 0 and ("**yes**: " .. table.concat(hit, ", ")) or "no"
	end
	say(("| %s | `%s` | %s | %s |"):format(h[1], target, where, cell(state)))
end
say()

-- A cited line is mapped through the diff, taking the citation as written against the old ref.
local hunkCache = {}
local function hunks(path)
	if not hunkCache[path] then
		local list = {}
		for _, l in ipairs(lines(("git -C %q diff -U0 %s %s -- %q"):format(opt.source, opt.from, opt.to, path))) do
			local a, b, c, d = l:match("^@@ %-(%d+),?(%d*) %+(%d+),?(%d*) @@")
			if a then list[#list + 1] = { tonumber(a), tonumber(b ~= "" and b or 1), tonumber(c), tonumber(d ~= "" and d or 1) } end
		end
		hunkCache[path] = list
	end
	return hunkCache[path]
end
local function mapLine(path, line)
	local shift = 0
	for _, h in ipairs(hunks(path)) do
		local first, count = h[1], h[2]
		if count == 0 then first = first + 1 end
		if line < first then break end
		if count > 0 and line < first + count then return nil end
		shift = shift + h[4] - h[2]
	end
	return line + shift
end

local citations = {}
for _, repo in ipairs(repos) do
	for _, file in ipairs(tracked(repo, "'*.lua' '*.md' '*.toc' '*.sh'")) do
		local n = 0
		for line in assert(io.open(repo .. "/" .. file)):lines() do
			n = n + 1
			for cited, ext, from, to in line:gmatch("([%w_/]*[%w_]+%.(%a+)):(%d+)%-?(%d*)") do
				local base = cited:match("([^/]+)$")
				local own = io.open(repo .. "/" .. cited) or io.open(repo .. "/" .. base)
				if own then own:close() end
				if not own and (ext == "lua" or ext == "xml") then
					for _, path in ipairs(changedList) do
						if path:sub(-#cited - 1) == "/" .. cited then
							local mapped = mapLine(path, tonumber(from))
							local mappedTo = to ~= "" and mapLine(path, tonumber(to))
							local now = not mapped and "inside a changed hunk"
								or (to ~= "" and not mappedTo) and ("from %d, end inside a changed hunk"):format(mapped)
								or (mapped == tonumber(from) and (to == "" or mappedTo == tonumber(to))) and "unmoved"
								or (to ~= "" and ("now %d-%d"):format(mapped, mappedTo) or ("now %d"):format(mapped))
							citations[#citations + 1] = { ("%s/%s:%d"):format(name(repo), file, n),
								("%s:%s%s"):format(cited, from, to ~= "" and ("-" .. to) or ""), path:gsub("^Interface/AddOns/", ""), now }
						end
					end
				end
			end
		end
	end
end
say(("### Citations of changed Blizzard files: %d"):format(#citations))
say()
if #citations > 0 then
	say("| Our line | Cites | Blizzard file | At the new ref |")
	say("|---|---|---|---|")
	for _, c in ipairs(citations) do say(("| %s | `%s` | %s | %s |"):format(c[1], c[2], c[3], c[4])) end
	say()
end

-- Section 5: what was measured in game on a build, to check again on the new one. Clean-paths rows are covered by
-- their citations in section 4.
local MEASURED = { "%d%d%d%d%-%d%d%-%d%d", "%f[%w]Deck%f[%W]", "%f[%w]DECK%f[%W]", "[Mm]easured", "%f[%d]%d%d%d%d%d%f[%D]",
	"%f[%d]1%.%d+%.%d+%.%d+", "[Ss]een in game", "[Ii]n game", "%f[%w]Mac%f[%W]" }
local remeasure = {}
for _, repo in ipairs(repos) do
	for _, file in ipairs({ "docs/client-notes.md" }) do
		local f = io.open(repo .. "/" .. file)
		if f then
			local n = 0
			for line in f:lines() do
				n = n + 1
				if not line:find("^#") and not line:find("^%- Last audited:") then
					for _, p in ipairs(MEASURED) do
						if line:find(p) then
							local text = line:gsub("^%s*[-|]%s*", "")
							if #text > 140 then text = text:sub(1, 137) .. "..." end
							remeasure[#remeasure + 1] = { ("%s/%s:%d"):format(name(repo), file, n), text }
							break
						end
					end
				end
			end
			f:close()
		end
	end
end
say(("## 5. Re-measure on the new build: %d"):format(#remeasure))
say()
say("| Note | Text |")
say("|---|---|")
for _, r in ipairs(remeasure) do say(("| %s | %s |"):format(r[1], cell(r[2]))) end
