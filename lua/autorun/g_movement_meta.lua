local PLAYER = FindMetaTable("Player")

function PLAYER:GetPreviousIsOnGround()
    return self:GetDTBool(1)
end

function PLAYER:SetPreviousIsOnGround(bool)
    self:SetDTBool(1, bool)
end

--#region Roll

function PLAYER:GetRollTime()
    return self:GetDTInt(0)
end

function PLAYER:SetRollTime(time)
    self:SetDTInt(0, time)
end

function PLAYER:GetRollUpdate()
    return self:GetDTBool(0)
end

function PLAYER:SetRollUpdate(bool)
    self:SetDTBool(0, bool)
end

function PLAYER:GetRollVelocity()
    return self:GetDTInt(1)
end

function PLAYER:SetRollVelocity(vel)
    self:SetDTInt(1, vel)
end

--#endregion

--#region WallJump

function PLAYER:GetWallDirection()
    return self:GetDTVector(0)
end

function PLAYER:SetWallDirection(dir)
    self:SetDTVector(0, dir)
end

function PLAYER:GetWallJumpUpdate()
    return self:GetDTBool(2)
end

function PLAYER:SetWallJumpUpdate(bool)
    self:SetDTBool(2, bool)
end

--#endregion

function PLAYER:GetIsLongJumping()
    return self:GetDTBool(3)
end

function PLAYER:SetIsLongJumping(bool)
    self:SetDTBool(3, bool)
end

function PLAYER:GetMaxSpeedOverride(ply)
    return self:GetDTInt(2)
end

function PLAYER:SetMaxSpeedOverride(ply, speed)
    self:SetDTInt(2, speed)
end



