local ActIndex = {
	[ "pistol" ] 		= ACT_HL2MP_IDLE_PISTOL,
	[ "smg" ] 			= ACT_HL2MP_IDLE_SMG1,
	[ "grenade" ] 		= ACT_HL2MP_IDLE_GRENADE,
	[ "ar2" ] 			= ACT_HL2MP_IDLE_AR2,
	[ "shotgun" ] 		= ACT_HL2MP_IDLE_SHOTGUN,
	[ "rpg" ]	 		= ACT_HL2MP_IDLE_RPG,
	[ "physgun" ] 		= ACT_HL2MP_IDLE_PHYSGUN,
	[ "crossbow" ] 		= ACT_HL2MP_IDLE_CROSSBOW,
	[ "melee" ] 		= ACT_HL2MP_IDLE_MELEE,
	[ "slam" ] 			= ACT_HL2MP_IDLE_SLAM,
	[ "normal" ]		= ACT_HL2MP_IDLE,
	[ "fist" ]			= ACT_HL2MP_IDLE_FIST,
	[ "melee2" ]		= ACT_HL2MP_IDLE_MELEE2,
	[ "passive" ]		= ACT_HL2MP_IDLE_PASSIVE,
	[ "knife" ]			= ACT_HL2MP_IDLE_KNIFE,
	[ "duel" ]			= ACT_HL2MP_IDLE_DUEL,
	[ "camera" ]		= ACT_HL2MP_IDLE_CAMERA,
	[ "magic" ]			= ACT_HL2MP_IDLE_MAGIC,
	[ "revolver" ]		= ACT_HL2MP_IDLE_REVOLVER
}

local TRANSTIME = -1

function SWEP:SetWeaponHoldType( t )
	t = string.lower( t )
	local index = ActIndex[ t ]
	
	if ( index == nil ) then
		t = "normal"
		index = ActIndex[ t ]
	end
	
	local TEMP_WalkAct = ACT_HL2MP_WALK
	local TEMP_RunAct = ACT_HL2MP_RUN
	
	if(self.ZedHeadLess==true&&self.ZedChangeStateOnHeadLoss==true) then
		TEMP_WalkAct = ACT_HL2MP_WALK_ANGRY
	end
	
	if(self.ZedCanSprint==false) then
		TEMP_RunAct = TEMP_WalkAct
	else
		if(KFPillAllValid(self)&&self:GetOwner():SelectWeightedSequence(TEMP_WalkAct)==-1) then
			TEMP_WalkAct = TEMP_RunAct
		end
	end
	
	self.ActivityTranslate = {}
	self.ActivityTranslate [ ACT_MP_STAND_IDLE ] 				= ACT_IDLE
	self.ActivityTranslate [ ACT_MP_WALK ] 						= TEMP_WalkAct
	self.ActivityTranslate [ ACT_MP_RUN ] 						= TEMP_RunAct
	self.ActivityTranslate [ ACT_MP_CROUCH_IDLE ] 				= ACT_IDLE
	self.ActivityTranslate [ ACT_MP_CROUCHWALK ] 				= TEMP_WalkAct
	self.ActivityTranslate [ ACT_MP_JUMP ] 						= ACT_HL2MP_JUMP_SLAM
	self.ActivityTranslate [ ACT_MP_SWIM ] 						= TEMP_WalkAct
	self.ActivityTranslate [ ACT_MP_SWIM_IDLE ]					= ACT_IDLE
	self.ActivityTranslate [ ACT_GMOD_NOCLIP_LAYER] 			= ACT_FLY
	
	

	self:SetupWeaponHoldTypeForAI( t )

end


function SWEP:TranslateActivity( act )
	
	if ( self:GetOwner():IsNPC() ) then
		if ( self.ActivityTranslateAI[ act ] ) then
			return self.ActivityTranslateAI[ act ]
		end
		return -1
	end

	if ( self.ActivityTranslate[ act ] != nil ) then
		return self.ActivityTranslate[ act ]
	end
	
	return -1

end