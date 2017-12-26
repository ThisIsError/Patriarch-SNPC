AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "ai_translations.lua" )
AddCSLuaFile( "sh_anim.lua" )

AddCSLuaFile( "KFPillBaseVars.lua" )
include( "KFPillBaseVars.lua" )

if(SERVER) then
	include( "KFPillBaseVarsSV.lua" )
end

SWEP.PrintName		= "Pill"
SWEP.Author			= "ERROR"
SWEP.Contact		= ""
SWEP.Purpose		= ""
SWEP.Instructions	= ""

SWEP.ViewModelFOV	= 62
SWEP.ViewModelFlip	= false
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

SWEP.Weight			= 0
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

SWEP.Slot			= 1
SWEP.SlotPos			= 1
SWEP.DrawAmmo			= false
SWEP.DrawCrosshair		= false

SWEP.ViewModel			= "models/weapons/v_pistol.mdl"
SWEP.WorldModel			= "models/weapons/w_pistol.mdl"


if(CLIENT) then
	function SWEP:KFPillThinkCL()
	end
end

function SWEP:KFPillRemove()
end

function SWEP:KFPillHolster()
end

if(SERVER) then

	SWEP.NextSVThink = -1
	
	function SWEP:KFPillOnRemove()
	end
	
	function SWEP:KFPillFourthAttack()
	end
	
	function SWEP:KFPillOnCreateRagdoll()
		return true
	end

	function SWEP:KFPillLostHead()
	end

	function SWEP:KFPillSecondaryAttack()
	end

	function SWEP:KFPillThirdAttack()
	end

	function SWEP:KFPillFifthAttack()
	end
	
	function SWEP:KFPillAddMeleeAttacks()
	end
	
	function SWEP:KFPillMeleeAttackEvent()
	end
	
	function SWEP:KFPillThink()
	end
	
	function SWEP:KFPillMoving()
	end
	
	function SWEP:KFPillNotMoving()
	end
	
	function SWEP:KFPillOnHeadLoss()
	end
	
	function SWEP:KFPillInit()
	end
	
	function SWEP:KFPillGestureEnd()
	end
	
	function SWEP:KFPillCanAttackThis(ENT2)
		if(self:KFPillIsEnemyNPC(ENT2)||self:KFPillIsEnemyPlayer(ENT2)||KFNPCIsProp(ENT2)) then
			return true
		end
	end

	function SWEP:KFPillIsEnemyNPC(ENT2)
		if(ENT2:IsNPC()&&ENT2:GetNPCState()!=NPC_STATE_DEAD&&(ENT2.SNPCClass!="C_SAVAGE"||GetConVar("kf_pill_zed_friendly"):GetInt()==0||
		ENT2:GetEnemy()==self:GetOwner())) then
			return true
		end
		
		return false
	end
		
	function SWEP:KFPillIsEnemyPlayer(ENT2)
		if(ENT2:IsPlayer()&&ENT2:Alive()&&(ENT2:GetNWBool("BeZed_IsZed",false)==false||GetConVar("kf_pill_player_friendly"):GetInt()==0)) then
			return true
		end
		
		return false
	end

	
	function SWEP:KFPillMakeHeadless()
		self.ZedHeadLess = true
		self:SetWeaponHoldType( "normal" )
		net.Start("KFPillNWDestroyHead")
		net.WriteEntity(self)
		net.Broadcast()
	end
	
	function SWEP:KFPillSelectMeleeAttack()
	end
	
	function SWEP:KFPillStun(ANM)
		if((self.ZedAnimation!=ANM||self.ZedStunInStun==true)&&self.ZedAnimation!=self.ZedFlinchGesture) then
			self:KFPillRemoveTimers()
			self:KFPillPlayGesture(ANM,1)
		end
	end
	
	function SWEP:KFPillFlinch(ANM)
		if(self.ZedAnimation!=ANM&&self.ZedAnimation!=self.ZedFlinchGesture&&self.ZedAnimation!=self.ZedStunGesture) then
			self:KFPillRemoveTimers()
			self:KFPillPlayGesture(ANM)
		end
	end
	
	function SWEP:KFPillSetBodygoup(BG)
		if(isstring(BG)) then
			local TEMP_BGSTR = string.Explode(",",BG)
			
			if(#TEMP_BGSTR>0) then
				for B=1, #TEMP_BGSTR do
					self:GetOwner():SetBodygroup(tonumber(TEMP_BGSTR[B]),1)
				end
			end
		else
			self:GetOwner():SetBodygroup(BG,1)
		end
	end
	

	function SWEP:KFPillKillHead(DMGPOP,FORCE,DMG,ATT,INF)
		local TEMP_FirstBone = string.Explode(",",self.GoreHead.bone)[1]
		local TEMP_FirstBoneMat = self:GetOwner():GetBoneMatrix(self:GetOwner():LookupBone(TEMP_FirstBone))
		local TEMP_FirstBonePos = TEMP_FirstBoneMat:GetTranslation()
		
		if(DMGPOP==true) then	
			for G=1,3 do
				self:KFPillCreateGib(self.GoreHead.bone,"models/Tripwire/Killing Floor/Zeds/KFGoreBrain"..G..".mdl",FORCE,DMG,false)
			end
			
			for G=1,2 do
				self:KFPillCreateGib(self.GoreHead.bone,"models/Tripwire/Killing Floor/Zeds/KFGoreEye.mdl",FORCE,DMG,false)
			end
		else
			self:KFPillCreateGib(self.GoreHead.bone,self.GoreHead.model,FORCE,DMG,true)
			KFNPCBleed(self,math.random(130,150),TEMP_FirstBonePos,AngleRand())
		end
		
		self:KFPillSetBodygoup(self.GoreHead.bodygroup1)
		sound.Play("KFMod.GoreDecap"..math.random(1,4),TEMP_FirstBonePos)
		self:KFPillMakeHeadless()
		self:KFPillLostHead()
		
		
		local TEMP_ATT = ATT
		local TEMP_INF = INF
		timer.Create("KFBeZed_Kill"..tostring(self),7,1,function()
			if(KFPillAllValid(self)) then
				self:KFPillKillHeadless(TEMP_ATT,TEMP_INF)
			end
		end)
		
		local TEMP_NECK = self:LookupBone("CHR_Neck")
		
		if(TEMP_NECK) then
			local TEMP_NeckPos, TEMP_NeckAng = self:GetBonePosition(TEMP_NECK)
			
			local CEffectData = EffectData()
			CEffectData:SetOrigin(TEMP_NeckPos)
			CEffectData:SetFlags(3)
			CEffectData:SetScale(math.random(7,9))
			CEffectData:SetColor(0)
			CEffectData:SetNormal(Vector(0,0,1))
			CEffectData:SetEntity(self)
			CEffectData:SetAngles(TEMP_NeckAng)
			util.Effect( "bloodspray", CEffectData, false )
		end
	end
	
	function SWEP:KFPillPlayMeleeAttack(IND,REM)
		if(!isnumber(IND)) then
			IND = math.random(1,#self.MeleeAttackGesture)
		end
		
		self:KFPillPlayGesture(self.MeleeAttackGesture[IND],self.MeleeFreeze[IND],IND,REM)
		self:KFPillMakeMeleeAttack(IND)
		
		self:KFPillMeleeAttackEvent()
	end
	
	function SWEP:KFPillMeleeAttackDamageMultiple()
		return 1
	end

	function SWEP:KFPillMeleeDamagesEnd()
	end

	function SWEP:KFPillMakeDamageToCreature()
	end

	function SWEP:KFPillHitSomething()
	end

	function SWEP:KFPillCreateMeleeTable()
		local TBL = {}
		TBL.damage = {}
		TBL.distance = {}
		TBL.radius = {}
		TBL.time = {}
		TBL.bone = {}
		TBL.damage = {}
		TBL.damagetype = {}
		TBL.distance = {}
		TBL.radius = {}
		TBL.time = {}
		TBL.bone = {}
		
		return TBL
	end

	function SWEP:KFPillPlayGesture(GESTURE,FREEZE,IND,REM,NOTIMER)
		if(FREEZE==2) then
			self:GetOwner():Freeze(true)
			self.ZedPlayingGesture = false
		elseif(FREEZE==1) then
			self.ZedPlayingGesture = false
		else
			FREEZE = 0
			self.ZedPlayingGesture = true
		end
		
		if(NOTIMER==nil) then
			NOTIMER = false
		end
		
		self.ZedPlayingAnimation = true
		self.ZedAnimation = GESTURE
		self:GetOwner():DoAnimationEvent(GESTURE)
		
		
		local TEMP_ENDTIME = -1
		
		if(NOTIMER!=true) then
			TEMP_ENDTIME = CurTime()+self:GetOwner():SequenceDuration(self:GetOwner():SelectWeightedSequence(self.ZedAnimation))
			
			timer.Create("BeZedTimer_EndAnimation"..tostring(self), self:GetOwner():SequenceDuration(self:GetOwner():SelectWeightedSequence(self.ZedAnimation)), 1, function()
				if(KFPillAllValid(self)) then
					self.ZedPlayingGesture = false
					self.ZedAnimation = -1
					self.ZedPlayingAnimation = false

					if(FREEZE==2) then
						self:GetOwner():Freeze(false)
					end
					
					self:KFPillGestureEnd()
					
					if(isnumber(IND)) then
						if(REM==true) then
							self:KFPillRemoveMeleeTable(IND)
						end
					end
				end
			end)
		end
		
		
		net.Start("KFPillNWPlayAnimation")
		net.WriteEntity(self)
		net.WriteString(tonumber(GESTURE))
		net.WriteString(tonumber(FREEZE))
		net.WriteBool(NOTIMER)
		net.WriteFloat(TEMP_ENDTIME)
		net.Broadcast()
		
	end

	function SWEP:KFPillOwnerBecomeZedEvent()
	end

	function SWEP:KFPillKillHeadless(ATTK,INFL)
		if(self.ZedHeadLess==true) then
			self:GetOwner():SetHealth(0)
			
			if(!IsValid(ATTK)||ATTK==NULL) then
				ATTK = game.GetWorld()
			end
			
			if(!IsValid(INFL)||INFL==NULL) then
				INFL = self
			end
			
			local TEMP_DIEMAZAFAKADIE = DamageInfo()
			TEMP_DIEMAZAFAKADIE:SetDamage(999)
			TEMP_DIEMAZAFAKADIE:SetDamagePosition(self:GetOwner():GetPos())
			TEMP_DIEMAZAFAKADIE:SetDamageForce(Vector(0,0,0))
			TEMP_DIEMAZAFAKADIE:SetAttacker(ATTK)
			TEMP_DIEMAZAFAKADIE:SetInflictor(INFL)
			self:GetOwner():TakeDamageInfo(TEMP_DIEMAZAFAKADIE)
		end
	end
	
				
	function SWEP:KFPillEnemyInRange(ENT2,DIST1,DIST2)
		if(self:KFPillIsEnemyNPC(ENT2)||self:KFPillIsEnemyPlayer(ENT2)||KFNPCIsProp(ENT2)) then
			local TEMP_Point1 = ENT2:NearestPoint(self:GetOwner():GetPos()+self:GetOwner():OBBCenter())
			local TEMP_Point2 = self:GetOwner():NearestPoint(TEMP_Point1)

			local TEMP_DistanceBetween = TEMP_Point1:Distance(TEMP_Point2)

			if(TEMP_Point2.z<(self:GetOwner():GetPos()+self:GetOwner():OBBMaxs()).z&&
			TEMP_Point2.z>((self:GetOwner():GetPos()+self:GetOwner():OBBMins()).z)) then

				if(TEMP_DistanceBetween<DIST2) then
					if(TEMP_DistanceBetween>DIST1||DIST1==0) then
						return 2
					else
						return 1
					end
				end
			end
		end

		return 0
	end

	function SWEP:KFPillRemoveMeleeTable(IND)
		self.MeleeDamageTime[IND] = {}
		self.MeleeDamageDamage[IND] = {}
		self.MeleeDamageType[IND] = {}
		self.MeleeDamageDistance[IND] = {}
		self.MeleeDamageBone[IND] = {}
		self.MeleeDamageRadius[IND] = {}

		self.MeleeAttackGesture[IND] = nil
		self.MeleeDamageCount[IND] = nil
		self.MeleeFreeze[IND] = nil
	end

	
	function SWEP:KFPillMakeMeleeAttack(IND)
		local TEMP_TargetTakeDamage = false
		local TEMP_SomeoneTakeDamage = false
		local TEMP_DamagesCount = 0
		
		for i=1, self.MeleeDamageCount[IND] do
			timer.Create("KFBeZed_DamageAttack"..tostring(self)..i,self.MeleeDamageTime[IND][i]-0.2,1,function()
				if(KFPillAllValid(self)&&self.MeleeDamageDistance[IND]!=nil&&self.MeleeDamageDistance[IND][i]!=nil) then
				
					local TEMP_TARGETDMG, TEMP_SOMEONEDMG, TEMP_DMGCNT = self:KFPillDoMeleeDamage(self.MeleeDamageDamage[IND][i],
					self.MeleeDamageType[IND][i],self.MeleeDamageDistance[IND][i]+7,self.MeleeDamageRadius[IND][i],
					self.MeleeDamageBone[IND][i],self.MeleeHitSound[IND],self.MeleeMissSound[IND])
					
					if(TEMP_TARGETDMG==true) then
						TEMP_TargetTakeDamage = true
					end
					
					if(TEMP_SOMEONEDMG==true) then
						TEMP_SomeoneTakeDamage = true
					end
					
					TEMP_DamagesCount = TEMP_DamagesCount+TEMP_DMGCNT
					
					if(i==self.MeleeDamageCount[IND]) then
						self:KFPillMeleeDamagesEnd(TEMP_TargetTakeDamage,TEMP_SomeoneTakeDamage,TEMP_DamagesCount==self.MeleeDamageCount[IND])
					end
				end
			end )
		end
	end
	
	
	function SWEP:KFPillDoMeleeDamage(DMG,TYPE,DIST,RAD,BONE,HITSND,MISSSND)
		local TEMP_TargetTakeDamage = false
		local TEMP_SomeoneTakeDamage = false
		local TEMP_DamagesCount = 0
		
		if(DIST!=nil) then
			local TEMP_OBBSize = (Vector(math.abs(self:GetOwner():OBBMins().x),math.abs(self:GetOwner():OBBMins().y),0)+
			Vector(math.abs(self:GetOwner():OBBMaxs().x),math.abs(self:GetOwner():OBBMaxs().y),0))/2
			local TEMP_PossibleDamageTargets = ents.FindInSphere(self:GetPos(), DIST+TEMP_OBBSize:Length()+15)
			local TEMP_DMGMAT = self:GetOwner():GetBoneMatrix(self:GetOwner():LookupBone(BONE))
			local TEMP_DMGPOS, TEMP_DMGANG = TEMP_DMGMAT:GetTranslation(), TEMP_DMGMAT:GetAngles()
			local TEMP_DamageApplied = false
				
			if(#TEMP_PossibleDamageTargets>0) then
				for _,v in pairs(TEMP_PossibleDamageTargets) do
					if(v!=self:GetOwner()&&v!=NULL&&v!=nil&&v!=self&&self:KFPillCanAttackThis(v)) then

						local TEMP_DistanceForMelee = self:KFPillEnemyInRange(v,0,DIST)
						
						local TEMP_DotVector = v:GetPos()
						local TEMP_DotDir = TEMP_DotVector - self:GetOwner():GetPos()
						TEMP_DotDir:Normalize()
						local TEMP_OWNER_FORWARD = Angle(0,self:GetOwner():EyeAngles().Yaw,0):Forward()
						local TEMP_Dot = Vector(TEMP_OWNER_FORWARD.x,TEMP_OWNER_FORWARD.y,0):Dot(Vector(TEMP_DotDir.x,TEMP_DotDir.y,0))
						
						if(TEMP_DistanceForMelee==2&&(TEMP_Dot>math.cos(RAD)||RAD==360)) then
							TEMP_DamageApplied = true
							
							local TEMP_FMOD = 100
							local TEMP_ZMOD = 0.3
							
							local TEMP_FlySpeed = (math.abs(v:OBBMins().x)+math.abs(v:OBBMins().y)+math.abs(v:OBBMins().z)+
							math.abs(v:OBBMaxs().x)+math.abs(v:OBBMaxs().y)+math.abs(v:OBBMaxs().z))
							
							local TEMP_PushVec = ((v:GetPos()+v:OBBCenter())-(self:GetPos()+self:OBBCenter())):GetNormalized()
							
							local TEMP_FlyDir = 
							(((Vector(TEMP_PushVec.x,TEMP_PushVec.y,TEMP_ZMOD))/
							TEMP_FlySpeed)*(100*self.ZedMeleeForce))*(DMG/1000)
							
							local TEMP_DAMAGEPOSITION = v:NearestPoint(TEMP_DMGPOS)
							local TEMP_DAMAGEFORCE = (TEMP_DAMAGEPOSITION-TEMP_DMGPOS):GetNormalized()*TEMP_FlyDir:Length()
							
							local TEMP_TargetDamage = DamageInfo()
							
							TEMP_TargetDamage:SetDamage(DMG*self:KFPillMeleeAttackDamageMultiple())
							TEMP_TargetDamage:SetInflictor(self)
							TEMP_TargetDamage:SetDamageType(TYPE)
							TEMP_TargetDamage:SetAttacker(self:GetOwner())
							TEMP_TargetDamage:SetDamagePosition(TEMP_DAMAGEPOSITION)
							TEMP_TargetDamage:SetDamageForce(TEMP_DAMAGEFORCE)
							v:TakeDamageInfo(TEMP_TargetDamage)
							
							if(v:IsNPC()||v:IsPlayer()) then
								TEMP_DamagesCount = 1
								TEMP_SomeoneTakeDamage = true
								self:KFPillMakeDamageToCreature(v)
							end
							
							if(TEMP_FlyDir.z>250||!v:IsOnGround()) then
								TEMP_FMOD = 25
							end
							
							if(v:IsPlayer()) then
								v:ViewPunch(Angle(math.random(-1,1)*TEMP_FlyDir:Length(),math.random(-1,1)*TEMP_FlyDir:Length(),math.random(-1,1)*TEMP_FlyDir:Length()))
								//TEMP_ZMOD = 0.4
							end
							
							TEMP_FlyDir = TEMP_FlyDir*TEMP_FMOD
							
							v:SetVelocity(TEMP_FlyDir)
						end
					end
				end
			end
			
			if(TEMP_DamageApplied==true) then
				self:KFPillHitSomething()
				
				sound.Play( table.Random(HITSND),TEMP_DMGPOS)
			else
				sound.Play( table.Random(MISSSND),TEMP_DMGPOS)
			end
		end
		
		
		
		return TEMP_TargetTakeDamage,TEMP_SomeoneTakeDamage,TEMP_DamagesCount
	end
	
	
	/*function SWEP:KFPillMakeMeleeAttack(IND)
		local TEMP_TargetTakeDamage = false
		local TEMP_SomeoneTakeDamage = false
		local TEMP_DamagesCount = 0
		
		for i=1, self.MeleeDamageCount[IND] do
			timer.Create("KFBeZed_DamageAttack"..tostring(self)..i,self.MeleeDamageTime[IND][i]-0.2,1,function()
				if(KFPillAllValid(self)&&self.MeleeDamageDistance[IND]!=nil&&self.MeleeDamageDistance[IND][i]!=nil) then
					local TEMP_OBBSize = (Vector(math.abs(self:GetOwner():OBBMins().x),math.abs(self:GetOwner():OBBMins().y),0)+
					Vector(math.abs(self:GetOwner():OBBMaxs().x),math.abs(self:GetOwner():OBBMaxs().y),0))/2
					local TEMP_PossibleDamageTargets = ents.FindInSphere(self:GetOwner():GetPos(), self.MeleeDamageDistance[IND][i]+TEMP_OBBSize:Length()+15)
					local TEMP_DMGMAT = self:GetOwner():GetBoneMatrix(self:GetOwner():LookupBone(self.MeleeDamageBone[IND][i]))
					local TEMP_DMGPOS, TEMP_DMGANG = TEMP_DMGMAT:GetTranslation(), TEMP_DMGMAT:GetAngles()
					local TEMP_DamageApplied = false
					
					if(TEMP_PossibleDamageTargets!=nil&&#TEMP_PossibleDamageTargets>0) then
						for _,v in pairs(TEMP_PossibleDamageTargets) do
							if(v!=self:GetOwner()&&v!=NULL&&v!=nil&&v!=self&&self:KFPillCanAttackThis(v)) then
								local TEMP_DistanceForMelee = self:KFPillEnemyInRange(v,0,self.MeleeDamageDistance[IND][i]+7)
								
								local TEMP_DotVector = v:GetPos()
								local TEMP_DotDir = TEMP_DotVector - self:GetOwner():GetPos()
								TEMP_DotDir:Normalize()
								local TEMP_OWNER_FORWARD = Angle(0,self:GetOwner():EyeAngles().Yaw,0):Forward()
								local TEMP_Dot = Vector(TEMP_OWNER_FORWARD.x,TEMP_OWNER_FORWARD.y,0):Dot(Vector(TEMP_DotDir.x,TEMP_DotDir.y,0))
								
								if(TEMP_DistanceForMelee==2&&(TEMP_Dot>math.cos(self.MeleeDamageRadius[IND][i])||
								self.MeleeDamageRadius[IND][i]==360)) then
									TEMP_DamageApplied = true
									
									local TEMP_FMOD = 100
									local TEMP_ZMOD = 0.4
									
									local TEMP_FlySpeed = (math.abs(v:OBBMins().x)+math.abs(v:OBBMins().y)+math.abs(v:OBBMins().z)+
									math.abs(v:OBBMaxs().x)+math.abs(v:OBBMaxs().y)+math.abs(v:OBBMaxs().z))
									
									local TEMP_FlyDir = 
									(((((v:GetPos()+v:OBBCenter())-(self:GetOwner():GetPos()+self:GetOwner():OBBCenter())):GetNormalized()+Vector(0,0,TEMP_ZMOD))/
									TEMP_FlySpeed)*(100*self.ZedMeleeForce))*(self.MeleeDamageDamage[IND][i]/1000)
									
									
									local TEMP_DAMAGEPOSITION = v:NearestPoint(TEMP_DMGPOS)
									local TEMP_DAMAGEFORCE = (TEMP_DAMAGEPOSITION-TEMP_DMGPOS):GetNormalized()*TEMP_FlyDir:Length()
									
									local TEMP_TargetDamage = DamageInfo()
									
									TEMP_TargetDamage:SetDamage(self.MeleeDamageDamage[IND][i]*self:KFPillMeleeAttackDamageMultiple())
									TEMP_TargetDamage:SetInflictor(self)
									TEMP_TargetDamage:SetDamageType(self.MeleeDamageType[IND][i])
									TEMP_TargetDamage:SetAttacker(self:GetOwner())
									TEMP_TargetDamage:SetDamagePosition(TEMP_DAMAGEPOSITION)
									TEMP_TargetDamage:SetDamageForce(TEMP_DAMAGEFORCE)
									v:TakeDamageInfo(TEMP_TargetDamage)
									
									if(!v:IsPlayer()&&!v:IsNPC()) then
										TEMP_SomeoneTakeDamage = true
										self:KFPillMakeDamageToCreature(v)
									end
									
									if(TEMP_FlyDir.z>250||!v:IsOnGround()) then
										TEMP_FMOD = 25
									end
									
									if(v:IsPlayer()) then
										v:ViewPunch(Angle(math.random(-1,1)*TEMP_FlyDir:Length(),math.random(-1,1)*TEMP_FlyDir:Length(),math.random(-1,1)*TEMP_FlyDir:Length()))
										TEMP_ZMOD = 0.4
									end
									
									TEMP_FlyDir = TEMP_FlyDir*TEMP_FMOD
									
									v:SetVelocity(TEMP_FlyDir)
								end
							end
						end
					end
					
					if(TEMP_DamageApplied==true) then
						self:KFPillHitSomething()
						
						sound.Play( table.Random(self.MeleeHitSound[IND]),TEMP_DMGPOS)
					else
						sound.Play( table.Random(self.MeleeMissSound[IND]),TEMP_DMGPOS)
					end
					
					if(i==self.MeleeDamageCount[IND]) then
						self:KFPillMeleeDamagesEnd(TEMP_TargetTakeDamage,TEMP_SomeoneTakeDamage,TEMP_DamagesCount==self.MeleeDamageCount[IND])
					end
				end
			end )
		end
	end*/

	function SWEP:KFPillSetMeleeParamsGesture(NUM,GES,CNT,TBL,TBLH,TBLM,FRZ)
		self.MeleeAttackGesture[NUM] = GES
		self.MeleeDamageCount[NUM] = CNT
		self.MeleeFreeze[NUM] = FRZ
		
		if(!self.MeleeHitSound[NUM]) then
			self.MeleeHitSound[NUM] = {}
		end
		
		if(!self.MeleeMissSound[NUM]) then
			self.MeleeMissSound[NUM] = {}
		end
		
		table.Add(self.MeleeHitSound[NUM],TBLH)
		table.Add(self.MeleeMissSound[NUM],TBLM)
		
		for N=1,CNT do
			if(!self.MeleeDamageTime[NUM]) then
				self.MeleeDamageTime[NUM] = {}
			end
			if(!self.MeleeDamageDamage[NUM]) then
				self.MeleeDamageDamage[NUM] = {}
			end
			if(!self.MeleeDamageType[NUM]) then
				self.MeleeDamageType[NUM] = {}
			end
			if(!self.MeleeDamageDistance[NUM]) then
				self.MeleeDamageDistance[NUM] = {}
			end
			if(!self.MeleeDamageRadius[NUM]) then
				self.MeleeDamageRadius[NUM] = {}
			end
			if(!self.MeleeDamageBone[NUM]) then
				self.MeleeDamageBone[NUM] = {}
			end
			
			self.MeleeDamageTime[NUM][N] = TBL.time[N]
			self.MeleeDamageDamage[NUM][N] = TBL.damage[N]
			self.MeleeDamageType[NUM][N] = TBL.damagetype[N]
			self.MeleeDamageDistance[NUM][N] = TBL.distance[N]
			self.MeleeDamageRadius[NUM][N] = TBL.radius[N]
			self.MeleeDamageBone[NUM][N] = TBL.bone[N]
		end
	end
	
	function SWEP:KFPillStopPreviousSound()
		self.NextSoundCanPlayTime = -1
		if(isstring(self.LastPlayedSound)) then
			if(IsValid(self:GetOwner())) then
				self:GetOwner():StopSound(self.LastPlayedSound)
			elseif(IsValid(self.RealOwner)) then
				self.RealOwner:StopSound(self.LastPlayedSound)
			end
		end
		
		self.LastPlayedSound = nil
	end
		
	function SWEP:KFPillPlayVoiceRandom(CH,SNDNM,IMIN,IMAX,CHAN)
		if(self.NextSoundCanPlayTime<CurTime()&&self.ZedHeadLess==false) then
			local TEMP_SoundChance = math.random(1,100)
		
			if(TEMP_SoundChance<CH) then
				local TEMP_SND = SNDNM..math.random(IMIN,IMAX)
					
				self:GetOwner():EmitSound( TEMP_SND )
				self.NextSoundCanPlayTime = CurTime()+SoundDuration(TEMP_SND)+0.2
				self.LastPlayedSound = TEMP_SND
			end
		end
	end
	
	
	
	function SWEP:KFPillCreateGib(BONE, MDL, FORCE, DMG, Bleed)
		local TEMP_Mat = self:GetOwner():GetBoneMatrix(self:GetOwner():LookupBone(BONE))
		local TEMP_Pos, TEMP_Ang = TEMP_Mat:GetTranslation(), TEMP_Mat:GetAngles()
		
		if(!DMG) then
			DMG = 100
		end
		
		local TEMP_Gib = ents.Create("prop_physics")
		TEMP_Gib:SetModel(MDL)
		TEMP_Gib:SetPos(TEMP_Pos)
		TEMP_Gib:SetAngles(TEMP_Ang)
		TEMP_Gib:SetCollisionGroup( COLLISION_GROUP_DEBRIS )
		TEMP_Gib:Spawn()
		TEMP_Gib:Activate()
		
		TEMP_Gib:SetOwner(self:GetOwner())
		
		TEMP_Gib:Fire("kill","",30)
		
		if(!isvector(FORCE)||!isnumber(FORCE.x)||!isnumber(FORCE.y)||!isnumber(FORCE.z)) then
			FORCE = Vector(math.random(-50,50),math.random(-50,50),math.random(-50,50)):GetNormalized()*(DMG*(math.random(70,130)/500))
		else
			FORCE = (FORCE:GetNormalized()+(Vector(math.random(-20,20),math.random(-20,20),math.random(-20,20))/100)):GetNormalized()*(DMG*((math.random(10,15)/1000)*FORCE:Length()))
		end
		
		timer.Simple(0.02,function()
			if(IsValid(TEMP_Gib)&&TEMP_Gib!=nil&&TEMP_Gib!=NULL) then
				local TEMP_GibPhys = TEMP_Gib:GetPhysicsObject()
				TEMP_GibPhys:SetVelocity(FORCE)
			end
		end)
				
		if(Bleed==true) then
			for T=1, 4 do
				timer.Simple(0.2*T,function()
					if(IsValid(TEMP_Gib)&&TEMP_Gib!=nil&&TEMP_Gib!=NULL) then
						KFNPCBleed(TEMP_Gib,1,TEMP_Gib:GetPos(),AngleRand())
						
						local CEffectData = EffectData()
						CEffectData:SetOrigin(TEMP_Gib:GetPos())
						CEffectData:SetFlags(3)
						CEffectData:SetScale(math.random(5,7))
						CEffectData:SetColor(0)
						CEffectData:SetNormal(-TEMP_Gib:GetVelocity())
						CEffectData:SetEntity(TEMP_Gib)
						CEffectData:SetAngles(TEMP_Gib:GetAngles())
						util.Effect( "bloodspray", CEffectData, false )
					end
				end)
			end
		end
	end

	
	
	function SWEP:KFPillSetBodygoup(BG)
		if(isstring(BG)) then
			local TEMP_BGSTR = string.Explode(",",BG)
			
			if(#TEMP_BGSTR>0) then
				for B=1, #TEMP_BGSTR do
					self:GetOwner():SetBodygroup(tonumber(TEMP_BGSTR[B]),1)
				end
			end
		else
			self:GetOwner():SetBodygroup(BG,1)
		end
	end
	
	function SWEP:KFPillSetExplosionDamage()
		return false, false
	end


	function SWEP:KFPillSprintEvent()
	end

	function SWEP:KFPillSprintEventExit()
	end
	
	function SWEP:KFPillDamageTake()
	end
	
	function SWEP:KFPillRemoveAllTimers()
		self:KFPillRemoveTimers()
		timer.Remove("KFBeZed_EnableSomething"..tostring(self))
		timer.Remove("KFBeZed_DisableSomething"..tostring(self))
	end
	
	function SWEP:KFPillRemoveTimers(STOPATTACKTIMER)
		timer.Remove("KFBeZed_Sound"..tostring(self))
		
		for T=1, 10 do
			timer.Remove("KFBeZed_DamageAttack"..tostring(self)..T)
		end
		
		timer.Remove("KFBeZed_StartAttack"..tostring(self))
		timer.Remove("KFBeZed_StartAnimation"..tostring(self))
		timer.Remove("KFBeZed_EndAnimation"..tostring(self))
		
		if(STOPATTACKTIMER==nil||STOPATTACKTIMER==true) then
			timer.Remove("KFBeZed_EndAttack"..tostring(self))
		end
	end
end



function KFPillAllValid(wep)
	if(IsValid(wep)&&wep!=nil&&wep!=NULL&&IsValid(wep:GetOwner())&&wep:GetOwner()!=nil&&wep:GetOwner()!=NULL&&wep:GetOwner():IsPlayer()&&!wep:GetOwner():IsRagdoll()&&
	wep:GetOwner():Alive()&&IsValid(wep:GetOwner():GetActiveWeapon())&&IsValid(wep.Weapon)&&wep.Weapon!=nil&&wep.Weapon!=NULL&&
	wep:GetOwner():GetActiveWeapon():GetClass()==wep.Weapon:GetClass()) then
		return true
	end
	
	return false
end

function SWEP:Initialize()
	self:SetHoldType( "normal" )
	self:SetColor(Color(0,0,0,0))
	
	if(SERVER) then
		self.ZedGore = GetConVar("kf_npc_gore"):GetInt()
		self:KFPillInit()
		self.Removed = false
		timer.Simple(0.1,function()
			if(IsValid(self)) then
				self.RealOwner = self:GetOwner()
			end
		end)
	end
end

function SWEP:PrimaryAttack()
	if(SERVER) then
		if(KFPillAllValid(self)&&self.ZedPlayingAnimation==false&&self:GetOwner():IsOnGround()) then
			local TEMP_IND = self:KFPillSelectMeleeAttack()

			self:KFPillPlayMeleeAttack(TEMP_IND)
		end
	end
end

function SWEP:SecondaryAttack()
	if(SERVER) then
		if(KFPillAllValid(self)&&self.ZedPlayingAnimation==false&&self:GetOwner():IsOnGround()) then
			self:KFPillSecondaryAttack()
		end
	end
end

function SWEP:Reload()
	if(SERVER) then
		if(KFPillAllValid(self)&&self.ZedPlayingAnimation==false&&self:GetOwner():IsOnGround()) then
			self:KFPillThirdAttack()
		end
	end
end

function SWEP:Holster()
	self:KFPillHolster()
	
	if(SERVER) then
		if(self.Removed!=true) then
			self:KFPillRemoveFunc()
			self.Removed = true
			
			self:Remove()
		end
	end

	return true
end

function SWEP:KFPillRemoveFunc(OWN)
	if(!OWN) then
		OWN = self:GetOwner()
	end
	
	if(!IsValid(OWN)) then return end
	
	if(SERVER) then
		self:KFPillOnRemove()
		OWN:SetNWBool("BeZed_IsZed",false)
		OWN:SetNWString("BeZed_ZedName","")
		
		if(self.ZedHeadLess==true&&!OWN:Alive()) then
			return false
		end
	
		self:KFPillStopPreviousSound()
		self:KFPillRemoveAllTimers()

		if(OWN:Alive()) then
			OWN:SetModel(self.ZedPlayerOriginalModel)
		
			local TEMP_SelfHPDepend = OWN:Health()/OWN:GetMaxHealth()
		
			OWN:SetMaxHealth(self.PlayerHealth)
			OWN:SetHealth(self.PlayerHealth*TEMP_SelfHPDepend)
		end

		
		OWN:SetViewOffset(Vector(0,0,64))
		OWN:SetCurrentViewOffset(Vector(0,0,64))
		
		net.Start("KFPillNWRemove")
		net.WriteEntity(self)
		net.WriteEntity(OWN)
		net.WriteVector(Vector(0,0,64))
		net.Broadcast()

		self.ZedAnimation = -1
		self.ZedPlayingAnimation = false
		self.ZedPlayingGesture = false
		
		OWN:ResetHull()
		//OWN:SetCollisionBounds(Vector(-self.ZedHull.x,-self.ZedHull.y,0),Vector(self.ZedHull.x,self.ZedHull.y,self.ZedHull.z))

		OWN:SetStepSize(18)

		OWN:SetWalkSpeed(self.PlayerSpeed)
		OWN:SetRunSpeed(self.PlayerRunSpeed)
		OWN:SetJumpPower(self.PlayerJumpPower)
	end
end

if(CLIENT) then
	net.Receive("KFPillNWRemove",function()
		local TEMP_Ent = net.ReadEntity()
		local TEMP_EntOwn = net.ReadEntity()
		local TEMP_VPos = net.ReadVector()
		
		if(IsValid(TEMP_Ent)&&IsValid(TEMP_EntOwn)&&isvector(TEMP_VPos)) then
			TEMP_EntOwn:SetViewOffset(TEMP_VPos)
			TEMP_EntOwn:SetCurrentViewOffset(TEMP_VPos)
			
			TEMP_Ent.ZedAnimation = -1
			TEMP_Ent.ZedPlayingAnimation = false
			TEMP_Ent.ZedPlayingGesture = false
			
			TEMP_EntOwn:ResetHull()
				
			TEMP_EntOwn:SetStepSize(18)
			
			TEMP_EntOwn:SetWalkSpeed(TEMP_Ent.PlayerSpeed)
			TEMP_EntOwn:SetRunSpeed(TEMP_Ent.PlayerRunSpeed)
			TEMP_EntOwn:SetJumpPower(TEMP_Ent.PlayerJumpPower)
		end
	end)
end

function SWEP:Deploy()
	if(KFPillAllValid(self)) then
	
		timer.Create("KFBeZed_EnableSomething"..tostring(self),0.1,1,function()
			if(KFPillAllValid(self)) then
				if(SERVER) then
					if(self:GetOwner():GetMoveType()==MOVETYPE_NOCLIP) then
						self:GetOwner():SetMoveType( MOVETYPE_WALK )
					end
					
					if(self:GetOwner():FlashlightIsOn()) then
						self:GetOwner():Flashlight(false)
					end
					
					self.ZedPlayerOriginalModel = self:GetOwner():GetModel()
					
					self:GetOwner():SetModel(self.ZedModel)
					self:GetOwner():SetNWBool("BeZed_IsZed",true)
					
					self:GetOwner().MeleeFlySpeed = self.ZedMeleeForce
					local TEMP_HP = GetConVar("kf_npc_"..string.lower(self.ZedName).."_hp"):GetInt()
					
					local TEMP_SelfHPDepend = self:GetOwner():Health()/self:GetOwner():GetMaxHealth()
					self.PlayerHealth = self:GetOwner():GetMaxHealth()
					
					local TEMP_BaseHPVar = GetConVar("kf_npc_"..string.lower(self.ZedName).."_hp"):GetDefault()
					local TEMP_ModHPVar = tonumber(GetConVar("kf_npc_"..string.lower(self.ZedName).."_hp"):GetInt())
					
					self:GetOwner():SetMaxHealth(TEMP_ModHPVar)
					self:GetOwner():SetHealth(self:GetOwner():GetMaxHealth()*TEMP_SelfHPDepend)
					self.ZedHeadHealth = (self.ZedBaseHeadHealth*TEMP_SelfHPDepend)*(TEMP_BaseHPVar/TEMP_ModHPVar)

					self:GetOwner():SetNWString("BeZed_ZedName",self.ZedName)
					
					local TEMP_Head = self:GetOwner():GetAttachment(self:GetOwner():LookupAttachment("eye"))

					if(!isnumber(self.ZedEyePos)&&TEMP_Head!=nil) then
						local TEMP_VOF = TEMP_Head.Pos-self:GetOwner():GetPos()
						self:GetOwner():SetCurrentViewOffset(Vector(0,0,TEMP_VOF.z))
						self:GetOwner():SetViewOffset(Vector(0,0,TEMP_VOF.z))
					else
						self:GetOwner():SetCurrentViewOffset(Vector(0,0,self.ZedEyePos))
						self:GetOwner():SetViewOffset(Vector(0,0,self.ZedEyePos))
					end
					
					local TEMP_BodyString = ""
					
					for B=0, self:GetOwner():GetNumBodyGroups() do
						TEMP_BodyString = TEMP_BodyString.."0"
					end
						
					self:GetOwner():SetBodyGroups(TEMP_BodyString)
					self:GetOwner():SetMaterial("")
					self:GetOwner():SetSkin(0)
					
					
					self:KFPillAddMeleeAttacks()
					self:KFPillOwnerBecomeZedEvent()
				end
				
				self.PlayerSpeed = self:GetOwner():GetWalkSpeed()
				self.PlayerRunSpeed = self:GetOwner():GetRunSpeed()
				self.PlayerJumpPower = self:GetOwner():GetJumpPower()
				
				self.ZedAnimation = -1
				self.ZedPlayingAnimation = false
				self.ZedPlayingGesture = false
				
				self:GetOwner():SetWalkSpeed(self.ZedWalkSpeed)
				self:GetOwner():SetRunSpeed(self.ZedRunSpeed)
				self:GetOwner():SetJumpPower(self.ZedJumpPower)

				self:GetOwner():ResetHull()
				
				self:GetOwner():SetHull(Vector(-self.ZedHull.x,-self.ZedHull.y,0),Vector(self.ZedHull.x,self.ZedHull.y,self.ZedHull.z))
				self:GetOwner():SetCollisionBounds(Vector(-self.ZedHull.x,-self.ZedHull.y,0),Vector(self.ZedHull.x,self.ZedHull.y,self.ZedHull.z))
				
				if(SERVER) then
					net.Start("KFPillNWSetHull")
					net.WriteEntity(self)
					net.WriteVector(Vector(-self.ZedHull.x,-self.ZedHull.y,0))
					net.WriteVector(Vector(self.ZedHull.x,self.ZedHull.y,self.ZedHull.z))
					net.Send(self:GetOwner())
				end
				
				timer.Remove("KFBeZed_Kill"..tostring(self))
			end
			
		end)
		return true
	end
end

function SWEP:Think()
	if(SERVER) then
		if(KFPillAllValid(self)) then
			self:KFPillThink()
		end
		
		if(self.NextSVThink<CurTime()) then
			self.NextSVThink = CurTime()+0.3
			
			if(self.ChasingSoundEnabled==true&&self.ZedPlayingAnimation==false) then
				self:KFPillPlayVoiceRandom(self.ChasingSound.chance,self.ChasingSound.name,self.ChasingSound.min,self.ChasingSound.max)
			end
		end
	end
	
	if(CLIENT) then
		if(KFPillAllValid(self)) then
			self:KFPillThinkCL()
		end
	end
end

function SWEP:OnRemove()
	if(SERVER) then
		if(self.Removed!=true) then
			self:KFPillRemoveFunc()
			self.Removed = true
		end
	end
end

function SWEP:OnDrop()
	if(SERVER) then
		if(self.Removed!=true) then
			self:KFPillRemoveFunc(self.RealOwner)
			self.Removed = true
			
			self:Remove()
		end
	end
end

function SWEP:OwnerChanged()
	if(SERVER) then
		if(!IsValid(self:GetOwner())||!self:GetOwner():IsPlayer()) then
			if(self.Removed!=true) then
				self:KFPillRemoveFunc(self.RealOwner)
				self.Removed = true
				
				self:Remove()
				
			end
		end
	end
end
