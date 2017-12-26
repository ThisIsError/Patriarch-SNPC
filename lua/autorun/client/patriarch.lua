local PatriarchMusic = nil
local LanguageChoosen = 0

hook.Add("Think","PatriarchMusic",function()
	if(IsValid(LocalPlayer())&&LocalPlayer()!=nil&&LocalPlayer()!=NULL) then
		if( !GetConVar("kf_npc_patriarch_music") ) then
			CreateClientConVar("kf_npc_patriarch_music", 1, true, false ,[[Patriarch theme will be played if set to 1.]])
		end
		
		if( !GetConVar("kf_pill_firstperson") ) then
			CreateClientConVar("kf_pill_firstperson", 0, true, false ,[[Enables firstperson when play as zed. Hard to control.]])
		end
		
		cvars.AddChangeCallback( "kf_npc_patriarch_music", function( name, Cold, Cnew )
			if(tonumber(Cnew)>1) then
				GetConVar(name):SetInt(1)
			elseif(tonumber(Cnew)<0) then
				GetConVar(name):SetInt(0)
			elseif(math.floor(tonumber(Cnew))!=tonumber(Cnew)) then
				GetConVar(name):SetInt(tonumber(Cold))
			end
		end )
		
		cvars.AddChangeCallback( "kf_pill_firstperson", function( name, Cold, Cnew )
			if(tonumber(Cnew)>1) then
				GetConVar(name):SetInt(1)
			elseif(tonumber(Cnew)<0) then
				GetConVar(name):SetInt(0)
			elseif(math.floor(tonumber(Cnew))!=tonumber(Cnew)) then
				GetConVar(name):SetInt(tonumber(Cold))
			end
		end )
		
		if(LanguageChoosen==0) then
			if(system.GetCountry()=="RU"||system.GetCountry()=="BY"||system.GetCountry()=="UK") then
				language.Add("npc_kfmod_patriarch", "Патриарх" )
				language.Add("ent_patriarchrocket", "Ракета" )
			else
				language.Add("npc_kfmod_patriarch", "Patriarch" )
				language.Add("ent_patriarchrocket", "Rocket" )
			end
			LanguageChoosen = 1
		end
		
		if(PatriarchMusic==nil) then
			PatriarchMusic = CreateSound( LocalPlayer(), "tripwire/killing floor/Music/KF_Abandon_All.wav")
		else
			if(#ents.FindByClass("npc_kfmod_patriarch")>0&&GetConVar("kf_npc_patriarch_music"):GetInt()>0) then
				if(!PatriarchMusic:IsPlaying()) then
					PatriarchMusic:Play()
				end
			else
				if(PatriarchMusic:IsPlaying()) then
					PatriarchMusic:Stop()
				end
			end
		end

		PatriarchMusic:ChangeVolume(GetConVar("snd_musicvolume"):GetFloat()*0.4)
	end
end)