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

--#region LongJump
function PLAYER:GetIsLongJumping()
    return self:GetDTBool(3)
end

function PLAYER:SetIsLongJumping(bool)
    self:SetDTBool(3, bool)
end

--#endregion

function PLAYER:GetMaxSpeedOverride()
    return self:GetDTInt(2)
end

function PLAYER:SetMaxSpeedOverride(speed)
    self:SetDTInt(2, speed)
end


--#region Dive

function PLAYER:GetIsDiving()
    return self:GetDTBool(4)
end

function PLAYER:SetIsDiving(bool)
    self:SetDTBool(4, bool)
end

--#endregion

--#region GroundPound

function PLAYER:GetFreezePlayer()
    return self:GetDTBool(6)
end

function PLAYER:SetFreezePlayer(bool)
    self:SetDTBool(6, bool)
end

function PLAYER:GetIsGroundPounding()
    return self:GetDTBool(5)
end

function PLAYER:SetIsGroundPounding(bool)
    self:SetDTBool(5, bool)
end

--#endregion

--#region Bonk

function PLAYER:GetIsBonking()
    return self:GetDTBool(7)
end

function PLAYER:SetIsBonking(bool)
    self:SetDTBool(7, bool)
end

--#endregion


--#region CapJump

function PLAYER:GetCapJumped()
    return self:GetDTBool(8)
end

function PLAYER:SetCapJumped(bool)
    self:SetDTBool(8, bool)
end

function PLAYER:GetHitCap()
    return self:GetDTBool(9)
end

function PLAYER:SetHitCap(bool)
    self:SetDTBool(9, bool)
end

--#endregion

--#region Ody Enabled

function PLAYER:GetOdyEnabled()
    return self:GetDTBool(10)
end

function PLAYER:SetOdyEnabled(bool)
    self:SetDTBool(10, bool)
end

--#endregion

