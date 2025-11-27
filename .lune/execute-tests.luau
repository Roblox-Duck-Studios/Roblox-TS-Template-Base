local net = require("@lune/net")
local serde = require("@lune/serde")
local fs = require("@lune/fs")
local task = require("@lune/task")
local process = require("@lune/process")

local processFlags = require("./process-flags")
local dotEnv = require("./dotenv")

local DEBUG = false

local flags = processFlags({
	["--api-key"] = "apiKey",
}, process.args)

if not (flags.apiKey or dotEnv.LUAU_API_KEY) then
	error("API key flag is required. Use --api-key or create a .env file with PUBLISH_API_KEY.")
end

local apiKey = flags.apiKey or dotEnv.LUAU_API_KEY

local publishResult = process.exec("lune", {
	"run",
	"publish",
	"--universe-id",
	"8049404126",
	"--place-id",
	"115458991925875",
})

if not publishResult.ok then
	error("Failed to publish test place." .. publishResult.stderr)
else
	if DEBUG then
		print("Successfully published test place.", publishResult.stderr)
	end

	if DEBUG then
		print("Executing Luau tests...")
	end

	local executeLuauResult = net.request({
		url = `https://apis.roblox.com/cloud/v2/universes/8049404126/places/115458991925875/luau-execution-session-tasks`,
		method = "POST",
		headers = {
			["Content-Type"] = "application/json",
			["x-api-key"] = apiKey,
		},
		body = serde.encode("json", { script = fs.readFile("scripts/jest.luau") }),
	})

	if not executeLuauResult.ok then
		error("Failed to execute Luau tests: " .. executeLuauResult.body)
	else
		print("Successfully executed Luau tests.")
	end

	local taskPath = serde.decode("json", executeLuauResult.body).path

	while true do
		local rawResult = net.request({
			url = `https://apis.roblox.com/cloud/v2/{taskPath}/logs`,
			method = "GET",
			headers = {
				["Content-Type"] = "application/json",
				["x-api-key"] = apiKey,
			},
		})

		local result = serde.decode("json", rawResult.body)

		if not rawResult.ok then
			error("Failed to fetch task logs: " .. rawResult.body)
		end

		if #result.luauExecutionSessionTaskLogs ~= 0 then
			for logIndex in ipairs(result.luauExecutionSessionTaskLogs) do
				for i, v in ipairs(result.luauExecutionSessionTaskLogs[1].messages) do
					print(v)
				end
			end
			break
		end

		task.wait(1)
	end
end
