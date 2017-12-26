SWEP.Category                   = "Killing Floor"
SWEP.PrintName			= "Welder"
SWEP.Author			= "ERROR" 
SWEP.Instructions		= "I am welding!"

SWEP.UseHands = false

SWEP.Spawnable = true
SWEP.AdminOnly = false

SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo		= "none"

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

SWEP.ViewModel			= "models/Tripwire/Killing Floor/weapons/c_Welder.mdl"
SWEP.WorldModel			= "models/Tripwire/Killing Floor/weapons/w_welder.mdl"

if(CLIENT) then
	SWEP.WepSelectIcon		= surface.GetTextureID("vgui/entities/weapon_kf_welder")
end

SWEP.WeldInterval = 0
SWEP.WeldingPower = 1

SWEP.SoundInterval = 0

function SWEP:AllValid()
	if(IsValid(self:GetOwner())&&!self:GetOwner():IsRagdoll()&&self:GetOwner()!=nil&&self:GetOwner()!=NULL&&
	self:GetOwner():Alive()&&IsValid(self:GetOwner():GetActiveWeapon())&&IsValid(self.Weapon)&&self.Weapon!=nil&&self.Weapon!=NULL&&
	self:GetOwner():GetActiveWeapon():GetClass()==self.Weapon:GetClass()) then
		return true
	end
	
	return false
end

function SWEP:Initialize()
	self:SetNWFloat("Welding",100)
	self:SetNWInt("Attacking",0)
	if(IsValid(self)&&self!=nil&&self!=NULL&&self:AllValid()) then
		self:SetHoldType("pistol")
	end
end

function SWEP:Deploy()
end

if(SERVER) then
	function SWEP:WeldingConditions(IND)
		local TEMP_TR = self:GetOwner():GetEyeTrace()
		local TEMP_DOOR = TEMP_TR.Entity
		local TEMP_STARTPOS = TEMP_TR.StartPos
		local TEMP_HITPOS = TEMP_TR.HitPos
		
		if(TEMP_STARTPOS:Distance(TEMP_HITPOS)<40) then
			if(TEMP_DOOR:GetClass()=="prop_door_rotating") then
				local TEMP_VECCLOSED = Vector(0,0,0)
				local TEMP_VECCURRENT = Vector(math.Truncate(TEMP_DOOR:GetAngles().x,2),math.Truncate(TEMP_DOOR:GetAngles().y,2),math.Truncate(TEMP_DOOR:GetAngles().z,2))
				
				if(isvector(TEMP_DOOR:GetSaveTable().m_angRotationClosed)) then
					TEMP_VECCLOSED = Vector(math.Truncate(TEMP_DOOR:GetSaveTable().m_angRotationClosed.x,2),math.Truncate(TEMP_DOOR:GetSaveTable().m_angRotationClosed.y,2),math.Truncate(TEMP_DOOR:GetSaveTable().m_angRotationClosed.z,2))
				end
				
				local TEMP_DOORISNOTLOCKED = (TEMP_DOOR:GetSaveTable().m_bLocked==false&&TEMP_DOOR:GetNWFloat("Welded",0)==0)||
				(TEMP_DOOR:GetSaveTable().m_bLocked==true&&TEMP_DOOR:GetNWFloat("Welded",0)>0)
				
				local TEMP_UNWELDCONDITION = TEMP_DOOR:GetNWFloat("Welded",0)<100&&self:GetNWInt("Attacking",0)==1
				local TEMP_WELDCONDITION = TEMP_DOOR:GetNWFloat("Welded",0)>0&&self:GetNWInt("Attacking",0)==-1
				
				if(IND==1) then
					TEMP_WELDCONDITION = TEMP_DOOR:GetNWFloat("Welded",0)<100
				elseif(IND==-1) then
					TEMP_WELDCONDITION = TEMP_DOOR:GetNWFloat("Welded",0)>0
				end
				
				if(TEMP_DOORISNOTLOCKED&&(TEMP_WELDCONDITION||TEMP_UNWELDCONDITION)&&TEMP_VECCLOSED==TEMP_VECCURRENT) then
					return true, TEMP_DOOR, TEMP_HITPOS
				end
			end
		end
		
		return false
	end
end

function SWEP:ViewModelDrawn()
	if(IsValid(self)&&self!=nil&&self!=NULL&&self:AllValid()) then
		local TEMP_MATRIX = self:GetOwner():GetViewModel():GetBoneMatrix(self:GetOwner():GetViewModel():LookupBone("flame_tip"))
		local TEMP_POS = TEMP_MATRIX:GetTranslation()
		local TEMP_ANG = TEMP_MATRIX:GetAngles()

		TEMP_POS = TEMP_POS+(TEMP_ANG:Forward()*-14.015)+(TEMP_ANG:Up()*-0.9)+(TEMP_ANG:Right()*-3.5)
		
		local TEMP_POS2 = TEMP_POS+(TEMP_ANG:Forward()*-0.02)+(TEMP_ANG:Up()*0.9)+(TEMP_ANG:Right()*0.6)

		TEMP_ANG:RotateAroundAxis( TEMP_ANG:Right(), 90 )
		
		local TEMP_ISDOORWELDED, TEMP_DOOR = self:WeldingConditions()
		local TEMP_DOORWELDEDVAR = "---"
		local TEMP_DOORWELDCOLOR = Color(255,120,120)
		
		if(TEMP_ISDOORWELDED) then
			local TEMP_DOORWELDNUMBER = TEMP_DOOR:GetNWFloat("Welded",0)
			
			if(TEMP_DOORWELDNUMBER>0&&TEMP_DOORWELDNUMBER<1) then
				TEMP_DOORWELDNUMBER = 1
			end
			
			if(TEMP_DOORWELDNUMBER>99&&TEMP_DOORWELDNUMBER<100) then
				TEMP_DOORWELDNUMBER = 99
			end
			
			TEMP_DOORWELDEDVAR = math.Clamp(math.floor(TEMP_DOORWELDNUMBER),0,100).."%"
			
			TEMP_DOORWELDCOLOR = Color(255-TEMP_DOORWELDNUMBER,120+TEMP_DOORWELDNUMBER,120)
		end
		
		local TEMP_WELDEDNUMBER = math.Clamp(math.floor(self:GetNWFloat("Welding",100)),0,100)
		local TEMP_WELDCOLOR = Color(255-(TEMP_WELDEDNUMBER*2.35),0+(TEMP_WELDEDNUMBER*2),0+(TEMP_WELDEDNUMBER*2.55),50)
			
		cam.Start3D2D(TEMP_POS,TEMP_ANG,0.03)
			draw.RoundedBox( 0, -4, 84, 68, -87*(TEMP_WELDEDNUMBER/100), TEMP_WELDCOLOR )
		cam.End3D2D()
		
		cam.Start3D2D(TEMP_POS2,TEMP_ANG,0.036)
			draw.DrawText( "Integrity\n"..TEMP_DOORWELDEDVAR, "Default", 0, 0, TEMP_DOORWELDCOLOR, TEXT_ALIGN_CENTER )
		cam.End3D2D()
	end
end


if(CLIENT) then
	function SWEP:WeldingConditions()
		local TEMP_TR = self:GetOwner():GetEyeTrace()
		local TEMP_DOOR = TEMP_TR.Entity
		local TEMP_STARTPOS = TEMP_TR.StartPos
		local TEMP_HITPOS = TEMP_TR.HitPos
		local TEMP_ENDPOS = TEMP_HITPOS
		local TEMP_HITNORMAL = TEMP_TR.HitNormal

			
		if(TEMP_STARTPOS:Distance(TEMP_HITPOS)<40) then
			if(TEMP_DOOR:GetClass()=="prop_door_rotating") then	
				return true, TEMP_DOOR, TEMP_ENDPOS, TEMP_HITNORMAL
			end
		end
		
		return false
	end
end

function SWEP:Think()
	if(IsValid(self)&&self!=nil&&self!=NULL&&self:AllValid()) then
		
		if(SERVER) then
			if(self:GetNWFloat("Welding",100)<100) then
				self:SetNWFloat("Welding",self:GetNWFloat("Welding",100)+0.2)
			end
		end
		
		if(self:GetNWInt("Attacking",0)!=0) then
			
			local TEMP_ISDOORWELDED, TEMP_DOOR, TEMP_HITPOS, TEMP_HITNORMAL = self:WeldingConditions()
	
	
			if(self:GetNWInt("Attacking",0)==1) then
				if(!self:GetOwner():KeyDown(IN_ATTACK)||!TEMP_ISDOORWELDED||self:GetNWFloat("Welding",0)<=self.WeldingPower) then
					self:SetNWInt("Attacking",0)
					self:SendWeaponAnim(ACT_VM_IDLE)
				else
					if(self.WeldInterval<CurTime()) then
						if(self.SoundInterval<CurTime()) then
							self:EmitSound("KFMod.Welder.Fire")
							self.SoundInterval = CurTime()+0.3
						end
						
						if(SERVER) then
							if(TEMP_DOOR:GetNWFloat("Welded",0)==0) then
								TEMP_DOOR:SetNWFloat("Welded",1)
								TEMP_DOOR:Fire("Lock","",0)
							else
								TEMP_DOOR:SetNWFloat("Welded",math.Clamp(TEMP_DOOR:GetNWFloat("Welded",0)+0.2,0,100))
							end
							
							self:SetNWFloat("Welding",self:GetNWFloat("Welding",100)-self.WeldingPower)
						end
						
						if(CLIENT) then
							local CEffectData = EffectData()
							CEffectData:SetOrigin(TEMP_HITPOS)
							CEffectData:SetNormal(TEMP_HITNORMAL)
							util.Effect( "MetalSpark", CEffectData, false )
						end		
				
						self.WeldInterval = CurTime()+0.02
						self:GetOwner():SetAnimation(PLAYER_ATTACK1)
					end
				end
			else
				if(!self:GetOwner():KeyDown(IN_ATTACK2)||!TEMP_ISDOORWELDED||self:GetNWFloat("Welding",0)<=self.WeldingPower) then
					self:SetNWInt("Attacking",0)
					self:SendWeaponAnim(ACT_VM_IDLE)
				else
					if(self.WeldInterval<CurTime()) then
						if(self.SoundInterval<CurTime()) then
							self:EmitSound("KFMod.Welder.Fire")
							self.SoundInterval = CurTime()+0.3
						end
						if(SERVER) then
							TEMP_DOOR:SetNWFloat("Welded",math.Clamp(TEMP_DOOR:GetNWFloat("Welded",0)-0.3,0,100))
							
							if(TEMP_DOOR:GetNWFloat("Welded",0)==0) then
								TEMP_DOOR:SetNWFloat("Welded",0)
								TEMP_DOOR:Fire("UnLock","",0)
							end
							
							self:SetNWFloat("Welding",self:GetNWFloat("Welding",100)-(self.WeldingPower*0.75))
						end
						
						if(CLIENT) then
							local CEffectData = EffectData()
							CEffectData:SetOrigin(TEMP_HITPOS)
							CEffectData:SetNormal(TEMP_HITNORMAL)
							util.Effect( "MetalSpark", CEffectData, false )
						end		
				
						self.WeldInterval = CurTime()+0.02
						self:GetOwner():SetAnimation(PLAYER_ATTACK1)
					end
				end
			end
			
			
		end
	end
end

function SWEP:Weld(IND)
	if(self:GetNWInt("Attacking",0)==0) then
		self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
		self:SetNWInt("Attacking",IND)
	end
end

function SWEP:PrimaryAttack()
	if(SERVER) then
		if(IsValid(self)&&self!=nil&&self!=NULL&&self:AllValid()&&self:WeldingConditions(1)==true) then
			self:Weld(1)
		end
	end
end


function SWEP:SecondaryAttack()
	if(SERVER) then
		if(IsValid(self)&&self!=nil&&self!=NULL&&self:AllValid()&&self:WeldingConditions(-1)==true) then
			self:Weld(-1)
		end
	end
end

function SWEP:Holster()
	self:SetNWInt("Attacking",0)
	return true
end