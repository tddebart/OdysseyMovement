// convars
CreateConVar('odysseyMovement_roll_maxVelocity', 450, 'The maximum velocity you can get from rolling')

CreateConVar('odysseyMovement_walljump_launchVelocityAway', -300, 'The horizontal velocity you get when walljumping away from the wall')
CreateConVar('odysseyMovement_walljump_launchVelocityUp', 300, 'The upwards velocity you get when walljumping away from the wall')

CreateConVar('odysseyMovement_backflip_height', 400.0, 'The height of the backflip')

CreateConVar('odysseyMovement_longjump_height', 600.0, 'The height of the longjump')
CreateConVar('odysseyMovement_longjump_distance', 300.0, 'The distance of the longjump')

local jumpSound = Sound('player_jump1')
local longJumpSound = Sound('player_longjump')
local diveSound = Sound('player_dive')
local bonkSound = Sound('player_bonk')
local poundPreSound = Sound('player_pound_pre')
local poundLandSound = Sound('player_pound_land')
local poundJumpSound = Sound('player_pound_jump')
local wallSlideSound = Sound('player_wallslide')
local wallJumpSound = Sound('player_walljump')

local loopId = 0

hook.Add('Move', 'OdyMove', function(ply, mv)

    if not ply:GetPreviousIsOnGround() and ply:IsOnGround() then
        landed(ply,mv)
    elseif not ply:IsOnGround() then
        inAir(ply,mv)
    end

    ply:SetPreviousIsOnGround(ply:IsOnGround())

    if ply:KeyPressed(IN_JUMP) then
        jumped(ply,mv)
    end

    if ply:KeyPressed(IN_DUCK) then
        ducked(ply,mv)
    end

    // if we press the use key
    if ply:KeyPressed(IN_USE) then
        use(ply, mv)
    end

    if ply:GetRollUpdate() then
        roll(ply, mv)
    end

    if ply:GetWallJumpUpdate() then
        wallJumpCheck(ply, mv)
    end

    if ply:GetMaxSpeedOverride() != 0 then
        local maxSpeedOverride = ply:GetMaxSpeedOverride()
        mv:SetMaxClientSpeed(maxSpeedOverride-1)
        mv:SetMaxSpeed(maxSpeedOverride-1)
    end

    if ply:GetFreezePlayer() then

        return true
    end
end)

function inAir (ply, mv)
    // Check if we need to update the walljump
    if not ply:GetWallJumpUpdate() then
        timer.Simple(0.2, function()
            ply:SetWallJumpUpdate(true)
        end)
    end
end

function landed (ply, mv)


    if ply:GetIsGroundPounding() || ply:GetIsBonking() then
        ply:SetRollVelocity(GetConVar('odysseyMovement_roll_maxVelocity'):GetInt())

        ply:EmitSound(poundLandSound)

        // Force crouch by +duck and -duck
        // TODO: need to find a way to force crouch without using concommands
        // because then you can't use the crouch key to uncrouch
        ply:ConCommand('+duck')

        timer.Simple(0.7, function()
            ply:SetIsGroundPounding(false)
            ply:SetIsBonking(false)

            ply:SetMaxSpeedOverride(0)
            ply:ConCommand('-duck')
        end)
    end

    ply:SetWallJumpUpdate(false)
    ply:SetWallDirection(Vector(0,0,0))

    ply:SetIsLongJumping(false)
    ply:SetIsDiving(false)

    if loopId != 0 then
        ply:StopLoopingSound(loopId)
    end

    // Reset roll velocity if we are not rolling after 0.3 seconds
    timer.Simple(0.3, function()
        if not ply:GetRollUpdate() then
            ply:SetRollVelocity(0)
        end
    end)
end

function jumped (ply, mv)
    // Walljump
    if ply:GetWallDirection() != Vector(0,0,0) and not ply:GetIsGroundPounding() then
        local vel = ply:GetWallDirection() * GetConVar('odysseyMovement_walljump_launchVelocityAway'):GetInt()
        vel.z = GetConVar('odysseyMovement_walljump_launchVelocityUp'):GetInt()
        mv:SetVelocity(vel)
        ply:SetWallDirection(Vector(0,0,0))

        ply:EmitSound(wallJumpSound)
        ply:EmitSound(jumpSound)

    end

    if not ply:IsOnGround() || ply:GetIsBonking() then return end


    // Ground pound jump
    if ply:GetIsGroundPounding() then
        ply:SetIsGroundPounding(false)
        ply:SetMaxSpeedOverride(0)
        ply:ConCommand('-duck')

        mv:SetVelocity(Vector(0,0,450))

        ply:EmitSound(poundJumpSound)
        return
    end

    // Backflip or longjump
    if (ply:Crouching() or ply:KeyDown(IN_DUCK)) and not ply:GetIsGroundPounding() then
        local vel = mv:GetVelocity()
        local vec = ply:GetAimVector()
        vec.z = 0
        local len = -100.0

        if math.abs(vel.x) + math.abs(vel.y) < 100 and ply:Crouching() then // Backflip
            vec.z = GetConVar('odysseyMovement_backflip_height'):GetFloat() / len

            mv:SetVelocity(vec * len)
            ply:EmitSound(poundJumpSound)
            return
        elseif ply:KeyDown(IN_DUCK) then // Longjump
            len = GetConVar('odysseyMovement_longjump_distance'):GetFloat()
            vec.z = GetConVar('odysseyMovement_longjump_height'):GetFloat() / len
            ply:SetIsLongJumping(true)

            ply:SetVelocity(vec * len)

            ply:SetRollVelocity(GetConVar('odysseyMovement_roll_maxVelocity'):GetInt())

            ply:EmitSound(longJumpSound)

            return
        end

    end

    ply:EmitSound(jumpSound)
end

function ducked (ply, mv)
    // Groundpound
    if
     not ply:IsOnGround()
     and not ply:GetIsLongJumping()
     and not ply:GetIsDiving()
     and not ply:GetIsGroundPounding() then
        ply:SetMaxSpeedOverride(1)
        ply:SetFreezePlayer(true)
        ply:SetIsGroundPounding(true)
        mv:SetVelocity(Vector(0,0,0))

        ply:EmitSound(poundPreSound)
        timer.Simple(0.3, function()
            if not ply:GetIsDiving() then
                ply:SetFreezePlayer(false)
                ply:SetVelocity(Vector(0,0,-500))
            end
        end)
    end

end

function use (ply, mv)
    // Roll
    if ply:Crouching() and (ply:IsOnGround() or ply:GetRollUpdate()) then
        ply:SetRollTime(0)
        ply:SetRollVelocity(
            math.min(GetConVar('odysseyMovement_roll_maxVelocity'):GetInt(),
             ply:GetRollVelocity() + 70))

        if not ply:GetRollUpdate() then
            ply:SetRollUpdate(true)
            roll(ply, mv)
        end
    // Dive
    elseif ply:GetIsGroundPounding() and not ply:IsOnGround() then
        ply:SetFreezePlayer(false)
        ply:SetMaxSpeedOverride(0)
        local vec = ply:GetAimVector()
        vec.z = 0
        vec = vec:GetNormalized()
        vec = vec * 350 + Vector(0,0,150)
        mv:SetVelocity(vec)

        ply:SetIsGroundPounding(false)
        ply:ConCommand('-duck')
        ply:SetIsDiving(true)

        ply:EmitSound(diveSound)
    end
end

function wallJumpCheck (ply, mv)
    local pos = ply:EyePos()
    pos.z = pos.z - 25
    local vel = mv:GetVelocity()
    local wallDir = ply:GetWallDirection()

    if wallDir == Vector(0,0,0) then
        wallDir = ply:GetAimVector()
    elseif vel.z < 0 then
        vel.z = vel.z + 5
        mv:SetVelocity(vel)
        loopId = ply:StartLoopingSound(wallSlideSound)
    end

    wallDir.z = 0
    wallDir = wallDir:GetNormalized()

    local tr = util.TraceLine({
        start = pos,
        endpos = pos + wallDir * 23,
        filter = ply
    })

    if tr.Hit then
        if (ply:GetIsLongJumping() || ply:GetIsDiving()) then
            if not ply:GetIsBonking() then
                ply:EmitSound(bonkSound)
            end
            mv:SetVelocity(wallDir * -50);
            ply:SetMaxSpeedOverride(1)
            ply:StopLoopingSound(loopId)
            ply:SetIsBonking(true)
        end

        if ply:GetWallDirection() == Vector(0,0,0) then
            if vel.z < 0 then vel.z = 0 end
            mv:SetVelocity(vel)
        end
        ply:SetWallDirection(wallDir)
    else
        ply:SetWallDirection(Vector(0,0,0))
        ply:StopLoopingSound(loopId)
    end
end

function roll (ply, mv)
    local vel = mv:GetVelocity()
    local rvel = ply:GetRollVelocity()
    local vec = ply:GetAimVector()

    if ply:GetRollTime() != 0 and (vel.x == 0 or vel.y == 0) and vec.z != 0 then
        ply:SetRollTime(50)
    end

    vec.z = 0
    vec = vec:GetNormalized()
    vec = vec * (rvel - ply:GetRollTime() * rvel / 50);

    mv:SetVelocity(Vector(vec.x, vec.y, vel.z))

    ply:SetRollTime(ply:GetRollTime() + 1)
    if ply:GetRollTime() >= 50 or not ply:Crouching() then
        ply:SetRollVelocity(0)
        ply:SetRollUpdate(false)
    end
end
