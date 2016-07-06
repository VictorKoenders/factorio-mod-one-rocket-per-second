require "story"

local chunks_to_generate = {};
local chunks_to_generate_count = 0;
local flooring_to_place = "";


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
			x = -20,
			y = -50,
		},
		right_bottom = {
			x = 0,
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

-- Move this into a terrain table, so we can declare multiple areas of water.
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

local function within_area(pos, area)
	return area.left_top.x <= pos.x and area.left_top.y <= pos.y and pos.x < area.right_bottom.x and pos.y < area.right_bottom.y;
end

local function spaced(pos, area)
	return (pos.x - area.left_top.x) % area.spacing.x == 0 and (pos.y - area.left_top.y) % area.spacing.y == 0;
end

local function type_at(pos)
	local areas = areas;
	for i = 1, #areas do
		local area = areas[i]
		if within_area(pos, area) then
			if not area.spacing or spaced(pos, area) then
				-- Check for a function under a similiar name that we can call so it can generate types instead of this edge case here.
				if area.type == "tree" then
					return area.type .. "-" .. string.format("%02d", math.random(1, 9));
				end
				return area.type
			end
		end
	end
	return nil;
end

local function is_water(pos)
	return within_area(pos, water);
end

local function fill_chunk(surface, area)
	local terrain = {};
	local terrain_l = 1;
	local entities_to_add = {};
	local entities_to_add_l = 1;
	
	local x = area.left_top.x;
	local max_x = area.right_bottom.x;
	
	local _y = area.left_top.y;
	local max_y = area.right_bottom.y;
	
	while x < max_x do
		local y = _y;
		while y < max_y do
			local name = "concrete";
			local pos = { x = x, y = y };
			if is_water(pos) then
				name = "water"
			end
			terrain[terrain_l] = { name = name, position = pos };
			terrain_l = terrain_l + 1
			
			local found_type = type_at(pos);
			if found_type then
				-- TODO Change this so each section can control its own generation more specifically, such as the alien artefacts.
				entities_to_add[entities_to_add_l] =  { type = found_type, pos = pos }
				entities_to_add_l = entities_to_add_l + 1
			end
			
			y = y + 1;
		end
		
		x = x + 1;
	end
	
	surface.set_tiles(terrain);
	
	local entities = surface.find_entities(area)
	for i = 1, #entities do
		local ent = entities[i]
		if ent.type ~= "player" then
			ent.destroy();
		end
	end
	
	
	local create_entity = surface.create_entity;
	for i = 1, #entities_to_add do
		local ent = entities_to_add[i];
		-- As stated above, I want to move this over into the area, so we can generate specific stuff, and not have edge cases here.
		if ent.type == "alien-artifact" then
			local chest = create_entity {
				name = "steel-chest",
				force = "player",
				position = ent.pos
			}
			chest.insert { name = "alien-artifact", count = 24000 }
		else
			local amount = 2147483647;
			if ent.type == "crude-oil" then
				amount = 750
			end
			create_entity {
				name = ent.type,
				position = ent.pos,
				amount = amount
			}
		end
	end
end

local function generate_chunk_on_tick()
	local chunk = chunks_to_generate[chunks_to_generate_count];
	chunks_to_generate_count = chunks_to_generate_count - 1;
	
	fill_chunk(chunk.surface, chunk.area);
	
	if chunks_to_generate_count == 0 then 
		script.on_event(defines.events.on_tick, nil)
	end
end

local function on_chunk_generated(event)
	if flooring_to_place == "" then 
		chunks_to_generate_count = chunks_to_generate_count + 1;
		chunks_to_generate[chunks_to_generate_count] = { surface = event.surface, area = event.area };
		return;
	else 
		fill_chunk(event.surface, event.area);
	end
end

local function on_player_created(event)
	local player = game.players[event.player_index];
	
	player.clear_items_inside()
	player.insert{ name = "personal-roboport-equipment", count = 5 };
	player.insert{ name = "exoskeleton-equipment", count = 4 };
	player.insert{ name = "fusion-reactor-equipment", count = 3 };
	player.insert{ name = "deconstruction-planner", count = 1 };
	player.insert{ name = "night-vision-equipment", count = 1 };
	player.insert{ name = "construction-robot", count = 50 };
	player.insert{ name = "power-armor-mk2", count = 1 };
	player.insert{ name = "blueprint", count = 10 };
	player.insert{ name = "steel-axe", count = 5 };
	
	player.insert{ name = "steam-engine", count = 10 };
	player.insert{ name = "boiler", count = 14 };
	player.insert{ name = "pipe-to-ground", count = 4 };
	player.insert{ name = "small-pump", count = 1 };
	player.insert{ name = "small-electric-pole", count = 100 };
end

function pos_str(pos)
  return string.format("[%g, %g]", pos.x, pos.y)
end

function area_str(area)
  return string.format("[%g, %g] -> [%g, %g]", area.left_top.x, area.left_top.y, area.right_bottom.x, area.right_bottom.y)
end

story_table = {{
	{
		action = function()
			game.show_message_dialog{text = {"msg-ask-flooring"}};
		end
	},
	{
		action = function()
			local player = game.players[1];
			if player ~= nil then
				player.gui.top.add{type = "button", name="button_flooring_grass", caption={"flooring-grass"}};
				player.gui.top.add{type = "button", name="button_flooring_concrete", caption={"flooring-concrete"}};
			end
		end
	},
	{
		condition = function(event)
			if event.name == defines.events.on_gui_click then
				if event.element.name == "button_flooring_grass" then
					flooring_to_place = "grass";
					return true;
				end
				if event.element.name == "button_flooring_concrete" then
					flooring_to_place = "concrete";
					return true;
				end
			end
		end,
		action = function()
			local player = game.players[1];
			player.gui.top.button_flooring_grass.destroy();
			player.gui.top.button_flooring_concrete.destroy();
			
			script.on_event(defines.events.on_tick, generate_chunk_on_tick);
			game.show_message_dialog{text = {"msg-ask-technologies"}}
			
			player.gui.top.add{type = "button", name = "button_technologies_researched", caption = {"button-technologies-researched"}}
			player.gui.top.add{type = "button", name = "button_technologies_normal", caption = {"button-technologies-normal"}}
		end
	},
	{
		condition = function(event)
			if event.name == defines.events.on_gui_click then
				local player = game.players[event.player_index]
				if event.element.name == "button_technologies_researched" then
					player.force.research_all_technologies()
				elseif event.element.name ~= "button_technologies_normal" then
					return false
				end
				player.gui.top.button_technologies_researched.destroy()
				player.gui.top.button_technologies_normal.destroy()
				return true
			end
			return false
		end,
		action = function()
			script.on_event(defines.events, nil);
			subscribe_events();
		end
	},
	{
		condition = function() return false end,
		action = function() end
	}
}};

story_init_helpers(story_table);

script.on_event(defines.events, function(event)
	story_update(global.story, event, "")
end)

script.on_init(function()
	global.story = story_init()
end)

script.on_event(defines.events.on_player_created, on_player_created)
script.on_event(defines.events.on_chunk_generated, on_chunk_generated)

function subscribe_events()
	script.on_event(defines.events.on_player_created, on_player_created)
	script.on_event(defines.events.on_chunk_generated, on_chunk_generated)
	
	if chunks_to_generate_count > 0 then
		script.on_event(defines.events.on_tick, generate_chunk_on_tick);
	end
end