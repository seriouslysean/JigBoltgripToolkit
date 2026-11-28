-- Offline specs for sharing between players: the real library's share, fed the messages a hostile friend, guild
-- or group member could send. AceComm, the client's encoding calls and its timers are stand-ins.
-- busted        (JBT_LIBRARY defaults to JigBoltgripToolkit.lua, JBT_LIBSTUB to tests/LibStub.lua)
local LIBRARY = os.getenv("JBT_LIBRARY") or "JigBoltgripToolkit.lua"
local LIBSTUB = os.getenv("JBT_LIBSTUB") or "tests/LibStub.lua"

-- The client's globals must be the real ones: the library reads them from there, while busted gives each spec
-- function a private environment that would hide them.
local G = getfenv(0)
local function real(fn)
	return function(...) setfenv(fn, G); return fn(...) end
end

describe("sharing", function()
	local busted_it = it
	local function it(name, fn) busted_it(name, real(fn)) end

	-- What a test reads back: messages sent, values the encoder holds, rows the module merged, the setting.
	local sent, store, merged, sending
	local probe, data, share, db

	-- A fresh client with one share connected, Mallory in the party, and `found` entries of our own to send.
	local function Connect(found)
		sent, store, merged, sending = {}, {}, {}, true
		LibStub = nil
		dofile(LIBSTUB)
		SlashCmdList = {}
		IsLoggedIn = function() return true end
		CreateFrame = function() return { SetScript = function() end, RegisterEvent = function() end, UnregisterEvent = function() end } end
		EventUtil = { ContinueOnPlayerLogin = function() end, ContinueOnAddOnLoaded = function() end }
		C_Timer = { After = function() end, NewTimer = function() return { Cancel = function() end } end }
		function wipe(t) for key in pairs(t) do t[key] = nil end return t end
		issecretvalue = function() return false end
		debugprofilestop, GetTime, GetServerTime = function() return 0 end, function() return 1000 end, function() return 1700000000 end
		UnitName = function() return "Tester" end
		UnitInParty = function(name) return name == "Mallory" or name == "Tester" end
		UnitInRaid, IsInGuild, IsInGroup, IsInRaid = function() end, function() return false end, function() return false end, function() return false end
		BNGetNumFriends = function() return 0 end
		C_FriendList = { GetNumFriends = function() return 0 end, ShowFriends = function() end }
		C_ChatInfo = { InChatMessagingLockdown = function() return false end }
		Enum = { CompressionMethod = { Deflate = 1 } }
		-- The encoder keeps each value and hands back a token, so a test can make a reply decode to any value.
		C_EncodingUtil = {
			SerializeCBOR = function(value) store[#store + 1] = value return "T" .. #store end,
			DeserializeCBOR = function(token) return store[tonumber(token:match("^T(%d+)$"))] end,
			CompressString = function(text) return text end, DecompressString = function(text) return text end,
			EncodeBase64 = function(text) return text end, DecodeBase64 = function(text) return text end,
		}
		local handlers = {}
		local comm = LibStub:NewLibrary("AceComm-3.0", 1)
		function comm:Embed(target)
			target.RegisterComm = function(_, prefix, handler) handlers[prefix] = handler end
			target.UnregisterComm = function(_, prefix) handlers[prefix] = nil end
			-- The send's callback is kept, not called: a message stays in the send queue until a test delivers it.
			target.SendCommMessage = function(_, prefix, text, channel, name, _, callback, argument)
				sent[#sent + 1] = { prefix = prefix, text = text, channel = channel, target = name,
					delivered = callback and function() callback(argument, #text, #text) end }
			end
		end
		assert(loadstring(assert(io.open(LIBRARY)):read("*a"), "JigBoltgripToolkit"))()
		local toolkit = LibStub("JigBoltgripToolkit-1.0")
		share = toolkit:NewShare({ addon = "Alpha" }, { protocol = 1, kinds = { thing = true },
			wire = function(entry) return { k = "thing", n = entry.n } end,
			validate = function() return true end,
			merge = function(rows) for _, row in ipairs(rows) do merged[#merged + 1] = row end return #rows > 0 end,
			sending = function() return sending end, receiving = function() return true end })
		db = {}
		local entries = {}
		for index = 1, found or 0 do entries[index] = { n = index } end
		share:Load(db, function(add) for _, entry in ipairs(entries) do add(entry) end end)
		share:Connect(true)
		probe, data = handlers[share.prefix], handlers[share.dataPrefix]
	end
	setfenv(Connect, G)

	-- Mallory's reply to our request: `value` is what its payload decodes to.
	local function Reply(id, after, through, value)
		store[#store + 1] = value
		data(nil, ("D %s %d %d T%d"):format(id, after, through, #store), "WHISPER", "Mallory")
	end
	local function Rows(count)
		local rows = {}
		for index = 1, count do rows[index] = { k = "thing", n = index } end
		return rows
	end

	-- Fails if a reply that decodes to a number or a boolean raises in the listener: the request then never finishes,
	-- no other peer is asked for three timeouts, and the same peer does it again on its next offer.
	it("a reply that is a number or a boolean is skipped, and the request finishes", function()
		for _, value in ipairs({ 5, true }) do
			Connect()
			probe(nil, "O 1700000000-1 10", "PARTY", "Mallory")
			Reply("1700000000-1", 0, 10, value)
			assert(db.exchange.received["1700000000-1"] == 10 and share.active == nil,
				"a reply that decodes to " .. tostring(value) .. " moves past it and frees the request")
		end
	end)

	-- Fails if one sender can queue a reply per request: each is a full encode and up to 4000 bytes waiting in the
	-- send queue, so 500 requests queued 500 replies.
	it("a sender gets one reply at a time", function()
		Connect(300)
		local before = #sent
		for request = 1, 500 do data(nil, ("G %s %d"):format(db.exchange.id, request % 299), "WHISPER", "Mallory") end
		assert(#sent - before == 1, "500 requests queued " .. (#sent - before) .. " replies")
		sent[#sent].delivered()
		data(nil, ("G %s 0"):format(db.exchange.id), "WHISPER", "Mallory")
		assert(#sent - before == 2, "the next request is answered once the reply has gone out")
		-- A reply still queued at the timeout: the request after it is answered, and the old reply's last chunk
		-- must not free the sender while the new reply waits.
		local old = sent[#sent]
		GetTime = function() return 1031 end
		data(nil, ("G %s 1"):format(db.exchange.id), "WHISPER", "Mallory")
		old.delivered()
		data(nil, ("G %s 2"):format(db.exchange.id), "WHISPER", "Mallory")
		assert(#sent - before == 3, "a late reply freed its sender: " .. (#sent - before - 2) .. " replies queued after the timeout")
	end)

	-- Fails if a peer can stretch one request without end: it offered the highest revision there is, then moved one
	-- revision per reply of 64 rows, and after 200 replies the request was still running.
	it("a reply with more rows than the revisions it covers is refused", function()
		Connect()
		probe(nil, "O 1700000000-2 4294967295", "PARTY", "Mallory")
		Reply("1700000000-2", 0, 1, Rows(64))
		assert(#merged == 0 and share.active == nil, "64 rows for one revision merged " .. #merged .. " rows")
	end)

	-- Fails if the peer's own claim of how much it has is what ends a request.
	it("a request ends after a fixed number of replies", function()
		Connect()
		probe(nil, "O 1700000000-3 4294967295", "PARTY", "Mallory")
		local replies = 0
		while share.active and replies < 200 do
			Reply("1700000000-3", share.active.after, share.active.after + 64, Rows(64))
			replies = replies + 1
		end
		assert(share.active == nil and replies == 64, "the request took " .. replies .. " replies")
	end)

	-- Fails if a player who turned Share My Finds off still sends the account's collection ID, which tells a guild
	-- or group which characters are one player. Their own probe, echoed by the channel, must still get no answer.
	it("a player who does not share sends no collection ID", function()
		Connect(3)
		sending = false
		local offer = share:Offer("H")
		assert(offer == "H 0-0 0", "sharing off sent " .. offer)
		local before = #sent
		probe(nil, offer, "PARTY", "Tester")
		assert(share.replyTimers.PARTY == nil and #sent == before, "its own probe was answered")
	end)

	-- Fails if a find the module forgot is still sent: a quest crate learned as a chest stayed in every reply
	-- until the next login.
	it("a forgotten entry is in no later reply", function()
		Connect(3)
		data(nil, ("G %s 0"):format(db.exchange.id), "WHISPER", "Mallory")
		sent[#sent].delivered()
		share:Forget(share.revisions[2].entry)
		data(nil, ("G %s 0"):format(db.exchange.id), "WHISPER", "Mallory")
		local rows = store[#store]
		assert(#rows == 2 and rows[1].n == 1 and rows[2].n == 3, "the reply after a forget holds " .. #rows .. " rows")
	end)

	-- Fails if a connected player who turns receiving on only offers: peers answer a hello, so an idle peer's
	-- finds waited for its next find.
	it("a sharing setting change says hello to the channels already joined", function()
		Connect()
		IsInGroup = function() return true end
		share:Refresh()
		local before = #sent
		share:Update()
		share:Refresh()
		local hello = sent[before + 1]
		assert(hello and hello.text:match("^H ") and hello.channel == "PARTY", "the change sent no hello to the party")
	end)
end)
