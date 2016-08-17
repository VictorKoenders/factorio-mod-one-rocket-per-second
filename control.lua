require("options")

require("terrain.data")
require("terrain.functions")

function options.on_complete()
	if chunks_to_generate_count > 0 then
		script.on_event(defines.events.on_tick, generate_chunk_on_tick);
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
	player.insert{ name = "blueprint-book", count = 1 };
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
	
	options.start(player)
end
script.on_event(defines.events.on_player_created, on_player_created);

function pos_str(pos)
  return string.format("[%g, %g]", pos.x, pos.y)
end

function area_str(area)
  return string.format("[%g, %g] -> [%g, %g]", area.left_top.x, area.left_top.y, area.right_bottom.x, area.right_bottom.y)
end
