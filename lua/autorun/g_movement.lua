// convars
CreateConVar('odysseyMovement_roll_maxVelocity', 450, 'The maximum velocity you can get from rolling')

CreateConVar('odysseyMovement_walljump_launchVelocityAway', -250, 'The horizontal velocity you get when walljumping away from the wall')
CreateConVar('odysseyMovement_walljump_launchVelocityUp', 250, 'The upwards velocity you get when walljumping away from the wall')

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
    ply:SetWallJumpUpdate(false)
    ply:SetWallDirection(Vector(0,0,0))
end

function jumped (ply, mv)
    // Walljump
    if ply:GetWallDirection() != Vector(0,0,0) then
        local vel = ply:GetWallDirection() * GetConVar('odysseyMovement_walljump_launchVelocityAway'):GetInt()
        vel.z = GetConVar('odysseyMovement_walljump_launchVelocityUp'):GetInt()
        mv:SetVelocity(vel)
        ply:SetWallDirection(Vector(0,0,0))

    end

    if not ply:IsOnGround() then return end
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
    end
end

function wallJumpCheck (ply, mv)
    local pos = ply:EyePos()
    pos.z = pos.z - 25
    local vel = mv:GetVelocity()
    local wallDir = ply:GetWallDirection()

    if wallDir == Vector(0,0,0) then
        wallDir = ply:GetAimVector()
    else
        vel.z = vel.z + 5
        mv:SetVelocity(vel)
    end

    wallDir.z = 0
    wallDir = wallDir:GetNormalized()

    local tr = util.TraceLine({
        start = pos,
        endpos = pos + wallDir * 23,
        filter = ply
    })

    if tr.Hit then
        if ply:GetWallDirection() == Vector(0,0,0) then
            if vel.z < 0 then vel.z = 0 end
            mv:SetVelocity(vel)
        end
        ply:SetWallDirection(wallDir)
    else
        ply:SetWallDirection(Vector(0,0,0))
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
