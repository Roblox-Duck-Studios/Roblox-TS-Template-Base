--usage
--input path, output path

local fs = require("@lune/fs")
local process = require("@lune/process")
local roblox = require("@lune/roblox")

local placePath = process.args[1]
local outputPath = process.args[2]

assert(outputPath, "Output path is required")
local placeInstance = roblox.deserializePlace(fs.readFile(placePath))

local SERVICE_LOOKUP = {
	"ReplicatedStorage",
	"ServerStorage",
	"Workspace",
}

fs.writeDir(outputPath)

--recursively finds children and uploads it as a rbxm file to the given path
local function writeChildren(path: string, lookup: Instance)
	for _, child in ipairs(lookup:GetChildren()) do
		if child:IsA("Folder") then
			fs.writeDir(path .. "/" .. child.Name)
			writeChildren(path .. "/" .. child.Name, child)
		else
			local model = roblox.serializeModel({ child })
			fs.writeFile(path .. "/" .. child.Name .. ".rbxm", model)
		end
	end
end

for _, serviceName in ipairs(SERVICE_LOOKUP) do
	local service = placeInstance:GetService(serviceName)

	local prefab = service:FindFirstChild("prefab")

	if prefab then
		writeChildren(outputPath, prefab)
	end
end
