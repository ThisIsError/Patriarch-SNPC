AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include('shared.lua')
include( "KFNPCBaseVars.lua" )

ENT.GoreEnabled[HITGROUP_KFHEAD] = false
ENT.GoreEnabled[HITGROUP_RIGHTLEG] = false
ENT.GoreEnabled[HITGROUP_RIGHTARM] = false

ENT.GoreLArm.bodygroup1 = "5,8,9,10"
ENT.GoreLArm.model = "models/Tripwire/Killing Floor/Zeds/KFPatriarchGoreGatling.mdl"

ENT.GoreLLeg.bodygroup1 = 7
ENT.GoreLLeg.model = "models/Tripwire/Killing Floor/Zeds/KFPatriarchGoreLeg.mdl"

ENT.PainSoundEnabled = true
ENT.PainSound.name = "KFMod.Patriarch.Pain"
ENT.PainSound.min = 1
ENT.PainSound.max = 12

ENT.DieSoundEnabled = true
ENT.DieSound.name = "KFMod.Patriarch.Die"
ENT.DieSound.min = 1
ENT.DieSound.max = 6

ENT.MeleeSoundEnabled = true
ENT.MeleeSound.name = "KFMod.Patriarch.WarnMelee"
ENT.MeleeSound.min = 1
ENT.MeleeSound.max = 9

ENT.IdlingSoundEnabled = true
ENT.IdlingSound.name = "KFMod.Patriarch.Idle"
ENT.IdlingSound.min = 1
ENT.IdlingSound.max = 7

ENT.ChasingSoundEnabled = true
ENT.ChasingSound.name = "KFMod.Patriarch.Chase"
ENT.ChasingSound.min = 1
ENT.ChasingSound.max = 11


ENT.AutoChangeActivityWhenHeadless = false
ENT.AutoChangeActivityWhenOnFire = false


ENT.InAttack = 0
ENT.RunToHeal = 0
ENT.Heals = 3
ENT.CanShoot = 0
ENT.Invisible = 0
ENT.Rage = 30
ENT.PipeBomb_DamageScale = 1.0
ENT.PrevEnemyPos = Vector(0,0,0)

ENT.MeleeFlySpeed = 250

ENT.Gun = nil
ENT.Camera = nil

ENT.EscapeSchedule = SCHED_RUN_RANDOM

ENT.MeleeAttackDistance = 30

ENT.NearestEnemyFindDistance = 45

ENT.EventModel = 0
ENT.EventRocket = 0

ENT.MustDoRadial = false

function ENT:Initialize()
	local TEMP_PCDate = string.Replace(util.DateStamp(),"-"," ")
	local TEMP_PCDateTBL = string.Explode(" ", TEMP_PCDate)
	
	self.MustDoRadial = false
	
	self.Model = "models/Tripwire/Killing Floor/Zeds/KFPatriarch.mdl"
	self.EventModel = 0
	self.PainSoundEnabled = true
	self.PainSound.name = "KFMod.Patriarch.Pain"
	self.PainSound.min = 1
	self.PainSound.max = 12

	self.DieSoundEnabled = true
	self.DieSound.name = "KFMod.Patriarch.Die"
	self.DieSound.min = 1
	self.DieSound.max = 6

	self.MeleeSoundEnabled = true
	self.MeleeSound.name = "KFMod.Patriarch.WarnMelee"
	self.MeleeSound.min = 1
	self.MeleeSound.max = 9
	
	self.IdlingSoundEnabled = true
	self.IdlingSound.name = "KFMod.Patriarch.Idle"
	self.IdlingSound.min = 1
	self.IdlingSound.max = 7

	self.ChasingSoundEnabled = true
	self.ChasingSound.name = "KFMod.Patriarch.Chase"
	self.ChasingSound.min = 1
	self.ChasingSound.max = 11
	
	self.GoreLLeg.model = "models/Tripwire/Killing Floor/Zeds/KFPatriarchGoreLeg.mdl"
	
	self.EventRocket = 0
	
	local TEMP_CanBeSanta = GetConVar("kf_npc_patriarch_santa"):GetInt()
	
	
	if((TEMP_CanBeSanta==1&&((tonumber(TEMP_PCDateTBL[2])==12&&tonumber(TEMP_PCDateTBL[3])>=17)||
	(tonumber(TEMP_PCDateTBL[2])==1&&tonumber(TEMP_PCDateTBL[3])<=14)))||TEMP_CanBeSanta==2) then
		if(TEMP_PCDateTBL[3]==31&&tonumber(TEMP_PCDateTBL[2])==12) then
			self.EventRocket = 1
		end
		
		self.Model = "models/Tripwire/Killing Floor/Zeds/KFPatriarchSanta.mdl"
		self.EventModel = 1
		
		self.PainSoundEnabled = true
		self.PainSound.name = "KFMod.PatriarchSanta.Pain"
		self.PainSound.min = 1
		self.PainSound.max = 12

		self.DieSoundEnabled = true
		self.DieSound.name = "KFMod.PatriarchSanta.Die"
		self.DieSound.min = 1
		self.DieSound.max = 6

		self.MeleeSoundEnabled = true
		self.MeleeSound.name = "KFMod.PatriarchSanta.WarnMelee"
		self.MeleeSound.min = 1
		self.MeleeSound.max = 9
		
		self.IdlingSoundEnabled = true
		self.IdlingSound.name = "KFMod.PatriarchSanta.Idle"
		self.IdlingSound.min = 1
		self.IdlingSound.max = 7

		self.ChasingSoundEnabled = true
		self.ChasingSound.name = "KFMod.PatriarchSanta.Chase"
		self.ChasingSound.min = 1
		self.ChasingSound.max = 24
		
		self.GoreLLeg.model = "models/Tripwire/Killing Floor/Zeds/KFPatriarchSantaGoreLeg.mdl"
	end
	
	self:KFNPCInit(Vector(-21,-21,95),MOVETYPE_STEP,{CAP_AIM_GUN},GetConVar("kf_npc_patriarch_hp"):GetInt(),"*0.75")
	
	local TEMP_MeleeHitTable = {}
	for S=1,12 do
		TEMP_MeleeHitTable[S] = "KFMod.ClawHit"..S
	end
	
	local TEMP_MeleeMissTable = {}
	for S=1,4 do
		TEMP_MeleeMissTable[S] = "KFMod.LightSwing"..S
	end
						
	local TEMP_MeleeTable = self:KFNPCCreateMeleeTable()
	
	TEMP_MeleeTable.damage[1] = 78
	TEMP_MeleeTable.damagetype[1] = bit.bor(DMG_SLASH, DMG_CLUB)
	TEMP_MeleeTable.distance[1] = 50
	TEMP_MeleeTable.radius[1] = 40
	TEMP_MeleeTable.time[1] = 0.93
	TEMP_MeleeTable.bone[1] = "Rpalm_MedAttachment"
	self:KFNPCSetMeleeParamsGesture(1,"S_Melee1",1, TEMP_MeleeTable,TEMP_MeleeHitTable,TEMP_MeleeMissTable)

	
	
	local TEMP_MeleeMissTable = {}
	TEMP_MeleeMissTable[1] = ""
	
	TEMP_MeleeTable.damage[1] = 11
	TEMP_MeleeTable.damagetype[1] = bit.bor(DMG_SLASH, DMG_CLUB)
	TEMP_MeleeTable.distance[1] = 40
	TEMP_MeleeTable.radius[1] = 30
	TEMP_MeleeTable.time[1] = 0.95
	TEMP_MeleeTable.bone[1] = "CHR_TentMain_Mouthspike2"
	TEMP_MeleeTable.damage[2] = 24
	TEMP_MeleeTable.damagetype[2] = bit.bor(DMG_SLASH, DMG_CLUB)
	TEMP_MeleeTable.distance[2] = 50
	TEMP_MeleeTable.radius[2] = 30
	TEMP_MeleeTable.time[2] = 1.05
	TEMP_MeleeTable.bone[2] = "CHR_TentMain_Mouthspike2"
	TEMP_MeleeTable.damage[3] = 20
	TEMP_MeleeTable.damagetype[3] = bit.bor(DMG_SLASH, DMG_CLUB)
	TEMP_MeleeTable.distance[3] = 60
	TEMP_MeleeTable.radius[3] = 30
	TEMP_MeleeTable.time[3] = 1.2
	TEMP_MeleeTable.bone[3] = "CHR_TentMain_Mouthspike2"
	self:KFNPCSetMeleeParamsGesture(2,"S_Melee3",3, TEMP_MeleeTable,TEMP_MeleeHitTable,TEMP_MeleeMissTable)
	
	
	
	local TEMP_MeleeHitTable = {}
	for S=1,4 do
		TEMP_MeleeHitTable[S] = "KFMod.StrongHit"..S
	end
	
	local TEMP_MeleeMissTable = {}
	for S=1,4 do
		TEMP_MeleeMissTable[S] = "KFMod.HeavySwing"..S
	end
	
	TEMP_MeleeTable.damage[1] = 92
	TEMP_MeleeTable.damagetype[1] = DMG_CLUB
	TEMP_MeleeTable.distance[1] = 52
	TEMP_MeleeTable.radius[1] = 45
	TEMP_MeleeTable.time[1] = 0.91
	TEMP_MeleeTable.bone[1] = "Gun_Barrel"
	self:KFNPCSetMeleeParamsGesture(3,"S_Melee2",1, TEMP_MeleeTable,TEMP_MeleeHitTable,TEMP_MeleeMissTable)
	
	local TEMP_MeleeHitTable = {}
	for S=1,4 do
		TEMP_MeleeHitTable[S] = "KFMod.StrongHit"..S
	end
	
	local TEMP_MeleeMissTable = {}
	for S=1,4 do
		TEMP_MeleeMissTable[S] = "KFMod.HeavySwing"..S
	end
	
	local TEMP_MeleeTable = self:KFNPCCreateMeleeTable()
	
	TEMP_MeleeTable.damage[1] = 78
	TEMP_MeleeTable.damagetype[1] = bit.bor(DMG_SLASH, DMG_CLUB)
	TEMP_MeleeTable.distance[1] = 55
	TEMP_MeleeTable.radius[1] = 360
	TEMP_MeleeTable.time[1] = 0.8
	TEMP_MeleeTable.bone[1] = "Rpalm_MedAttachment"
	TEMP_MeleeTable.damage[2] = 92
	TEMP_MeleeTable.damagetype[2] = DMG_CLUB
	TEMP_MeleeTable.distance[2] = 70
	TEMP_MeleeTable.radius[2] = 360
	TEMP_MeleeTable.time[2] = 1.0
	TEMP_MeleeTable.bone[2] = "Gun_Barrel"
	TEMP_MeleeTable.damage[3] = 92
	TEMP_MeleeTable.damagetype[3] = DMG_CLUB
	TEMP_MeleeTable.distance[3] = 70
	TEMP_MeleeTable.radius[3] = 360
	TEMP_MeleeTable.time[3] = 1.5
	TEMP_MeleeTable.bone[3] = "Gun_Barrel"
	TEMP_MeleeTable.damage[4] = 78
	TEMP_MeleeTable.damagetype[4] = bit.bor(DMG_SLASH, DMG_CLUB)
	TEMP_MeleeTable.distance[4] = 55
	TEMP_MeleeTable.radius[4] = 360
	TEMP_MeleeTable.time[4] = 1.7
	TEMP_MeleeTable.bone[4] = "Rpalm_MedAttachment"
	self:KFNPCSetMeleeParams(4,"S_MeleeR",4, TEMP_MeleeTable,TEMP_MeleeHitTable,TEMP_MeleeMissTable)

	
	
	self.Gun = ents.Create("ent_patriarchgun")
						
	self.Gun:SetPos(self:GetPos())
	self.Gun:SetAngles(self:GetAngles())
	self.Gun:Spawn()
	
	self.Gun:SetOwner(self)
	self.Gun:SetParent(self)

	local TEMP_IntroCvar = GetConVar("kf_npc_patriarch_intro"):GetInt()
	
	if(TEMP_IntroCvar>0) then
		self.CanShoot = 0
		timer.Create("StartAttack"..tostring(self),0.1,1,function()
			if(IsValid(self)&&self!=nil&&self!=NULL) then
				self:KFNPCStopAllTimers()
				self.InAttack = -1
				self:KFNPCPlayAnimation("S_Spawn",0)
				
				self:KFNPCStopPreviousSound()
				
				if(self.EventModel==1) then
					self:KFNPCPlaySoundRandom(100,"KFMod.PatriarchSanta.Awake",1,8)
				else
					self:KFNPCPlaySoundRandom(100,"KFMod.Patriarch.Awake",1,7)
				end
				
				if(TEMP_IntroCvar>1&&#ents.FindByClass("npc_kfmod_patriarch")==1) then
				
					local TEMP_CamPos = self:GetPos()+(self:GetForward()*100)+Vector(0,0,100)
					
					local TEMP_CamTR = util.TraceHull( {
						start = self:GetPos()+self:OBBCenter(),
						endpos = TEMP_CamPos,
						filter = self,
						mins = Vector( -6, -6 -6 ),
						maxs = Vector( 6, 6, 6 ),
						mask = MASK_ALL
					} )
					
					if(TEMP_CamTR.Fraction>0.7) then
						self.Camera = ents.Create("prop_physics")
							
						self.Camera:SetModel("models/props_c17/oildrum001.mdl")
						self.Camera:SetColor(255,255,255,0)
						self.Camera:SetPos(TEMP_CamTR.HitPos)
						self.Camera:SetAngles(self:GetAngles()+Angle(30,180,0))
						self.Camera:Spawn()
						self.Camera:Activate()
						self.Camera:SetMoveType(MOVETYPE_NONE)
						self.Camera:SetSolid(SOLID_NONE)
						self.Camera:PhysicsInit(SOLID_NONE)
						
						for _,v in pairs(player.GetAll()) do
							v:Freeze(true)
							v:SetViewEntity(self.Camera)
						end
					end
				end
				
				timer.Create("Attack"..tostring(self),3.55,1,function()
					if(IsValid(self)&&self!=nil&&self!=NULL) then
						self:KFNPCStopPreviousSound()
				
						if(self.EventModel==1) then
							self:KFNPCPlaySoundRandom(100,"KFMod.PatriarchSanta.Scream",1,6)
						else
							self:KFNPCPlaySoundRandom(100,"KFMod.Patriarch.Scream",1,6)
						end
					end
				end)
						
				timer.Create("EndAttack"..tostring(self),5.8,1,function()
					if(IsValid(self)&&self!=nil&&self!=NULL) then
						self.CanShoot = 1
						
						if(TEMP_IntroCvar>1&&IsValid(self.Camera)&&self.Camera!=nil&&self.Camera!=NULL) then
							self.Camera:Remove()
							for _,v in pairs(player.GetAll()) do
								v:Freeze(false)
								v:SetViewEntity(v)
							end
						end
						self:KFNPCClearAnimation()
					end
				end)
			end
		end)
	else
		timer.Simple(0.25,function()
			self.CanShoot = 1
		end)
	end
end

function ENT:KFNPCSelectMeleeAttack() 
	if(self.MustDoRadial==true) then
		self.MustDoRadial = false
		return 4
	end
	
	return math.random(1,3)
end



function ENT:KFNPCOnEnemyCountFinded(COUNT)
	if(((COUNT>2&&self.RunToHeal==0)||(COUNT>3&&self.RunToHeal==1))) then
		if(self.PlayingAnimation==false) then
			self.MustDoRadial = false
			
			self:KFNPCStopAllTimers()
			self:KFNPCMeleePlay(4)
		else
			self.MustDoRadial = true
		end
	else
		self.MustDoRadial = false
	end
end

function ENT:KFNPCMeleeAttackEvent()
	if((self.Animation=="S_Melee1"||self.Animation=="S_Melee2"||self.Animation=="S_Melee3")&&self.RunToHeal==1) then
		self:SetSchedule(SCHED_CHASE_ENEMY)
	end
	
	if(self.Animation=="S_MeleeR") then
		self:KFNPCStopPreviousSound()
		
		if(self.EventModel==1) then
			self:KFNPCPlaySoundRandom(100,"KFMod.PatriarchSanta.WarnRadial",1,2)
		else
			self:KFNPCPlaySoundRandom(100,"KFMod.Patriarch.WarnRadial",1,2)
		end
		
		timer.Create("MidAttack"..tostring(self),2,1,function()
			if(IsValid(self)&&self!=nil&&self!=NULL) then
				self:KFNPCStopPreviousSound()
				if(self.EventModel==1) then
					self:KFNPCPlaySoundRandom(100,"KFMod.PatriarchSanta.RadialEnd",1,5)
				else
					self:KFNPCPlaySoundRandom(100,"KFMod.Patriarch.RadialEnd",1,3)
				end
			end
		end)
	end
end

function ENT:KFNPCMeleeSequenceEnd(ANM)
end

function ENT:KFNPCDamageTake(dmginfo,dmg,mul,RealAttacker,RealInflictor)
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
	
	if(self:Health()-(dmginfo:GetDamage()*mul)<self:GetMaxHealth()*(0.1+(self.Heals*0.2))&&self.RunToHeal==0&&self.Heals>0) then
		self:KFNPCStun(self.StunSequence)
		self.Rage = 50
		
		self:StopSound( "KFMod.Patriarch.MinigunShoot" )
		self.RunToHeal = 1
		
		if(self.NextSoundCanPlayTime<CurTime()) then
			if(self.EventModel==1) then
				self:KFNPCPlaySoundRandom(33,"KFMod.PatriarchSanta.KnockDown",1,7)
			else
				self:KFNPCPlaySoundRandom(33,"KFMod.Patriarch.KnockDown",1,7)
			end
		end
	end

	return mul
end

function ENT:KFNPCThink()
	if(self.PipeBomb_DamageScale<1) then
		self.PipeBomb_DamageScale = math.min(self.PipeBomb_DamageScale+0.033,1.0)
	end
	
	if(!IsValid(self.Gun)||self.Gun==NULL||self.Gun==nil) then
		self:Remove()
	end
	
	if(IsValid(self:GetEnemy())&&self:GetEnemy()!=nil&&self:GetEnemy()!=NULL&&
	((self:GetEnemy():IsPlayer()&&self:GetEnemy():Alive())||!self:GetEnemy():IsPlayer())) then
		if(self.Animation=="S_RangedRocket"&&self:GetEnemy():Visible(self)) then
			local TEMP_EnemyTracer = util.TraceHull( {
				start = self:GetAttachment( self:LookupAttachment("Minigunshoot") ).Pos,
				endpos = self:GetEnemy():GetPos()+self:GetEnemy():OBBCenter(),
				filter = self,
				mins = Vector( -2, -2, -2 ),
				maxs = Vector( 2, 2, 2 ),
				mask = MASK_SHOT
			} )
			
			if(TEMP_EnemyTracer.Entity==self:GetEnemy()) then
				self.PrevEnemyPos = self:GetEnemy():GetPos()
			end
		end
		
		if(self.Animation=="S_RangedMGIdle") then
			local TEMP_Dif = (self:GetEnemy():GetPos()+self:GetEnemy():OBBCenter())-(self:GetPos()+Vector(0,0,30))
			local TEMP_AngP = TEMP_Dif:Angle().Pitch
			local TEMP_AngY = TEMP_Dif:Angle().Yaw-self:GetAngles().Yaw
			local TEMP_AngP = math.NormalizeAngle(TEMP_AngP)*2.1
			
			self:SetPoseParameter("aim_pitch_npc",TEMP_AngP)
			self:SetPoseParameter("aim_yaw",math.Clamp(TEMP_AngY,-30,30))
		end
	end
	
	if(self.RunToHeal==1&&self.PlayingAnimation==false) then
		
		if(self.Rage>0) then
			self.Rage = self.Rage-1
		end
		
		if((!self:GetEnemy()||self:GetEnemy()==nil||self:GetEnemy()==NULL||!self:GetEnemy():Visible(self)||
		(self:GetEnemy():IsPlayer()&&!self:GetEnemy():Alive())||self.Rage==0||
		(self:GetEnemy():GetPos():Distance(self:GetPos())>500&&self.Rage==12))) then
			self.RunToHeal = 2
			
			self:KFNPCStopAllTimers()
			
			self:KFNPCPlayAnimation("S_Heal",0)
			
			timer.Create("StartAttack"..tostring(self),0.7,1,function()
				if(IsValid(self)&&self!=nil&&self!=NULL) then
					self:KFNPCStopAllTimers()
					self:SetBodygroup( self.Heals, 1 )
					self:SetBodygroup( 4, 1 )
			
					timer.Create("Attack"..tostring(self),1.6,1,function()
						if(IsValid(self)&&self!=nil&&self!=NULL) then
							self:SetHealth(self:Health()+(self:GetMaxHealth()/3))
							self.Heals = self.Heals-1
							
							self:KFNPCStopPreviousSound()
							
							if(self.EventModel==1) then
								self:KFNPCPlaySoundRandom(100,"KFMod.PatriarchSanta.Scream",1,6)
							else
								self:KFNPCPlaySoundRandom(100,"KFMod.Patriarch.Scream",1,6)
							end
							
							timer.Create("Attack"..tostring(self),1.8,1,function()
								if(IsValid(self)&&self!=nil&&self!=NULL) then
									self:KFNPCStopPreviousSound()
									
									if(self.EventModel==1) then
										self:KFNPCPlaySoundRandom(100,"KFMod.PatriarchSanta.Heal",1,4)
									else
										self:KFNPCPlaySoundRandom(100,"KFMod.Patriarch.Heal",1,4)
									end
								end
							end)
						end
					end)
				
					timer.Create("MidAttack"..tostring(self),3.85,1,function()
						if(IsValid(self)&&self!=nil&&self!=NULL) then
							self:SetBodygroup( 4, 0 )
							
							local TEMP_SYRPOS, TEMP_SYRANG = self:GetBonePosition(self:LookupBone("Rpalm_MedAttachment"))
			
							local TEMP_Syringe = ents.Create("prop_physics")
							TEMP_Syringe:SetModel("models/Tripwire/Killing Floor/Zeds/KFPatriarchSyringe.mdl")
							TEMP_Syringe:SetPos(TEMP_SYRPOS)
							TEMP_Syringe:SetAngles(TEMP_SYRANG)
							TEMP_Syringe:Spawn()
							TEMP_Syringe:SetOwner(self)
							TEMP_Syringe:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
							
							local TEMP_SyrPhys = TEMP_Syringe:GetPhysicsObject()
							TEMP_SyrPhys:SetVelocity(-self:GetForward()*100)
							
							TEMP_Syringe:Fire("kill","",3)
						end
					end)
				
					timer.Create("EndAttack"..tostring(self),4.5,1,function()
						if(IsValid(self)&&self!=nil&&self!=NULL) then
							self:KFNPCClearAnimation()
							self.RunToHeal = 0
							self.Rage = 28
							self.CanShoot = 1
						end
					end)
				end
			end)
		end
	end
	
	if(!self:GetEnemy()||self:GetEnemy()==nil||self:GetEnemy()==NULL||(self:GetEnemy():IsPlayer()&&!self:GetEnemy():Alive())) then
		self.Rage = 25
	end
	
	if(self.Invisible>1) then
		if(self.Invisible<10) then
			self:SetMaterial("models/Tripwire/Killing Floor/Zeds/siren/Siren_scream",true)
		end
		
		self.Invisible = self.Invisible-1
		
		if(self.Invisible==1) then
			self:SetMaterial("models/Tripwire/Killing Floor/Zeds/invisibility",true)
			self:RemoveAllDecals()
			self:DrawShadow(false)
		end
	end
	
	if(self.PlayingAnimation==false&&(self.Rage<0.1||self.RunToHeal==1)) then
		if(self.Invisible==0) then
			self.Invisible = 16
		end
	else
		if(self.Invisible>0) then
			self.Invisible = 0
			self:DrawShadow(true)
			self:SetMaterial("",true)
			//self:RemoveFlags(FL_NOTARGET)
		end
	end
end

function ENT:SelectSchedule( iNPCState )
	if(!isnumber(self.NextRun)) then
		self.NextRun = 0
	end
	
	if(self.LastPosKnow<CurTime()) then
		if(IsValid(self:GetEnemy())&&self:GetEnemy()!=NULL&&self:GetEnemy()!=nil&&
		(self:GetEnemy():IsNPC()||(self:GetEnemy():IsPlayer()&&self:GetEnemy():Alive()))) then
			if(!self:IsUnreachable(self:GetEnemy())) then
				if(self.CantChaseTargetTimes<10) then
					self.LastUsedPosition = self.LastUsedPosition+1
					
					if(self.LastUsedPosition>4) then
						self.LastUsedPosition = 1
					end
					
					if(self.LastUsedPosition==1) then
						self.LastPosition[1] = self:GetEnemy():GetPos()
					elseif(self.LastUsedPosition==2) then
						self.LastPosition[2] = self:GetEnemy():GetPos()
					elseif(self.LastUsedPosition==3) then
						self.LastPosition[3] = self:GetEnemy():GetPos()
					elseif(self.LastUsedPosition==4) then
						self.LastPosition[4] = self:GetEnemy():GetPos()
					end
				end
			else
				local TEMP_LastPosChoosen = false

				if(self.LastUsedPosition==4) then
					if(self.LastPosition[1]!=nil) then
						self:SetLastPosition(self.LastPosition[2])
						TEMP_LastPosChoosen = true
					elseif(self.LastPosition[2]!=nil) then
						self:SetLastPosition(self.LastPosition[2])
						TEMP_LastPosChoosen = true
					elseif(self.LastPosition!=nil) then
						self:SetLastPosition(self.LastPosition[3])
						TEMP_LastPosChoosen = true
					elseif(self.LastPosition[4]!=nil) then
						self:SetLastPosition(self.LastPosition[4])
						TEMP_LastPosChoosen = true
					end
				end
				
				if(TEMP_LastPosChoosen==false) then
					if(self.LastUsedPosition==3) then
						if(self.LastPosition[4]!=nil) then
							self:SetLastPosition(self.LastPosition[4])
							TEMP_LastPosChoosen = true
						elseif(self.LastPosition[1]!=nil) then
							self:SetLastPosition(self.LastPosition[2])
							TEMP_LastPosChoosen = true
						elseif(self.LastPosition[2]!=nil) then
							self:SetLastPosition(self.LastPosition[2])
							TEMP_LastPosChoosen = true
						elseif(self.LastPosition[3]!=nil) then
							self:SetLastPosition(self.LastPosition[3])
							TEMP_LastPosChoosen = true
						end
					end
					
					if(TEMP_LastPosChoosen==false) then
						if(self.LastUsedPosition==2) then
							if(self.LastPosition[3]!=nil) then
								self:SetLastPosition(self.LastPosition[3])
								TEMP_LastPosChoosen = true
							elseif(self.LastPosition[4]!=nil) then
								self:SetLastPosition(self.LastPosition[4])
								TEMP_LastPosChoosen = true
							elseif(self.LastPosition[1]!=nil) then
								self:SetLastPosition(self.LastPosition[2])
								TEMP_LastPosChoosen = true
							elseif(self.LastPosition[2]!=nil) then
								self:SetLastPosition(self.LastPosition[2])
								TEMP_LastPosChoosen = true
							end
						end
						
						if(TEMP_LastPosChoosen==false) then
							if(self.LastUsedPosition==1) then
								if(self.LastPosition[2]!=nil) then
									self:SetLastPosition(self.LastPosition[2])
									TEMP_LastPosChoosen = true
								elseif(self.LastPosition[3]!=nil) then
									self:SetLastPosition(self.LastPosition[3])
									TEMP_LastPosChoosen = true
								elseif(self.LastPosition[4]!=nil) then
									self:SetLastPosition(self.LastPosition[4])
									TEMP_LastPosChoosen = true
								elseif(self.LastPosition[1]!=nil) then
									self:SetLastPosition(self.LastPosition[2])
									TEMP_LastPosChoosen = true
								end
							end
						end
					end
				end
				
			end
		end
		
		self.LastPosKnow = CurTime()+0.3
	end
		
	if(self.PlayingAnimation==false||self.PlayingGesture==true) then
		if(self.RunToHeal==1) then
			if(self.PlayingGesture==true) then
				if(!self:IsCurrentSchedule(SCHED_CHASE_ENEMY)) then
					self:SetSchedule(SCHED_CHASE_ENEMY)
				end	
			else
				if(self.NextRun<CurTime()) then
					self:SetSchedule(SCHED_RUN_FROM_ENEMY_MOB)
					self.NextRun = CurTime()+0.39
				end
			end
		else
			if(IsValid(self:GetEnemy())&&self:GetEnemy()!=NULL&&self:GetEnemy()!=nil&&
			(self:GetEnemy():IsNPC()||(self:GetEnemy():IsPlayer()&&self:GetEnemy():Alive()))) then
				if(self.CantChaseTargetTimes>10) then
					if((self:GetPos():Distance(self:GetSaveTable().m_vecLastPosition)<250||self.CantChaseReason==1)&&self.CantChaseTargetTimes<20) then
						if(!self:IsCurrentSchedule(SCHED_FORCED_GO_RUN)) then
							self:SetSchedule(SCHED_FORCED_GO_RUN)
						end
					else
						if(!self:IsCurrentSchedule(SCHED_RUN_RANDOM)) then
							self:SetSchedule(SCHED_RUN_RANDOM)
						end
					end
				else
					local TEMP_DistanceForMelee = self:KFNPCEnemyInMeleeRange(self:GetEnemy(),0,self.MeleeAttackDistance-5)
					
					if(TEMP_DistanceForMelee==0) then
						if(!self:IsCurrentSchedule(SCHED_CHASE_ENEMY)) then
							self:SetSchedule(SCHED_CHASE_ENEMY)
						end
					end
				end
			else
				if(!self:IsCurrentSchedule(SCHED_IDLE_WANDER)) then
					self:SetSchedule(SCHED_IDLE_WANDER)
				end
			end
		end
	end
end


function ENT:KFNPCAnimEnemyIsValid()
	if( ((self.AttackIndex==1&&self.RunToHeal==0)
	||self.AttackIndex==3||self.AttackIndex==4)) then
		local TEMP_DIFF = ((self:GetEnemy():GetPos()-self:GetPos()):Angle().Yaw)-self:GetAngles().Yaw
		local TEMP_YAW = math.NormalizeAngle(TEMP_DIFF)
		TEMP_YAW = math.Clamp(TEMP_YAW,-40,40)
		
		if(math.abs(TEMP_DIFF)>170&&TEMP_YAW==0) then
			TEMP_YAW = math.Clamp(TEMP_DIFF,-1,1)
		end
		
		self:SetAngles(Angle(0,self:GetAngles().Yaw+TEMP_YAW,0))
	end
	
	if(self.PlayingGesture==true) then
		if(self.Hard==0) then
			if(self:GetMovementActivity()!=ACT_WALK) then
				self:SetMovementActivity(ACT_WALK)
			end
		else
			if(self:GetMovementActivity()!=ACT_RUN) then
				self:SetMovementActivity(ACT_RUN)
			end
		end
	end
end

function ENT:KFNPCThinkEnemyValid()
	if(self.Rage>0&&self.RunToHeal==0) then
		if(self:GetMovementActivity()!=ACT_WALK) then
			self:SetMovementActivity(ACT_WALK)
		end
		
		if(self:Visible(self:GetEnemy())) then
			self.Rage = self.Rage-1
		else
			self.Rage = self.Rage-0.1
		end
	else
		if(self:GetMovementActivity()!=ACT_RUN) then
			self:SetMovementActivity(ACT_RUN)
		end
	end
end




function ENT:KFNPCDistanceForMeleeTooBig() 
	if(self.CanShoot==1&&self.RunToHeal==0) then
		local TEMP_ShootChance = math.random(0,1000)
		
		if(self.Hard==1) then
			TEMP_ShootChance = math.random(-20,1020)
		end
		
		if(self:IsUnreachable( self:GetEnemy())) then
			TEMP_ShootChance = math.random(-500,1500)
		end

		if(TEMP_ShootChance<10) then
			if(self.EventModel==1) then
				self:KFNPCPlaySoundRandom(100,"KFMod.PatriarchSanta.WarnMinigun",1,8)
			else
				self:KFNPCPlaySoundRandom(100,"KFMod.Patriarch.WarnMinigun",1,4)
			end
			
			sound.Play( "KFMod.Patriarch.MinigunLoad",self:GetPos() )

			
			self.InAttack = 3
			self.CanShoot = 0
			
			local TEMP_MinigunShootsTime = math.random(2,5)
			
			self:KFNPCPlayAnimation("S_RangedMGStart",3)
			
			timer.Create("StartAttack"..tostring(self),1.7,1,function()
				if(IsValid(self)&&self!=nil&&self!=NULL) then
					self:KFNPCPlayAnimation("S_RangedMGIdle",3,false)
					
					self:EmitSound( "KFMod.Patriarch.MinigunShoot" )	
					
					local TEMP_ShootInterval = 0.05
					local TEMP_BRadius = 2
					local TEMP_BSlowSDownEffect = 4
					
					if(self.Hard>0) then
						TEMP_ShootInterval = 0.045
						TEMP_BRadius = 4
						TEMP_BSlowSDownEffect = 2
					end
					
					timer.Create("Attack"..tostring(self),TEMP_ShootInterval,
					math.Round(TEMP_MinigunShootsTime/TEMP_ShootInterval),function()
						if(IsValid(self)&&self!=nil&&self!=NULL) then
							local TEMP_EPOS = self:GetPos()+(self:GetForward()*1000)
							
							local TEMP_WeaponPos = self:GetAttachment( self:LookupAttachment("Minigunshoot") )
							local TEMP_ShootingPos = TEMP_WeaponPos.Pos
							
							local TEMP_BTr = util.TraceLine( {
								start = Vector(self:GetPos().x,self:GetPos().y,TEMP_WeaponPos.Pos.z),
								endpos = TEMP_WeaponPos.Pos,
								filter = self
							} )
							
							if(TEMP_BTr.Hit) then
								TEMP_ShootingPos = Vector(self:GetPos().x,self:GetPos().y,TEMP_WeaponPos.Pos.z)
							end
							
							if(IsValid(self:GetEnemy())&&self:GetEnemy()!=nil&&(self:KFNPCIsEnemyNPC(self:GetEnemy())||
							self:KFNPCIsEnemyPlayer(self:GetEnemy()))) then
								TEMP_EPOS = self:GetEnemy():GetPos()+self:GetEnemy():OBBCenter()
							end
							
							bullet = {}
							bullet.Attacker=self:GetActiveWeapon()
							bullet.Damage=6*self.DMGMult
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
							
							
							local TEMP_CEffectData = EffectData()
							TEMP_CEffectData:SetOrigin(TEMP_WeaponPos.Pos)
							TEMP_CEffectData:SetColor(0)
							TEMP_CEffectData:SetEntity(self)
							TEMP_CEffectData:SetAngles(TEMP_WeaponPos.Ang)
							util.Effect( "MuzzleFlash", TEMP_CEffectData, false )
						end
					end)
					
					timer.Create("MidAttack"..tostring(self),TEMP_MinigunShootsTime,1,function()
						if(IsValid(self)&&self!=nil&&self!=NULL) then
							self:KFNPCPlayAnimation("S_RangedMGEnd",0,false)
							self:StopSound( "KFMod.Patriarch.MinigunShoot" )
							sound.Play( "KFMod.Patriarch.MinigunUnload", self:GetPos() )
							
							timer.Create("EndAttack"..tostring(self),2.05,1,function()
								if(IsValid(self)&&self!=nil&&self!=NULL) then
									self.Rage = 20
									self:KFNPCStopAllTimers()
									self:KFNPCClearAnimation()
								end
							end)
						end
					end)
				end
			end)
			
			
			
			timer.Simple(12,function()
				if(IsValid(self)&&self!=nil&&self!=NULL) then
					self.CanShoot = 1
				end
			end)
		
		elseif(TEMP_ShootChance>990) then
			if(self.EventModel==1) then
				self:KFNPCPlaySoundRandom(100,"KFMod.PatriarchSanta.WarnRocket",1,2)
			else
				self:KFNPCPlaySoundRandom(100,"KFMod.Patriarch.WarnRocket",1,2)
			end

			sound.Play( "KFMod.Patriarch.RocketLoad", self:GetPos() )
			
			self.InAttack = 4
			self.CanShoot = 0
			
			local TEMP_ShootMode = 0
			local TEMP_EndShootingTime = 1.5
			local TEMP_RocketDist = self:GetPos():Distance(self:GetEnemy():GetPos()+self:GetEnemy():OBBCenter())

			if(self.Hard==1&&TEMP_RocketDist>300&&TEMP_RocketDist<4000) then
				local TEMP_WeaponPos = self:GetAttachment( self:LookupAttachment("Minigunshoot") )
				
				local TEMP_RocketTracer = util.TraceHull( {
					start = self:GetPos()+self:OBBCenter(),
					endpos = self:GetPos()+self:OBBCenter()+Vector(0,0,300),
					filter = self,
					mins = Vector( -5, -5, -5 ),
					maxs = Vector( 5, 5, 5 ),
					mask = MASK_SHOT_HULL
				} )
				
				local TEMP_RocketTracer2 = util.TraceHull( {
					start = self:GetEnemy():GetPos()+self:GetEnemy():OBBCenter(),
					endpos = self:GetEnemy():GetPos()+self:GetEnemy():OBBCenter()+Vector(0,0,300),
					filter = {self, self:GetEnemy()},
					mins = Vector( -5, -5, -5 ),
					maxs = Vector( 5, 5, 5 ),
					mask = MASK_SHOT_HULL
				} )

				if(TEMP_RocketTracer.Fraction>0.9&&TEMP_RocketTracer2.Fraction>0.9) then
					TEMP_ShootMode = math.random(0,1)
					
					if(TEMP_ShootMode==1) then
						TEMP_EndShootingTime = 1.8
					end
				end
			end
			
			for B=1, 3 do
				self:SetBodygroup(7+B,0)
			end
			
			if(TEMP_ShootMode==0) then
				self:KFNPCPlayAnimation("S_RangedRocket",4)
			else
				self:KFNPCPlayAnimation("S_RangedRocket2",4)
			end
			if(IsValid(self:GetEnemy())&&self:GetEnemy()!=nil&&self:GetEnemy()!=NULL) then
				self.PrevEnemyPos = self:GetEnemy():GetPos()
			else
				self.PrevEnemyPos = self:GetPos()+(self:GetForward()*1000)
			end
			
			timer.Create("StartAttack"..tostring(self),2.5,1,function()
				if(IsValid(self)&&self!=nil&&self!=NULL) then
					self:KFNPCStopAllTimers()
					
					local TEMP_RocketSpeed = 2450
		
					
					local TEMP_RocketCount = 1
					
					if(self.Hard==1) then
						TEMP_RocketCount = 3
					end
					
					local TEMP_Rockets = {}
					
					
					for R=1, TEMP_RocketCount do
						local TEMP_WeaponPos = self:GetAttachment( self:LookupAttachment("Rocketshoot"..R) )
						
						
						local TEMP_Rocket = ents.Create("ent_patriarchrocket")
						TEMP_Rocket:SetPos(TEMP_WeaponPos.Pos)
						TEMP_Rocket:SetAngles(self:GetForward():Angle())
						TEMP_Rocket:Spawn()
						TEMP_Rocket:SetOwner(self)
						
						TEMP_Rocket.EventEffect = self.EventRocket
						
						if(GetConVar("kf_npc_difficulty"):GetInt()>0) then
							TEMP_Rocket.Damage = 200+(50*(GetConVar("kf_npc_difficulty"):GetInt()-1))
						end
						
						self:SetBodygroup(7+R,1)
						
						table.insert(TEMP_Rockets,TEMP_Rocket)
						
						if(TEMP_ShootMode==0) then
							local TEMP_EPOS = self:GetPos()+(self:GetForward()*TEMP_RocketSpeed)
							
							if(IsValid(self:GetEnemy())&&self:GetEnemy()!=nil&&self:GetEnemy()!=NULL&&(self:GetEnemy():IsNPC()||
							(self:GetEnemy():IsPlayer()&&self:GetEnemy():Alive()))) then
								
								if(self:GetEnemy():Visible(self)) then
									TEMP_EPOS = self:GetEnemy():GetPos()+self:GetEnemy():OBBCenter()
									
									local TEMP_DST = TEMP_Rocket:GetPos():Distance(self:GetEnemy():GetPos())
									local TEMP_NEWPOS = TEMP_EPOS+((self:GetEnemy():GetVelocity())/
									((TEMP_RocketSpeed*math.Rand(0.87,0.92))/TEMP_DST))
										
									if(self:VisibleVec(TEMP_NEWPOS)) then
										TEMP_EPOS = TEMP_NEWPOS
									end
								else
									TEMP_EPOS = self.PrevEnemyPos
									
									local TEMP_GroundTR = util.TraceLine( {
										start = self.PrevEnemyPos,
										endpos = self.PrevEnemyPos+Vector(0,0,-200),
										filter = self:GetEnemy()
									} )
									
									local TEMP_NEWPOS = TEMP_GroundTR.HitPos
									
									if(self:VisibleVec(TEMP_NEWPOS)) then
										TEMP_EPOS = TEMP_NEWPOS
									end
								end
							else
								TEMP_EPOS = TEMP_WeaponPos.Pos+(self:GetForward()*100)
							end
							
							
							
							TEMP_Rocket:SetAngles((TEMP_EPOS-TEMP_Rocket:GetPos()):Angle())
							
							local TEMP_GrenPhys = TEMP_Rocket:GetPhysicsObject()
							TEMP_GrenPhys:EnableGravity(false)
							TEMP_GrenPhys:SetVelocity(((TEMP_EPOS-TEMP_Rocket:GetPos()):GetNormalized()+
							(Vector(math.random(-10,10),math.random(-10,10),math.random(-10,10))/1000))
							*TEMP_RocketSpeed)
								
						else
							local TEMP_RandVec = Vector(50,0,0)
							
							if(R==2) then
								TEMP_RandVec = Vector(-33,33,0)
							elseif(R==3) then
								TEMP_RandVec = Vector(-33,-33,0)
							end
							
							local TEMP_HPos = self:GetPos()+(self:GetForward()*100)+Vector(0,0,700)+TEMP_RandVec
							
							if(IsValid(self:GetEnemy())&&self:GetEnemy()!=nil&&self:GetEnemy()!=NULL&&(self:GetEnemy():IsNPC()||
							(self:GetEnemy():IsPlayer()&&self:GetEnemy():Alive()))) then
								TEMP_HPos = self:GetEnemy():GetPos()+self:GetEnemy():OBBCenter()+TEMP_RandVec
							end
							
							local TEMP_Dist = TEMP_HPos:Distance(TEMP_Rocket:GetPos())
							local TEMP_Mul = TEMP_RocketSpeed
							local TEMP_Acos = math.acos(math.Clamp((TEMP_Dist)/TEMP_Mul,-1,1))*(180/math.pi)
							
							local TEMP_Ang = Angle(-TEMP_Acos,(TEMP_HPos-TEMP_Rocket:GetPos()):Angle().Yaw,0)
							
							
							
							TEMP_Rocket:SetAngles(TEMP_Ang)
							
							local TEMP_GrenPhys = TEMP_Rocket:GetPhysicsObject()
							TEMP_GrenPhys:EnableGravity(true)
							TEMP_GrenPhys:SetVelocity((TEMP_Rocket:GetForward()+(VectorRand()/1000)):GetNormalized()*TEMP_Mul)
						end
						
					end
					
					if(#TEMP_Rockets>1) then
						if(IsValid(TEMP_Rockets[1])) then
							if(IsValid(TEMP_Rockets[2])) then
								constraint.NoCollide(TEMP_Rockets[1],TEMP_Rockets[2],0,0)
							end
							if(IsValid(TEMP_Rockets[3])) then
								constraint.NoCollide(TEMP_Rockets[1],TEMP_Rockets[3],0,0)
							end
						end
						
						if(IsValid(TEMP_Rockets[2])&&IsValid(TEMP_Rockets[3])) then
							constraint.NoCollide(TEMP_Rockets[2],TEMP_Rockets[3],0,0)
						end
					end
					
					sound.Play( "KFMod.RocketShoot", self:GetPos() )
					
					
					timer.Create("EndAttack"..tostring(self),TEMP_EndShootingTime,1,function()
						if(IsValid(self)&&self!=nil&&self!=NULL) then
							self.Rage = 20
							self:KFNPCStopAllTimers()
							self:KFNPCClearAnimation()
						end
					end)
					
					
					timer.Simple(12,function()
						if(IsValid(self)&&self!=nil&&self!=NULL) then
							self.CanShoot = 1
						end
					end)
				end
			end)
		end
	end
end

function ENT:KFNPCOnCreateRagdoll(dmginfo,boom)
	if(self.EventModel==0) then
		self:SetBodygroup(6,1)
		self:KFNPCCreateGib("CHR_Head","models/Tripwire/Killing Floor/Zeds/KFPatriarchGoreGlasses.mdl",100)
	end
	
	local TEMP_DMG = dmginfo:GetDamage()
	
	if(boom==true) then
		TEMP_DMG = 299
	end
	
	return true, TEMP_DMG
end

function ENT:KFNPCRemove()
	if(IsValid(self.Gun)&&self.Gun==NULL&&self.Gun==nil) then
		self.Gun:Remove()
	end
	
	if(IsValid(self.Camera)&&self.Camera!=nil&&self.Camera!=NULL) then
		self.Camera:Remove()
		for _,v in pairs(player.GetAll()) do
			v:Freeze(false)
			v:SetViewEntity(v)
		end
	end
						
	self:StopSound( "KFMod.Patriarch.MinigunShoot")
end