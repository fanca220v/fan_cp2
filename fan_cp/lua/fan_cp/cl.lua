net.Receive("faq_req.GetCPs", function()
	local TABLE = net.ReadTable()
	fan_cp.cps = TABLE
	print("Get CPs info")
end)
net.Receive("faq_req.Sound", function() --todo
	surface.PlaySound(net.ReadString())
end)
local draw_pos_cps
local getlang = function(text)
   return fan_cp.cfg.lang_str[fan_cp.cfg.lang]["hud"][text] or "invalid translate"
end
-- /cps
fan_cp.cps_info = function()
	if fan_cp.info then fan_cp.info:Remove() end
	fan_cp.info = vgui.Create("DFrame")
	fan_cp.info:SetSize(ScrW()*.5, ScrH()*.5)
	fan_cp.info:Center()
	fan_cp.info:MakePopup()
	fan_cp.info:SetTitle(getlang("cp information"))

	fan_cp.info.btnClose:SetText("X")
	fan_cp.info.btnClose.Paint = function(self,w,h) if self:IsHovered() then draw.RoundedBox(10, 0,0, w,h, Color(200,20,20)) end end

	fan_cp.info.scrl = vgui.Create("DScrollPanel", fan_cp.info)
	fan_cp.info.scrl:Dock(FILL)
	local allow_view= {
		["captured"] 	= true,
		["award"]  		= true,
		["name"] 		= true,
		["owner"]		= true
	}
	for k,v in pairs(fan_cp.cps) do
		local g = fan_cp.info.scrl:Add("DButton")
		g:SetText(getlang("capture") .. ' "'.. v.name ..'"')
		g:SetTall(60)
		g:Dock(TOP)
		g:DockMargin(3,3,3,3)
		g.DoClick = function()
			fan_cp.info.scrl:Clear()

			local d = fan_cp.info.scrl:Add("DButton")
			d:SetText(getlang("back"))
			d:SetTall(60)
			d:Dock(TOP)
			d:DockMargin(3,3,3,3)
			d.DoClick = fan_cp.cps_info
			for i,o in pairs(v) do
				if (isstring(o) or isnumber(o)) and allow_view[tostring(i)] then
					local j = fan_cp.info.scrl:Add("DLabel")
					j:SetText(getlang(i) ..": ".. o)
					j:SetFont("fan_cp.WARN3")
					j:SizeToContents()
					j:Dock(TOP)
					j:DockMargin(3,3,3,3)
				end
			end
			local e = fan_cp.info.scrl:Add("DButton")
			e:SetText(getlang("wallhack"))
			e:Dock(TOP)
			e:DockMargin(3,3,3,3)
			e.DoClick = function()
				if draw_pos_cps == k then draw_pos_cps=nil return end 
				draw_pos_cps = k
			end
		end
	end
end

local GET_TEAM = function(p)
	for i,o in pairs(fan_cp.cfg.fraq) do
		if o.meta(p) then return i end
	end
	return '???'
end
local CAP_TOCHKI = function(TEAM)
	local z = 0 
	for k,v in pairs(fan_cp.cps) do
		if v.captured and v.owner == TEAM then z=z+1 return v.name end
	end
	return false
end

// 3 minutes
surface.CreateFont("fan_cp.WARN", {font="Tahoma", size = 40, weight = 5000})
surface.CreateFont("fan_cp.WARN2", {font="Tahoma", size = 14, weight = 5000})
surface.CreateFont("fan_cp.WARN3", {font="Tahoma", size = 30, weight = 5000})
surface.CreateFont("fan_cp.wh", { font = "Arial", size = 15, weight = 5000})

local color_line = Color(0,0,0)
hook.Add("HUDPaint", "FAN_CP", function()
	local zaxvat_tochki = CAP_TOCHKI(GET_TEAM(LocalPlayer()))
	if zaxvat_tochki != false then
		color_line = CurTime() % 2 < 1 and Color(0,0,0) or Color(255,0,0)

		local x,y,w,h = 10,150,300,100
		surface.SetDrawColor(0,0,0,160)
		surface.DrawRect(x,y,w,h)
		surface.SetDrawColor(color_line)
		surface.DrawOutlinedRect(x,y,w,h,5)
		surface.SetMaterial(Material("icon16/error.png", "smooth mips"))
		surface.DrawTexturedRect(x+w-h+10,y+10,h-20,h-20)
		draw.SimpleText(string.upper(getlang("WARNING")), "fan_cp.WARN", x+10,y+10, color_line)
		draw.SimpleText(string.upper(getlang("CAPTURE YOUR CP")), "fan_cp.WARN2", x+10,y+10+40, color_line)
		draw.SimpleText(zaxvat_tochki, "fan_cp.WARN3", x+(w*0.35),y+10+40+14, color_line, TEXT_ALIGN_CENTER)
	end
	if draw_pos_cps!=nil then
		if fan_cp.cfg.cps[draw_pos_cps] then
			local tbl = fan_cp.cfg.cps[draw_pos_cps]
			-- local v = fan_cp.cps[draw_pos_cps].ent
			local point1 = tbl["pos"]["position"] - Vector(0, 0, 5)
			local point2 = tbl["pos"]["position"] + Vector(0, 0, 70)
			local pos = point1:ToScreen()
			local pos2 = point2:ToScreen()
			local h = pos.y - pos2.y
			local w = h / 2.2
			surface.SetDrawColor(color_white)
			surface.DrawOutlinedRect(pos.x - w / 2,pos.y-h,w,h,1)
			draw.SimpleText(string.upper(getlang("capture")) ..": ".. tbl.name, "fan_cp.wh", pos.x,pos.y-h-20, color_white, TEXT_ALIGN_CENTER)
		end
	end
end)