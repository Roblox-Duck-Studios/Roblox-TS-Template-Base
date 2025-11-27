-- MIT License

-- Copyright (c) 2021 osyrisrblx

-- Permission is hereby granted, free of charge, to any person obtaining a copy
-- of this software and associated documentation files (the "Software"), to deal
-- in the Software without restriction, including without limitation the rights
-- to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
-- copies of the Software, and to permit persons to whom the Software is
-- furnished to do so, subject to the following conditions:

-- The above copyright notice and this permission notice shall be included in all
-- copies or substantial portions of the Software.

-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
-- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
-- FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
-- AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
-- LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
-- OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
-- SOFTWARE.

local fs = require("@lune/fs")
local roblox = require("@lune/roblox")
local process = require("@lune/process")

local outPath = process.args[1]

local game = roblox.deserializePlace(fs.readFile("build.rbxl"))

local SERVICE_BLACKLIST = {
	StarterPlayer = true,
}

local OUTPUT_PREFIX =
	`/* eslint-disable -- auto generated file*/\n//WARNING: Auto generated file, please do not modify this file unless you know what you're doing\n`

local output = ""
local indent = ""

local function pushIndent()
	indent = indent .. "\t"
end

local function popIndent()
	indent = string.sub(indent, 2)
end

local function writeLine(str)
	if str == "" then
		output = output .. "\n"
	else
		output = output .. indent .. str .. "\n"
	end
end

local function writeService(service)
	local serviceChildren = service:GetChildren()

	if next(serviceChildren) == nil then
		return
	end

	writeLine("interface " .. service.ClassName .. " {")
	pushIndent()

	local function search(instance)
		local name = instance.Name
		if name == "node_modules" then
			return
		end
		local prefix = ""
		if name == "Terrain" and instance.Parent == game.Workspace then
			prefix = "readonly "
		end
		if not string.match(name, "^[_a-zA-Z][_a-zA-Z0-9]*$") then
			name = '"' .. name .. '"'
		end
		local definition = prefix .. name .. ": " .. instance.ClassName
		local children = instance:GetChildren()
		if next(children) == nil then
			writeLine(definition .. ";")
		else
			writeLine(definition .. " & {")
			pushIndent()
			local seen = {}
			for _, child in ipairs(children) do
				if not seen[child.Name] then
					seen[child.Name] = true
					search(child)
				end
			end
			popIndent()
			writeLine("};")
		end
	end
	for _, child in ipairs(serviceChildren) do
		search(child)
	end

	popIndent()
	writeLine("}")
	writeLine("")
end

for _, service in ipairs(game:GetChildren()) do
	if not SERVICE_BLACKLIST[service.Name] then
		writeService(service)
	end
end

fs.writeFile(outPath, OUTPUT_PREFIX .. string.match(output, "^(.-)%s*$") :: string .. "\n")
