return {
	Default = function(x,CHx,seed,z,CHz)
		local amplitude = 5
		local frequency = 7
		local lacunarity = 4
		local gain = 3
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
	Desert = function(x,CHx,seed,z,CHz)
		local amplitude = 6
		local frequency = 10
		local lacunarity = 3
		local gain = 1
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
	
	Forest = function(x,CHx,seed,z,CHz)
		local amplitude = 3
		local frequency = 5
		local lacunarity = 8
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
