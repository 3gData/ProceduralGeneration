return {
	Default = function()
		return 0
	end,
	Desert = function(x,z)
		return 0
	end,
	RoughHills = function(x,CHx,seed,z,CHz)
		local amplitude = 10
		local frequency = 20
		local lacunarity = 2
		local gain = 2
		local octaves = 6
		local y = 0
		local amp = amplitude
		local freq = frequency
		for i = 1,octaves do
			y = (y + (amp * math.noise((x + CHx+seed) / freq, (z + CHz+seed) / freq)))
			freq = (freq * lacunarity)
			amp = (amp * gain)
		end
		return y
	end,
	
	Ice = function(x,CHx,seed,z,CHz)
		local amplitude = 10
		local frequency = 40
		local lacunarity = 2
		local gain = 2
		local octaves = 6
		local y = 0
		local amp = amplitude
		local freq = frequency
		for i = 1,octaves do
			y = (y + (amp * math.noise((x + CHx+seed) / freq, (z + CHz+seed) / freq)))
			freq = (freq * lacunarity)
			amp = (amp * gain)
		end
		return y
	end,
}

--[[local module = {}

local size = 3500--500^2

local points = {}

for i = 1, size do
	points[i] = Vector3.new(
		math.random(1,size),
		0, 
		math.random(1,size)) 
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

math.randomseed(tick())
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

local Biomes = {
	"Desert",
	"Mountains",
	"Plains",
	"RoughHills"
}

shuffle(Biomes)

local biome_Weights = {
	Desert = 150,
	Mountains = 25,
	Plains = 225,
	RoughHills = 100,
}

local biomeSelection = {}
for i,v in pairs(Biomes) do
	for x = 1,biome_Weights[v] do
		table.insert(biomeSelection,v)
	end
	print(("%s:%s"):format(i,size/#Biomes))
end


shuffle(biomeSelection)

local Colours = {
	Desert = Enum.Material.Sand, --BrickColor.Yellow(),
	Mountains = Enum.Material.Slate,--BrickColor.Gray(),
	RoughHills = Enum.Material.CrackedLava,
	Plains = Enum.Material.LeafyGrass--BrickColor.Green(),
}

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

function module.getBiome(pos)
	return biomeSelection[GetSortedMagnitudeArray(points,pos,true)]
end


return module]]
