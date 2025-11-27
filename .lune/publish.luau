--!strict
local fs = require("@lune/fs")
local process = require("@lune/process")
local net = require("@lune/net")

local processFlags = require("./process-flags")
local dotEnv = require("./dotenv")

type FlagsTable = { [string]: unknown? }

local flags = processFlags({
	["--project"] = "project",
	["-p"] = "project",
	["--file"] = "file",
	["-f"] = "file",
	["--universe-id"] = "universeId",
	["-u"] = "universeId",
	["--place-id"] = "placeId",
	["--api-key"] = "apiKey",
}, process.args)

if not flags.universeId then
	error("Universe ID flag is required. Use --universe-id or -u to specify the universe ID.")
end

if not flags.placeId then
	error("Place ID flag is required. Use --place-id to specify the place ID.")
end

if not (flags.apiKey or dotEnv.PUBLISH_API_KEY) then
	error("API key flag is required. Use --api-key or create a .env file with PUBLISH_API_KEY.")
end

local apiKey = flags.apiKey or dotEnv.PUBLISH_API_KEY
local file = fs.readFile(flags.file or "build.rbxl")

local result = net.request({
	url = `https://apis.roblox.com/universes/v1/{flags.universeId}/places/{flags.placeId}/versions?versionType=Published`,
	method = "POST",
	headers = {
		["Content-Type"] = "application/octet-stream",
		["x-api-key"] = apiKey,
	},
	body = file,
})

if result.ok then
	print(`Successfully uploaded place version for project "{project}": {result.body}`)
else
	error(`Failed to upload place version for project "{project}": {result.statusCode} {result.statusMessage}`)
end
