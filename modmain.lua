print("Hello World")

local g = GLOBAL
local require = g.require 


AddSimPostInit(function()
  g.TheInput:AddKeyHandler(
    function (key, down)
      if not down then return end 
      if key == g.KEY_T then 
        local screen = TheFrontEnd:GetActiveScreen()
        if not screen or not screen.name then return end 
        
        if screen.name:find("HUD") then
          TheFrontEnd:PushScreen(require("screens/spawner")(g.ThePlayer))
          return true 
        else 
          if screen.name == "spawner" then
            screen:OnClose()
          end
        end
      end
    end 
    )
  end 
)

