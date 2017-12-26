util.AddNetworkString("ExplodePatriarchRocket")
util.AddNetworkString("ExplodePatriarchRocketNE")

AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")

ENT.Exploding = false
ENT.EventEffect = 0
ENT.Damage = 75

function ENT:Detonate()
	self.Exploding = true
	self:SetHealth(0)
	
	local Explosion = ents.Create( "env_explosion" )
	Explosion:SetPos( self:GetPos() )
	Explosion:Spawn()
	
	Explosion:SetOwner(self)
	
	Explosion:SetKeyValue( "iMagnitude", tostring(self.Damage) )
	Explosion:SetKeyValue( "iRadiusOverride", "190" )
	Explosion:SetKeyValue("spawnflags","64")
	Explosion:EmitSound( "Tripwire/Killing Floor/explosion"..math.random(1,5)..".wav", 411, 100, 0.8, CHAN_WEAPON )
	Explosion:Fire("Explode", 0, 0 )
	Explosion:Fire("Kill","",0.01)
	
	timer.Create("StopProjectile"..tostring(self),0.01,1,function()
		if(IsValid(self)&&self!=nil&&self!=NULL) then
			self:SetNoDraw(true)
			self:DrawShadow(false)
			self:SetVelocity(Vector(0,0,0))
			self:SetMoveType(MOVETYPE_NONE)
		end
	end)
	
	self:Fire("kill","",1)
	
	if(self.EventEffect==0) then
		net.Start("ExplodePatriarchRocket")
		net.WriteEntity(self)
		net.WriteVector(self:GetPos())
		net.Broadcast()
	elseif(self.EventEffect==1) then
		net.Start("ExplodePatriarchRocketNE")
		net.WriteEntity(self)
		net.WriteVector(self:GetPos())
		net.Broadcast()
	end
end

function ENT:Initialize()
	self:SetModel( "models/Tripwire/Killing Floor/Projectiles/KFPatriarchRocket.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	self:AddEFlags(EFL_NO_DAMAGE_FORCES)
	self:AddFlags(FL_GRENADE)
	self:SetCollisionGroup(COLLISION_GROUP_DISSOLVING)
	
	
	self.Damage = 75

	self.EventEffect = 0
	
	local phys = self:GetPhysicsObject()

	if (phys:IsValid()) then
		phys:Wake()
	end
	
	self:SetHealth(500)
	self:SetTrigger(true)
end

function ENT:StartTouch( ent )
	local TEMP_OWNERWEAPON = self:GetOwner()

	if(IsValid(self:GetOwner())&&self:GetOwner()!=nil&&self:GetOwner()!=NULL&&self:GetOwner():IsPlayer()) then
		if(IsValid(self:GetOwner():GetActiveWeapon())) then
			TEMP_OWNERWEAPON = self:GetOwner():GetActiveWeapon()
		end
	end
	
	
	if(ent:GetClass()!=self:GetClass()&&ent!=self:GetOwner()&&self.Exploding==false&&ent!=TEMP_OWNERWEAPON) then
		self:Detonate()
	end
end


function ENT:PhysicsCollide( data, phys )
	if(self.Exploding==false) then
		self:Detonate()
	end
end

function ENT:Think()
	local TEMP_Vel = self:GetPhysicsObject():GetVelocity()
	self:SetAngles(TEMP_Vel:Angle())
	self:GetPhysicsObject():SetVelocity(TEMP_Vel)
	
	if(bit.band( util.PointContents( self:GetPos() ), CONTENTS_WATER ) == CONTENTS_WATER ) then
		if(self.Exploding==false) then
			self:Detonate()
		end
	end
end

