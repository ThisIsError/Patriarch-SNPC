include('shared.lua')

function ENT:Think()
	if(self:GetMaterial()=="models/Tripwire/Killing Floor/Zeds/invisibility"||
	self:GetMaterial()=="models/Tripwire/Killing Floor/Zeds/Siren/Siren_Scream") then
		self:RemoveAllDecals()
	end
end

killicon.Add( "npc_kfmod_patriarch", "HUD/killicons/patriarch_hand", Color( 255, 255, 255, 255 ) )
killicon.Add( "#npc_kfmod_patriarch", "HUD/killicons/patriarch_hand", Color( 255, 255, 255, 255 ) )