areas = {
	-- 3 lanes of copper
	{
		left_top = {
			x = -10000,
			y = -650
		},
		right_bottom = {
			x = -100,
			y = -550
		},
		type = "copper-ore"
	},
	{
		left_top = {
			x = -10000,
			y = -50
		},
		right_bottom = {
			x = -100,
			y = 50
		},
		type = "copper-ore"
	},
	{
		left_top = {
			x = -10000,
			y = 550
		},
		right_bottom = {
			x = -100,
			y = 650
		},
		type = "copper-ore"
	},

	-- 2 lanes of iron
	{
		left_top = {
			x = -10000,
			y = -350
		},
		right_bottom = {
			x = -100,
			y = -250
		},
		type = "iron-ore"
	},
	{
		left_top = {
			x = -10000,
			y = 250
		},
		right_bottom = {
			x = -100,
			y = 350
		},
		type = "iron-ore"
	},

	-- 1 lane of coal
	{
		left_top = {
			x = 100,
			y = -150
		},
		right_bottom = {
			x = 1482,
			y = -50
		},
		type = "coal"
	},

	-- a LOT of crude oil
	{
		left_top = {
			x = 100,
			y = 200
		},
		right_bottom = {
			x = 11350,
			y = 10000
		},
		spacing = {
			x = 3,
			y = 8
		},
		type = "crude-oil"
	},
	--
	--{
	--	left_top = {
	--		x = 500,
	--		y = 200
	--	},
	--	right_bottom = {
	--		x = 620,
	--		y = 10700
	--	},
	--	spacing = {
	--		x = 3,
	--		y = 8
	--	},
	--	type = "crude-oil"
	--},
	--{
	--	left_top = {
	--		x = 1000,
	--		y = 200
	--	},
	--	right_bottom = {
	--		x = 1120,
	--		y = 10700
	--	},
	--	spacing = {
	--		x = 3,
	--		y = 8
	--	},
	--	type = "crude-oil"
	--},
	--{
	--	left_top = {
	--		x = 1500,
	--		y = 200
	--	},
	--	right_bottom = {
	--		x = 1650,
	--		y = 10700
	--	},
	--	spacing = {
	--		x = 3,
	--		y = 8
	--	},
	--	type = "crude-oil"
	--},
	--{
	--	left_top = {
	--		x = 2000,
	--		y = 200
	--	},
	--	right_bottom = {
	--		x = 2150,
	--		y = 10700
	--	},
	--	spacing = {
	--		x = 3,
	--		y = 8
	--	},
	--	type = "crude-oil"
	--},

	-- little bit of stone for making furnaces etc
	{
		left_top = {
			x = 100,
			y = -300,
		},
		right_bottom = {
			x = 300,
			y = -244
		},
		type = "stone"
	},

	-- chests for alien artifacts
	{
		left_top = {
			x = 50,
			y = 50,
		},
		right_bottom = {
			x = 60,
			y = 60
		},
		type = "alien-artifact"
	},

	-- and some wood to get started
	{
		left_top = {
			x = -20,
			y = -50,
		},
		right_bottom = {
			x = 0,
			y = -30
		},
		gen_type = function()
			return "tree-" .. string.format("%02d", math.random(1, 9));
		end
	},
	-- starter patch in the middle
	{
		left_top = {
			x = -60,
			y = -100
		},
		right_bottom = {
			x = -30,
			y = -30
		},
		type = "iron-ore"
	},
	{
		left_top = {
			x = 30,
			y = -60
		},
		right_bottom = {
			x = 60,
			y = -30
		},
		type = "coal"
	},
	{
		left_top = {
			x = -60,
			y = 30
		},
		right_bottom = {
			x = -30,
			y = 60
		},
		type = "copper-ore"
	},
	{
		left_top = {
			x = 30,
			y = 30
		},
		right_bottom = {
			x = 40,
			y = 40
		},
		type = "stone"
	},
	{
		left_top = {
			x = -50,
			y = 00
		},
		right_bottom = {
			x = -40,
			y = 10
		},
		gen_type = function()
			return "tree-" .. string.format("%02d", math.random(1, 9));
		end
	}
};

-- TODO: Move this into a terrain table, so we can declare multiple areas of water.
water = {
	left_top = {
		x = 100,
		y = 100
	},
	right_bottom = {
		x = 4228,
		y = 102
	}
};
