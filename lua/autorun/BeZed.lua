

if SERVER then 
	AddCSLuaFile()
	util.AddNetworkString("KFPillFlashlight")
end

local HITGROUP_KFHEAD = 8

if(SERVER) then

	local CPill = FindMetaTable( "Weapon" )
	
	function CPill:KFPillCheckDamage(dmgtype,dmginfo)
		local TEMP_DMGHEADPOP, TEMP_DMGMUL = false, 1
		
		if(isnumber(self.DamageTypeMult[dmgtype])) then
			TEMP_DMGMUL = self.DamageTypeMult[dmgtype]
			
			if(dmgtype==DMG_BLAST) then TEMP_DMGHEADPOP = true end
			if(dmgtype==DMG_CRUSH) then TEMP_DMGHEADPOP = true end
			if(dmgtype==DMG_GENERIC) then TEMP_DMGHEADPOP = true end
			if(dmgtype==DMG_BULLET) then TEMP_DMGHEADPOP = true end
			if(dmgtype==DMG_VEHICLE) then TEMP_DMGHEADPOP = true end
			if(dmgtype==DMG_FALL) then TEMP_DMGHEADPOP = true end
			if(dmgtype==DMG_CLUB) then TEMP_DMGHEADPOP = true end
			if(dmgtype==DMG_SONIC) then TEMP_DMGHEADPOP = true end
			if(dmgtype==DMG_ALWAYSGIB) then TEMP_DMGHEADPOP = true end
			if(dmgtype==DMG_AIRBOAT) then TEMP_DMGHEADPOP = true end
			if(dmgtype==DMG_BLAST_SURFACE) then TEMP_DMGHEADPOP = true end
			if(dmgtype==DMG_BUCKSHOT) then TEMP_DMGHEADPOP = true end
			if(dmgtype==DMG_DIRECT) then TEMP_DMGHEADPOP = true end
			if(dmgtype==DMG_DISSOLVE) then TEMP_DMGHEADPOP = true end
			if(dmgtype==DMG_PLASMA) then TEMP_DMGHEADPOP = true end
		else
			if(!dmginfo:IsDamageType(dmgtype)) then
				TEMP_DMGMUL = self.DamageMultOther
			else
				local TEMP_DmgtypeCount = 0
				
				if(bit.band(dmgtype,DMG_BLAST)) then TEMP_DmgtypeCount = TEMP_DmgtypeCount+1  TEMP_DMGMUL = TEMP_DMGMUL+self.DamageTypeMult[DMG_BLAST] TEMP_DMGHEADPOP = true end
				if(bit.band(dmgtype,DMG_CRUSH)) then TEMP_DmgtypeCount = TEMP_DmgtypeCount+1 TEMP_DMGMUL = TEMP_DMGMUL+self.DamageTypeMult[DMG_CRUSH] TEMP_DMGHEADPOP = true end
				if(bit.band(dmgtype,DMG_GENERIC)) then TEMP_DmgtypeCount = TEMP_DmgtypeCount+1 TEMP_DMGMUL = TEMP_DMGMUL+self.DamageTypeMult[DMG_GENERIC] TEMP_DMGHEADPOP = true end
				if(bit.band(dmgtype,DMG_BULLET)) then TEMP_DmgtypeCount = TEMP_DmgtypeCount+1 TEMP_DMGMUL = TEMP_DMGMUL+self.DamageTypeMult[DMG_BULLET] TEMP_DMGHEADPOP = true end
				if(bit.band(dmgtype,DMG_SLASH)) then TEMP_DmgtypeCount = TEMP_DmgtypeCount+1 TEMP_DMGMUL = TEMP_DMGMUL+self.DamageTypeMult[DMG_SLASH] end
				if(bit.band(dmgtype,DMG_BURN)) then TEMP_DmgtypeCount = TEMP_DmgtypeCount+1 TEMP_DMGMUL = TEMP_DMGMUL+self.DamageTypeMult[DMG_BURN] end
				if(bit.band(dmgtype,DMG_VEHICLE)) then TEMP_DmgtypeCount = TEMP_DmgtypeCount+1 TEMP_DMGMUL = TEMP_DMGMUL+self.DamageTypeMult[DMG_VEHICLE] TEMP_DMGHEADPOP = true end
				if(bit.band(dmgtype,DMG_FALL)) then TEMP_DmgtypeCount = TEMP_DmgtypeCount+1 TEMP_DMGMUL = TEMP_DMGMUL+self.DamageTypeMult[DMG_FALL] TEMP_DMGHEADPOP = true end
				if(bit.band(dmgtype,DMG_CLUB)) then TEMP_DmgtypeCount = TEMP_DmgtypeCount+1 TEMP_DMGMUL = TEMP_DMGMUL+self.DamageTypeMult[DMG_CLUB] TEMP_DMGHEADPOP = true end
				if(bit.band(dmgtype,DMG_SHOCK)) then TEMP_DmgtypeCount = TEMP_DmgtypeCount+1 TEMP_DMGMUL = TEMP_DMGMUL+self.DamageTypeMult[DMG_SHOCK] end
				if(bit.band(dmgtype,DMG_SONIC)) then TEMP_DmgtypeCount = TEMP_DmgtypeCount+1 TEMP_DMGMUL = TEMP_DMGMUL+self.DamageTypeMult[DMG_SONIC] TEMP_DMGHEADPOP = true end
				if(bit.band(dmgtype,DMG_ENERGYBEAM)) then TEMP_DmgtypeCount = TEMP_DmgtypeCount+1 TEMP_DMGMUL = TEMP_DMGMUL+self.DamageTypeMult[DMG_ENERGYBEAM] end
				if(bit.band(dmgtype,DMG_NEVERGIB)) then TEMP_DmgtypeCount = TEMP_DmgtypeCount+1 TEMP_DMGMUL = TEMP_DMGMUL+self.DamageTypeMult[DMG_NEVERGIB] end
				if(bit.band(dmgtype,DMG_ALWAYSGIB)) then TEMP_DmgtypeCount = TEMP_DmgtypeCount+1 TEMP_DMGMUL = TEMP_DMGMUL+self.DamageTypeMult[DMG_ALWAYSGIB] TEMP_DMGHEADPOP = true end
				if(bit.band(dmgtype,DMG_DROWN)) then TEMP_DmgtypeCount = TEMP_DmgtypeCount+1 TEMP_DMGMUL = TEMP_DMGMUL+self.DamageTypeMult[DMG_DROWN] end
				if(bit.band(dmgtype,DMG_PARALYZE)) then TEMP_DmgtypeCount = TEMP_DmgtypeCount+1 TEMP_DMGMUL = TEMP_DMGMUL+self.DamageTypeMult[DMG_PARALYZE] end
				if(bit.band(dmgtype,DMG_NERVEGAS)) then TEMP_DmgtypeCount = TEMP_DmgtypeCount+1 TEMP_DMGMUL = TEMP_DMGMUL+self.DamageTypeMult[DMG_NERVEGAS] end
				if(bit.band(dmgtype,DMG_POISON)) then TEMP_DmgtypeCount = TEMP_DmgtypeCount+1 TEMP_DMGMUL = TEMP_DMGMUL+self.DamageTypeMult[DMG_POISON] end
				if(bit.band(dmgtype,DMG_ACID)) then TEMP_DmgtypeCount = TEMP_DmgtypeCount+1 TEMP_DMGMUL = TEMP_DMGMUL+self.DamageTypeMult[DMG_ACID] end
				if(bit.band(dmgtype,DMG_AIRBOAT)) then TEMP_DmgtypeCount = TEMP_DmgtypeCount+1 TEMP_DMGMUL = TEMP_DMGMUL+self.DamageTypeMult[DMG_AIRBOAT] TEMP_DMGHEADPOP = true end
				if(bit.band(dmgtype,DMG_BLAST_SURFACE)) then TEMP_DmgtypeCount = TEMP_DmgtypeCount+1 TEMP_DMGMUL = TEMP_DMGMUL+self.DamageTypeMult[DMG_BLAST_SURFACE] TEMP_DMGHEADPOP = true end
				if(bit.band(dmgtype,DMG_BUCKSHOT)) then TEMP_DmgtypeCount = TEMP_DmgtypeCount+1 TEMP_DMGMUL = TEMP_DMGMUL+self.DamageTypeMult[DMG_BUCKSHOT] TEMP_DMGHEADPOP = true end
				if(bit.band(dmgtype,DMG_DIRECT)) then TEMP_DmgtypeCount = TEMP_DmgtypeCount+1 TEMP_DMGMUL = TEMP_DMGMUL+self.DamageTypeMult[DMG_DIRECT] TEMP_DMGHEADPOP = true end
				if(bit.band(dmgtype,DMG_DISSOLVE)) then TEMP_DmgtypeCount = TEMP_DmgtypeCount+1 TEMP_DMGMUL = TEMP_DMGMUL+self.DamageTypeMult[DMG_DISSOLVE] TEMP_DMGHEADPOP = true end
				if(bit.band(dmgtype,DMG_DROWNRECOVER)) then TEMP_DmgtypeCount = TEMP_DmgtypeCount+1 TEMP_DMGMUL = TEMP_DMGMUL+self.DamageTypeMult[DMG_DROWNRECOVER] end
				if(bit.band(dmgtype,DMG_PHYSGUN)) then TEMP_DmgtypeCount = TEMP_DmgtypeCount+1 TEMP_DMGMUL = TEMP_DMGMUL+self.DamageTypeMult[DMG_PHYSGUN] end
				if(bit.band(dmgtype,DMG_PLASMA)) then TEMP_DmgtypeCount = TEMP_DmgtypeCount+1 TEMP_DMGMUL = TEMP_DMGMUL+self.DamageTypeMult[DMG_PLASMA] TEMP_DMGHEADPOP = true end
				if(bit.band(dmgtype,DMG_PREVENT_PHYSICS_FORCE)) then TEMP_DmgtypeCount = TEMP_DmgtypeCount+1 TEMP_DMGMUL = TEMP_DMGMUL+self.DamageTypeMult[DMG_PREVENT_PHYSICS_FORCE] end
				if(bit.band(dmgtype,DMG_RADIATION)) then TEMP_DmgtypeCount = TEMP_DmgtypeCount+1 TEMP_DMGMUL = TEMP_DMGMUL+self.DamageTypeMult[DMG_RADIATION] end
				if(bit.band(dmgtype,DMG_REMOVENORAGDOLL)) then TEMP_DmgtypeCount = TEMP_DmgtypeCount+1  TEMP_DMGMUL = TEMP_DMGMUL+self.DamageTypeMult[DMG_REMOVENORAGDOLL] end
				if(bit.band(dmgtype,DMG_SLOWBURN)) then TEMP_DmgtypeCount = TEMP_DmgtypeCount+1  TEMP_DMGMUL = TEMP_DMGMUL+self.DamageTypeMult[DMG_SLOWBURN] end
				
				if(TEMP_DmgtypeCount>0) then
					TEMP_DMGMUL = TEMP_DMGMUL/TEMP_DmgtypeCount
				end
			end
		end
		
		TEMP_DMGMUL = TEMP_DMGMUL*self.DamageMultAll
		
		return TEMP_DMGHEADPOP, TEMP_DMGMUL
	end
end

hook.Add( "CalcView", "KFBeZedCalcView", function( ply, pos, angles, fov )
	if(LocalPlayer():GetNWBool("BeZed_IsZed",false)==true&&LocalPlayer():Alive()) then
		local view = {}
		view.origin = pos
		view.angles = angles
		view.fov = fov
		
		
		if(GetConVar("kf_pill_firstperson"):GetInt()==1) then
			local TEMP_Attachment = LocalPlayer():GetAttachment(LocalPlayer():LookupAttachment("eye"))
			
			if(TEMP_Attachment) then
				view.origin = TEMP_Attachment.Pos+((-TEMP_Attachment.Ang:Right()*8)+(TEMP_Attachment.Ang:Forward()*3))
				view.angles = angles
				view.fov = 90
				view.drawviewer = true
			end
		else
			local TEMP_CamChange = (pos+Vector(0,0,30))-( (angles:Forward()*100)-angles:Right()*35 )
			
			local TEMP_BackTR = util.TraceHull( {
				start = pos,
				endpos = TEMP_CamChange,
				filter = LocalPlayer(),
				mins = Vector( -7, -7, -7 ),
				maxs = Vector( 7, 7, 7 ),
				mask = MASK_VISIBLE_AND_NPCS
			} )
			

			view.origin = TEMP_BackTR.HitPos
			view.angles = angles
			view.fov = fov
			view.drawviewer = true
		end
		
		return view
	end
end)

local CMoveData = FindMetaTable( "CMoveData" )
local CPlayer = FindMetaTable( "Player" )

function CMoveData:RemoveKeys( keys )
	local newbuttons = bit.band( self:GetButtons(), bit.bnot( keys ) )
	self:SetButtons( newbuttons )
end

function CPlayer:IsHoldingKFPill()
	local TEMP_WEP = self:GetActiveWeapon()
	
	if(IsValid(TEMP_WEP)&&TEMP_WEP!=nil&&TEMP_WEP!=NULL) then
		if(TEMP_WEP.IsKFPill==true) then
			return true, TEMP_WEP
		end
	end
	
	return false, nil
end


hook.Add("PlayerNoClip", "KFPillNoclipDisable", function( ply )
	if(ply:IsHoldingKFPill()) then
		return false 
	end
end)


hook.Add( "SetupMove", "KFBeZedKeys", function( ply, mvd, cmd )
	local TEMP_IsHoldingPill, TEMP_WEP = ply:IsHoldingKFPill()
	
	if(TEMP_IsHoldingPill) then
		
		if(mvd:KeyDown(IN_SPEED)) then
			if(SERVER) then
				if(KFPillAllValid(TEMP_WEP)) then
					TEMP_WEP:KFPillSprintEvent()
				end
			end
			
			if(TEMP_WEP.ZedCanSprint==false) then
				mvd:RemoveKeys(IN_SPEED)
			end
		end
		
		
		if(SERVER) then
			if((mvd:KeyDown(IN_MOVELEFT)||mvd:KeyDown(IN_MOVERIGHT)||mvd:KeyDown(IN_FORWARD)||mvd:KeyDown(IN_BACK))&&TEMP_WEP.ZedPlayingAnimation==false) then
				TEMP_WEP:KFPillMoving()
			else
				TEMP_WEP:KFPillNotMoving()
			end
		end
		
		if(mvd:KeyReleased(IN_SPEED)) then
			if(SERVER) then
				if(KFPillAllValid(TEMP_WEP)) then
					TEMP_WEP:KFPillSprintEventExit()
				end
			end
		end
		
		if(cmd:KeyDown(IN_DUCK)) then
			if(SERVER) then
				if(KFPillAllValid(TEMP_WEP)&&TEMP_WEP.ZedPlayingAnimation==false&&ply:IsOnGround()) then
					TEMP_WEP:KFPillFourthAttack()
				end
			end
			
			mvd:RemoveKeys(IN_DUCK)
		end
		
		if(cmd:KeyDown(IN_WALK)) then
			if(SERVER) then
				if(KFPillAllValid(TEMP_WEP)&&TEMP_WEP.ZedPlayingAnimation==false&&ply:IsOnGround()) then
					TEMP_WEP:KFPillFifthAttack()
				end
			end
			
			mvd:RemoveKeys(IN_WALK)
		end
		
		if(cmd:KeyDown(IN_JUMP)) then
			if(KFPillAllValid(TEMP_WEP)&&TEMP_WEP.ZedPlayingAnimation==true) then
				mvd:RemoveKeys(IN_JUMP)
			end
		end
		
		if ( TEMP_WEP.ZedPlayingAnimation==true&&TEMP_WEP.ZedPlayingGesture==false ) then
			mvd:SetMaxClientSpeed( 1 )
			//mvd:SetSideVelocity
		end
		
	end
end )

				

hook.Add("ScalePlayerDamage","KFBeZedDamageHitgroup",function(ply,hitgroup,dmginfo)
	if(SERVER) then
		local TEMP_IsHoldingPill, TEMP_WEP = ply:IsHoldingKFPill()
		
		if(TEMP_IsHoldingPill&&KFPillAllValid(TEMP_WEP)) then
			TEMP_WEP.ZedLastDamagedHitgroup = hitgroup
		end
	end
end)

hook.Add( "DoPlayerDeath", "KFBeZedDie", function( ply, att, dmginfo )
	if(SERVER) then
		local TEMP_IsHoldingPill, TEMP_WEP = ply:IsHoldingKFPill()

		if(TEMP_IsHoldingPill&&KFPillAllValid(TEMP_WEP)) then
			TEMP_WEP:GetOwner():Freeze(false)
			
			TEMP_WEP:GetOwner():SetMaterial("")
			
			local TEMP_DMGHEADPOP, TEMP_DMGMUL = TEMP_WEP:KFPillCheckDamage(dmginfo:GetDamageType(),dmginfo)
			local TEMP_MeatList = ""
			
			local TEMP_BoomDamage = dmginfo:IsExplosionDamage()
		
			local TEMP_ExpDamage, TEMP_ExpDamageFullDestroy = TEMP_WEP:KFPillSetExplosionDamage(dmginfo:GetDamageType())
			
			if(TEMP_BoomDamage==false&&TEMP_ExpDamage==true) then
				TEMP_BoomDamage = true
			end
			
			local TEMP_ExplosionRadius = (TEMP_WEP:GetPos()-dmginfo:GetDamagePosition()):Length()
			TEMP_ExplosionRadius = ((TEMP_ExplosionRadius*dmginfo:GetDamage())/(TEMP_ExplosionRadius*0.8))*0.3


			if(TEMP_WEP.ZedGore==1) then
				if(TEMP_WEP.GoreEnabled[HITGROUP_KFHEAD]&&((TEMP_WEP.ZedHeadLess==false&&
				((isnumber(TEMP_WEP.HitBoxLastDamage[HITGROUP_KFHEAD])&&TEMP_WEP.HitBoxLastDamage[HITGROUP_KFHEAD]>CurTime())||
				TEMP_BoomDamage))||TEMP_WEP.HeadLess==true)) then
					if(TEMP_WEP.HeadLess==false) then
						local TEMP_FirstBone = string.Explode(",",TEMP_WEP.GoreHead.bone)[1]
						local TEMP_FirstBonePos = TEMP_WEP:GetOwner():GetBonePosition(TEMP_WEP:GetOwner():LookupBone(TEMP_FirstBone))
						local TEMP_FirstBonePosSmall = TEMP_FirstBonePos:Distance(dmginfo:GetDamagePosition())<TEMP_ExplosionRadius
						
						
						if((TEMP_BoomDamage&&TEMP_FirstBonePosSmall)||TEMP_ExpDamageFullDestroy||!TEMP_BoomDamage) then
							TEMP_WEP:KFPillKillHead(TEMP_DMGHEADPOP,dmginfo:GetDamageForce(),dmginfo:GetDamage())
							sound.Play("KFMod.Gore"..math.random(1,8),TEMP_WEP:GetOwner():GetBonePosition(TEMP_WEP:GetOwner():LookupBone(TEMP_FirstBone)))
						end
					end
					
					TEMP_MeatList = KFNPCStringAdd(TEMP_MeatList,TEMP_WEP.GoreHead.bone)
				end
			
				if(TEMP_WEP.GoreEnabled[HITGROUP_LEFTLEG]&&(TEMP_BoomDamage||
				(isnumber(TEMP_WEP.HitBoxLastDamage[HITGROUP_LEFTLEG])&&TEMP_WEP.HitBoxLastDamage[HITGROUP_LEFTLEG]>CurTime()))) then
					local TEMP_FirstBone = string.Explode(",",TEMP_WEP.GoreLLeg.bone)[1]
					local TEMP_FirstBonePos = TEMP_WEP:GetOwner():GetBonePosition(TEMP_WEP:GetOwner():LookupBone(TEMP_FirstBone))
					local TEMP_FirstBonePosSmall = TEMP_FirstBonePos:Distance(dmginfo:GetDamagePosition())<TEMP_ExplosionRadius
					
					if((TEMP_BoomDamage&&TEMP_FirstBonePosSmall)||TEMP_ExpDamageFullDestroy||!TEMP_BoomDamage) then
						TEMP_MeatList = KFNPCStringAdd(TEMP_MeatList,TEMP_WEP.GoreLLeg.bone)
						TEMP_WEP:KFPillSetBodygoup(TEMP_WEP.GoreLLeg.bodygroup1)
						TEMP_WEP:KFPillCreateGib(TEMP_FirstBone, TEMP_WEP.GoreLLeg.model,dmginfo:GetDamageForce(),dmginfo:GetDamage(),true)
						KFNPCBleed(TEMP_WEP,math.random(13,15),TEMP_FirstBonePos,AngleRand())
						sound.Play("KFMod.Gore"..math.random(1,8),TEMP_WEP:GetOwner():GetBonePosition(TEMP_WEP:GetOwner():LookupBone(TEMP_FirstBone)))
					end
				end
				
				if(TEMP_WEP.GoreEnabled[HITGROUP_RIGHTLEG]&&(TEMP_BoomDamage||
				(isnumber(TEMP_WEP.HitBoxLastDamage[HITGROUP_RIGHTLEG])&&TEMP_WEP.HitBoxLastDamage[HITGROUP_RIGHTLEG]>CurTime()))) then
					local TEMP_FirstBone = string.Explode(",",TEMP_WEP.GoreRLeg.bone)[1]
					local TEMP_FirstBonePos = TEMP_WEP:GetOwner():GetBonePosition(TEMP_WEP:GetOwner():LookupBone(TEMP_FirstBone))
					local TEMP_FirstBonePosSmall = TEMP_FirstBonePos:Distance(dmginfo:GetDamagePosition())<TEMP_ExplosionRadius
					
					if((TEMP_BoomDamage&&TEMP_FirstBonePosSmall)||TEMP_ExpDamageFullDestroy||!TEMP_BoomDamage) then
						TEMP_MeatList = KFNPCStringAdd(TEMP_MeatList,TEMP_WEP.GoreRLeg.bone)
						TEMP_WEP:KFPillSetBodygoup(TEMP_WEP.GoreRLeg.bodygroup1)
						TEMP_WEP:KFPillCreateGib(TEMP_FirstBone,TEMP_WEP.GoreRLeg.model,dmginfo:GetDamageForce(),dmginfo:GetDamage(),true)
						KFNPCBleed(TEMP_WEP,math.random(13,15),TEMP_FirstBonePos,AngleRand())
						sound.Play("KFMod.Gore"..math.random(1,8),TEMP_WEP:GetOwner():GetBonePosition(TEMP_WEP:GetOwner():LookupBone(TEMP_FirstBone)))
					end
				end
				
				if(TEMP_WEP.GoreEnabled[HITGROUP_LEFTARM]&&(TEMP_BoomDamage||
				(isnumber(TEMP_WEP.HitBoxLastDamage[HITGROUP_LEFTARM])&&TEMP_WEP.HitBoxLastDamage[HITGROUP_LEFTARM]>CurTime()))) then
					local TEMP_FirstBone = string.Explode(",",TEMP_WEP.GoreLArm.bone)[1]
					local TEMP_FirstBonePos = TEMP_WEP:GetOwner():GetBonePosition(TEMP_WEP:GetOwner():LookupBone(TEMP_FirstBone))
					local TEMP_FirstBonePosSmall = TEMP_FirstBonePos:Distance(dmginfo:GetDamagePosition())<TEMP_ExplosionRadius
					
					if((TEMP_BoomDamage&&TEMP_FirstBonePosSmall)||TEMP_ExpDamageFullDestroy||!TEMP_BoomDamage) then
						TEMP_MeatList = KFNPCStringAdd(TEMP_MeatList,TEMP_WEP.GoreLArm.bone)
						TEMP_WEP:KFPillSetBodygoup(TEMP_WEP.GoreLArm.bodygroup1)
						TEMP_WEP:KFPillCreateGib(TEMP_FirstBone,TEMP_WEP.GoreLArm.model,dmginfo:GetDamageForce(),dmginfo:GetDamage(),true)
						KFNPCBleed(TEMP_WEP,math.random(13,15),TEMP_FirstBonePos,AngleRand())
						sound.Play("KFMod.Gore"..math.random(1,8),TEMP_WEP:GetOwner():GetBonePosition(TEMP_WEP:GetOwner():LookupBone(TEMP_FirstBone)))
					end
				end
				
				if(TEMP_WEP.GoreEnabled[HITGROUP_RIGHTARM]&&(TEMP_BoomDamage||
				(isnumber(TEMP_WEP.HitBoxLastDamage[HITGROUP_RIGHTARM])&&TEMP_WEP.HitBoxLastDamage[HITGROUP_RIGHTARM]>CurTime()))) then
					local TEMP_FirstBone = string.Explode(",",TEMP_WEP.GoreRArm.bone)[1]
					local TEMP_FirstBonePos = TEMP_WEP:GetOwner():GetBonePosition(TEMP_WEP:GetOwner():LookupBone(TEMP_FirstBone))
					local TEMP_FirstBonePosSmall = TEMP_FirstBonePos:Distance(dmginfo:GetDamagePosition())<TEMP_ExplosionRadius
					
					if((TEMP_BoomDamage&&TEMP_FirstBonePosSmall)||TEMP_ExpDamageFullDestroy||!TEMP_BoomDamage) then
						TEMP_MeatList = KFNPCStringAdd(TEMP_MeatList,TEMP_WEP.GoreRArm.bone)
						TEMP_WEP:KFPillSetBodygoup(TEMP_WEP.GoreRArm.bodygroup1)
						TEMP_WEP:KFPillCreateGib(TEMP_FirstBone,TEMP_WEP.GoreRArm.model,dmginfo:GetDamageForce(),dmginfo:GetDamage(),true)
						KFNPCBleed(TEMP_WEP,math.random(13,15),TEMP_FirstBonePos,AngleRand())
						sound.Play("KFMod.Gore"..math.random(1,8),TEMP_WEP:GetOwner():GetBonePosition(TEMP_WEP:GetOwner():LookupBone(TEMP_FirstBone)))
					end
				end
			end
			
			local TEMP_IsCreateRagdoll = TEMP_WEP:KFPillOnCreateRagdoll(dmginfo,TEMP_BoomDamage)
			
			
			if(TEMP_IsCreateRagdoll==true) then
				
				TEMP_WEP:KFPillStopPreviousSound()
				
				if(TEMP_WEP.DieSoundEnabled==true) then
					TEMP_WEP:KFPillPlayVoiceRandom(100,TEMP_WEP.DieSound.name,TEMP_WEP.DieSound.min,TEMP_WEP.DieSound.max)
				end
				
				local TEMP_BodyString = ""
						
				for B=0, TEMP_WEP:GetOwner():GetNumBodyGroups() do
					TEMP_BodyString = TEMP_BodyString..TEMP_WEP:GetOwner():GetBodygroup(B)
				end
				
				TEMP_WEP:GetOwner().KFRagdoll = TEMP_BodyString
			else
				TEMP_WEP:GetOwner().KFRagdoll = -1
			end
		end
	end
end)

hook.Add("PostPlayerDeath","KFBeZedDeathRagdoll",function(ply)
	if(SERVER) then
		local TEMP_RAGDOLL = ply:GetRagdollEntity()
		
		if(isentity(TEMP_RAGDOLL)) then
			if(ply.KFRagdoll==-1) then
				TEMP_RAGDOLL:Remove()
			elseif(isstring(ply.KFRagdoll)) then
				TEMP_RAGDOLL:SetBodyGroups(ply.KFRagdoll)
			end
		end
		
		ply.KFRagdoll = nil
	end
end)

hook.Add("PlayerSpawn","KFBeZedSpawn",function(ply)
	if(SERVER) then
		ply:UnSpectate()
	end
end)

hook.Add("EntityTakeDamage","KFBeZedDamage",function(ply,dmginfo)
	if(SERVER) then
		if(ply:IsPlayer()) then
			local TEMP_IsHoldingPill, TEMP_WEP = ply:IsHoldingKFPill()
			
			if(TEMP_IsHoldingPill&&KFPillAllValid(TEMP_WEP)) then
				
				if(dmginfo:IsFallDamage()) then
					dmginfo:SetDamage(0)
				end
				
				local TEMP_RealInflictor = dmginfo:GetInflictor()
				local TEMP_RealAttacker = dmginfo:GetAttacker()
				
				
				if(!IsValid(TEMP_RealAttacker)&&IsValid(TEMP_RealInflictor)) then
					TEMP_RealAttacker = TEMP_RealInflictor
				end
				
				if(IsValid(TEMP_RealAttacker)&&!IsValid(TEMP_RealInflictor)) then
					TEMP_RealInflictor = TEMP_RealAttacker
				end
				
				if(IsValid(TEMP_RealAttacker)&&TEMP_RealAttacker:IsVehicle()&&IsValid(TEMP_RealAttacker:GetDriver())) then
					TEMP_RealAttacker = TEMP_RealAttacker:GetDriver()
				end

				
				if(IsValid(TEMP_RealInflictor)&&IsValid(TEMP_RealAttacker)&&TEMP_RealAttacker==TEMP_RealInflictor&&
				(TEMP_RealInflictor:IsPlayer()||TEMP_RealInflictor:IsNPC())) then
					if(IsValid(TEMP_RealInflictor:GetActiveWeapon())) then
						TEMP_RealAttacker = TEMP_RealInflictor
						TEMP_RealInflictor = TEMP_RealInflictor:GetActiveWeapon()
					end
				end
				
				if(!IsValid(TEMP_RealInflictor)&&!IsValid(TEMP_RealAttacker)) then
					TEMP_RealInflictor = TEMP_WEP:GetOwner()
					TEMP_RealAttacker = TEMP_WEP:GetOwner()
				end
				
				dmginfo:SetInflictor(TEMP_RealInflictor)
				dmginfo:SetAttacker(TEMP_RealAttacker)
				
				local TEMP_DMGHEADPOP, TEMP_DMGMUL = TEMP_WEP:KFPillCheckDamage(dmginfo:GetDamageType(),dmginfo)

	
				
				if(TEMP_WEP.ZedLastDamagedHitgroup==0||TEMP_WEP.ZedLastDamagedHitgroup==-1) then
					local TEMP_HitTracer = util.TraceLine( {
						start = dmginfo:GetDamagePosition(),
						endpos = dmginfo:GetDamagePosition()+(dmginfo:GetDamageForce()*100),
						ignoreworld = true,
						filter = function( ent ) if ( ent==TEMP_WEP:GetOwner() ) then return true end end
					} )
				
					
					if(TEMP_HitTracer.Hit) then
						TEMP_WEP.ZedLastDamagedHitgroup = TEMP_HitTracer.HitGroup
					end
				end
				
				
				if(TEMP_WEP.ZedLastDamagedHitgroup==0||TEMP_WEP.ZedLastDamagedHitgroup==-1) then
					local TEMP_NearestPoint = TEMP_WEP:GetOwner():NearestPoint(dmginfo:GetDamagePosition())
					
					local TEMP_HitTracer = util.TraceHull( {
						start = TEMP_NearestPoint,
						endpos = TEMP_NearestPoint,
						ignoreworld = true,
						mins = Vector(100,100,100),
						maxs = Vector(100,100,100),
						filter = function( ent ) if ( ent==TEMP_WEP:GetOwner() ) then return true end end
					} )
					
					if(TEMP_HitTracer.Hit) then
						TEMP_WEP.ZedLastDamagedHitgroup = TEMP_HitTracer.HitGroup
					end
				end
				
				if(TEMP_WEP.ZedLastDamagedHitgroup==0||TEMP_WEP.ZedLastDamagedHitgroup==-1) then
					if(IsValid(TEMP_RealInflictor)&&TEMP_RealInflictor!=nil&&TEMP_RealInflictor!=NULL&&
					isentity(TEMP_RealInflictor)&&!TEMP_RealInflictor:IsWeapon()) then
						local TEMP_InflictorHullMin, TEMP_InflictorHullMax = TEMP_RealInflictor:GetCollisionBounds()
						
						local TEMP_HitTracer = util.TraceHull( {
							start = TEMP_RealInflictor:GetPos(),
							endpos = TEMP_RealInflictor:GetPos()+(TEMP_RealInflictor:GetForward()*100),
							ignoreworld = true,
							mins = TEMP_InflictorHullMin*1.3,
							maxs = TEMP_InflictorHullMax*1.3,
							filter = function( ent ) if ( ent==TEMP_WEP:GetOwner() ) then return true end end
						} )
					
						if(TEMP_HitTracer.Hit) then
							TEMP_WEP.ZedLastDamagedHitgroup = TEMP_HitTracer.HitGroup
						end
					end
				end
				
				if(TEMP_WEP.ZedHeadLess==false) then
					if(TEMP_WEP.ZedLastDamagedHitgroup==8) then
						if(isnumber(TEMP_RealInflictor.KFHeadshootMultiplier)) then
							TEMP_DMGMUL = TEMP_DMGMUL*TEMP_RealInflictor.KFHeadshootMultiplier
						else
							TEMP_DMGMUL = TEMP_DMGMUL*1.25
						end
					end
				end
				
				if(TEMP_WEP.ZedLastDamagedHitgroup!=0||TEMP_WEP.ZedLastDamagedHitgroup!=-1) then
					TEMP_WEP.HitBoxLastDamage[TEMP_WEP.ZedLastDamagedHitgroup] = CurTime()+0.1
				end
				
				local TEMP_RealMul = TEMP_DMGMUL
				
				TEMP_DMGMUL = TEMP_WEP:KFPillDamageTake(dmginfo,dmginfo:GetDamage()*TEMP_DMGMUL,TEMP_DMGMUL,
				TEMP_RealAttacker,TEMP_RealInflictor)
				
				if(TEMP_DMGMUL==nil) then
					TEMP_DMGMUL = TEMP_RealMul
				end
				
				if(TEMP_WEP.ZedHeadLess==false&&TEMP_WEP.ZedLastDamagedHitgroup==8) then
					if(TEMP_WEP.GoreEnabled[HITGROUP_KFHEAD]) then
						TEMP_WEP.ZedHeadHealth = TEMP_WEP.ZedHeadHealth-(dmginfo:GetDamage()*TEMP_DMGMUL)
						
						if(TEMP_WEP.ZedHeadHealth<1) then
							if(TEMP_WEP.ZedGore==1) then
								TEMP_WEP:KFPillKillHead(TEMP_DMGHEADPOP,dmginfo:GetDamageForce(),dmginfo:GetDamage(),TEMP_RealAttacker,TEMP_RealInflictor)
							else
								local TEMP_FirstHeadBone = string.Explode(",",TEMP_WEP.GoreHead.bone)[1]
								sound.Play("KFMod.GoreDecap"..math.random(1,4),TEMP_WEP:GetOwner():GetBonePosition(TEMP_WEP:GetOwner():LookupBone(TEMP_FirstHeadBone)))
								TEMP_WEP.ZedHeadLess = true
								
								TEMP_WEP:KFPillOnHeadLoss()
							end
							
							if(TEMP_WEP.ZedDieOnHeadLoss==false) then
								local TEMP_HeadLossDamage = DamageInfo()
								TEMP_HeadLossDamage:SetDamageForce(dmginfo:GetDamageForce())
								TEMP_HeadLossDamage:SetDamagePosition(dmginfo:GetDamagePosition())
								TEMP_HeadLossDamage:SetDamageType(dmginfo:GetDamageType())
								TEMP_HeadLossDamage:SetDamage(TEMP_WEP:GetOwner():GetMaxHealth()/3)
								TEMP_HeadLossDamage:SetAttacker(TEMP_RealAttacker)
								TEMP_HeadLossDamage:SetInflictor(TEMP_RealInflictor)
								TEMP_WEP:TakeDamageInfo(TEMP_HeadLossDamage)
							else
								TEMP_WEP:GetOwner():SetHealth(-1)
								
								
								local TEMP_DMG = DamageInfo()
								
								TEMP_DMG:SetDamageType(DMG_POISON)
								TEMP_DMG:SetDamage(TEMP_WEP:GetOwner():GetMaxHealth())
								TEMP_DMG:SetDamageForce(TEMP_WEP:GetVelocity())
								TEMP_DMG:SetDamagePosition(TEMP_WEP:GetPos())
								TEMP_DMG:SetAttacker(TEMP_RealAttacker)
								TEMP_DMG:SetInflictor(TEMP_RealInflictor)
								TEMP_WEP:TakeDamageInfo(TEMP_DMG)
							end
							
							TEMP_WEP:GetOwner():RemoveAllDecals()
							
							if(TEMP_WEP.ZedStunOnHeadLoss) then
								TEMP_WEP:KFPillStun(TEMP_WEP.ZedStunGesture)
							else
								TEMP_WEP:KFPillFlinch(TEMP_WEP.ZedFlinchGesture)
							end
						end
					end
					
					local TEMP_DMGSND = "KFMod.ImpactSkull"..math.random(1,5)
					sound.Play( Sound(TEMP_DMGSND), TEMP_WEP:GetPos() )		
				end
				
				if(TEMP_WEP.PainSoundEnabled==true) then
					TEMP_WEP:KFPillPlayVoiceRandom(30,TEMP_WEP.PainSound.name,TEMP_WEP.PainSound.min,TEMP_WEP.PainSound.max)
				end

				if(dmginfo:GetDamage()*TEMP_DMGMUL>TEMP_WEP.ZedFlinchDamage-1&&(dmginfo:GetDamage()*TEMP_DMGMUL<TEMP_WEP.ZedStunDamage+1||
				TEMP_WEP.ZedStunDamage==0)&&TEMP_WEP.ZedFlinchDamage>0) then
					TEMP_WEP:KFPillFlinch(TEMP_WEP.ZedFlinchGesture)
				elseif(dmginfo:GetDamage()*TEMP_DMGMUL>TEMP_WEP.ZedStunDamage-1&&TEMP_WEP.ZedStunDamage>0&&TEMP_WEP.ZedHeadLess==false) then
					TEMP_WEP:KFPillStun(TEMP_WEP.ZedStunGesture)
				end
				
				dmginfo:SetDamage(dmginfo:GetDamage()*TEMP_DMGMUL)
				
				if(TEMP_WEP:GetOwner():Health()-dmginfo:GetDamage()>0) then
					TEMP_WEP.ZedLastDamagedHitgroup = 0
				end
			end
		end
	end
end)

hook.Add("CanPlayerEnterVehicle","KFBeZedEnterVehicle",function( ply )
	if(SERVER) then
		if(ply:IsHoldingKFPill()) then
			return false
		end
	end
end)


hook.Add("PlayerSwitchFlashlight","KFBeZedTurnFlashlight",function( ply )
	if(ply:IsHoldingKFPill()&&!ply:FlashlightIsOn()) then
		net.Start("KFPillFlashlight")
		net.WriteEntity(ply:GetActiveWeapon())
		net.Send(ply)
		
		return false
	end
	
end)
