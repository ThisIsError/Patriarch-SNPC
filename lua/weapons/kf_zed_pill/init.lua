util.AddNetworkString("KFPillNWPlayAnimation")
util.AddNetworkString("KFPillNWDestroyHead")
util.AddNetworkString("KFPillNWSetHull")
util.AddNetworkString("KFPillNWRemove")

AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "ai_translations.lua" )
AddCSLuaFile( "sh_anim.lua" )
AddCSLuaFile( "shared.lua" )

include( "ai_translations.lua" )
include( "sh_anim.lua" )
include( "shared.lua" )

SWEP.Weight				= 5
SWEP.AutoSwitchTo		= true
SWEP.AutoSwitchFrom		= true

SWEP.RenderGroup = RENDERGROUP_BOTH

function SWEP:OnRestore()
end

function SWEP:AcceptInput( name, activator, caller, data )
	return false
end

function SWEP:KeyValue( key, value )
end


function SWEP:Equip( NewOwner )

end

function SWEP:EquipAmmo( NewOwner )

end


function SWEP:ShouldDropOnDie()
	return false
end

function SWEP:GetCapabilities()

	return bit.bor( CAP_WEAPON_RANGE_ATTACK1, CAP_INNATE_RANGE_ATTACK1 )

end

function SWEP:NPCShoot_Secondary( ShootPos, ShootDir )

	self:SecondaryAttack()

end

function SWEP:NPCShoot_Primary( ShootPos, ShootDir )

	self:PrimaryAttack()

end

AccessorFunc( SWEP, "fNPCMinBurst", 		"NPCMinBurst" )
AccessorFunc( SWEP, "fNPCMaxBurst", 		"NPCMaxBurst" )
AccessorFunc( SWEP, "fNPCFireRate", 		"NPCFireRate" )
AccessorFunc( SWEP, "fNPCMinRestTime", 	"NPCMinRest" )
AccessorFunc( SWEP, "fNPCMaxRestTime", 	"NPCMaxRest" )

