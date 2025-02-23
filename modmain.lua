local _g = GLOBAL
local require = _g.require

AddSimPostInit(function()
	_g.TheInput:AddKeyHandler(
	function(key, down)
        -- Only trigger on key down
		if not down then return end
		-- Push our screen
		if key == _g.KEY_T then
			local screen = TheFrontEnd:GetActiveScreen()
			-- End if we can't find the screen name (e.g. asleep)
			if not screen or not screen.name then return true end
			-- If the hud exists, open the UI
			if screen.name:find("HUD") then
				-- We want to pass in the (clientside) player entity
				TheFrontEnd:PushScreen(require("widgets/spawner")(_g.ThePlayer))
				return true
			else
				-- If the screen is already open, close it
				if screen.name == "spawner" then
					screen:OnClose()
				end
			end
		end
		-- Require CTRL for any debug keybinds
		if _g.TheInput:IsKeyDown(_g.KEY_CTRL) then
			 -- Load latest save and run latest scripts
			if key == _g.KEY_R then
				if _g.TheWorld.ismastersim then
					_g.c_reset()
				else
					_g.TheNet:SendRemoteExecute("c_reset()")
				end
			end
		end
	end)
end)