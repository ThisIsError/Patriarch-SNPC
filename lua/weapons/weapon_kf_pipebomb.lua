SWEP.Category                   = "Killing Floor"
SWEP.PrintName			= "Pipe Bomb"
SWEP.Author			= "ERROR" 
SWEP.Instructions		= "BOOM!"

SWEP.UseHands = false

SWEP.Spawnable = true
SWEP.AdminOnly = false

SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= 2
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo		= "slam"

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo		= "none"

SWEP.Weight			= 5
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

SWEP.Slot			= 3
SWEP.SlotPos			= 3
SWEP.DrawAmmo			= true
SWEP.DrawCrosshair		= false

SWEP.ViewModel			= "models/Tripwire/Killing Floor/weapons/c_Pipe_Bomb.mdl"
SWEP.WorldModel			= "models/Tripwire/Killing Floor/weapons/w_pipe_bomb.mdl"

if(CLIENT) then
	SWEP.WepSelectIcon		= surface.GetTextureID("vgui/entities/weapon_kf_pipebomb")
end

local SwingSound = "weapons/iceaxe/iceaxe_swing1.wav"

function SWEP:AllValid()
	if(IsValid(self:GetOwner())&&!self:GetOwner():IsRagdoll()&&self:GetOwner()!=nil&&self:GetOwner()!=NULL&&
	self:GetOwner():Alive()&&IsValid(self:GetOwner():GetActiveWeapon())&&IsValid(self.Weapon)&&self.Weapon!=nil&&self.Weapon!=NULL&&
	self:GetOwner():GetActiveWeapon():GetClass()==self.Weapon:GetClass()) then
		return true
	end
	
	return false
end

function SWEP:Initialize()
	if(IsValid(self)&&self!=nil&&self!=NULL&&self:AllValid()) then
		self:SetHoldType("slam")
	end
end

function SWEP:Deploy()
	if(IsValid(self)&&self!=nil&&self!=NULL&&self:AllValid()) then
		if( SERVER ) then
			if(self:GetOwner():GetAmmoCount("slam")==0) then
				self:GetOwner():GetViewModel():SetNoDraw(true)
			else
				self:GetOwner():GetViewModel():SetNoDraw(false)
			end
			self:GetOwner():GetViewModel():SetSkin(2)
			self:SetSkin(2)
		end
		self:EmitSound("tripwire/killing floor/weapons/pipebomb/select.wav",70,100,0.8,CHAN_WEAPON)
	end
	
	return true
end

function SWEP:Think()
	if(IsValid(self)&&self!=nil&&self!=NULL&&self:AllValid()) then
		if(self:GetOwner():GetAmmoCount("slam")>0&&self:GetOwner():GetViewModel():GetNoDraw()==true) then
			self:GetOwner():GetViewModel():SetNoDraw(false)
		end
	end
end

function SWEP:PrimaryAttack()
	if(IsValid(self)&&self!=nil&&self!=NULL&&self:AllValid()) then
		if(self:GetOwner():GetAmmoCount("slam")>0) then
			self.Weapon:SetNextPrimaryFire( CurTime() + 1.8 )
			self:SendWeaponAnim( ACT_VM_PRIMARYATTACK )
			
			if( SERVER ) then
				timer.Create("LightOffPlant"..tostring(self),0.2,1,function()
					if(IsValid(self)&&self!=nil&&self!=NULL&&self:AllValid()) then
						self:GetOwner():GetViewModel():SetSkin(0)
						self:SetSkin(0)
					end
				end)
			end
			
			timer.Create("StartPlant"..tostring(self),0.9,1,function()
				if(IsValid(self)&&self!=nil&&self!=NULL&&self:AllValid()) then
					self:Plant()
				end
			end)
		end
	end
end


function SWEP:SecondaryAttack()
end

function SWEP:Holster()
	timer.Remove("StartPlant"..tostring(self))
	return true
end

function SWEP:Plant()
	self:GetOwner():SetAnimation(PLAYER_ATTACK1)
	
	if( SERVER ) then
		self:EmitSound("tripwire/killing floor/weapons/pipebomb/throw"..math.random(1,4)..".wav",100,100,0.8,CHAN_WEAPON)
					
		local PLANTPOS = Vector(0,0,0)
		local PLANTANG = Angle(0,0,0)
		
		if(self:GetOwner():LookupAttachment("anim_attachment_rh")) then
			local Attachment = self:GetOwner():GetAttachment(self:GetOwner():LookupAttachment("anim_attachment_rh"))
			
			PLANTPOS = Attachment.Pos
			PLANTANG = Attachment.Ang
		else
			PLANTPOS = (self:GetOwner():GetPos()+self:GetOwner():OBBCenter())+(self:GetOwner():GetEyeTrace().Normal*20)
			PLANTANG = self:GetOwner():EyeAngles()
		end
		
		local TEMP_TRACER = util.TraceLine( {
			start = self:GetOwner():GetPos()+self:GetOwner():OBBCenter(),
			endpos = PLANTPOS,
			filter = self:GetOwner() 
		} )
		
		
		PLANTPOS = TEMP_TRACER.HitPos
		PLANTANG = TEMP_TRACER.Normal:Angle()
		
		local Pipe = ents.Create("ent_planted_pipebomb")
		Pipe:SetPos(PLANTPOS)
		Pipe:SetAngles(PLANTANG)
		Pipe:Spawn()
		Pipe:SetCreator(self:GetOwner())
		
		self:GetOwner():RemoveAmmo( 1, self.Weapon:GetPrimaryAmmoType() )
				
		timer.Create("EndPlant"..tostring(self),0.7,1,function()
			if(IsValid(self)&&self!=nil&&self!=NULL&&self:AllValid()) then
				self:SendWeaponAnim( ACT_VM_IDLE )
				self:GetOwner():GetViewModel():SetSkin(2)
				self:SetSkin(2)
				
				if(self:GetOwner():GetAmmoCount("slam")==0) then
					self:GetOwner():GetViewModel():SetNoDraw(true)
				else
					self:GetOwner():GetViewModel():SetNoDraw(false)
				end
			end
		end)
	end
	
	if ( CLIENT ) then
		return 
	end
end