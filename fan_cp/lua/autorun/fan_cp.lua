-- local GAMEMODE = GAMEMODE or GM
-- if GAMEMODE.Name != "DarkRP" then return end -- only for darkrp

fan_cp={
	Log = function(log)
		MsgC(Color(255,0,0), "[FAN CP] ", Color(255,255,255), log .."\n")
	end
}
fan_cp.inc = {
	cl = function(file)
		file="fan_cp/".. file
		if SERVER then
			AddCSLuaFile(file)
			return
		end
		include(file)
		fan_cp.Log("loaded ".. file .." | cl")
	end,
	sv = function(file)
		file="fan_cp/".. file
		if SERVER then
			include(file)
			fan_cp.Log("loaded ".. file .." | sv")
		end
	end,
	sh = function(file)
		file="fan_cp/".. file
		if SERVER then
			AddCSLuaFile(file)
		end
		include(file)
		fan_cp.Log("loaded ".. file .." | sh")
	end
}
--sh
fan_cp.inc.sh("sh.lua")
--sv
fan_cp.inc.sv("sv.lua")
--cl
fan_cp.inc.cl("cl.lua")





-- loaded notify
local watermark = {
[[//|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||\\]],
[[//...............................................................\\]],
[[//.FFFFFFF..AAAAAAA..NNNN....NN......CCCCCC..PPPPPPP.............\\]],
[[//.FFFFFFF..AAAAAAA..NN..NN..NN......CCCCCC..PP...PP.............\\]],
[[//.FF.......AA...AA..NN...NN.NN......CC......PP...PP.......22222.\\]],
[[//.FFFF.....AAAAAAA..NN...NN.NN......CC......PPPPPPP.ssss.....22.\\]],
[[//.FF.......AA...AA..NN...NN.NN......CC......PP......s........22.\\]],
[[//.FF.......AA...AA..NN....NNNN......CCCCCC..PP......ssss..22222.\\]],
[[//.FF.......AA...AA..NN.....NNN......CCCCCC..PP.........s..22....\\]],
[[//...................................................ssss..22222.\\]],
[[//...............................................................\\]],
[[//||||||||||||||||||||works.fanatiktop.xyz|||||||||||||||||||||||\\]],
[[-																	 ]],
[[                     FAN CP 2 | FULL LOADED			             ]],
}
for o=1,#watermark do
	MsgC(Color(255,0,0), watermark[o] .."\n")
end