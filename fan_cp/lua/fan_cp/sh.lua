fan_cp.cfg = {
	-- factions
	fraq 	= {
		-- ex.:
		-- ["id"] = {
		-- 	color 		=Color(100,100,20),
		-- 	meta 		=function(ply)     -- access, etc: ply:isCP()
		-- 		return (!ply:isCP()) or false
		-- 	end
		-- },
		["Альянс"] = {
			color 		=Color(20,20,100),
			meta 		=function(ply)
				return (ply:isCP()) or false
			end
		},
		["Повстанцы"] = {
			color 		=Color(100,100,20),
			meta 		=function(ply)
				return (!ply:isCP()) or false
			end
		}
	},
	-- capture points
	cps 	= {
		-- ex.:
		-- ["id"] ={
		-- 	name 	= "name",
		-- 	time 	= 30, -- capture time
		-- 	owner 	= "id faction", -- fan_cp.cfg.fraq
		-- 	pos 	= {
		-- 		angle 			= Angle(0, 0, 0),
		-- 		position 		= Vector(-990.468750, -1852.687500, -143.656250)
		-- 	},
		-- 	zones = {
		-- 		[1] = Vector(-3605.219727, -897.650208, 307.027435),
		-- 		[2] = Vector(487.393494, -2041.140259, -239.103485)
		-- 	}, -- zone, kill in zone and capture = add score
		-- 	award = 100, -- award
		-- 	award_cd = 30, -- award cooldown
		-- 	req_online = 3 -- need # online for start capture
		--  model = "MODEL PATH" -- overide model
		--  cd = 300, -- cooldown capture
		-- },
		["DEV"] ={
			name 	= "Альфа",
			time 	= 30,
			owner 	= "Повстанцы", -- fan_cp.cfg.fraq
			pos 	= {
				angle 			= Angle(0, 0, 0),
				position 		= Vector(-990.468750, -1852.687500, -143.656250)
			},
			zones = {
				[1] = Vector(-3605.219727, -897.650208, 307.027435),
				[2] = Vector(487.393494, -2041.140259, -239.103485)
			},
			award = 100,
			award_cd = 30,
			-- req_online = 3,
			model = "models/props_combine/combine_monitorbay.mdl"
		},
		["DEV2"] ={
			name 	= "Дельта",
			time 	= 10,
			owner 	= "Альянс", -- fan_cp.cfg.fraq
			pos 	= {
				angle 			= Angle(0, 0, 0),
				position 		= Vector(-4909.625000, 5374.968750, -95.656250)
			},
			zones = {
				[1] = Vector(-2612.625000, 3748.031250, -196.593750),
				[2] = Vector(-5246.718750, 6433.000000, 4273.531250)
			},
			award = 228,
			award_cd = 10,
			-- req_online = 6,
			-- req_online_team = 3
		}
	},
	lang = "ru", -- set language
	lang_str = {
		["ru"] = {
			-- Over entity
			["owner"] = "Владелец:",
			["time"] = "Время:",
			["capture"] = "Захват:",
			["left secs"] = "Осталось:",
			["defender's/attack"] = "Защищающиеся/Аттакующие",
			["sec"] = "с",

			-- server
			["wait"] = "Подождите",
			["need"] = "Надо",
			["now"] = "Сейчас",
			["players on server"] = "игроков на сервере",
			["already your cp"] = "Уже ваша точка",
			["impossible"] = "Нельзя",
			["players on capture zone"] = "игроков около точки",
			["defenders"] = "защищающихся",
			["start capture"] = "начали захват точки", -- alliance *this string* *cpname*
			["defended capture"] = "отстояли точку",
			["owners"] = "Владельцы",
			["captured point"] = "захватили точку",
			["you received"] = "Вы получили",
			["per point"] = "за точку",

			-- client
			['hud'] = {
				["cp information"] = "Информация о точках", -- title frame (/cps)
				["capture"]	= "Точка", -- capture point
				["back"] = "Назад",
				["wallhack"] = "Показать сквозь стены", -- Show Through Walls

				["WARNING"] = "ВНИМАНИЕ",
				["CAPTURE YOUR CP"] = "ЗАХВАТЫВАЮТ ВАШУ ТОЧКУ",

				["captured"]= "Захватывается",
				["award"] 	= "Награда",
				["owner"] 	= "Владелец",
				["name"] 	= "Название",
			}
		},
		["eng"] = {
			-- Over entity
			["owner"] = "Owner:",
			["time"] = "Time:",
			["capture"] = "Capture:",
			["left secs"] = "Time left:",
			["defender's/attack"] = "Defeders/Attackers",
			["sec"] = "s",

			-- server
			["wait"] = "Wait",
			["need"] = "Need",
			["now"] = "Now",
			["players on server"] = "players on server",
			["already your cp"] = "already your cp",
			["impossible"] = "impossible",
			["players on capture zone"] = "players on capture zone",
			["defenders"] = "defenders",
			["start capture"] = "start capture point", -- alliance *this string* *cpname*
			["defended capture"] = "defended capture",
			["owners"] = "Owners",
			["captured point"] = "captured point",
			["you received"] = "you received",
			["per point"] = "per point",

			-- client
			['hud'] = {
				["cp information"] = "Capture Points information", -- title frame (/cps)
				["capture"]	= "Point", -- capture point
				["back"] = "Back",
				["wallhack"] = "Show through walls", -- Show Through Walls

				["WARNING"] = "WARNING",
				["CAPTURE YOUR CP"] = "CAPTURE YOUR POINT",

				["captured"]= "Is captured",
				["award"] 	= "Award",
				["owner"] 	= "Owner",
				["name"] 	= "Name",
			}
		}
	}
}

-- dont touch
fan_cp.cps = {}
function fan_cp.inzone(self, z1, z2)
	return self:GetPos():WithinAABox(z1, z2) 
end

-- if SERVER then fan_cp.refresh_cps() end