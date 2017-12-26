function ENT:RunAI( strExp )
	if(self.IsAlive==true) then
		if(self.PlayingAnimation==false||(self.PlayingAnimation==true&&self.PlayingGesture==true)) then
			if((self.PlayingAnimation==false||self.PlayingGesture==true)&&!self.CurrentSchedule) then
				self:SelectSchedule()
			end
			
			if ( self:IsRunningBehavior() ) then
				return true
			end
			
			if ( self:DoingEngineSchedule() ) then
				return true
			end
			
			if ( self.CurrentSchedule ) then
				self:DoSchedule( self.CurrentSchedule )
			end

			if ( !self.CurrentSchedule ) then
				self:SelectSchedule()
			end
		end
		
		self:MaintainActivity()
	end
end

function ENT:SelectSchedule( iNPCState )
	if(self.LastPosKnow<CurTime()) then
		if(IsValid(self:GetEnemy())&&self:GetEnemy()!=NULL&&self:GetEnemy()!=nil&&
		(self:GetEnemy():IsNPC()||(self:GetEnemy():IsPlayer()&&self:GetEnemy():Alive()))) then
			if(!self:IsUnreachable(self:GetEnemy())) then
				if(self.CantChaseTargetTimes<10) then
					self.LastUsedPosition = self.LastUsedPosition+1
					
					if(self.LastUsedPosition>4) then
						self.LastUsedPosition = 1
					end
					
					if(self.LastUsedPosition==1) then
						self.LastPosition[1] = self:GetEnemy():GetPos()
					elseif(self.LastUsedPosition==2) then
						self.LastPosition[2] = self:GetEnemy():GetPos()
					elseif(self.LastUsedPosition==3) then
						self.LastPosition[3] = self:GetEnemy():GetPos()
					elseif(self.LastUsedPosition==4) then
						self.LastPosition[4] = self:GetEnemy():GetPos()
					end
				end
			else
				local TEMP_LastPosChoosen = false

				if(self.LastUsedPosition==4) then
					if(self.LastPosition[1]!=nil) then
						self:SetLastPosition(self.LastPosition[2])
						TEMP_LastPosChoosen = true
					elseif(self.LastPosition[2]!=nil) then
						self:SetLastPosition(self.LastPosition[2])
						TEMP_LastPosChoosen = true
					elseif(self.LastPosition!=nil) then
						self:SetLastPosition(self.LastPosition[3])
						TEMP_LastPosChoosen = true
					elseif(self.LastPosition[4]!=nil) then
						self:SetLastPosition(self.LastPosition[4])
						TEMP_LastPosChoosen = true
					end
				end
				
				if(TEMP_LastPosChoosen==false) then
					if(self.LastUsedPosition==3) then
						if(self.LastPosition[4]!=nil) then
							self:SetLastPosition(self.LastPosition[4])
							TEMP_LastPosChoosen = true
						elseif(self.LastPosition[1]!=nil) then
							self:SetLastPosition(self.LastPosition[2])
							TEMP_LastPosChoosen = true
						elseif(self.LastPosition[2]!=nil) then
							self:SetLastPosition(self.LastPosition[2])
							TEMP_LastPosChoosen = true
						elseif(self.LastPosition[3]!=nil) then
							self:SetLastPosition(self.LastPosition[3])
							TEMP_LastPosChoosen = true
						end
					end
					
					if(TEMP_LastPosChoosen==false) then
						if(self.LastUsedPosition==2) then
							if(self.LastPosition[3]!=nil) then
								self:SetLastPosition(self.LastPosition[3])
								TEMP_LastPosChoosen = true
							elseif(self.LastPosition[4]!=nil) then
								self:SetLastPosition(self.LastPosition[4])
								TEMP_LastPosChoosen = true
							elseif(self.LastPosition[1]!=nil) then
								self:SetLastPosition(self.LastPosition[2])
								TEMP_LastPosChoosen = true
							elseif(self.LastPosition[2]!=nil) then
								self:SetLastPosition(self.LastPosition[2])
								TEMP_LastPosChoosen = true
							end
						end
						
						if(TEMP_LastPosChoosen==false) then
							if(self.LastUsedPosition==1) then
								if(self.LastPosition[2]!=nil) then
									self:SetLastPosition(self.LastPosition[2])
									TEMP_LastPosChoosen = true
								elseif(self.LastPosition[3]!=nil) then
									self:SetLastPosition(self.LastPosition[3])
									TEMP_LastPosChoosen = true
								elseif(self.LastPosition[4]!=nil) then
									self:SetLastPosition(self.LastPosition[4])
									TEMP_LastPosChoosen = true
								elseif(self.LastPosition[1]!=nil) then
									self:SetLastPosition(self.LastPosition[2])
									TEMP_LastPosChoosen = true
								end
							end
						end
					end
				end
				
			end
		end
		
		self.LastPosKnow = CurTime()+0.3
	end
		
	if(self.PlayingAnimation==false||self.PlayingGesture==true) then
		if((self:IsOnFire()&&self.AutoChangeActivityWhenOnFire&&self.BurnTime>self.BurnTimeToPanic&&self.BurnTime<self.BurnTimeToPanic+3)
		||(self.HeadLess==true&&self.AutoChangeActivityWhenHeadless)) then
			if(!self:IsCurrentSchedule(SCHED_RUN_RANDOM)) then
				self:SetSchedule(SCHED_RUN_RANDOM)
			end
		else
			if(IsValid(self:GetEnemy())&&self:GetEnemy()!=NULL&&self:GetEnemy()!=nil&&
			(self:GetEnemy():IsNPC()||(self:GetEnemy():IsPlayer()&&self:GetEnemy():Alive()))) then
				if(self.CantChaseTargetTimes>10) then
					if((self:GetPos():Distance(self:GetSaveTable().m_vecLastPosition)<250)&&self.CantChaseTargetTimes<20) then
						if(!self:IsCurrentSchedule(SCHED_FORCED_GO_RUN)) then
							self:SetSchedule(SCHED_FORCED_GO_RUN)
						end
					else
						if(!self:IsCurrentSchedule(SCHED_RUN_RANDOM)) then
							self:SetSchedule(SCHED_RUN_RANDOM)
						end
					end
				else
					local TEMP_DistanceForMelee = self:KFNPCEnemyInMeleeRange(self:GetEnemy(),0,self.MeleeAttackDistance-5)
					
					if(TEMP_DistanceForMelee==0) then
						if(!self:IsCurrentSchedule(SCHED_CHASE_ENEMY)) then
							self:SetSchedule(SCHED_CHASE_ENEMY)
						end
					end
				end
			else
				if(!self:IsCurrentSchedule(SCHED_IDLE_WANDER)) then
					self:SetSchedule(SCHED_IDLE_WANDER)
				end
			end
		end
	end
end

function ENT:StartSchedule( schedule )
	self.CurrentSchedule 	= schedule
	self.CurrentTaskID 		= 1
	self:SetTask( schedule:GetTask( 1 ) )
end

function ENT:DoSchedule( schedule )

	if ( self.CurrentTask ) then
		self:RunTask( self.CurrentTask )
	end

	if ( self:TaskFinished() ) then
		self:NextTask( schedule )
	end

end

function ENT:ScheduleFinished()
	self.CurrentSchedule 	= nil
	self.CurrentTask 		= nil
	self.CurrentTaskID 		= nil
end

function ENT:SetTask( task )
	self.CurrentTask 	= task
	self.bTaskComplete 	= false
	self.TaskStartTime 	= CurTime()

	self:StartTask( self.CurrentTask )
end

function ENT:NextTask( schedule )
	self.CurrentTaskID = self.CurrentTaskID + 1

	if ( self.CurrentTaskID > schedule:NumTasks() ) then
		self:ScheduleFinished( schedule )
		return
	end

	self:SetTask( schedule:GetTask( self.CurrentTaskID ) )
end

function ENT:StartTask( task )
	task:Start( self.Entity )
end

function ENT:RunTask( task )
	task:Run( self.Entity )
end

function ENT:TaskTime()
	return CurTime() - self.TaskStartTime
end

function ENT:OnTaskComplete()
	self.bTaskComplete = true
end

function ENT:TaskFinished()
	return self.bTaskComplete
end

function ENT:StartEngineTask( iTaskID, TaskData )
end

function ENT:RunEngineTask( iTaskID, TaskData )
end

function ENT:StartEngineSchedule( scheduleID ) self:ScheduleFinished() self.bDoingEngineSchedule = true end
function ENT:EngineScheduleFinish() self.bDoingEngineSchedule = nil end
function ENT:DoingEngineSchedule()	return self.bDoingEngineSchedule end

function ENT:OnCondition( iCondition )
end