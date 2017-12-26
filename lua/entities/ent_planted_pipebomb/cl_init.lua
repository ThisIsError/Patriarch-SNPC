include('shared.lua')

killicon.Add( "ent_planted_pipebomb", "HUD/killicons/killing_floor_pipebomb", Color( 255, 255, 255, 255 ) )

function ENT:Initialize()
	self.emitter = ParticleEmitter(self:GetPos(), false)
end

function ENT:Think()
end

function ENT:OnRemove()
	if(self:GetNWBool("Exploding"..tostring(self),false)==true) then
		for P=1, 50 do
			local smoke = { 
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
			local Vel = Vector(math.random(-1,1),math.random(-1,1),math.random(0,1))*math.random(85,103)
			local particle = self.emitter:Add( table.Random(smoke), self:GetPos())
			particle:SetDieTime( 3 )
			particle:SetStartAlpha( 190 )
			particle:SetEndAlpha( 0 )
			particle:SetStartSize( 87 )
			particle:SetEndSize( 70 )
			particle:SetRoll( math.Rand( 60, 120 ) )
			particle:SetRollDelta( math.Rand( -1, 1 ) )
			particle:SetVelocity(Vel)
			particle:SetColor( 105, 105, 105 )
			particle:SetGravity(-Vel*0.5)
			particle:SetAngleVelocity( Angle(1,1,1))
			particle:SetCollide(true)
		end
	end
	
	self.emitter:Finish()
end

function ENT:Draw()
    self:DrawModel()
end