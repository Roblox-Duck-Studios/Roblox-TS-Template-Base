--!strict

local function processflags(processedFlags: { [string]: string }, args: { string })
	local flags = {}
	for i, v in ipairs(args) do
		local flag = processedFlags[v]
		if flag then
			local argument = args[i + 1]

			if processedFlags[argument] then
				error("Flag " .. v .. " requires an argument")
			else
				flags[flag] = argument
			end
		else
			local previous = args[i - 1]
			if not (previous and processedFlags[previous]) then
				error("unknown flag: " .. v)
			end
		end
	end
	return flags
end

return processflags
