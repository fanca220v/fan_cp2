if fan_cp.isLoaded then return end
fan_cp.isLoaded = true

util.AddNetworkString("faq_req.GetCPs")
--
// clientside updater
fan_cp.updCL = function()
	net.Start("faq_req.GetCPs")
		net.WriteTable(fan_cp.cps)
	net.Broadcast()
end
fan_cp.notify = function(self, tip, msg)
	if self == "*" then
		DarkRP.notifyAll(tip, 10, msg)
		return
	end
	DarkRP.notify(self, tip, 10, msg)
end
--
// return default info table
local DEFAULT_CP_TABLE = function(v)
v=v or {
	zones = {Vector(0,0,0), Vector(0,0,0)},
	time = 0,
	endtime = 0
}

return	{
			captured 	= false,

			name 		= v.name,
			zones 		= v.zones,
			endtime 	= v.time,
			owner 		= v.owner,
			award 		= v.award,
			award_cd 	= v.award_cd,
			req_online  = v.req_online or 0,
			req_online_team=v.req_online_team or 0,
			req_online_def_team=v.req_online_def_team or 0,
			req_job     = v.req_job or false,
			cd 			= v.cd or 0,
			
			time  		= 0,
			cap_team 	= nil,
			old_team 	= "?",
			kills 		= {
				[1]=0,
				[2]=0
			},
			cooldown 	= 0
		}
end

// spawn cp's and create info table
timer.Simple(1,function()
	for k,v in pairs(fan_cp.cfg.cps) do
		if fan_cp.cps[k] then fan_cp.cps[k].ent:Remove() end
		fan_cp.cps[k]=DEFAULT_CP_TABLE(v)

		fan_cp.cps[k].ent=ents.Create("fan_cp")
		fan_cp.cps[k].ent:SetPos(v.pos.position)
		fan_cp.cps[k].ent:SetAngles(v.pos.angle)
		fan_cp.cps[k].ent:SetID(k)
		if v.model != nil then
			fan_cp.cps[k].ent:SetModel(v.model)
		end
		fan_cp.cps[k].ent:Spawn()

		fan_cp.updCL()
	end
end)

// get player faction
local GET_TEAM = function(p)
	for i,o in pairs(fan_cp.cfg.fraq) do
		if o.meta(p) then return i end
	end
	return '???'
end

// get language
local getlang = function(text, hud)
    local tbl = fan_cp and fan_cp.cfg.lang_str[fan_cp.cfg.lang] or {}
    if hud then tbl = fan_cp and fan_cp.cfg.lang_str[fan_cp.cfg.lang]["hud"] or {} end
    return tbl[text] or "invalid translate"
end
fan_cp.startCapture = function(self,ID)
	local cp = fan_cp.cps[ID]
	if cp.cooldown > CurTime() then fan_cp.notify(self, 1, getlang("wait") .." ".. CurTime()-cp.cooldown) return end
	local TEAM = GET_TEAM(self)
	if TEAM=='???' then fan_cp.notify(self, 1, getlang("impossible")) return end
	if TEAM==cp.owner then fan_cp.notify(self, 1, getlang("already your cp")) return end
	if cp.req_online and #player.GetAll()<cp.req_online then fan_cp.notify(self, 1, getlang("need") .." ".. cp.req_online .."(".. getlang("now") .." ".. #player.GetAll() ..") ".. getlang("players on server") ..".") return end
	if cp.req_online_team then
		local colvo = 0
		local colvo_own = 0
		for k,v in pairs(player.GetAll()) do
			if fan_cp.inzone(v, cp.zones[1], cp.zones[2]) and TEAM==GET_TEAM(v) then colvo = colvo+1 end
			if cp.owner==GET_TEAM(v) then colvo_own = colvo_own+1 end
		end
		if cp.req_online_team > colvo then
			fan_cp.notify(self, 1, getlang("need") .." ".. cp.req_online_team .."(".. getlang("now") .." ".. colvo ..") ".. getlang("players on capture zone") ..".")
			return
		end
		if cp.req_online_def_team > colvo_own then
			fan_cp.notify(self, 1, getlang("need") .." ".. cp.req_online_def_team .."(".. getlang("now") .." ".. colvo_own ..") ".. getlang("defenders") ..".")
			return
		end
	end
	if cp.req_job and cp.req_job!=self:Team() then fan_cp.notify(self, 1, getlang("impossible")) return end

	fan_cp.cps[ID].captured	= true
	fan_cp.cps[ID].cap_team	= TEAM
	fan_cp.cps[ID].old_team	= cp.owner
	fan_cp.cps[ID].time 	= CurTime() + fan_cp.cps[ID].endtime
	fan_cp.updCL()

	local cp=fan_cp.cps[ID]
	fan_cp.notify("*", 0, cp.cap_team .. " ".. getlang("start capture") .." ".. cp.name .."(".. getlang("owners") ..": ".. cp.old_team ..")" )

/*
use this hook.      |
                    v        for example, add to logs
*/
	hook.Run("fan_cp.start", self, ID, fan_cp.cps[ID].owner)
end
fan_cp.endCapture = function(ID)
	local cp = table.Copy(fan_cp.cps[ID])

	-- PrintTable(cp.kills)

	local is_captured 			= (cp.kills[1] < cp.kills[2]) and true or false
	fan_cp.cps[ID]				= DEFAULT_CP_TABLE(cp)
	fan_cp.cps[ID].owner 		= is_captured and cp.cap_team or cp.old_team
	fan_cp.cps[ID].endtime 		= cp.endtime
	fan_cp.cps[ID].captured 	= false
	fan_cp.cps[ID].cooldown 	= CurTime()+cp.cd
	fan_cp.updCL()

	if is_captured then
		fan_cp.notify("*", 0, fan_cp.cps[ID].owner .." ".. getlang("start capture") .." ".. fan_cp.cps[ID].name )
	else
		fan_cp.notify("*", 0, fan_cp.cps[ID].owner .." ".. getlang("defended capture") .." ".. fan_cp.cps[ID].name )
	end

/*
use this hook.      |
                    v        for example, add to logs
*/
	hook.Run("fan_cp.end", ID, fan_cp.cps[ID].owner)
end

// check capture timer
hook.Add("Think", "fan_cp.Capture", function()
	for k,v in pairs(fan_cp.cps) do
		if v.captured and v.time < CurTime() then
			fan_cp.endCapture(k)
		end
	end
end)

// capture points award 
local asewtag = 0
hook.Add("Think", "fan_cp.Award", function()
	if asewtag>CurTime() then return end
	for k,v in pairs(fan_cp.cps) do
		for _,self in pairs(player.GetAll()) do
			local TEAM = GET_TEAM(self)
			if TEAM=='???' then continue end
			if TEAM==v.owner then
				self:addMoney(v.award)
				fan_cp.notify(self, 0, getlang("you received") .." ".. DarkRP.formatMoney(v.award) .." ".. getlang("per point") .." ".. v.name )
			end
		end
		asewtag= CurTime()+v.award_cd
	end
end)

// Add scores with capture
hook.Add("PlayerDeath", "fan_cp.Capture", function( self, _, att )
	local da = false
	for k,v in pairs(fan_cp.cps) do
		if v.captured and GET_TEAM(self) == v.old_team and fan_cp.inzone(self,v.zones[1],v.zones[2]) then
			v.kills[2]=v.kills[2]+1
			da = true
		end
		if v.captured and GET_TEAM(self) == v.cap_team and fan_cp.inzone(self,v.zones[1],v.zones[2]) then
			v.kills[1]=v.kills[1]+1
			da = true
		end
	end
	if da==true then fan_cp.updCL() end 
end)

// info menu
hook.Add("PlayerSay", "fan_cp.info", function(self, text)
	if string.Trim(string.lower(text)) == "/cps" then
		self:SendLua([[fan_cp.cps_info()]])
		return ""
	end
end)
