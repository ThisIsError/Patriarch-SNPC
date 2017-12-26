local Category = "Killing Floor Zeds"
local VoiceHearDist = 350

local NPC = {
	Name = "Patriarch", 
	Class = "npc_kfmod_patriarch",			
	Category = Category	
}

list.Set( "NPC", "npc_kfmod_patriarch", NPC )


if(CLIENT) then
	surface.CreateFont( "HuskGunChargeFont", {
		font = "Arial",
		extended = false,
		size = 50,
		weight = 500,
		blursize = 0,
		scanlines = 0,
		antialias = true,
		underline = false,
		italic = false,
		strikeout = false,
		symbol = false,
		rotary = false,
		shadow = false,
		additive = false,
		outline = false,
	} )
end

function AddFootstepSounds(NAME,IMIN,IMAX,PATH)
	for S=IMIN, IMAX do
		sound.Add( {
			name = NAME,
			channel = CHAN_BODY,
			volume = 0.15,
			level = 70,
			pitch = { 95, 105 },
			sound = PATH..S..".wav"
		} )
	end
end

function AddSoundInterval(NAME,IMIN,IMAX,CHAN,VOL,LEV,PITMIN,PITMAX,PATH)
	for S=IMIN, IMAX do
		sound.Add( {
			name = NAME..S,
			channel = CHAN,
			volume = VOL,
			level = LEV,
			pitch = { PITMIN, PITMAX },
			sound = PATH..S..".wav"
		} )
	end
end

AddSoundInterval("KFMod.Patriarch.Awake",1,7,CHAN_VOICE,1,VoiceHearDist,98,102,"Tripwire/Killing Floor/Patriarch/VoiceIntro/Intro")
AddSoundInterval("KFMod.Patriarch.Scream",1,6,CHAN_VOICE,1,VoiceHearDist,98,102,"Tripwire/Killing Floor/Patriarch/VoiceIntro/Scream")
AddSoundInterval("KFMod.Patriarch.Heal",1,4,CHAN_VOICE,1,VoiceHearDist,98,102,"Tripwire/Killing Floor/Patriarch/VoiceHeal/Heal")
AddSoundInterval("KFMod.Patriarch.WarnRadial",1,2,CHAN_VOICE,1,360,98,102,"Tripwire/Killing Floor/Patriarch/VoiceMelee/Radial")
AddSoundInterval("KFMod.Patriarch.KnockDown",1,7,CHAN_VOICE,1,VoiceHearDist,98,102,"Tripwire/Killing Floor/Patriarch/VoiceKnock/KnockDown")
AddSoundInterval("KFMod.Patriarch.Pain",1,12,CHAN_VOICE,1,VoiceHearDist,98,102,"Tripwire/Killing Floor/Patriarch/VoicePain/Pain")
AddSoundInterval("KFMod.Patriarch.Die",1,6,CHAN_VOICE,1,VoiceHearDist,98,102,"Tripwire/Killing Floor/Patriarch/VoiceDeath/Death")
AddSoundInterval("KFMod.Patriarch.WarnMelee",1,9,CHAN_VOICE,1,VoiceHearDist,98,102,"Tripwire/Killing Floor/Patriarch/VoiceMelee/Melee")
AddSoundInterval("KFMod.Patriarch.RadialEnd",1,3,CHAN_VOICE,1,VoiceHearDist,98,102,"Tripwire/Killing Floor/Patriarch/VoiceTaunt/Radial")
AddSoundInterval("KFMod.Patriarch.WarnMinigun",1,4,CHAN_VOICE,1,VoiceHearDist,98,102,"Tripwire/Killing Floor/Patriarch/VoiceGunReady/Minigun")
AddSoundInterval("KFMod.Patriarch.Chase",1,11,CHAN_VOICE,1,VoiceHearDist,98,102,"Tripwire/Killing Floor/Patriarch/VoiceChase/Chase")
AddSoundInterval("KFMod.Patriarch.Idle",1,7,CHAN_VOICE,1,VoiceHearDist,98,102,"Tripwire/Killing Floor/Patriarch/VoiceIdle/Idle")
AddSoundInterval("KFMod.Patriarch.WarnRocket",1,2,CHAN_VOICE,1,VoiceHearDist,98,102,"Tripwire/Killing Floor/Patriarch/VoiceGunReady/Rocket")


AddSoundInterval("KFMod.PatriarchSanta.Awake",1,8,CHAN_VOICE,1,VoiceHearDist,98,102,"Tripwire/Killing Floor/Patriarch_Santa/VoiceIntro/Intro")
AddSoundInterval("KFMod.PatriarchSanta.Scream",1,6,CHAN_VOICE,1,VoiceHearDist,98,102,"Tripwire/Killing Floor/Patriarch_Santa/VoiceIntro/Scream")
AddSoundInterval("KFMod.PatriarchSanta.Heal",1,4,CHAN_VOICE,1,VoiceHearDist,98,102,"Tripwire/Killing Floor/Patriarch_Santa/VoiceHeal/Heal")
AddSoundInterval("KFMod.PatriarchSanta.WarnRadial",1,2,CHAN_VOICE,1,360,98,102,"Tripwire/Killing Floor/Patriarch_Santa/VoiceMelee/Radial")
AddSoundInterval("KFMod.PatriarchSanta.KnockDown",1,7,CHAN_VOICE,1,VoiceHearDist,98,102,"Tripwire/Killing Floor/Patriarch_Santa/VoiceKnock/KnockDown")
AddSoundInterval("KFMod.PatriarchSanta.Pain",1,12,CHAN_VOICE,1,VoiceHearDist,98,102,"Tripwire/Killing Floor/Patriarch_Santa/VoicePain/Pain")
AddSoundInterval("KFMod.PatriarchSanta.Die",1,6,CHAN_VOICE,1,VoiceHearDist,98,102,"Tripwire/Killing Floor/Patriarch_Santa/VoiceDeath/Death")
AddSoundInterval("KFMod.PatriarchSanta.WarnMelee",1,9,CHAN_VOICE,1,VoiceHearDist,98,102,"Tripwire/Killing Floor/Patriarch_Santa/VoiceMelee/Melee")
AddSoundInterval("KFMod.PatriarchSanta.RadialEnd",1,5,CHAN_VOICE,1,VoiceHearDist,98,102,"Tripwire/Killing Floor/Patriarch_Santa/VoiceTaunt/Radial")
AddSoundInterval("KFMod.PatriarchSanta.WarnMinigun",1,8,CHAN_VOICE,1,VoiceHearDist,98,102,"Tripwire/Killing Floor/Patriarch_Santa/VoiceGunReady/Minigun")
AddSoundInterval("KFMod.PatriarchSanta.Chase",1,24,CHAN_VOICE,1,VoiceHearDist,98,102,"Tripwire/Killing Floor/Patriarch_Santa/VoiceChase/Chase")
AddSoundInterval("KFMod.PatriarchSanta.Idle",1,7,CHAN_VOICE,1,VoiceHearDist,98,102,"Tripwire/Killing Floor/Patriarch_Santa/VoiceIdle/Idle")
AddSoundInterval("KFMod.PatriarchSanta.WarnRocket",1,2,CHAN_VOICE,1,VoiceHearDist,98,102,"Tripwire/Killing Floor/Patriarch_Santa/VoiceGunReady/Rocket")


sound.Add( {
	name = "KFMod.Patriarch.Idle1",
	channel = CHAN_VOICE,
	volume = 1.0,
	level = VoiceHearDist,
	pitch = { 98, 102 },
	sound = "Tripwire/Killing Floor/Patriarch/VoiceIdle/Idle1.wav"
} )


sound.Add( {
	name = "KFMod.Patriarch.MinigunLoad",
	channel = CHAN_WEAPON,
	volume = 1.0,
	level = 90,
	pitch = { 98, 102 },
	sound = "Tripwire/Killing Floor/Patriarch/WEP_MinigunStart.wav"
} )

sound.Add( {
	name = "KFMod.Patriarch.MinigunShoot",
	channel = CHAN_WEAPON,
	volume = 1.0,
	level = 90,
	pitch = { 98, 102 },
	sound = "Tripwire/Killing Floor/Patriarch/WEP_MinigunShooting.wav"
} )

sound.Add( {
	name = "KFMod.Patriarch.MinigunUnload",
	channel = CHAN_WEAPON,
	volume = 1.0,
	level = 90,
	pitch = { 98, 102 },
	sound = "Tripwire/Killing Floor/Patriarch/WEP_MinigunEnd.wav"
} )

sound.Add( {
	name = "KFMod.Patriarch.RocketLoad",
	channel = CHAN_WEAPON,
	volume = 1.0,
	level = 90,
	pitch = { 98, 102 },
	sound = "Tripwire/Killing Floor/Patriarch/WEP_RocketStart.wav"
} )

sound.Add( {
	name = "KFMod.RocketShoot",
	channel = CHAN_WEAPON,
	volume = 1.0,
	level = 90,
	pitch = { 98, 102 },
	sound = "Tripwire/Killing Floor/Patriarch/WEP_RocketShooting.wav"
} )

sound.Add( {
	name = "KFMod.Welder.Fire",
	channel = CHAN_WEAPON,
	volume = 1.0,
	level = 130,
	pitch = { 98, 102 },
	sound = "Tripwire/Killing Floor/Weapons/Welder/Fire.wav"
} )

AddSoundInterval("KFMod.LightSwing",1,4,CHAN_ITEM,1,WeaponHearDist,98,102,"Tripwire/Killing Floor/LightSwing")
AddSoundInterval("KFMod.HeavySwing",1,4,CHAN_ITEM,1,WeaponHearDist,98,102,"Tripwire/Killing Floor/HeavySwing")

AddSoundInterval("KFMod.StrongHit",1,6,CHAN_BODY,1,DamageHearDist,98,102,"Tripwire/Killing Floor/StrongHit")

AddSoundInterval("KFMod.GoreDecap",1,4,CHAN_BODY,1,GoreHearDist,98,102,"Tripwire/Killing Floor/Decap")
AddSoundInterval("KFMod.Gore",1,8,CHAN_BODY,1,GoreHearDist,98,102,"Tripwire/Killing Floor/Gib")

AddSoundInterval("KFMod.ImpactSkull",1,5,CHAN_BODY,1,80,98,102,"Tripwire/Killing Floor/ImpactSkull")
AddSoundInterval("KFMod.ClawHit",1,12,CHAN_BODY,1,80,98,102,"Tripwire/Killing Floor/ClawHit")



AddFootstepSounds("KFMod.Zed.FootstepLeft",1,3,"tripwire/killing floor/footsteps/zeds/tile")
AddFootstepSounds("KFMod.Zed.FootstepRight",4,6,"tripwire/killing floor/footsteps/zeds/tile")

AddFootstepSounds("KFMod.RageZed.FootstepLeft",1,3,"tripwire/killing floor/footsteps/zeds/big_zed/tile")
AddFootstepSounds("KFMod.RageZed.FootstepRight",4,6,"tripwire/killing floor/footsteps/zeds/big_zed/tile")
