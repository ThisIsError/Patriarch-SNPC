include( "shared.lua" )

ENT.RenderGroup = RENDERGROUP_BOTH

function ENT:Draw()
	self.Entity:DrawModel()
end

function ENT:DrawTranslucent()
	self:Draw()
end

function KFNPCRemovePhysBonesByBones(PHYSENT,PHYS)
	local TEMP_STR = string.Explode(",",PHYS)
	
	for P=1, #TEMP_STR do
		if(isnumber(PHYSENT:LookupBone(TEMP_STR[P]))) then
			local TEMP_PhysBone = PHYSENT:GetPhysicsObjectNum(PHYSENT:TranslateBoneToPhysBone(PHYSENT:LookupBone(TEMP_STR[P])))
			
			if(IsValid(TEMP_PhysBone)) then
				TEMP_PhysBone:EnableCollisions(false)
				TEMP_PhysBone:SetMass(0.1)
			end
		end
	end
end


net.Receive("KFNPCBloodExplosion",function()
	local TEMP_V1 = net.ReadVector()
	local TEMP_V2 = net.ReadVector()
	
	local TEMP_EMITTER = ParticleEmitter(TEMP_V1,false)
	
	for P=1, 10 do
		local TEMP_V = Vector(math.random(TEMP_V1.x,TEMP_V2.x),math.random(TEMP_V1.y,TEMP_V2.y),math.random(TEMP_V1.z,TEMP_V2.z))

		local TEMP_ANGLE = AngleRand()

		
		local TEMP_PARTICLE = TEMP_EMITTER:Add("particle/smokestack", TEMP_V )
		TEMP_PARTICLE:SetDieTime( 0.6 )
		TEMP_PARTICLE:SetStartSize( 15 )
		TEMP_PARTICLE:SetEndSize( 30 )
		TEMP_PARTICLE:SetStartAlpha( 235 )
		TEMP_PARTICLE:SetEndAlpha( 50 )
		TEMP_PARTICLE:SetVelocity( TEMP_ANGLE:Forward() * 55 )
		TEMP_PARTICLE:SetGravity( TEMP_ANGLE:Forward() * -33 )
		TEMP_PARTICLE:SetColor(65,0,0)

		TEMP_PARTICLE:SetRoll( 15 )
		TEMP_PARTICLE:SetRollDelta( 1 )
		
		TEMP_PARTICLE:SetCollide( true )
		TEMP_PARTICLE:SetCollideCallback( function( part, hitpos, hitnormal )
			part:SetDieTime(-1)
		end )

		
		TEMP_V = Vector(math.random(TEMP_V1.x,TEMP_V2.x),math.random(TEMP_V1.y,TEMP_V2.y),math.random(TEMP_V1.z,TEMP_V2.z))

		TEMP_ANGLE = AngleRand()

		
		local TEMP_PARTICLE = TEMP_EMITTER:Add("particle/cloud", TEMP_V )
		TEMP_PARTICLE:SetDieTime( 3 )
		TEMP_PARTICLE:SetStartSize( 1 )
		TEMP_PARTICLE:SetEndSize( 1 )
		TEMP_PARTICLE:SetStartAlpha( 255 )
		TEMP_PARTICLE:SetEndAlpha( 235 )
		TEMP_PARTICLE:SetVelocity( TEMP_ANGLE:Forward() * 355 )
		TEMP_PARTICLE:SetGravity( Vector(0,0,-600) )
		TEMP_PARTICLE:SetColor(65,0,0)
		
		TEMP_PARTICLE:SetRoll( 15 )
		TEMP_PARTICLE:SetRollDelta( 1 )
		
		TEMP_PARTICLE:SetCollide( true )
		TEMP_PARTICLE:SetCollideCallback( function( part, hitpos, hitnormal )
			part:SetDieTime(-1)
		end )
		
		
		TEMP_V = Vector(math.random(TEMP_V1.x,TEMP_V2.x),math.random(TEMP_V1.y,TEMP_V2.y),math.random(TEMP_V1.z,TEMP_V2.z))

		TEMP_ANGLE = AngleRand()

		
		local TEMP_PARTICLE = TEMP_EMITTER:Add( "effects/blooddrop", TEMP_V )
		TEMP_PARTICLE:SetDieTime( 4 )
		TEMP_PARTICLE:SetStartSize( 3 )
		TEMP_PARTICLE:SetEndSize( 3 )
		TEMP_PARTICLE:SetStartAlpha( 255 )
		TEMP_PARTICLE:SetEndAlpha( 255 )
		TEMP_PARTICLE:SetVelocity( TEMP_ANGLE:Forward() * 425 )
		TEMP_PARTICLE:SetGravity( Vector( 0, 0, -600 ) )
		TEMP_PARTICLE:SetColor(65,0,0)
		
		TEMP_PARTICLE:SetRoll( 15 )
		TEMP_PARTICLE:SetRollDelta( 1 )

		TEMP_PARTICLE:SetCollide( true )
		TEMP_PARTICLE:SetCollideCallback( function( part, hitpos, hitnormal )
			part:SetDieTime(-1)
		end )
		
	end

	TEMP_EMITTER:Finish( )
end)

net.Receive("KFNPCRagdoll",function()
	local TEMP_ENT = net.ReadEntity()
	local TEMP_Bodygroups = net.ReadString()
	local TEMP_Physobjects = net.ReadString()
	local TEMP_Skin = tonumber(net.ReadString())
	
	if(IsValid(TEMP_ENT)&&TEMP_ENT!=nil&&TEMP_ENT!=NULL) then
		local Doll = TEMP_ENT:BecomeRagdollOnClient()
		
		KFNPCRemovePhysBonesByBones(Doll, TEMP_Physobjects)
		
		Doll:SetMaterial("")
		Doll:SetColor(Color(255,255,255,255))
		Doll:SetBodyGroups(TEMP_Bodygroups)
		Doll:SetSkin(TEMP_Skin)
		Doll:RemoveAllDecals()
		Doll:DrawShadow(true)
	end
end)