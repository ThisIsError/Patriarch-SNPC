HITGROUP_KFHEAD = 8

SWEP.MeleeAttackGesture = {}
SWEP.MeleeMissSound = {}
SWEP.MeleeHitSound = {}
SWEP.MeleeDamageRadius = {}
SWEP.MeleeDamageCount = {}
SWEP.MeleeDamageTime = {}
SWEP.MeleeDamageDamage = {}
SWEP.MeleeDamageType = {}
SWEP.MeleeDamageDistance = {}
SWEP.MeleeDamageBone = {}
SWEP.MeleeFreeze = {}
SWEP.MeleeDamageTime[1] = {}
SWEP.MeleeDamageDamage[1] = {}
SWEP.MeleeDamageType[1] = {}
SWEP.MeleeDamageDistance[1] = {}
SWEP.MeleeDamageBone[1] = {}
SWEP.MeleeDamageRadius[1] = {}

SWEP.MeleeFreeze[1] = false
SWEP.MeleeAttackGesture[1] = nil
SWEP.MeleeDamageCount[1] = 1
SWEP.MeleeDamageTime[1][1] = 0.1
SWEP.MeleeDamageDamage[1][1] = 1
SWEP.MeleeDamageType[1][1] = DMG_GENERIC
SWEP.MeleeDamageDistance[1][1] = 1
SWEP.MeleeDamageRadius[1][1] = 1
SWEP.MeleeDamageBone[1][1] = "CHR_Head"

SWEP.ZedModel = "models/Tripwire/Killing Floor/Zeds/BeZed/KFPatriarch.mdl"
SWEP.ZedMeleeForce = 90
SWEP.ZedPlayerOriginalModel = ""


SWEP.NextSoundCanPlayTime = -1
SWEP.LastPlayedSound = ""

SWEP.GoreEnabled = {}
SWEP.GoreEnabled[HITGROUP_LEFTLEG] = true
SWEP.GoreEnabled[HITGROUP_RIGHTLEG] = true
SWEP.GoreEnabled[HITGROUP_LEFTARM] = true
SWEP.GoreEnabled[HITGROUP_RIGHTARM] = true
SWEP.GoreEnabled[HITGROUP_KFHEAD] = true

SWEP.ZedGore = true

SWEP.ZedStunDamage = 0
SWEP.ZedFlinchDamage = 0
SWEP.ZedFlinchGesture = ACT_GESTURE_FLINCH_BLAST
SWEP.ZedStunGesture = ACT_SPECIAL_ATTACK1
SWEP.ZedStunOnHeadLoss = true
SWEP.ZedStunInStun = false

SWEP.GoreHead = {}
SWEP.GoreHead.model = "models/Tripwire/Killing Floor/Zeds/KFHuskGoreHead.mdl"
SWEP.GoreHead.bone = "CHR_Head"
SWEP.GoreHead.bodygroup1 = 1

SWEP.GoreRArm = {}
SWEP.GoreRArm.model = "models/Tripwire/Killing Floor/Zeds/KFHuskGoreRHand.mdl"
SWEP.GoreRArm.bone = "CHR_RArmForeArm,CHR_RArmPalm"
SWEP.GoreRArm.bodygroup1 = 3

SWEP.GoreLArm = {}
SWEP.GoreLArm.model = "models/Tripwire/Killing Floor/Zeds/KFHuskGoreLHand.mdl"
SWEP.GoreLArm.bone = "CHR_LArmForeArm,CHR_LArmPalm"
SWEP.GoreLArm.bodygroup1 = 2

SWEP.GoreRLeg = {}
SWEP.GoreRLeg.model = "models/Tripwire/Killing Floor/Zeds/KFHuskGoreRLeg.mdl"
SWEP.GoreRLeg.bone = "CHR_RCalf,CHR_RAnkle,CHR_RToe0"
SWEP.GoreRLeg.bodygroup1 = 5

SWEP.GoreLLeg = {}
SWEP.GoreLLeg.model = "models/Tripwire/Killing Floor/Zeds/KFHuskGoreLLeg.mdl"
SWEP.GoreLLeg.bone = "CHR_LCalf,CHR_LAnkle,CHR_LToe0"
SWEP.GoreLLeg.bodygroup1 = 4

SWEP.PainSoundEnabled = false
SWEP.PainSound = {}
SWEP.PainSound.name = ""
SWEP.PainSound.min = 1
SWEP.PainSound.max = 1

SWEP.DieSoundEnabled = false
SWEP.DieSound = {}
SWEP.DieSound.name = ""
SWEP.DieSound.min = 1
SWEP.DieSound.max = 1

SWEP.MeleeSoundEnabled = false
SWEP.MeleeSound = {}
SWEP.MeleeSound.name = ""
SWEP.MeleeSound.min = 1
SWEP.MeleeSound.max = 1

SWEP.ChasingSoundEnabled = false
SWEP.ChasingSound = {}
SWEP.ChasingSound.name = ""
SWEP.ChasingSound.min = 1
SWEP.ChasingSound.max = 1
SWEP.ChasingSound.chance = 5


SWEP.DamageTypeMult = {}
SWEP.DamageTypeMult[DMG_GENERIC] = 1
SWEP.DamageTypeMult[DMG_CRUSH] = 1
SWEP.DamageTypeMult[DMG_BULLET] = 1
SWEP.DamageTypeMult[DMG_SLASH] = 1
SWEP.DamageTypeMult[DMG_BURN] = 1
SWEP.DamageTypeMult[DMG_VEHICLE] = 1
SWEP.DamageTypeMult[DMG_FALL] = 1
SWEP.DamageTypeMult[DMG_BLAST] = 1
SWEP.DamageTypeMult[DMG_CLUB] = 1
SWEP.DamageTypeMult[DMG_SHOCK] = 1
SWEP.DamageTypeMult[DMG_SONIC] = 1
SWEP.DamageTypeMult[DMG_ENERGYBEAM] = 1
SWEP.DamageTypeMult[DMG_NEVERGIB] = 1
SWEP.DamageTypeMult[DMG_ALWAYSGIB] = 1
SWEP.DamageTypeMult[DMG_DROWN] = 1
SWEP.DamageTypeMult[DMG_PARALYZE] = 1
SWEP.DamageTypeMult[DMG_NERVEGAS] = 1
SWEP.DamageTypeMult[DMG_POISON] = 1
SWEP.DamageTypeMult[DMG_ACID] = 1
SWEP.DamageTypeMult[DMG_AIRBOAT] = 1
SWEP.DamageTypeMult[DMG_BLAST_SURFACE] = 1
SWEP.DamageTypeMult[DMG_BUCKSHOT] = 1
SWEP.DamageTypeMult[DMG_DIRECT] = 1
SWEP.DamageTypeMult[DMG_DISSOLVE] = 1
SWEP.DamageTypeMult[DMG_DROWNRECOVER] = 1
SWEP.DamageTypeMult[DMG_PHYSGUN] = 1
SWEP.DamageTypeMult[DMG_PLASMA] = 1
SWEP.DamageTypeMult[DMG_PREVENT_PHYSICS_FORCE] = 1
SWEP.DamageTypeMult[DMG_RADIATION] = 1
SWEP.DamageTypeMult[DMG_REMOVENORAGDOLL] = 1
SWEP.DamageTypeMult[DMG_SLOWBURN] = 1
SWEP.DamageMultOther = 1
SWEP.DamageMultAll = 1

SWEP.ZedHeadHealth = 0
SWEP.ZedBaseHeadHealth = 0
SWEP.ZedLastDamagedHitgroup = 0
SWEP.HitBoxLastDamage = {}
SWEP.ZedDieOnHeadLoss = false

SWEP.PlayerHealth = 100


