include('shared.lua')

killicon.Add( "ent_patriarchrocket", "HUD/killicons/patriarch_rocket", Color( 255, 255, 255, 255 ) )

function ENT:Initialize()
	self.Emitter = ParticleEmitter(self:GetPos(), false)
end

function ENT:Think()
	if(IsValid(self)&&self!=nil&&self!=NULL&&self:GetNoDraw()==false) then
		if(IsValid(self.Emitter)) then
			local TEMP_Smoke = {
				"particle/smokesprites_0001",
				"particle/smokesprites_0002",
				"particle/smokesprites_0003",
				"particle/smokesprites_0004",
				"particle/smokesprites_0005",
				"particle/smokesprites_0006",
				"particle/smokesprites_0007",
				"particle/smokesprites_0008",
				"particle/smokesprites_0009",
				"particle/smokesprites_0010",
				"particle/smokesprites_0012",
				"particle/smokesprites_0013",
				"particle/smokesprites_0014",
				"particle/smokesprites_0015",
				"particle/smokesprites_0016"
			}
			
			local TEMP_Particle = self.Emitter:Add( table.Random(TEMP_Smoke), self:GetPos())
			TEMP_Particle:SetDieTime( 1 )
			TEMP_Particle:SetStartAlpha( 220 )
			TEMP_Particle:SetEndAlpha( 0 )
			TEMP_Particle:SetStartSize( 2 )
			TEMP_Particle:SetEndSize( 55 )
			TEMP_Particle:SetRoll( math.Rand( 60, 120 ) )
			TEMP_Particle:SetRollDelta( math.Rand( -1, 1 ) )
			TEMP_Particle:SetColor( 105, 105, 105 )
			TEMP_Particle:SetVelocity(Vector(math.random(-1,1),math.random(-1,1),math.random(-1,1)))
			TEMP_Particle:SetGravity(Vector(0,0,0))
			TEMP_Particle:SetAngleVelocity( Angle(1,1,1))
			TEMP_Particle:SetCollide(true)
		else
			self.Emitter = ParticleEmitter(self:GetPos(), false)
		end
	end
end

net.Receive("ExplodePatriarchRocket",function()
	local ent = net.ReadEntity()
	local pos = net.ReadVector()
	
	if(IsValid(ent)&&ent!=nil&&ent!=NULL) then
		local TEMP_Smoke = { 
			"particle/smokesprites_0001",
			"particle/smokesprites_0002",
			"particle/smokesprites_0003",
			"particle/smokesprites_0004",
			"particle/smokesprites_0005",
			"particle/smokesprites_0006",
			"particle/smokesprites_0007",
			"particle/smokesprites_0008",
			"particle/smokesprites_0009",
			"particle/smokesprites_0010",
			"particle/smokesprites_0012",
			"particle/smokesprites_0013",
			"particle/smokesprites_0014",
			"particle/smokesprites_0015",
			"particle/smokesprites_0016"
		}
		local TEMP_Emitter = ParticleEmitter(pos, false)
		
		if(IsValid(TEMP_Emitter)) then
			for P=1, 50 do
				local TEMP_Vel = Vector(math.random(-1,1),math.random(-1,1),math.Rand(0,0.7))*math.random(14,45)
				
				local TEMP_Particle = TEMP_Emitter:Add( table.Random(TEMP_Smoke), pos)
				TEMP_Particle:SetDieTime( 3 )
				TEMP_Particle:SetStartAlpha( 190 )
				TEMP_Particle:SetEndAlpha( 0 )
				TEMP_Particle:SetStartSize( 15 )
				TEMP_Particle:SetEndSize( 85 )
				TEMP_Particle:SetRoll( math.Rand( 60, 120 ) )
				TEMP_Particle:SetVelocity(TEMP_Vel)
				TEMP_Particle:SetColor( 105, 105, 105 )
				TEMP_Particle:SetGravity(-TEMP_Vel*0.25)
				TEMP_Particle:SetAngleVelocity( Angle(math.Rand(-1,1),math.Rand(-1,1),math.Rand(-1,1)))
				TEMP_Particle:SetCollide(false)
			end
			
			TEMP_Emitter:Finish()
		end
	end
end)


net.Receive("ExplodePatriarchRocketNE",function()
	local ent = net.ReadEntity()
	local pos = net.ReadVector()
	
	if(IsValid(ent)&&ent!=nil&&ent!=NULL) then
		local TEMP_Emitter = ParticleEmitter(pos, false)
		
		if(IsValid(TEMP_Emitter)) then
			local TEMP_ColReferences = {}
			table.insert(TEMP_ColReferences,Color(255,0,0))
			table.insert(TEMP_ColReferences,Color(0,255,0))
			table.insert(TEMP_ColReferences,Color(0,0,255))
			table.insert(TEMP_ColReferences,Color(191,6,255))
			table.insert(TEMP_ColReferences,Color(0,206,209))
			table.insert(TEMP_ColReferences,Color(0,255,255))
			table.insert(TEMP_ColReferences,Color(50,205,50))
			table.insert(TEMP_ColReferences,Color(124,252,0))
			table.insert(TEMP_ColReferences,Color(255,255,0))
			table.insert(TEMP_ColReferences,Color(205,102,0))
			
			for P=1, 50 do
				local TEMP_Col = TEMP_ColReferences[math.random(1,#TEMP_ColReferences)]
				local TEMP_Vel = VectorRand()*math.random(120,130)
			
				local TEMP_Particle = TEMP_Emitter:Add( "particle/particle_glow_03", pos)
				TEMP_Particle:SetDieTime( 2 )
				TEMP_Particle:SetStartAlpha( 255 )
				TEMP_Particle:SetEndAlpha( 0 )
				TEMP_Particle:SetStartSize( 15 )
				TEMP_Particle:SetEndSize( 6 )
				TEMP_Particle:SetVelocity(TEMP_Vel)
				TEMP_Particle:SetColor( TEMP_Col.r,TEMP_Col.g,TEMP_Col.b )
				TEMP_Particle:SetGravity(Vector(0,0,-60))
				TEMP_Particle:SetCollide(false)
			end
			
			TEMP_Emitter:Finish()
		end
	end
end)

function ENT:OnRemove()
	if(IsValid(self.Emitter)) then
		self.Emitter:Finish()
	end
end

function ENT:Draw()
    self:DrawModel()
end