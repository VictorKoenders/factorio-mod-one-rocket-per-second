local areas = {
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
			x = -50,
			y = -50,
		},
		right_bottom = {
			x = -30,
			y = -30
		},
		type = "tree"
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
		type = "tree"
	}
};

local water = {
	left_top = {
		x = 100,
		y = 100
	},
	right_bottom = {
		x = 4228,
		y = 102
	}
}

function pointIsInArea(point, area)
	return area.left_top.x <= point.x
	   and area.left_top.y <= point.y
	   and area.right_bottom.x >= point.x
	   and area.right_bottom.y >= point.y
end

function getTypeAt(position)
	for _, area in pairs(areas) do
		if pointIsInArea(position, area) then
			if not area.spacing 
				or (
					(position.x - area.left_top.x) % area.spacing.x == 0
					and (position.y - area.left_top.y) % area.spacing.y == 0
				)
			then
				if area.type == "tree" then
					return area.type .. "-" .. string.format("%02d", math.random(1, 9));
				end
				return area.type
			end
		end
	end
	return nil;
end

function isWaterAt(position)
	return pointIsInArea(position, water);
end

script.on_event(defines.events.on_player_created, function(event)
	local player = game.players[event.player_index];
	player.insert{ name = "personal-roboport-equipment", count = 5 };
	player.insert{ name = "exoskeleton-equipment", count = 4 };
	player.insert{ name = "fusion-reactor-equipment", count = 3 };
	player.insert{ name = "deconstruction-planner", count = 1 };
	player.insert{ name = "night-vision-equipment", count = 1 };
	player.insert{ name = "construction-robot", count = 50 };
	player.insert{ name = "power-armor-mk2", count = 1 };
	player.insert{ name = "blueprint", count = 10 };
	player.insert{ name = "steel-axe", count = 5 };
end)

script.on_event(defines.events.on_chunk_generated, function(event)
	local tiles = {};
	local entitiesToAdd = {};
	local x = event.area.left_top.x  - 1;
	while x <= event.area.right_bottom.x + 1 do
		local y = event.area.left_top.y - 1;
		while y <= event.area.right_bottom.y + 1 do
			local name = "concrete";
			if isWaterAt({ x = x, y = y }) then name = "water" end
			table.insert(tiles, { name = name, position = { x = x, y = y } });

			local type = getTypeAt({ x = x, y = y });
			if type ~= nil then
				table.insert(entitiesToAdd, { type = type, x = x, y = y });
			end

			y = y + 1;
		end

		x = x + 1;
	end
	event.surface.set_tiles(tiles);

	local entities = event.surface.find_entities(event.area)
	for _, ent in pairs(entities) do
		local foundEntity = getTypeAt(ent.position);
		if ent.type ~= "player" and (foundEntity == nil or ent.type ~= foundEntity.type) then
			ent.destroy();
		end
	end

	for _, ent in pairs(entitiesToAdd) do
		local amount = 2147483647;
		if ent.type == "crude-oil" then
			amount = 750
		end

		if ent.type == "alien-artifact" then
			local chest = event.surface.create_entity {
				name = "steel-chest",
				force = "player",
				position = { x = ent.x, y = ent.y }
			}
			chest.insert { name = "alien-artifact", count = 24000 }
		else
			event.surface.create_entity {
				name = ent.type,
				position = { x = ent.x, y = ent.y },
				amount = amount
			}
		end
	end
end)