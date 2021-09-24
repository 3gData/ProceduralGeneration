local size = 100
math.randomseed(tick())
local points = {}

for i = 1, size do
	points[i] = Vector3.new(
		math.random(1,size),
		0, 
		math.random(1,size)) 
end

local Colours = {}

for i = 1,size do
	Colours[i] = Color3.new(math.random(),math.random(),math.random())
end

local function shallowCopy(original)
	local copy = {}
	for key, value in pairs(original) do
		copy[key] = value
	end
	return copy
end	

function valueToIndex(tab,val)
	for i,v in pairs(tab) do
		if v == val then
			return i
		end
	end
end

function shuffle(array)
	local output = { }
	local random = math.random

	for index = 1, #array do
		local offset = index - 1
		local value = array[index]
		local randomIndex = offset*random()
		local flooredIndex = randomIndex - randomIndex%1

		if flooredIndex == offset then
			output[#output + 1] = value
		else
			output[#output + 1] = output[flooredIndex + 1]
			output[flooredIndex + 1] = value
		end
	end

	return output
end

function GetSortedMagnitudeArray(arrr, origin, ascending)
	local match = {}    
	local arr = shallowCopy(arrr)
	ascending = ascending or true        
	for i,v in pairs(arr) do
		local mag = (v-origin).Magnitude
		match[mag] = v
		arr[i] = mag
	end

	table.sort(arr,function(a,b)
		if a and b then
			if ascending then
				return a < b
			else
				return a > b
			end
		end
	end)        
	
	local final = {}        
	for i,v in pairs(arr) do
		if match[v] then
			final[i] = match[v]
		end
	end
	return valueToIndex(points,final[1])
end

for x = 1,size do
	for z = 1,size do
		local Origin,Ascending = Vector3.new(x,0,z),true
		local Point = GetSortedMagnitudeArray(points,Origin,Ascending)
		local part = Instance.new("Part")
		part.Color = Colours[Point]
		part.Position = Vector3.new(x,0,z)
		part.Anchored = true
		part.Size = Vector3.new(1,1,1)
		part.Parent = workspace
	end
end

