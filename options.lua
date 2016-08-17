-- The configurable stuff for people to choose from.
local options = {
	{
		key = "flooring",
		buttons = {
			"grass",
			"concrete"
		}
	},	
	{
		key = "technologies",
		buttons = {
			"yes",
			"no"
		},
		action = function(player, value)
			if value == "yes" then
				player.force.research_all_technologies();
			end
		end
	},	
	{
		key = "cheat-mode",
		buttons = {
			"yes",
			"no"
		},
		action = function(player, value)
			player.cheat_mode = (value == "yes");
		end
	}
}

-- Boring logic stuffs
local next_option = 1;
local active;
function options.start(player)
	if next_option < 0 then
		return;
	end

	local option = options[next_option];
	if not option then
		script.on_event(defines.events.on_gui_click, nil);
		next_option = -1;
		active = nil;
		
		if options.on_complete then
			options.on_complete();
		end
		return;
	end
	
	local options_frame = player.gui.center.add{type="frame", name="options_frame", caption = {option.key .. "-caption"}};
	
	local buttons = option.buttons;
	for i = 1, #buttons do
		local button = buttons[i];
		options_frame.add{type = "button", name = button, caption = {option.key .. "-" .. button}};
	end
	
	active = {
		option = option,
		options_frame = options_frame,
		player_index = player.index
	};
end

local function on_gui_click(event)
	if not active then
		return;
	end
	local active = active;
	-- TODO, currently this is the part the breaks it across saves, as the player_index must change, or something... I don't fully understand the issue. I haven't looked into it yet.
	if active.player_index == event.player_index then
		local player = game.players[event.player_index];
		local name = event.element.name;
		if active.option.action then
			name = active.option.action(player,name);
		end
		if name then
			if options.add then
				options.add(active.option.key, name)
			else
				options[active.option.key] = name;
			end
		end
		next_option = next_option + 1;
		active.options_frame.destroy();
		options.start(player);
	end
end

script.on_event(defines.events.on_gui_click, on_gui_click);

return options;
