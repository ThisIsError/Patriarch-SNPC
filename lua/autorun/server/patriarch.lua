if( !GetConVar("kf_npc_ragdoll_dietime") ) then
	CreateConVar("kf_npc_ragdoll_dietime", 300, bit.bor(FCVAR_ARCHIVE, FCVAR_REPLICATED) ,[[Serverside zed corpse disappear after this amount of seconds. 0 - not disappear.]])
end


if( !GetConVar("kf_npc_patriarch_intro") ) then
	CreateConVar("kf_npc_patriarch_intro", 1, bit.bor(FCVAR_ARCHIVE, FCVAR_REPLICATED) ,[[Controls patriarch intro. 0 - none, 1 - intro, 2 - intro with camera.]])
end

if( !GetConVar("kf_npc_patriarch_hp") ) then
	CreateConVar("kf_npc_patriarch_hp", 4000, bit.bor(FCVAR_ARCHIVE, FCVAR_REPLICATED) ,[[Patriarch will have this amount of health on spawn.]])
end

if( !GetConVar("kf_npc_hp_per_player_enabled") ) then
	CreateConVar("kf_npc_hp_per_player_enabled", 1, bit.bor(FCVAR_ARCHIVE, FCVAR_REPLICATED) ,[[If set to 1, patriarch health will be increased depending on player count.]])
end

if( !GetConVar("kf_npc_difficulty")) then
	CreateConVar("kf_npc_difficulty", 2, bit.bor(FCVAR_ARCHIVE, FCVAR_REPLICATED) ,[[5 levels of difficulty. 0 - beginner, 1 - normal, 2 - hard, 3 - suicidal, 4 - hell on earth.]])
end

if( !GetConVar("kf_npc_hardmode")) then
	CreateConVar("kf_npc_hardmode", 0, bit.bor(FCVAR_ARCHIVE, FCVAR_REPLICATED) ,[[If set to 1, killing floor npc will have new abilities and will be harder.]])
end

if( !GetConVar("kf_npc_gore")) then
	CreateConVar("kf_npc_gore", 1, bit.bor(FCVAR_ARCHIVE, FCVAR_REPLICATED) ,[[If set to 1, killing floor npc can be dismembered sometimes.]])
end
if( !GetConVar("kf_pill_zed_friendly")) then
	CreateConVar("kf_pill_zed_friendly", 1, bit.bor(FCVAR_ARCHIVE, FCVAR_REPLICATED) ,[[Zeds will be friendly to player zed.]])
end

if( !GetConVar("kf_pill_player_friendly")) then
	CreateConVar("kf_pill_player_friendly", 1, bit.bor(FCVAR_ARCHIVE, FCVAR_REPLICATED) ,[[Player zed can't damage another player zed with melee attack.]])
end

if( !GetConVar("kf_npc_friendly_attack")) then
	CreateConVar("kf_npc_friendly_attack", 1, bit.bor(FCVAR_ARCHIVE, FCVAR_REPLICATED) ,[[If zed hurted by another zed they start fighting. Set to 0 to disable it.]])
end

if( !GetConVar("kf_nerf_player_speed")) then
	CreateConVar("kf_nerf_player_speed", 0, bit.bor(FCVAR_ARCHIVE, FCVAR_REPLICATED) ,[[Player speed will be greatly decreased.]])
end

if( !GetConVar("kf_npc_patriarch_santa")) then
	CreateConVar("kf_npc_patriarch_santa", 1, bit.bor(FCVAR_ARCHIVE, FCVAR_REPLICATED) ,[[Set to 1 to allow patriarch use robosanta model from 17 decembery to 14 january. 0 - not use, 2 - use always.]])
end

hook.Add("PlayerSpawn","KFNerSpeedSpawn",function(ply)
	if(GetConVar("kf_nerf_player_speed"):GetInt()==1) then
		timer.Simple(0.1,function()
			if(IsValid(ply)&&ply!=nil&&ply!=NULL) then
				ply:SetWalkSpeed(130)
				ply:SetRunSpeed(220)
			end
		end)
	end
end)

hook.Add("EntityTakeDamage","KFPatriachDamage", function( target, dmg )
	if(IsValid(dmg:GetAttacker())&&dmg:GetAttacker()!=NULL&&
	dmg:GetAttacker()!=nil&&dmg:GetAttacker():GetClass()=="ent_patriarchrocket") then
		if(IsValid(dmg:GetAttacker():GetOwner())&&dmg:GetAttacker():GetOwner()!=NULL&&
		dmg:GetAttacker():GetOwner()!=nil&&dmg:GetAttacker():GetOwner():GetClass()=="npc_kfmod_patriarch") then
			dmg:SetAttacker(dmg:GetAttacker():GetOwner())
		end
	end
		
	if(IsValid(dmg:GetInflictor())&&dmg:GetInflictor()!=NULL&&dmg:GetInflictor()!=nil&&
	dmg:GetInflictor():GetClass()=="env_explosion") then
		if(IsValid(dmg:GetInflictor():GetOwner())&&dmg:GetInflictor():GetOwner()!=NULL&&
		dmg:GetInflictor():GetOwner()!=nil&&(dmg:GetInflictor():GetOwner():GetClass()=="ent_patriarchrocket"||
		dmg:GetInflictor():GetOwner():GetClass()=="ent_planted_pipebomb")) then
			if(IsValid(dmg:GetInflictor():GetOwner():GetOwner())&&dmg:GetInflictor():GetOwner():GetOwner()!=NULL&&
			dmg:GetInflictor():GetOwner():GetOwner()!=nil&&(dmg:GetInflictor():GetOwner():GetOwner():GetClass()=="npc_kfmod_patriarch"||
			dmg:GetInflictor():GetOwner():GetOwner():IsPlayer())) then
				dmg:SetAttacker(dmg:GetInflictor():GetOwner():GetOwner())
				dmg:SetInflictor(dmg:GetInflictor():GetOwner())
			end
		end
	end


	if(IsValid(dmg:GetAttacker())&&dmg:GetAttacker()!=NULL&&dmg:GetAttacker()!=nil&&
	dmg:GetAttacker():GetClass()=="ent_patriarchgun"&&dmg:IsBulletDamage()) then
		if(IsValid(dmg:GetAttacker():GetOwner())&&dmg:GetAttacker():GetOwner()!=NULL&&dmg:GetAttacker():GetOwner()!=nil&&
		dmg:GetAttacker():GetOwner():GetClass()=="npc_kfmod_patriarch") then
			dmg:SetInflictor(dmg:GetAttacker())
			dmg:SetAttacker(dmg:GetInflictor():GetOwner())
		end
	end
	
	if(target:GetClass()=="prop_door_rotating"&&target:GetSaveTable( ).m_bLocked==true&&target:GetNWFloat("Welded",0)>0) then
		target:SetNWFloat("Welded",target:GetNWFloat("Welded",0)-dmg:GetDamage()/5)

		if(target:GetNWFloat("Welded",0)<1) then
			target:Fire("Open",0)
			target:Remove()
		end
	end
end)

hook.Add("ScaleNPCDamage","KFNPCHitboxDamage", function( npc, hitgr, dmg )
	if(npc.SNPCClass=="C_MONSTER_LAB") then
		npc.LastDamageHitgroup = hitgr
	end
end)


cvars.AddChangeCallback( "kf_npc_ragdoll_dietime", function( name, Cold, Cnew )
	if(!isnumber(tonumber(Cnew))) then
		if(isnumber(tonumber(Cold))) then
			GetConVar(name):SetInt(tonumber(Cold))
		else
			GetConVar(name):SetInt(300)
		end
	else
		if(tonumber(Cnew)>999999) then
			GetConVar(name):SetInt(999999)
		elseif(tonumber(Cnew)<0) then
			GetConVar(name):SetInt(0)
		elseif(math.floor(tonumber(Cnew))!=tonumber(Cnew)) then
			GetConVar(name):SetInt(tonumber(Cold))
		end
	end
end )

cvars.AddChangeCallback( "kf_npc_difficulty", function( name, Cold, Cnew )
	if(!isnumber(tonumber(Cnew))) then
		if(isnumber(tonumber(Cold))) then
			GetConVar(name):SetInt(tonumber(Cold))
		else
			GetConVar(name):SetInt(2)
		end
	else
		if(tonumber(Cnew)>4) then
			GetConVar(name):SetInt(4)
		elseif(tonumber(Cnew)<0) then
			GetConVar(name):SetInt(0)
		elseif(math.floor(tonumber(Cnew))!=tonumber(Cnew)) then
			GetConVar(name):SetInt(tonumber(Cold))
		end
	end
end )

cvars.AddChangeCallback( "kf_npc_hardmode", function( name, Cold, Cnew )
	if(!isnumber(tonumber(Cnew))) then
		if(isnumber(tonumber(Cold))) then
			GetConVar(name):SetInt(tonumber(Cold))
		else
			GetConVar(name):SetInt(0)
		end
	else
		if(tonumber(Cnew)>1) then
			GetConVar(name):SetInt(1)
		elseif(tonumber(Cnew)<0) then
			GetConVar(name):SetInt(0)
		elseif(math.floor(tonumber(Cnew))!=tonumber(Cnew)) then
			GetConVar(name):SetInt(tonumber(Cold))
		end
	end
end )

cvars.AddChangeCallback("kf_nerf_player_speed", function( name, Cold, Cnew )
	if(!isnumber(tonumber(Cnew))) then
		if(isnumber(tonumber(Cold))) then
			GetConVar(name):SetInt(tonumber(Cold))
		else
			GetConVar(name):SetInt(0)
		end
	else
		if(tonumber(Cnew)>1) then
			GetConVar(name):SetInt(1)
		elseif(tonumber(Cnew)<0) then
			GetConVar(name):SetInt(0)
		elseif(math.floor(tonumber(Cnew))!=tonumber(Cnew)) then
			GetConVar(name):SetInt(tonumber(Cold))
		end
	end
end )



cvars.AddChangeCallback( "kf_npc_gore", function( name, Cold, Cnew )
	if(!isnumber(tonumber(Cnew))) then
		if(isnumber(tonumber(Cold))) then
			GetConVar(name):SetInt(tonumber(Cold))
		else
			GetConVar(name):SetInt(1)
		end
	else
		if(tonumber(Cnew)>1) then
			GetConVar(name):SetInt(1)
		elseif(tonumber(Cnew)<0) then
			GetConVar(name):SetInt(0)
		elseif(math.floor(tonumber(Cnew))!=tonumber(Cnew)) then
			GetConVar(name):SetInt(tonumber(Cold))
		end
	end
end )

cvars.AddChangeCallback( "kf_pill_zed_friendly", function( name, Cold, Cnew )
	if(!isnumber(tonumber(Cnew))) then
		if(isnumber(tonumber(Cold))) then
			GetConVar(name):SetInt(tonumber(Cold))
		else
			GetConVar(name):SetInt(1)
		end
	else
		if(tonumber(Cnew)>1) then
			GetConVar(name):SetInt(1)
		elseif(tonumber(Cnew)<0) then
			GetConVar(name):SetInt(0)
		elseif(math.floor(tonumber(Cnew))!=tonumber(Cnew)) then
			GetConVar(name):SetInt(tonumber(Cold))
		end
	end
end )

cvars.AddChangeCallback( "kf_pill_player_friendly", function( name, Cold, Cnew )
	if(!isnumber(tonumber(Cnew))) then
		if(isnumber(tonumber(Cold))) then
			GetConVar(name):SetInt(tonumber(Cold))
		else
			GetConVar(name):SetInt(1)
		end
	else
		if(tonumber(Cnew)>1) then
			GetConVar(name):SetInt(1)
		elseif(tonumber(Cnew)<0) then
			GetConVar(name):SetInt(0)
		elseif(math.floor(tonumber(Cnew))!=tonumber(Cnew)) then
			GetConVar(name):SetInt(tonumber(Cold))
		end
	end
end )

cvars.AddChangeCallback( "kf_npc_hp_per_player_enabled", function( name, Cold, Cnew )
	if(!isnumber(tonumber(Cnew))) then
		if(isnumber(tonumber(Cold))) then
			GetConVar(name):SetInt(tonumber(Cold))
		else
			GetConVar(name):SetInt(1)
		end
	else
		if(tonumber(Cnew)>1) then
			GetConVar(name):SetInt(1)
		elseif(tonumber(Cnew)<-100) then
			GetConVar(name):SetInt(-100)
		elseif(math.floor(tonumber(Cnew))!=tonumber(Cnew)) then
			GetConVar(name):SetInt(tonumber(Cold))
		end
	end
end )

cvars.AddChangeCallback( "kf_npc_patriarch_intro", function( name, Cold, Cnew )
	if(!isnumber(tonumber(Cnew))) then
		if(isnumber(tonumber(Cold))) then
			GetConVar(name):SetInt(tonumber(Cold))
		else
			GetConVar(name):SetInt(1)
		end
	else
		if(tonumber(Cnew)>2) then
			GetConVar(name):SetInt(2)
		elseif(tonumber(Cnew)<0) then
			GetConVar(name):SetInt(0)
		elseif(math.floor(tonumber(Cnew))!=tonumber(Cnew)) then
			GetConVar(name):SetInt(tonumber(Cold))
		end
	end
end )

cvars.AddChangeCallback( "kf_npc_patriarch_santa", function( name, Cold, Cnew )
	if(!isnumber(tonumber(Cnew))) then
		if(isnumber(tonumber(Cold))) then
			GetConVar(name):SetInt(tonumber(Cold))
		else
			GetConVar(name):SetInt(1)
		end
	else
		if(tonumber(Cnew)>2) then
			GetConVar(name):SetInt(2)
		elseif(tonumber(Cnew)<0) then
			GetConVar(name):SetInt(0)
		elseif(math.floor(tonumber(Cnew))!=tonumber(Cnew)) then
			GetConVar(name):SetInt(tonumber(Cold))
		end
	end
end )

cvars.AddChangeCallback( "kf_npc_friendly_attack", function( name, Cold, Cnew )
	if(!isnumber(tonumber(Cnew))) then
		if(isnumber(tonumber(Cold))) then
			GetConVar(name):SetInt(tonumber(Cold))
		else
			GetConVar(name):SetInt(1)
		end
	else
		if(tonumber(Cnew)>1) then
			GetConVar(name):SetInt(1)
		elseif(tonumber(Cnew)<0) then
			GetConVar(name):SetInt(0)
		elseif(math.floor(tonumber(Cnew))!=tonumber(Cnew)) then
			GetConVar(name):SetInt(tonumber(Cold))
		end
	end
end )

cvars.AddChangeCallback( "kf_npc_patriarch_hp", function( name, Cold, Cnew )
	if(!isnumber(tonumber(Cnew))) then
		if(isnumber(tonumber(Cold))) then
			GetConVar(name):SetInt(tonumber(Cold))
		else
			GetConVar(name):SetInt(4000)
		end
	else
		if(tonumber(Cnew)>999999) then
			GetConVar(name):SetInt(999999)
		elseif(tonumber(Cnew)<10) then
			GetConVar(name):SetInt(10)
		elseif(math.floor(tonumber(Cnew))!=tonumber(Cnew)) then
			GetConVar(name):SetInt(tonumber(Cold))
		end
	end
end )

KFNPCCanCreateCLRagdolls = true

	

timer.Simple(0.1,function()
	local TEMP_ClearRagdollHook = hook.GetTable()["CreateClientsideRagdoll"]
	
	if(TEMP_ClearRagdollHook!=nil&&istable(TEMP_ClearRagdollHook)) then
		KFNPCCanCreateCLRagdolls = false
	end
end)