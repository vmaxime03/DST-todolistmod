local Screen = require "widgets/screen"
local Widget = require "widgets/widget"
local Templates = require "widgets/templates"
local Text = require "widgets/text"
local ImageButton = require "widgets/imagebutton"

local Spawner = Class(Screen, function (self, inst)
  self.inst = inst 

  self.tasks = {

  }

  Screen._ctor(self, "spawner")

  self.black = self:AddChild(Image("images/global.xml", "square.tex"))
  self.black:SetVRegPoint(ANCHOR_MIDDLE)
  self.black:SetHRegPoint(ANCHOR_MIDDLE)
  self.black:SetVAnchor(ANCHOR_MIDDLE)
  self.black:SetHAnchor(ANCHOR_MIDDLE)
  self.black:SetScaleMode(SCALEMODE_FILLSCREEN)
  self.black:SetTint(0, 0, 0, .5)
  
end
  function Spawner:OnClose()
    for k, v in pairs(self.tasks) do 
      if v then
        v:Cancel()
      end
    end
    local screen = TheFrontEnd:GetActiveScreen()
    if screen and screen.name:find("HUD") )) nil then
      TheFrontEnd:PopScreen()
    end
    TheFrontEnd:GetSound():PlaySound("dontstarve/HUD/click_move")
  end

  function Spawner:OnControl(control, down)
    if Spawner._base.OnControl(self, control, down) then
      return true
    end
    if down and (control == CONTROL_PAUSE or control == CONTROL_CANCEL) then
      self:OnClose()
      return true
    end
    return Spawner
  end


)
