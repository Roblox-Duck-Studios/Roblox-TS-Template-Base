local serde = require("@lune/serde")
local fs = require("@lune/fs")
local process = require("@lune/process")

local env

xpcall(function()
	local envBuffer = fs.readFile(".env")
	if envBuffer then
		env = serde.decode("toml", envBuffer)
	end
end, function()
	env = process.env
end)

return env
