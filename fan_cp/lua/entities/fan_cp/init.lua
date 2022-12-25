AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")
function ENT:Initialize()
	self:SetModel("models/props_combine/combine_interface001.mdl")
	
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_NONE)
	self:SetSolid(SOLID_BBOX)

	self.CD = 0 
end
function ENT:Use(ply)
	if CurTime()<self.CD then return end
	if fan_cp.cps[self:GetID()].captured==true then return end

	fan_cp.startCapture(ply, self:GetID())
	self.CD = CurTime()+5
end