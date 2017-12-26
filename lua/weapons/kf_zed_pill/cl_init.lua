include( "ai_translations.lua" )
include( "sh_anim.lua" )
include( "shared.lua" )

SWEP.Slot				= 0						-- Slot in the weapon selection menu
SWEP.SlotPos			= 10					-- Position in the slot
SWEP.DrawAmmo			= true					-- Should draw the default HL2 ammo counter
SWEP.DrawCrosshair		= true 					-- Should draw the default crosshair
SWEP.DrawWeaponInfoBox	= true					-- Should draw the weapon info box
SWEP.BounceWeaponIcon   = true					-- Should the weapon icon bounce?
SWEP.SwayScale			= 1.0					-- The scale of the viewmodel sway
SWEP.BobScale			= 1.0					-- The scale of the viewmodel bob

SWEP.RenderGroup 		= RENDERGROUP_OPAQUE

-- Override this in your SWEP to set the icon in the weapon selection
SWEP.WepSelectIcon		= surface.GetTextureID( "weapons/swep" )

-- This is the corner of the speech bubble
SWEP.SpeechBubbleLid	= surface.GetTextureID( "gui/speech_lid" )


SWEP.DLight = nil
SWEP.DLightOn = false

net.Receive("KFPillFlashlight",function()
	local self = net.ReadEntity()
	
	if(KFPillAllValid(self)) then
		if(self.DLightOn==false) then
			self.DLight = DynamicLight( self:EntIndex() )
			self.DLight.r = 255
			self.DLight.g = 255
			self.DLight.b = 255
			self.DLight.pos = LocalPlayer():GetPos()
			self.DLight.brightness = 0.5
			self.DLight.Size = 1024
			self.DLight.DieTime = CurTime() + 1
			self.DLight.style = 0
			
			self.DLightOn = true
		else
			self.DLight.DieTime = 0
			self.DLightOn = false
		end
	end
end)

function SWEP:KFPillPlayGestureCL(GESTURE,FREEZE,NOTIMER,ENDTIME)
	timer.Remove("BeZedTimer_EndAnimation"..tostring(self))
	
	
	if(FREEZE==2) then
		self:GetOwner():Freeze(true)
		self.ZedPlayingGesture = false
	elseif(FREEZE==1) then
		self.ZedPlayingGesture = false
	else
		FREEZE = 0
		self.ZedPlayingGesture = true
	end
	
	self.ZedPlayingAnimation = true
	self.ZedAnimation = GESTURE
	self:GetOwner():DoAnimationEvent(GESTURE)
	
	if(NOTIMER!=true) then
		timer.Create("BeZedTimer_EndAnimation"..tostring(self), ENDTIME-CurTime(), 1, function()
			if(KFPillAllValid(self)) then
				self.ZedPlayingGesture = false
				self.ZedAnimation = -1
				self.ZedPlayingAnimation = false

				if(FREEZE==2) then
					self:GetOwner():Freeze(false)
				end
			end
		end)
	end
	
end


net.Receive("KFPillNWSetHull",function()
	local self = net.ReadEntity()
	local TEMP_V1 = net.ReadVector()
	local TEMP_V2 = net.ReadVector()
	
	if(TEMP_V1==Vector(0,0,0)||TEMP_V2==Vector(0,0,0)) then
		if(IsValid(LocalPlayer())&&LocalPlayer()!=NULL) then
			LocalPlayer():ResetHull()
		end
		LocalPlayer():SetHull(TEMP_V1,TEMP_V2)
	end
	
	LocalPlayer():Freeze(false)
end)

net.Receive("KFPillNWPlayAnimation",function()
	local TEMP_ENT = net.ReadEntity()
	local TEMP_GESTURE = tonumber(net.ReadString())
	local TEMP_FREEZE = tonumber(net.ReadString())
	local TEMP_NOTIMER = net.ReadBool()
	local TEMP_ENDTIME = net.ReadFloat()
	
	if(isentity(TEMP_ENT)&&TEMP_ENT:IsWeapon()&&TEMP_ENT.IsKFPill&&KFPillAllValid(TEMP_ENT)) then
		TEMP_ENT:KFPillPlayGestureCL(TEMP_GESTURE,TEMP_FREEZE,TEMP_NOTIMER,TEMP_ENDTIME)
	end
end)


net.Receive("KFPillNWDestroyHead",function()
	local TEMP_ENT = net.ReadEntity()

	if(IsValid(TEMP_ENT)&&TEMP_ENT:IsWeapon()&&TEMP_ENT.IsKFPill&&KFPillAllValid(TEMP_ENT)) then
		TEMP_ENT.ZedHeadLess = true
		TEMP_ENT:SetWeaponHoldType( "normal" )
		TEMP_ENT:GetOwner():RemoveAllDecals()
	end
end)

function SWEP:DrawHUD()
end


--[[---------------------------------------------------------
	Checks the objects before any action is taken
	This is to make sure that the entities haven't been removed
-----------------------------------------------------------]]
function SWEP:DrawWeaponSelection( x, y, wide, tall, alpha )
	
	-- Set us up the texture
	surface.SetDrawColor( 255, 255, 255, alpha )
	surface.SetTexture( self.WepSelectIcon )
	
	-- Lets get a sin wave to make it bounce
	local fsin = 0
	
	if ( self.BounceWeaponIcon == true ) then
		fsin = math.sin( CurTime() * 10 ) * 5
	end
	
	-- Borders
	y = y + 10
	x = x + 10
	wide = wide - 20
	
	-- Draw that mother
	surface.DrawTexturedRect( x + (fsin), y - (fsin),  wide-fsin*2 , ( wide / 2 ) + (fsin) )
	
	-- Draw weapon info box
	self:PrintWeaponInfo( x + wide + 20, y + tall * 0.95, alpha )
	
end


--[[---------------------------------------------------------
	This draws the weapon info box
-----------------------------------------------------------]]
function SWEP:PrintWeaponInfo( x, y, alpha )

	if ( self.DrawWeaponInfoBox == false ) then return end

	if (self.InfoMarkup == nil ) then
		local str
		local title_color = "<color=230,230,230,255>"
		local text_color = "<color=150,150,150,255>"
		
		local TEMP_INSTRUCTIONS = string.Replace(self.Instructions,"$M1",input.LookupBinding("attack"))
		TEMP_INSTRUCTIONS = string.Replace(TEMP_INSTRUCTIONS,"$M2",input.LookupBinding("attack2"))
		TEMP_INSTRUCTIONS = string.Replace(TEMP_INSTRUCTIONS,"$R",input.LookupBinding("+reload"))
		TEMP_INSTRUCTIONS = string.Replace(TEMP_INSTRUCTIONS,"$W",input.LookupBinding("walk"))
		TEMP_INSTRUCTIONS = string.Replace(TEMP_INSTRUCTIONS,"$D",input.LookupBinding("duck"))
		TEMP_INSTRUCTIONS = string.Replace(TEMP_INSTRUCTIONS,"$F",input.LookupBinding("flashlight"))
		TEMP_INSTRUCTIONS = string.Replace(TEMP_INSTRUCTIONS,"$N",input.LookupBinding("noclip"))
		
		str = "<font=HudSelectionText>"
		if ( self.Author != "" ) then str = str .. title_color .. "Author:</color>\t"..text_color..self.Author.."</color>\n" end
		if ( self.Contact != "" ) then str = str .. title_color .. "Contact:</color>\t"..text_color..self.Contact.."</color>\n\n" end
		if ( self.Purpose != "" ) then str = str .. title_color .. "Purpose:</color>\n"..text_color..self.Purpose.."</color>\n\n" end
		if ( self.Instructions != "" ) then str = str .. title_color .. "Instructions:</color>\n"..text_color..TEMP_INSTRUCTIONS.."</color>\n" end
		str = str .. "</font>"
		
		self.InfoMarkup = markup.Parse( str, 250 )
	end
	
	surface.SetDrawColor( 60, 60, 60, alpha )
	surface.SetTexture( self.SpeechBubbleLid )
	
	surface.DrawTexturedRect( x, y - 64 - 5, 128, 64 ) 
	draw.RoundedBox( 8, x - 5, y - 6, 260, self.InfoMarkup:GetHeight() + 18, Color( 60, 60, 60, alpha ) )
	
	self.InfoMarkup:Draw( x+5, y+5, nil, nil, alpha )
	
end


--[[---------------------------------------------------------
	Name: SWEP:FreezeMovement()
	Desc: Return true to freeze moving the view
-----------------------------------------------------------]]
function SWEP:FreezeMovement()
	return false
end


--[[---------------------------------------------------------
	Name: SWEP:ViewModelDrawn( ViewModel )
	Desc: Called straight after the viewmodel has been drawn
-----------------------------------------------------------]]
function SWEP:ViewModelDrawn( ViewModel )
end


--[[---------------------------------------------------------
	Name: OnRestore
	Desc: Called immediately after a "load"
-----------------------------------------------------------]]
function SWEP:OnRestore()
end

--[[---------------------------------------------------------
	Name: OnRemove
	Desc: Called just before entity is deleted
-----------------------------------------------------------]]
function SWEP:OnRemove()
end

--[[---------------------------------------------------------
	Name: CustomAmmoDisplay
	Desc: Return a table
-----------------------------------------------------------]]
function SWEP:CustomAmmoDisplay()
end

--[[---------------------------------------------------------
	Name: GetViewModelPosition
	Desc: Allows you to re-position the view model
-----------------------------------------------------------]]
function SWEP:GetViewModelPosition( pos, ang )

	return pos, ang
	
end

--[[---------------------------------------------------------
	Name: TranslateFOV
	Desc: Allows the weapon to translate the player's FOV (clientside)
-----------------------------------------------------------]]
function SWEP:TranslateFOV( current_fov )
	
	return current_fov

end


--[[---------------------------------------------------------
	Name: DrawWorldModel
	Desc: Draws the world model (not the viewmodel)
-----------------------------------------------------------]]
function SWEP:DrawWorldModel()
	if(self.DLight!=nil&&self.DLightOn==true) then
		self.DLight.DieTime = CurTime() + 0.25
		self.DLight.pos = LocalPlayer():GetPos()
	end
end


--[[---------------------------------------------------------
	Name: DrawWorldModelTranslucent
	Desc: Draws the world model (not the viewmodel)
-----------------------------------------------------------]]
function SWEP:DrawWorldModelTranslucent()
//
end

--[[---------------------------------------------------------
	Name: AdjustMouseSensitivity
	Desc: Allows you to adjust the mouse sensitivity.
-----------------------------------------------------------]]
function SWEP:AdjustMouseSensitivity()

	return nil
	
end

--[[---------------------------------------------------------
	Name: GetTracerOrigin
	Desc: Allows you to override where the tracer comes from (in first person view)
		 returning anything but a vector indicates that you want the default action
-----------------------------------------------------------]]
function SWEP:GetTracerOrigin()

--[[
	local ply = self:GetOwner()
	local pos = ply:EyePos() + ply:EyeAngles():Right() * -5
	return pos
--]]

end

--[[---------------------------------------------------------
	Name: FireAnimationEvent
	Desc: Allows you to override weapon animation events
-----------------------------------------------------------]]
function SWEP:FireAnimationEvent( pos, ang, event, options )

	if ( !self.CSMuzzleFlashes ) then return end

	-- CS Muzzle flashes
	if ( event == 5001 or event == 5011 or event == 5021 or event == 5031 ) then
	
		local data = EffectData()
		data:SetFlags( 0 )
		data:SetEntity( self:GetOwner():GetViewModel() )
		data:SetAttachment( math.floor( ( event - 4991 ) / 10 ) )
		data:SetScale( 1 )

		if ( self.CSMuzzleX ) then
			util.Effect( "CS_MuzzleFlash_X", data )
		else
			util.Effect( "CS_MuzzleFlash", data )
		end
	
		return true
	end

end