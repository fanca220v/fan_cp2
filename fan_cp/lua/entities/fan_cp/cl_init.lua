include("shared.lua");
surface.CreateFont( "FANCA CP", {
    font = "Tahoma",
    size = 30,
    weight = 4000,
    antialias = true
} )
local getlang = function(text, hud)
    local tbl = fan_cp and fan_cp.cfg.lang_str[fan_cp.cfg.lang] or {}
    if hud then tbl = fan_cp and fan_cp.cfg.lang_str[fan_cp.cfg.lang]["hud"] or {} end
    return tbl[text] or "invalid translate"
end
local col = {
    inactive = color_white,
    active   = Color(255,0,0)
}
function ENT:Draw() 
    self:DrawModel() 
    if not self:GetID() then self:DrawModel()  return end
    local INFO = fan_cp.cfg.cps[self:GetID()]
    -- if not INFO then return end
    local CP_INFO = fan_cp.cps[self:GetID()]
    if not CP_INFO then CP_INFO=INFO end

    local isactive = CP_INFO.captured
    local time = INFO.time

    local i = 25
    local COLOR = isactive and HSVToColor((CurTime()*100)%360,1,1)--[[col.active]] or col.inactive
    local AhEyes = LocalPlayer():EyeAngles()
    cam.Start3D2D( self:GetPos()+self:GetUp()*79, Angle(0, AhEyes.y-90, 90), 0.18 )
        if isactive then            
            draw.SimpleText(getlang"capture" .. " ".. INFO.name, "FANCA CP", 0, i*0, COLOR, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
            draw.SimpleText(getlang"left secs" .." ".. math.floor(CP_INFO.time - CurTime()) ..getlang("sec"), "FANCA CP", 0, i*1, COLOR, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
            draw.SimpleText(getlang"defender's/attack", "FANCA CP", 0, i*3, COLOR, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)        
            draw.SimpleText(CP_INFO.kills[1] .."/".. CP_INFO.kills[2], "FANCA CP", 0, i*4, COLOR, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)        
        else
            draw.SimpleText(INFO.name, "FANCA CP", 0, i*0, COLOR, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
            draw.SimpleText(getlang("owner") .." ".. CP_INFO.owner, "FANCA CP", 0, i*1, COLOR, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
        end
    cam.End3D2D()
end