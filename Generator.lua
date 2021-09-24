local biomeClass = require(script.Biome)
local SimplexNoise = require(script.Simplex)
local seed = math.random()

local Equator = math.random(0,1000)
SimplexNoise.Seed(seed)

local points = {}
local size = 1000

local TemperatureGradient = {
	Ice = {0,5},
	--Tundra = {5,10},
	RoughHills = {5,10},
	Plains = {11,17},
	Forest = {18,24},
	Jungle = {25,30},
	Desert = {31,50}
}

local Materials = {
	Ice = Enum.Material.Ice,
	--Tundra = Enum.Material.Ice,
	RoughHills = Enum.Material.Slate,
	Plains = Enum.Material.Grass,
	Forest = Enum.Material.LeafyGrass,
	Jungle = Enum.Material.CrackedLava,
	Desert = Enum.Material.Sand
}

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

function getBiome(temp)
	for i,v in pairs(TemperatureGradient) do
		if temp >= v[1] and temp <= v[2] then
			return i
		end
	end
end
function ridgenoise(nx, ny)
	return 2 * (math.abs(math.noise(nx+seed, ny+seed)));
end

function GenerateHeightmap(size,ChunkX,ChunkZ)
	local heightmap = {}
	local tab = {}
	for x = 1,size do
		local hx = {}
		heightmap[x] = hx
		for z = 1,size do
			local latitude = math.abs((Equator - ChunkZ+z) + (Equator - ChunkX+x))
			local temp = math.ceil(((latitude / size) * -25) - (0) * 2 + 50)
			
			if temp < 0 then
				temp = 0
			end
			
			local biome = getBiome(temp)
			local y = 0
			if biomeClass[biome] then
				y = biomeClass[biome](x,ChunkX,seed,z,ChunkZ)
			end
			hx[z] = y
			--Implementing Voronoi Diagram into Biome.. But it's too performance - Impactful
			--GetSortedMagnitudeArray(points,Vector3.new(ChunkX+x,0,ChunkZ+z),true)
			workspace.Terrain:FillBlock(CFrame.new(ChunkX+x,y,ChunkZ+z),Vector3.new(1,30,1),Materials[biome])
		end
	end
	return heightmap

end

local heightmap = GenerateHeightmap(size,0,0)
