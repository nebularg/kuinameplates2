--------------------------------------------------------------------------------
-- Kui Nameplates
-- By Kesava at curse.com
-- All rights reserved
--------------------------------------------------------------------------------
-- Initialise addon events & begin to find nameplates
--------------------------------------------------------------------------------
-- initalise addon global
KuiNameplates = CreateFrame('Frame')
local addon = KuiNameplates
addon.debug = true
addon.debug_messages = true
--addon.draw_frames = true

-- plugin vars
addon.plugins = {}
local sort, tinsert = table.sort, tinsert
local function PluginSort(a,b)
    return a.priority > b.priority
end

-- element vars
addon.elements = {}

-- this is the size of the container, not the visible frame
-- changing it will cause positioning problems
local width, height = 142, 40
--------------------------------------------------------------------------------
function addon:print(msg)
    if not addon.debug then return end
    print('|cff666666KNP2 '..GetTime()..':|r '..(msg and msg or nil))
end
--------------------------------------------------------------------------------
function addon:NAME_PLATE_CREATED(frame)
    self.HookNameplate(frame)
end
function addon:NAME_PLATE_UNIT_ADDED(unit)
    local f = C_NamePlate.GetNamePlateForUnit(unit)
    if not f then return end
    f.kui.handler:OnUnitAdded(unit)
end
function addon:NAME_PLATE_UNIT_REMOVED(unit)
    local f = C_NamePlate.GetNamePlateForUnit(unit)
    if not f then return end
    if f.kui:IsShown() then
        self:print('unit lost: '..unit..' ('..f.kui.state.name..')')
        f.kui.handler:OnHide()
    end
end
--------------------------------------------------------------------------------
local function OnEvent(self,event,...)
    if event ~= 'PLAYER_LOGIN' then
        if self[event] then
            self[event](self,...)
        end
        return
    end
    self.uiscale = UIParent:GetEffectiveScale()

    -- get the pixel-perfect width/height of the default, non-trivial frames
    self.width, self.height = floor(width / self.uiscale), floor(height / self.uiscale)

    -- initialise plugins
    if #self.plugins > 0 then
        sort(self.plugins, PluginSort)
        for k,plugin in ipairs(self.plugins) do
            plugin:Initialise()
        end
    end

    if not self.layout then
        -- throw missing layout
        print('|cff9966ffKui Namemplates|r: A compatible layout was not loaded. You probably forgot to enable Kui Nameplates: Core in your addon list.')
    else
        if self.layout.Initialise then
            self.layout:Initialise()
        end
    end
end
------------------------------------------- initialise addon scripts & events --
addon:SetScript('OnEvent',OnEvent)
addon:RegisterEvent('PLAYER_LOGIN')
addon:RegisterEvent('NAME_PLATE_CREATED')
addon:RegisterEvent('NAME_PLATE_UNIT_ADDED')
addon:RegisterEvent('NAME_PLATE_UNIT_REMOVED')
