local Screen = require "widgets/screen"
local Widget = require "widgets/widget"
local TEMPLATES = require "widgets/redux/templates" --https://github.com/taichunmin/dont-starve-together-game-scripts/tree/master/widgets/redux
local Text = require "widgets/text"
local ImageButton = require "widgets/imagebutton"

local ScrollableList = require "widgets/scrollablelist"

local Spawner = Class(Screen, function(self, inst)
    -- Player instance
    self.inst = inst
     -- Any 'DoTaskInTime's or 'DoPeriodicTask's should be assigned in here
     -- These are cancelled upon close to prevent stale components
    self.tasks = {}
  
    -- If you want to maintain state look into GetModConfigData, Replicas, or TheSim:SetPersistentString
  
    -- Register screen name
    Screen._ctor(self, "spawner")

    self.root = self:AddChild(TEMPLATES.ScreenRoot("root"))

    self.listspanel = self.root:AddChild(TEMPLATES.RectangleWindow(500, 300))
    self.listspanel:SetPosition(0, 25)

    self.toptext = self.root:AddChild(Text(NEWFONT_OUTLINE, 27, "TO DO LIST", {unpack(GOLD)}))
    self.toptext:SetPosition(0, 155, 0)
    self.bottomtext = self.root:AddChild(Text(NEWFONT_OUTLINE, 27, "test", {unpack(GOLD)}))
    self.bottomtext:SetPosition(0, -103, 0)

    self.closebutton = self.listspanel:AddChild(TEMPLATES.StandardButton(function()
            self:OnClose()
        end, "CLOSE", {130, 40}))
    self.closebutton:SetPosition(0, -170)

    self:loadElements()
      
    -- Darken the game
    -- We're using the DST global assets
    -- self.black = self:AddChild(Image("images/global.xml", "square.tex"))
    -- self.black:SetVRegPoint(ANCHOR_MIDDLE)
    -- self.black:SetHRegPoint(ANCHOR_MIDDLE)
    -- self.black:SetVAnchor(ANCHOR_MIDDLE)
    -- self.black:SetHAnchor(ANCHOR_MIDDLE)
    -- self.black:SetScaleMode(SCALEMODE_FILLSCREEN)
    -- self.black:SetTint(0, 0, 0, .5)


    -- self.proot = self:AddChild(Widget("ROOT"))
    -- self.proot:SetVAnchor(ANCHOR_MIDDLE)
    -- self.proot:SetHAnchor(ANCHOR_MIDDLE)

    -- self.proot:SetPosition(20, 0, 0)
    -- self.proot:SetScaleMode(SCALEMODE_PROPORTIONAL)

    -- local Templates = require "widgets/templates"
     -- We're using a template for our background
    -- In this case we're calling a function to assemble the pieces of "images/dialogcurly_9slice.xml"
    -- The offsets center it above the player's inventory

    -- self.bg = self.proot:AddChild(Templates.CurlyWindow(500, 450, 1, 1, 68, -40))
    -- self.title = self.proot:AddChild(Text(NEWFONT_OUTLINE, 40, "To Do List", {unpack(GOLD)}))
    -- self.title:SetPosition(0, 250)





    -- self.animationUp = self.proot:AddChild(Text(NEWFONT_OUTLINE, 30, "Y: ", {unpack(RED)}))
    -- self.animationUp:SetPosition(-520, -350)
    -- -- Assign the task to the client
    -- self.tasks[#self.tasks + 1] = self.inst:DoPeriodicTask(.1, function()
    --   local pos = self.animationUp:GetPosition()
    --   self.animationUp:SetPosition(pos.x, pos.y > 350 and -350 or pos.y + 5)
    --   self.animationUp:SetString("Y: " .. pos.y)
    -- end)
  
    -- self.animationRight = self.proot:AddChild(Text(NEWFONT_OUTLINE, 30, "X: ", {unpack(RED)}))
    -- self.animationRight:SetPosition(-600, -290)
    -- -- Assign the task to the client
    -- self.tasks[#self.tasks + 1] = self.inst:DoPeriodicTask(.1, function()
    --   local pos = self.animationRight:GetPosition()
    --   self.animationRight:SetPosition(pos.x > 600 and -600 or pos.x + 5, pos.y)
    --   self.animationRight:SetString("X: " .. pos.x)
    -- end)

end)



function Spawner:loadElements()
    self.musicnames = {
        "test1", "test1", "test1", "test1",  "test1", "test1", "test1", "test1", "test1", "test1", "test1", "test1", "test1", "test1", "test1", "test1", "test1", "test1", "test1", "test1",  "test1", "test1", "test1", "test1", "test1", "test1", "test1", "test1", "test1", "test1", "test1", "test1",
        "test1", "test1", "test1", "test1",  "test1", "test1", "test1", "test1", "test1", "test1", "test1", "test1", "test1", "test1", "test1", "test1", "test1", "test1", "test1", "test1",  "test1", "test1", "test1", "test1", "test1", "test1", "test1", "test1", "test1", "test1", "test1", "test1"
    }
    local function createListElem(context, index)
        print("DEBUG 1")
        local widget = Widget("widget-" .. index)
        widget:SetOnGainFocus(function()
             self.scrollbar:OnWidgetFocus(widget)
        end)
        -- widget.item = widget:AddChild(self:DestListItem())
        -- local dest = widget.item
        -- widget.focus_forward = dest
        return widget
    end
    local function apply_userfn(context, widget, name, index)
        print("DEBUG 2")
        -- widget.name = name
        -- widget.item:Hide()
        -- if not name then
        --     widget.focus_forward = nil
        --     return
        -- end
        -- widget.focus_forward = widget.item
        -- widget.item:Show()
        -- local item = widget.item
        -- local singer = TUNING.XYMUSICLIST[index].singer
        -- if singer ~= nil then
        --     item:SetInfo(index, string.format("%s(%s)", name, singer))
        -- else
        --     item:SetInfo(index, name)
        -- end
    end

    if not self.scrollbar then
        self.scrollbar = self.listspanel:AddChild(TEMPLATES.ScrollingGrid(self.musicnames, {
                widget_width = 240,
                widget_height = 30,
                num_visible_rows = 7,
                num_columns = 2,
                item_ctor_fn = createListElem,
                apply_fn = apply_userfn,
                scrollbar_offset = 25,
                scrollbar_height_offset = -80,
                allow_bottom_empty_row = true
            }))

    end
end



function Spawner:OnClose()
-- Cancel any started tasks
-- This prevents stale components
    for k,v in pairs(self.tasks) do
        if v then
            v:Cancel()
        end
    end
    local screen = TheFrontEnd:GetActiveScreen()
    -- Don't pop the HUD
    if screen and screen.name:find("HUD") == nil then
        -- Remove our screen
        TheFrontEnd:PopScreen()
    end
    TheFrontEnd:GetSound():PlaySound("dontstarve/HUD/click_move")
end

function Spawner:OnControl(control, down)
    -- Sends clicks to the screen
    if Spawner._base.OnControl(self, control, down) then
        return true
    end
    -- Close UI on ESC
    if down and (control == CONTROL_PAUSE or control == CONTROL_CANCEL) then
        self:OnClose()
        return true
    end
end


return Spawner