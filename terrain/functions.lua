chunks_to_generate = {};
chunks_to_generate_count = 0;

function within_area(pos, area)
	return area.left_top.x <= pos.x and area.left_top.y <= pos.y and pos.x < area.right_bottom.x and pos.y < area.right_bottom.y;
end

function spaced(pos, area)
	return (pos.x - area.left_top.x) % area.spacing.x == 0 and (pos.y - area.left_top.y) % area.spacing.y == 0;
end

function types_at(pos)
	local types;
	local areas = areas;
	for i = 1, #areas do
		local area = areas[i]
		if within_area(pos, area) then
			if not area.spacing or spaced(pos, area) then
				types = types or {}
				types[#types + 1] = area.gen_type and area.gen_type() or area.type;
			end
		end
	end
	return types;
end

function is_water(pos)
	return within_area(pos, water);
end

function fill_chunk(surface, area)
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
			local name = global.options.flooring;
			local pos = { x = x, y = y };
			if is_water(pos) then
				name = "water"
			end
			terrain[terrain_l] = { name = name, position = pos };
			terrain_l = terrain_l + 1

			local found_types = types_at(pos);
			if found_types then
				if (#found_types > 1) then
					log('Invalid shit');
				end
				-- TODO Change this so each section can control its own generation more specifically, such as the alien artefacts.
				entities_to_add[entities_to_add_l] = { type = found_types[1], pos = pos }
				entities_to_add_l = entities_to_add_l + 1
			end

			y = y + 1;
		end

		x = x + 1;
	end

	surface.set_tiles(terrain, false);

	local entities = surface.find_entities(area)
	for i = 1, #entities do
		local ent = entities[i]
		if ent.type ~= "player" then
			local pos = ent.position;
			if pos.x >= area.left_top.x and
				 pos.x < area.right_bottom.x and
				 pos.y >= area.left_top.y and
				 pos.y < area.right_bottom.y then
				ent.destroy();
			end
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

function generate_chunk_on_tick()
	local chunk = chunks_to_generate[chunks_to_generate_count];
	chunks_to_generate_count = chunks_to_generate_count - 1;

	fill_chunk(chunk.surface, chunk.area);

	if chunks_to_generate_count == 0 then
		script.on_event(defines.events.on_tick, nil)
	end
end

function on_chunk_generated(event)
	if not global.options.flooring then
		chunks_to_generate_count = chunks_to_generate_count + 1;
		chunks_to_generate[chunks_to_generate_count] = { surface = event.surface, area = event.area };
		return;
	else
		fill_chunk(event.surface, event.area);
	end
end

script.on_event(defines.events.on_chunk_generated, on_chunk_generated);
