local biomeClass = require(script.Biome)
local SimplexNoise = require(script.Simplex)
local voronoi = require(script.Voronoi)

local seed = math.random()
local Size = 500

local Equator = Vector3.new(
	300,
	0,
	300
)


local DominantPosition

local Temperatures = {
	Ice = {0,5},
	--Tundra = {5,10},
	RoughHills = {5,10},
	Plains = {11,17},
	Forest = {18,24},
	Jungle = {25,40},
	Desert = {40,50}
}

local Materials = {
	Ice = Enum.Material.Ice,
	--Tundra = Enum.Material.Ice,
	RoughHills = Enum.Material.Slate,
	Plains = Enum.Material.Grass,
	Forest = Enum.Material.LeafyGrass,
	Jungle = Enum.Material.Marble,
	Desert = Enum.Material.Sand
}

function Total(arr)
	local c = 0
	for i,v in pairs(arr) do
		v += c
	end
	return c
end

function getBiome(temp)
	for i,v in pairs(Temperatures) do
		if temp >= v[1] and temp <= v[2] then
			return i
		end
	end
end

function diviseUntilSmall(num)
	for i = 1,10000000,10 do
		if(num/i) < 1 then
			return (num/i)
		end
	end
end

function ManhattanDistance(a, b)
	local abs = math.abs
	return abs(a.X - b.X) + abs(a.Y - b.Y) + abs(a.Z - b.Z);
end

--[[function FBM(x, z,CHx,CHz)
	local y = 0
	local amp = amplitude
	local freq = frequency
	for i = 1,octaves do
		y = (y + (amp * math.noise((x + CHx+seed) / freq, (z + CHz+seed) / freq)))
		freq = (freq * lacunarity)
		amp = (amp * gain)
	end
	return y
end]]

function ridgenoise(nx, ny)
	return 2 * (math.abs(math.noise(nx+seed, ny+seed)));
end

function GenerateTemperature(X, Z,size)
	local latitude = math.abs((Equator.X - X) + (Equator.Z - Z))
	local temp = math.ceil(((latitude / size) * -35) - (0) * 2 + 50)
	if temp < 0 then
		temp = 0
	end
	return temp
end

function ClosestPoint(Points, Position)
	local ClosestMagnitude, ClosestPoint = 10000,Vector3.new()
	for i,Point in pairs(Points) do
		local Magnitude = ManhattanDistance(Position, Point.Position)--(Point.Position - Position).Magnitude
		if Magnitude < ClosestMagnitude then
			ClosestMagnitude = Magnitude
			ClosestPoint = Point	
		end
	end
	--if DominantPosition == ClosestPoint.Position then
	--	--print(DominantPosition)
	--else
	--	DominantPosition = ClosestPoint.Position
	--end
	return ClosestPoint	
end

function CalculateWeight(Array)
	local Total = 0
	
	for i,v in pairs(Array) do
		Total += v
	end
	
	local Weights = {}
	for i,v in pairs(Array) do
		Weights[i] = (v/Total)
	end
	return Weights
end

function AssignCellPositions(Points, Size, ChunkX,ChunkZ)
	local Positions = {}
	local Totals = {}
	for x = 1,Size do
		Positions[x] = {}
		for z = 1,Size do
			local PX,PZ = (ChunkX + x), ChunkZ + z
			local Point = ClosestPoint(Points, Vector3.new(PX,0,PZ)) --Voronoi implementation!
			local Temperature = GenerateTemperature(Point.X,Point.Z, Size)
			local Biome = getBiome(Temperature)
			Positions[x][z] = {Biome = Biome, Temp = Temperature}
			if Totals[Biome] then
				Totals[Biome] += 1
			else
				Totals[Biome] = 0
			end
		end
	end
	return Positions, Totals
end

function GenerateHeightmap(size,ChunkX,ChunkZ, Points)
	local heightmap = {}
	local tab = {}
	local Cells,Weights = AssignCellPositions(Points, size, ChunkX, ChunkZ)
	Weights = CalculateWeight(Weights)
	
	local LastBiome
	local LastY
	
	for x = 1,size do
		local hx = {}
		for z = 1,size do
			local biome = Cells[x][z].Biome
			local y = biomeClass[biome] or biomeClass.Forest
			y = y(x,ChunkX,seed,z,ChunkZ) + 1
			
			LastBiome = biome
			LastY = y
			--local Part = Instance.new("Part")
			--Part.Name = tostring(x)..tostring(z)
			--Part.Material = Materials[biome]
			--Part.Size = Vector3.new(1,20,1)
			--Part.CFrame = CFrame.new(ChunkX+x,y,ChunkZ+z)
			--Part.Anchored = true
			--Part.CanCollide = true
			--Part.Parent = workspace
			workspace.Terrain:FillBlock(CFrame.new(ChunkX+x,y,ChunkZ+z),Vector3.new(1,50,1),Materials[biome] or Enum.Material.Ground)
		end
	end
	return heightmap

end


function DrawTrees()
	local Diagram = voronoi.new(CFrame.new(),CFrame.new(Size,1,Size),45)
	local Points = Diagram:GeneratePoints()
	local heightmap = GenerateHeightmap(Size,0,0, Points)
end

DrawTrees()
