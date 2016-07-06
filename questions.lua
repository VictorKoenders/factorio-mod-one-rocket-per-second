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
