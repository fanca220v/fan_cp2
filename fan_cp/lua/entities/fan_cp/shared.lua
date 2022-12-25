ENT.Base 				= "base_gmodentity"
ENT.Type 				= "anim"
ENT.PrintName 			= "Точка Захвата"
ENT.Author 	  			= "FANCA"
ENT.Category  			= 'FAN Capture 2'
ENT.Spawnable			= true
ENT.AdminOnly 			= true
function ENT:SetupDataTables()
	self:NetworkVar( "String", 0, "ID" )
end	
-- function ENT:Initialize()
-- 	self:PhysicsInit(SOLID_VPHYSICS)
-- 	self:SetMoveType(MOVETYPE_NONE)
-- 	self:SetSolid(SOLID_BBOX)
-- end