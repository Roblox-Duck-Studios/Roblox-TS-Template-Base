local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local StarterPlayer = game:GetService("StarterPlayer")

local Jest = require(ReplicatedStorage.rbxts_include.node_modules["@rbxts"].jest.src)

local status, result = Jest.runCLI(script, {
	verbose = false,
	ci = false,
	setupFiles = { ReplicatedStorage.common.utils["setup-tests"] },
}, {
	ReplicatedStorage.TS.__tests__,
	ServerScriptService.TS.__tests__,
	StarterPlayer.StarterPlayerScripts.TS.__tests__,
	ReplicatedStorage.common.__tests__,
	ServerScriptService.common.__tests__,
	StarterPlayer.StarterPlayerScripts.common.__tests__,
}):awaitStatus()

if status == "Rejected" or result.results.numFailedTestSuites > 0 or result.results.numFailedTests > 0 then
	print(result)
	error("Tests failed!")
else
	print("Tests passed!")
end
