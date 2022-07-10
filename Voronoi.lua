local module = {}
module.__index = module

function module.new(Position, Extents, Amount)
	local self = setmetatable({
		Size  = Extents;
		Origin = Position;
		Amount = Amount;
	}, module)
	return self
end

function module:GeneratePoints()
	local Points = {}
	for i = 1,self.Amount,1 do
		local random = Random.new()
		Points[i] = self.Origin * CFrame.new(random:NextInteger(1,self.Size.X),self.Size.Y,random:NextInteger(1,self.Size.Z))
	end
	return Points
end

return module
