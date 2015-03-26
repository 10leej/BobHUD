local _, cfg = ... --export config
local addon, ns = ... --get addon namespace

function SetActiveInactive(frame, active, inactive)
   frame:SetScript("OnUpdate", function(self, elapsed)
         local current = GetMouseFocus()
         while current ~= nil do
            if current == frame then
               frame:SetAlpha(active)
               return
            end
            current = current:GetParent()
         end
         frame:SetAlpha(inactive)
   end)    
end

if cfg.OOCfade then

	local f = CreateFrame("Frame",nil,UIParent)
    f:RegisterEvent("PLAYER_ENTERING_WORLD")
    f:RegisterEvent("PLAYER_REGEN_DISABLED")
    f:RegisterEvent("PLAYER_REGEN_ENABLED")
    function f:OnEvent(event)
        if event == "PLAYER_REGEN_DISABLED"
        then
            SetActiveInactive(PlayerFrame, 1.0, 1.0)
            SetActiveInactive(TargetFrame, 1.0, 1.0)
            SetActiveInactive(FocusFrame,  1.0, 1.0)
        else
            SetActiveInactive(PlayerFrame, 1.0, cfg.transparency.fadeout)
            SetActiveInactive(TargetFrame, 1.0, cfg.transparency.fadeout)
            SetActiveInactive(FocusFrame,  1.0, cfg.transparency.fadeout)
        end
    end
    f:SetScript("OnEvent", f.OnEvent)

end
