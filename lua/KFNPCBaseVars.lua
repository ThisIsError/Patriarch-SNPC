HITGROUP_KFHEAD = 8

ENT.IsAlive = true
ENT.Animation = ""
ENT.PlayingAnimation = false
ENT.PlayingGesture = false
ENT.NextSoundCanPlayTime = 0
ENT.LastPlayedSound = ""
ENT.NextTryingFindEnemy = CurTime()+1
ENT.AttackIndex = 0
ENT.Hard = GetConVar("kf_npc_hardmode"):GetInt()
ENT.Gore = GetConVar("kf_npc_gore"):GetInt()

ENT.AttackGestureIndex = nil
ENT.FlinchGestureIndex = nil

ENT.RegEnemy = nil
ENT.SNPCClass = "C_MONSTER_LAB"

ENT.NearestEnemyFindDistance = 0

ENT.PreviousPosition = Vector(0,0,0)
ENT.CantChaseTargetTimes = 0
ENT.MustJumpTimes = 0

ENT.LastUsedPosition = 1
ENT.LastPosition = {}
ENT.LastPosKnow = -1

ENT.Hate = 1
ENT.DMGMult = 1
ENT.HPMult = 1

ENT.LastEnemyPosition = Vector(0,0,0)

ENT.IdleSequence = "S_Idle"

ENT.MeleeAttackDistance = 16
ENT.MeleeAttackDistanceMin = 0

ENT.StunDamage = 0
ENT.StunInStun = false
ENT.StunSequence = "S_Fall"
ENT.StunOnHeadLoss = true
ENT.DieOnHeadLoss = false

ENT.FlinchDamage = 0
ENT.FlinchSequence = "S_Flinch"
ENT.FlinchGesture = ACT_GESTURE_SMALL_FLINCH
ENT.FlinchOnHeadLoss = false

ENT.HeadHealth = 100
ENT.HeadLess = false
ENT.LastDamageHitgroup = 0
ENT.HitBoxLastDamage = {}
ENT.AutoChangeActivityWhenHeadless = true
ENT.AutoChangeActivityWhenOnFire = true
ENT.BurnTimeToPanic = 3
ENT.BurnTime = 0

ENT.GoreEnabled = {}
ENT.GoreEnabled[HITGROUP_LEFTLEG] = true
ENT.GoreEnabled[HITGROUP_RIGHTLEG] = true
ENT.GoreEnabled[HITGROUP_LEFTARM] = true
ENT.GoreEnabled[HITGROUP_RIGHTARM] = true
ENT.GoreEnabled[HITGROUP_KFHEAD] = true

ENT.GoreHead = {}
ENT.GoreHead.model = "models/Tripwire/Killing Floor/Zeds/KFHuskGoreHead.mdl"
ENT.GoreHead.bone = "CHR_Head"
ENT.GoreHead.bodygroup1 = 1

ENT.GoreRArm = {}
ENT.GoreRArm.model = "models/Tripwire/Killing Floor/Zeds/KFHuskGoreRHand.mdl"
ENT.GoreRArm.bone = "CHR_RArmForeArm,CHR_RArmPalm"
ENT.GoreRArm.bodygroup1 = 3

ENT.GoreLArm = {}
ENT.GoreLArm.model = "models/Tripwire/Killing Floor/Zeds/KFHuskGoreLHand.mdl"
ENT.GoreLArm.bone = "CHR_LArmForeArm,CHR_LArmPalm"
ENT.GoreLArm.bodygroup1 = 2

ENT.GoreRLeg = {}
ENT.GoreRLeg.model = "models/Tripwire/Killing Floor/Zeds/KFHuskGoreRLeg.mdl"
ENT.GoreRLeg.bone = "CHR_RCalf,CHR_RAnkle,CHR_RToe0"
ENT.GoreRLeg.bodygroup1 = 5

ENT.GoreLLeg = {}
ENT.GoreLLeg.model = "models/Tripwire/Killing Floor/Zeds/KFHuskGoreLLeg.mdl"
ENT.GoreLLeg.bone = "CHR_LCalf,CHR_LAnkle,CHR_LToe0"
ENT.GoreLLeg.bodygroup1 = 4

ENT.PainSoundEnabled = false
ENT.PainSound = {}
ENT.PainSound.name = ""
ENT.PainSound.min = 1
ENT.PainSound.max = 1

ENT.DieSoundEnabled = false
ENT.DieSound = {}
ENT.DieSound.name = ""
ENT.DieSound.min = 1
ENT.DieSound.max = 1

ENT.MeleeSoundEnabled = false
ENT.MeleeSound = {}
ENT.MeleeSound.name = ""
ENT.MeleeSound.min = 1
ENT.MeleeSound.max = 1

ENT.IdlingSoundEnabled = false
ENT.IdlingSound = {}
ENT.IdlingSound.name = ""
ENT.IdlingSound.min = 1
ENT.IdlingSound.max = 1

ENT.ChasingSoundEnabled = false
ENT.ChasingSound = {}
ENT.ChasingSound.name = ""
ENT.ChasingSound.min = 1
ENT.ChasingSound.max = 1
ENT.ChasingSound.chance = 3

ENT.MeleeFlySpeed = 30

ENT.MeleeAttackSequence = {}
ENT.MeleeAttackGesture = {}
ENT.MeleeMissSound = {}
ENT.MeleeHitSound = {}
ENT.MeleeDamageRadius = {}
ENT.MeleeDamageCount = {}
ENT.MeleeDamageTime = {}
ENT.MeleeDamageDamage = {}
ENT.MeleeDamageType = {}
ENT.MeleeDamageDistance = {}
ENT.MeleeDamageBone = {}
ENT.MeleeDamageTime[1] = {}
ENT.MeleeDamageDamage[1] = {}
ENT.MeleeDamageType[1] = {}
ENT.MeleeDamageDistance[1] = {}
ENT.MeleeDamageBone[1] = {}
ENT.MeleeDamageRadius[1] = {}

ENT.MeleeAttackSequence[1] = "S_Melee1"
ENT.MeleeAttackGesture[1] = nil
ENT.MeleeDamageCount[1] = 1
ENT.MeleeDamageTime[1][1] = 0.1
ENT.MeleeDamageDamage[1][1] = 1
ENT.MeleeDamageType[1][1] = DMG_GENERIC
ENT.MeleeDamageDistance[1][1] = 1
ENT.MeleeDamageRadius[1][1] = 1
ENT.MeleeDamageBone[1][1] = "CHR_Head"



ENT.DamageTypeMult = {}
ENT.DamageTypeMult[DMG_GENERIC] = 1
ENT.DamageTypeMult[DMG_CRUSH] = 1
ENT.DamageTypeMult[DMG_BULLET] = 1
ENT.DamageTypeMult[DMG_SLASH] = 1
ENT.DamageTypeMult[DMG_BURN] = 1
ENT.DamageTypeMult[DMG_VEHICLE] = 1
ENT.DamageTypeMult[DMG_FALL] = 1
ENT.DamageTypeMult[DMG_BLAST] = 1
ENT.DamageTypeMult[DMG_CLUB] = 1
ENT.DamageTypeMult[DMG_SHOCK] = 1
ENT.DamageTypeMult[DMG_SONIC] = 1
ENT.DamageTypeMult[DMG_ENERGYBEAM] = 1
ENT.DamageTypeMult[DMG_NEVERGIB] = 1
ENT.DamageTypeMult[DMG_ALWAYSGIB] = 1
ENT.DamageTypeMult[DMG_DROWN] = 1
ENT.DamageTypeMult[DMG_PARALYZE] = 1
ENT.DamageTypeMult[DMG_NERVEGAS] = 1
ENT.DamageTypeMult[DMG_POISON] = 1
ENT.DamageTypeMult[DMG_ACID] = 1
ENT.DamageTypeMult[DMG_AIRBOAT] = 1
ENT.DamageTypeMult[DMG_BLAST_SURFACE] = 1
ENT.DamageTypeMult[DMG_BUCKSHOT] = 1
ENT.DamageTypeMult[DMG_DIRECT] = 1
ENT.DamageTypeMult[DMG_DISSOLVE] = 1
ENT.DamageTypeMult[DMG_DROWNRECOVER] = 1
ENT.DamageTypeMult[DMG_PHYSGUN] = 1
ENT.DamageTypeMult[DMG_PLASMA] = 1
ENT.DamageTypeMult[DMG_PREVENT_PHYSICS_FORCE] = 1
ENT.DamageTypeMult[DMG_RADIATION] = 1
ENT.DamageTypeMult[DMG_REMOVENORAGDOLL] = 1
ENT.DamageTypeMult[DMG_SLOWBURN] = 1
ENT.DamageMultOther = 1
ENT.DamageMultAll = 1
//ENT.DamageMultExplosion = 1
//ENT.DamageMultBullet = 1

ENT.JumpHeight = 240


ENT.NeedFlinch = false