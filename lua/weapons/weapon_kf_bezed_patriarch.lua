if(SERVER) then include( "KFPillBaseVarsSV.lua" ) end
include( "KFPillBaseVars.lua" )
AddCSLuaFile( "KFPillBaseVars.lua" )


SWEP.Base			= "kf_zed_pill"
SWEP.Category                   = "Killing Floor Pills"
SWEP.PrintName			= "Patriarch"
SWEP.Author			= "ERROR" 
SWEP.Instructions		= "$M1 - Melee\n$M2 - Minigun\n$R - Rocket\n$W - Radial\n$D - Syringe(must be at 75%HP or lower)"

SWEP.UseHands = false

SWEP.Spawnable = true

SWEP.WorldModel			= "models/Tripwire/Killing Floor/weapons/BeZed/PatriarchShootPos.mdl"

SWEP.ZedHull = Vector(21,21,95)
SWEP.ZedModel = "models/Tripwire/Killing Floor/Zeds/KFPatriarch.mdl"
SWEP.ZedWalkSpeed = 120
SWEP.ZedRunSpeed = 400
SWEP.ZedName = "Patriarch"
SWEP.ZedCanSprint = true

SWEP.ZedChangeStateOnHeadLoss = false

SWEP.Invisible = 0

SWEP.PipeBomb_DamageScale = 1

SWEP.NextThinkTime = -1

SWEP.Healed = true

if(SERVER) then
	SWEP.ZedStunGesture = ACT_SPECIAL_ATTACK2
	
	SWEP.GoreEnabled[HITGROUP_KFHEAD] = false
	SWEP.GoreEnabled[HITGROUP_RIGHTLEG] = false
	SWEP.GoreEnabled[HITGROUP_RIGHTARM] = false

	SWEP.GoreLArm.bodygroup1 = "5,8,9,10"
	SWEP.GoreLArm.model = "models/Tripwire/Killing Floor/Zeds/KFPatriarchGoreGatling.mdl"

	SWEP.GoreLLeg.bodygroup1 = 7
	SWEP.GoreLLeg.model = "models/Tripwire/Killing Floor/Zeds/KFPatriarchGoreLeg.mdl"

	SWEP.PainSoundEnabled = true
	SWEP.PainSound.name = "KFMod.Patriarch.Pain"
	SWEP.PainSound.min = 1
	SWEP.PainSound.max = 12

	SWEP.DieSoundEnabled = true
	SWEP.DieSound.name = "KFMod.Patriarch.Die"
	SWEP.DieSound.min = 1
	SWEP.DieSound.max = 6

	SWEP.MeleeSoundEnabled = true
	SWEP.MeleeSound.name = "KFMod.Patriarch.WarnMelee"
	SWEP.MeleeSound.min = 1
	SWEP.MeleeSound.max = 9

	SWEP.ChasingSoundEnabled = true
	SWEP.ChasingSound.name = "KFMod.Patriarch.Chase"
	SWEP.ChasingSound.min = 1
	SWEP.ChasingSound.max = 11
	
	SWEP.ZedMeleeForce = 230
end

function SWEP:KFPillOnRemove()
	self:StopSound( "KFMod.Patriarch.MinigunShoot" )
end

function SWEP:KFPillInit()
	self:SetNWFloat("Heals",3)
end

function SWEP:KFPillSprintEvent()
	if(self.Invisible>1) then
		if(self.Invisible<10) then
			self:GetOwner():SetMaterial("models/Tripwire/Killing Floor/Zeds/siren/Siren_scream",true)
		end
		
		self.Invisible = self.Invisible-0.25
		
		if(self.Invisible==1) then
			self:GetOwner():SetMaterial("models/Tripwire/Killing Floor/Zeds/invisibility",true)
			self:GetOwner():RemoveAllDecals()
			self:GetOwner():DrawShadow(false)
		end
	end
	
	if(self.ZedPlayingAnimation==false) then
		if(self.Invisible==0) then
			self.Invisible = 16
		end
	else
		if(self.Invisible>0) then
			self.Invisible = 0
			self:GetOwner():DrawShadow(true)
			self:GetOwner():SetMaterial("",true)
		end
	end
end

function SWEP:KFPillSprintEventExit()
	self.Invisible = 0
	self:GetOwner():DrawShadow(true)
	self:GetOwner():SetMaterial("",true)
end

function SWEP:KFPillOwnerBecomeZedEvent()
	local TEMP_IntroCvar = GetConVar("kf_npc_patriarch_intro"):GetInt()
	
	if(TEMP_IntroCvar>0) then
		self:KFPillPlayGesture(ACT_RELOAD,2)
				
		self:KFPillPlayVoiceRandom(100,"KFMod.Patriarch.Awake",1,7)
		
		timer.Create("BeZedTimer_StartAttack"..tostring(self:GetOwner()),3.55,1,function()
			if(KFPillAllValid(self)) then
				self:KFPillPlayVoiceRandom(100,"KFMod.Patriarch.Scream",1,6)
			end
		end)
	end
end

function SWEP:KFPillAddMeleeAttacks()
	local TEMP_MeleeHitTable = {}
	
	for S=1,12 do
		TEMP_MeleeHitTable[S] = "KFMod.ClawHit"..S
	end
	
	local TEMP_MeleeMissTable = {}
	for S=1,4 do
		TEMP_MeleeMissTable[S] = "KFMod.LightSwing"..S
	end
						
	local TEMP_MeleeTable = self:KFPillCreateMeleeTable()
	
	TEMP_MeleeTable.damage[1] = 43
	TEMP_MeleeTable.damagetype[1] = bit.bor(DMG_SLASH, DMG_CLUB)
	TEMP_MeleeTable.distance[1] = 50
	TEMP_MeleeTable.radius[1] = 40
	TEMP_MeleeTable.time[1] = 0.93
	TEMP_MeleeTable.bone[1] = "Rpalm_MedAttachment"
	self:KFPillSetMeleeParamsGesture(1,ACT_GMOD_GESTURE_MELEE_SHOVE_1HAND,1, TEMP_MeleeTable,TEMP_MeleeHitTable,TEMP_MeleeMissTable)

	
	
	local TEMP_MeleeMissTable = {}
	TEMP_MeleeMissTable[1] = ""
	
	TEMP_MeleeTable.damage[1] = 12
	TEMP_MeleeTable.damagetype[1] = bit.bor(DMG_SLASH, DMG_CLUB)
	TEMP_MeleeTable.distance[1] = 40
	TEMP_MeleeTable.radius[1] = 30
	TEMP_MeleeTable.time[1] = 0.95
	TEMP_MeleeTable.bone[1] = "CHR_TentMain_Mouthspike2"
	TEMP_MeleeTable.damage[2] = 16
	TEMP_MeleeTable.damagetype[2] = bit.bor(DMG_SLASH, DMG_CLUB)
	TEMP_MeleeTable.distance[2] = 50
	TEMP_MeleeTable.radius[2] = 30
	TEMP_MeleeTable.time[2] = 1.05
	TEMP_MeleeTable.bone[2] = "CHR_TentMain_Mouthspike2"
	TEMP_MeleeTable.damage[3] = 19
	TEMP_MeleeTable.damagetype[3] = bit.bor(DMG_SLASH, DMG_CLUB)
	TEMP_MeleeTable.distance[3] = 60
	TEMP_MeleeTable.radius[3] = 30
	TEMP_MeleeTable.time[3] = 1.2
	TEMP_MeleeTable.bone[3] = "CHR_TentMain_Mouthspike2"
	self:KFPillSetMeleeParamsGesture(2,ACT_GESTURE_MELEE_ATTACK1,3, TEMP_MeleeTable,TEMP_MeleeHitTable,TEMP_MeleeMissTable)
	
	
	
	local TEMP_MeleeHitTable = {}
	for S=1,4 do
		TEMP_MeleeHitTable[S] = "KFMod.StrongHit"..S
	end
	
	local TEMP_MeleeMissTable = {}
	for S=1,4 do
		TEMP_MeleeMissTable[S] = "KFMod.HeavySwing"..S
	end
	
	TEMP_MeleeTable.damage[1] = 57
	TEMP_MeleeTable.damagetype[1] = DMG_CLUB
	TEMP_MeleeTable.distance[1] = 52
	TEMP_MeleeTable.radius[1] = 45
	TEMP_MeleeTable.time[1] = 0.91
	TEMP_MeleeTable.bone[1] = "Gun_Barrel"
	self:KFPillSetMeleeParamsGesture(3,ACT_GMOD_GESTURE_MELEE_SHOVE_2HAND,1, TEMP_MeleeTable,TEMP_MeleeHitTable,TEMP_MeleeMissTable)
end

function SWEP:KFPillFifthAttack()
	local TEMP_MeleeHitTable = {}
	for S=1,4 do
		TEMP_MeleeHitTable[S] = "KFMod.StrongHit"..S
	end
	
	local TEMP_MeleeMissTable = {}
	for S=1,4 do
		TEMP_MeleeMissTable[S] = "KFMod.HeavySwing"..S
	end
	
	local TEMP_MeleeTable = self:KFPillCreateMeleeTable()
	local TEMP_RadialRadius = 360
	
	TEMP_MeleeTable.damage[1] = 43
	TEMP_MeleeTable.damagetype[1] = bit.bor(DMG_SLASH, DMG_CLUB)
	TEMP_MeleeTable.distance[1] = 105
	TEMP_MeleeTable.radius[1] = TEMP_RadialRadius
	TEMP_MeleeTable.time[1] = 0.8
	TEMP_MeleeTable.bone[1] = "Rpalm_MedAttachment"
	TEMP_MeleeTable.damage[2] = 57
	TEMP_MeleeTable.damagetype[2] = DMG_CLUB
	TEMP_MeleeTable.distance[2] = 120
	TEMP_MeleeTable.radius[2] = TEMP_RadialRadius
	TEMP_MeleeTable.time[2] = 1.0
	TEMP_MeleeTable.bone[2] = "Gun_Barrel"
	TEMP_MeleeTable.damage[3] = 57
	TEMP_MeleeTable.damagetype[3] = DMG_CLUB
	TEMP_MeleeTable.distance[3] = 120
	TEMP_MeleeTable.radius[3] = TEMP_RadialRadius
	TEMP_MeleeTable.time[3] = 1.5
	TEMP_MeleeTable.bone[3] = "Gun_Barrel"
	TEMP_MeleeTable.damage[4] = 43
	TEMP_MeleeTable.damagetype[4] = bit.bor(DMG_SLASH, DMG_CLUB)
	TEMP_MeleeTable.distance[4] = 105
	TEMP_MeleeTable.radius[4] = TEMP_RadialRadius
	TEMP_MeleeTable.time[4] = 1.7
	TEMP_MeleeTable.bone[4] = "Rpalm_MedAttachment"
	self:KFPillSetMeleeParamsGesture(4,ACT_MELEE_ATTACK2,4, TEMP_MeleeTable,TEMP_MeleeHitTable,TEMP_MeleeMissTable,1)
	
	self:KFPillPlayMeleeAttack(4,true)
	
	self:KFPillStopPreviousSound()
	self:KFPillPlayVoiceRandom(100,"KFMod.Patriarch.WarnRadial",1,2)
	
	timer.Create("BeZedTimer_StartAttack"..tostring(self),2.5,1,function()
		if(KFPillAllValid(self)) then
			self:KFPillPlayVoiceRandom(100,"KFMod.Patriarch.RadialEnd",1,3)
		end
	end)
end

function SWEP:KFPillThirdAttack()
	self:KFPillPlayVoiceRandom(100,"KFMod.Patriarch.WarnRocket",1,2)

	sound.Play( "KFMod.Patriarch.RocketLoad", self:GetOwner():GetPos() )
	
	self:KFPillPlayGesture(ACT_MP_ATTACK_STAND_GRENADE,1,nil,nil)
	
	timer.Create("BeZedTimer_StartAttack"..tostring(self),2.5,1,function()
		if(KFPillAllValid(self)) then
			local TEMP_RocketSpeed = 2450
			
			local TEMP_WeaponPos = self:GetOwner():GetAttachment( self:GetOwner():LookupAttachment("Rocketshoot1") )
				
				
			local TEMP_Rocket = ents.Create("ent_patriarchrocket")
			TEMP_Rocket:SetPos(TEMP_WeaponPos.Pos)
			TEMP_Rocket:SetAngles(self:GetOwner():GetForward():Angle())
			TEMP_Rocket:Spawn()
			TEMP_Rocket:SetOwner(self:GetOwner())
				
			self:GetOwner():SetBodygroup(8,1)
				
			local TEMP_EPOS = self:GetOwner():GetEyeTraceNoCursor().HitPos
			
			TEMP_Rocket:SetAngles((TEMP_EPOS-TEMP_Rocket:GetPos()):Angle())
			
			local TEMP_GrenPhys = TEMP_Rocket:GetPhysicsObject()
			TEMP_GrenPhys:EnableGravity(false)
			TEMP_GrenPhys:SetVelocity(((TEMP_EPOS-TEMP_Rocket:GetPos()):GetNormalized()+
			(Vector(math.random(-10,10),math.random(-10,10),math.random(-10,10))/1000))
			*TEMP_RocketSpeed)
			
			sound.Play( "KFMod.RocketShoot", self:GetPos() )
		end
	end)
end

function SWEP:KFPillSecondaryAttack()
	self:KFPillPlayVoiceRandom(100,"KFMod.Patriarch.WarnMinigun",1,2)

	sound.Play( "KFMod.Patriarch.MinigunLoad",self:GetOwner():GetPos() )
	self:KFPillPlayGesture(ACT_ARM,1,nil,nil,true)

	local TEMP_MinShoots = math.random(10,15)

	timer.Create("KFBeZedTimer_StartAttack"..tostring(self),1.5,1,function()
		if(KFPillAllValid(self)) then
			self:KFPillPlayGesture(ACT_GESTURE_RANGE_ATTACK1,1,nil,nil,true)
		
			self:EmitSound( "KFMod.Patriarch.MinigunShoot" )	
			
			local TEMP_ShootInterval = 0.05
			local TEMP_BRadius = 2
			local TEMP_BSlowSDownEffect = 4
			local TEMP_BDamage = 4

			timer.Create("KFBeZed_DamageAttack"..tostring(self).."1",TEMP_ShootInterval,0,function()
				if(KFPillAllValid(self)) then
					local TEMP_EPOS = self:GetOwner():GetEyeTraceNoCursor().HitPos
					
					local TEMP_WeaponPos = self:GetOwner():GetAttachment( self:GetOwner():LookupAttachment("Minigunshoot") )
					local TEMP_ShootingPos = TEMP_WeaponPos.Pos
					
					local TEMP_BTr = util.TraceLine( {
						start = Vector(self:GetOwner():GetPos().x,self:GetOwner():GetPos().y,TEMP_WeaponPos.Pos.z),
						endpos = TEMP_WeaponPos.Pos,
						filter = { self:GetOwner(), self}
					} )
					
					if(TEMP_BTr.Hit) then
						TEMP_ShootingPos = Vector(self:GetOwner():GetPos().x,self:GetOwner():GetPos().y,TEMP_WeaponPos.Pos.z)
					end
					
					
					bullet = {}
					bullet.Attacker=self:GetOwner()
					bullet.Damage=TEMP_BDamage
					bullet.Dir=(TEMP_EPOS-TEMP_ShootingPos):GetNormalized()
					bullet.Spread=Vector(0.09,0.09,0.09)
					bullet.Tracer=1	
					bullet.Force=2
					bullet.HullSize = TEMP_BRadius
					bullet.Num = 1
					bullet.TracerName = "Tracer"
					bullet.Src = TEMP_ShootingPos
					bullet.Callback = function(attacker,tr,dmg)
						if(tr.Entity:IsPlayer()) then
							tr.Entity:SetVelocity((-tr.Entity:GetVelocity()+
							Vector(0,0,tr.Entity:GetVelocity().z))/TEMP_BSlowSDownEffect)
						end
					end
					self:FireBullets(bullet)
					TEMP_MinShoots = TEMP_MinShoots-1
					
					local TEMP_CEffectData = EffectData()
					TEMP_CEffectData:SetOrigin(TEMP_WeaponPos.Pos)
					TEMP_CEffectData:SetColor(0)
					TEMP_CEffectData:SetEntity(self)
					TEMP_CEffectData:SetAngles(TEMP_WeaponPos.Ang)
					util.Effect( "MuzzleFlash", TEMP_CEffectData, false )
					
					if((TEMP_MinShoots<1&&!self:GetOwner():KeyDown(IN_ATTACK2))||TEMP_MinShoots<-70) then
						timer.Remove("KFBeZed_DamageAttack"..tostring(self).."1")
						self:KFPillPlayGesture(ACT_DISARM,1)
						
						self:GetOwner():StopSound( "KFMod.Patriarch.MinigunShoot" )
						sound.Play( "KFMod.Patriarch.MinigunUnload", self:GetOwner():GetPos() )
					end
				end
			end)
		end
	end)
end

function SWEP:KFPillFourthAttack()
	if(self:GetNWFloat("Heals",3)>0&&self:GetOwner():Health()<self:GetOwner():GetMaxHealth()*0.75) then
		self:KFPillPlayGesture(ACT_SPECIAL_ATTACK1,1)
			
		timer.Create("KFBeZed_StartAttack"..tostring(self),0.7,1,function()
			if(KFPillAllValid(self)) then
				self:GetOwner():SetBodygroup( self:GetNWFloat("Heals",3), 1 )
				self:GetOwner():SetBodygroup( 4, 1 )
		
				timer.Create("KFBeZed_DamageAttack"..tostring(self).."1",1.6,1,function()
					if(KFPillAllValid(self)) then
						self:GetOwner():SetHealth(math.min(self:GetOwner():Health()+(self:GetOwner():GetMaxHealth()/3),self:GetOwner():GetMaxHealth()))
						self:SetNWFloat("Heals",self:GetNWFloat("Heals",3)-1)
						
						self:KFPillStopPreviousSound()
						self:KFPillPlayVoiceRandom(100,"KFMod.Patriarch.Scream",1,6)
						
						
					end
				end)
				
				timer.Create("KFBeZed_DamageAttack"..tostring(self).."2",3.4,1,function()
					if(KFPillAllValid(self)) then
						self:KFPillStopPreviousSound()
						self:KFPillPlayVoiceRandom(100,"KFMod.Patriarch.Heal",1,4)
					end
				end)
			
				timer.Create("KFBeZed_DamageAttack"..tostring(self).."3",3.85,1,function()
					if(KFPillAllValid(self)) then
						self:GetOwner():SetBodygroup( 4, 0 )
						
						local TEMP_SYR = self:GetOwner():GetAttachment(self:GetOwner():LookupAttachment("anim_attachment_rh"))
		
						local TEMP_Syringe = ents.Create("prop_physics")
						TEMP_Syringe:SetModel("models/Tripwire/Killing Floor/Zeds/KFPatriarchSyringe.mdl")
						TEMP_Syringe:SetPos(TEMP_SYR.Pos)
						TEMP_Syringe:SetAngles(TEMP_SYR.Ang)
						TEMP_Syringe:Spawn()
						TEMP_Syringe:SetOwner(self:GetOwner())
						TEMP_Syringe:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
						
						local TEMP_SyrPhys = TEMP_Syringe:GetPhysicsObject()
						TEMP_SyrPhys:SetVelocity(-self:GetOwner():GetForward()*100)
						
						TEMP_Syringe:Fire("kill","",3)
						
						self.Healed = true
					end
				end)
			end
		end)
	end
end

function SWEP:KFPillThink()
	if(self.NextThinkTime<CurTime()) then
		self.NextThinkTime = CurTime()+0.1
		
		if(self.PipeBomb_DamageScale<1) then
			self.PipeBomb_DamageScale = math.min(self.PipeBomb_DamageScale+0.033,1.0)
		end
	end
end

function SWEP:KFPillSelectMeleeAttack()
	return math.random(1,3)
end

function SWEP:KFPillDamageTake(dmginfo,dmg,mul,RealAttacker,RealInflictor)
	if(RealAttacker!=self) then
		if(RealInflictor:GetClass()=="ent_planted_pipebomb"&&dmginfo:IsExplosionDamage()) then
			if(self.PipeBomb_DamageScale>0.5125) then
				self.PipeBomb_DamageScale = self.PipeBomb_DamageScale-0.0375
				mul = mul*(self.PipeBomb_DamageScale+0.0375)
			else
				mul = 0
			end
		end
	end
	
	if(self:GetOwner():Health()-(dmginfo:GetDamage()*mul)<self:GetOwner():GetMaxHealth()*(0.1+(self:GetNWFloat("Heals",0)*0.2))&&self:GetNWFloat("Heals",0)>0&&self.Healed==true) then
		timer.Remove("BeZedTimer_StartAttack"..tostring(self))
		timer.Remove("KFBeZed_DamageAttack"..tostring(self).."1")
		timer.Remove("KFBeZed_DamageAttack"..tostring(self).."2")
		
		self:KFPillStun(self.ZedStunGesture)
		self.Healed = false
		self:StopSound( "KFMod.Patriarch.MinigunShoot" )
		
		self:KFPillStopPreviousSound()
		self:KFPillPlayVoiceRandom(90,"KFMod.Patriarch.KnockDown",1,4)
	end
	
	return mul
end

if(CLIENT) then
	function SWEP:DrawHUD()
		if(KFPillAllValid(self)) then
			local W,H = ScrW(), ScrH()
			
			draw.RoundedBox( 6, W-200, H-80, 170, 55, Color( 0, 0, 0, 75 ) )
			
			surface.SetFont("HudHintTextLarge")
			surface.SetTextColor( 223, 244, 66, 205 )
			
			surface.SetTextPos(W-180,H-50)
			surface.DrawText( "SYRINGE" )
			
			surface.SetFont("HuskGunChargeFont")
			surface.SetTextPos(W-100,H-75)
			surface.DrawText( math.floor(self:GetNWFloat("Heals",3)) )
			
			
			local XY = self:GetOwner():GetEyeTraceNoCursor().HitPos:ToScreen()
			
			
			surface.DrawCircle( XY.x, XY.y, 7, 255, 0, 0, 18 )
			surface.DrawCircle( XY.x, XY.y, 6, 255, 0, 0, 15 )
			surface.DrawCircle( XY.x, XY.y, 5, 0, 255, 0, 12 )
			surface.DrawCircle( XY.x, XY.y, 4, 0, 255, 0, 9 )
			surface.DrawCircle( XY.x, XY.y, 3, 0, 0, 255, 6 )
			surface.DrawCircle( XY.x, XY.y, 2, 0, 0, 255, 3 )
		end
	end
end