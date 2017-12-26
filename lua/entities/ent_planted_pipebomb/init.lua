AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")

ENT.Planted = 0

ENT.PlantPos = Vector(0,0,0)
ENT.PlantNormal = Angle(0,0,0)


function ENT:Boom()
	self:SetNWBool("Exploding"..tostring(self), true)

	local Explosion = ents.Create( "env_explosion" )
	Explosion:SetPos( self:GetPos() )
	Explosion:Spawn()
	
	self:SetOwner(self:GetCreator())
	Explosion:SetOwner(self)

	Explosion:SetKeyValue( "iMagnitude", "1500" )
	Explosion:SetKeyValue( "iRadiusOverride", "250" )
	Explosion:SetKeyValue("spawnflags","64")
	Explosion:EmitSound( "Tripwire/Killing Floor/explosion"..math.random(1,5)..".wav", 411, 100, 0.8, CHAN_WEAPON )
	Explosion:Fire("Explode", 0, 0 )
	Explosion:Fire("Kill","",0.01)
	
	self:Fire("kill","",0.2)
end

function ENT:Initialize()
	self:SetModel( "models/Tripwire/Killing Floor/weapons/w_pipe_bomb_planted.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	self:AddFlags(FL_GRENADE)
	
	self:SetCollisionGroup(COLLISION_GROUP_WEAPON)
 
	local phys = self:GetPhysicsObject()

	if (phys:IsValid()) then
		phys:Wake()
	end
	
	self:SetTrigger(true)
	self:SetNWBool("Exploding"..tostring(self),false)
	
	self:SetCreator(self:GetOwner())
	//self:SetOwner(NULL)
	
	timer.Create("BeepUsual"..tostring(self),2,0,function()
		if(IsValid(self)&&self!=nil&&self!=NULL) then
			self.Planted = 1
			self:SetSkin(1)
			self:EmitSound("tripwire/killing floor/weapons/pipebomb/beep.wav",60,100,0.8,CHAN_WEAPON)
			
			timer.Simple(0.1,function()
				if(IsValid(self)&&self!=nil&&self!=NULL) then
					self:SetSkin(0)
				end
			end)
		end
	end)
end

function ENT:Think()
	if(self.Planted==1) then
		if(self:GetNWBool("Exploding"..tostring(self),false)==false) then
			local MyNearbyTargets = ents.FindInSphere(self:GetPos(),80)

			local Mass = 0
			
			if(#MyNearbyTargets!=0) then 
				for i,I in pairs(MyNearbyTargets) do
					if((I:IsPlayer()&&I:Alive()&&I!=self:GetCreator())||I:IsNPC()) then
						if(I:IsNPC()) then
							Mass = Mass+math.abs(I:OBBMins().x)+math.abs(I:OBBMins().y)+math.abs(I:OBBMins().z)+
							math.abs(I:OBBMaxs().x)+math.abs(I:OBBMaxs().y)+math.abs(I:OBBMaxs().z)
						else
							Mass = Mass+72
						end
					end
				end
			end
			
			if(Mass>150) then
				self:SetNWBool("Exploding"..tostring(self),true)
				timer.Remove("BeepUsual"..tostring(self))
				self:SetSkin(0)
				
				timer.Create("Beep"..tostring(self),0.15,3,function()
					if(IsValid(self)&&self!=nil&&self!=NULL) then
						self:EmitSound("tripwire/killing floor/weapons/pipebomb/beep.wav",60,110,0.8,CHAN_WEAPON)
						
						self:SetSkin(1)
						self:EmitSound("tripwire/killing floor/weapons/pipebomb/beep.wav",60,100,0.8,CHAN_WEAPON)
						
						timer.Simple(0.1,function()
							if(IsValid(self)&&self!=nil&&self!=NULL) then
								self:SetSkin(0)
							end
						end)
					end
				end)
				
				timer.Create("Explode"..tostring(self),0.6,1,function()
					if(IsValid(self)&&self!=nil&&self!=NULL) then
						self:Boom()
					end
				end)
			end
		end
	end
end

function ENT:OnTakeDamage(dmg)
	if(self:GetNWBool("Exploding"..tostring(self),false)==false&&self.Planted==1) then
		if(IsValid(dmg:GetAttacker())&&dmg:GetAttacker()!=nil&&dmg:GetAttacker()!=NULL&&
		((dmg:GetAttacker():IsPlayer()&&dmg:GetAttacker()==self:GetCreator()&&!dmg:IsExplosionDamage())||dmg:GetAttacker():IsNPC())) then
			self:SetNWBool("Exploding"..tostring(self),true)
			self:Boom()
		end
	end
end


