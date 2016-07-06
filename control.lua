require "story"
require "questions"
require "terrain_data"
require "terrain_functions"

chunks_to_generate = {};
chunks_to_generate_count = 0;
flooring_to_place = "";

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
	player.insert{ name = "offshore-pump", count = 1 };
	player.insert{ name = "small-electric-pole", count = 100 };
	
	player.insert{ name = "electric-mining-drill", count = 50 };
	player.insert{ name = "stone-furnace", count = 50 };
	player.insert{ name = "transport-belt", count = 200 };
	player.insert{ name = "inserter", count = 50 };
end

function pos_str(pos)
  return string.format("[%g, %g]", pos.x, pos.y)
end

function area_str(area)
  return string.format("[%g, %g] -> [%g, %g]", area.left_top.x, area.left_top.y, area.right_bottom.x, area.right_bottom.y)
end

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