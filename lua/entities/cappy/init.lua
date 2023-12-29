include('shared.lua')
AddCSLuaFile('cl_init.lua')

local capOffset = Vector(0,0,5)

function ENT:Initialize()
    self:SetModel("models/MarioCap.mdl")
    -- self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_CUSTOM)
    self:SetSolid(SOLID_NONE)
    self:SetGravity(0)

    self:SetStartPos(self:GetPos())

    self:Activate()

    local phys = self:GetPhysicsObject()
    if phys:IsValid() then
        -- phys:Wake()
    end

    // Remove the entity after 20 seconds
    timer.Simple(20, function()
        if self:IsValid() then
            self:Remove()
        end
    end)
end

function ENT:Think()
    // As long as flying is true fly towards the end position
    if self:GetIsFlying() then
        local pos = self:GetPos()
        local endPos = self:GetEndPos()
        local dir = (endPos - pos):GetNormalized()
        local speed = 400
        local newPos = pos + dir * speed * FrameTime()
        self:SetPos(newPos)

        // Spin the model

    end

    local ang = self:GetAngles()
        ang:RotateAroundAxis(-ang:Up(), 400 * FrameTime())
        self:SetAngles(ang)

    // Check if the entity is close enough to the end position
    if self:GetPos():Distance(self:GetEndPos()) < 5 and self:GetIsFlying(true) then
        self:SetIsFlying(false)
        self:SetSolid(SOLID_VPHYSICS)

        timer.Simple(0.5, function()
            if self:IsValid() then
                self:SetShouldRemove(true)

                timer.Simple(1.5, function()
                    if self:IsValid() then
                        self:Remove()
                    end
                end)
            end
        end)
    end


    if not self:GetIsFlying() then
        checkClose(self, self:GetOwner())
    end


    if self:GetShouldRemove() then

        if not self:GetOwner():KeyDown(IN_USE) then
            self:Remove()
        end

    end


    self:NextThink(CurTime())


    return true
end

function checkClose(this, ply)

    // Check if the player is close to us
    if ply:GetPos():Distance(this:GetPos() - capOffset - Vector(0,0,28)) < 40 then
        ply:SetHitCap(true)
        this:Remove()
    end

    // Check if we are near any entitys we can press e on
    for k, v in pairs(ents.FindInSphere(this:GetPos() - capOffset, 20)) do
        if v:GetClass() == "func_door" then
            v:Fire("Open")
            this:Remove()
        end

        if v:GetClass() == "func_door_rotating" then
            v:Fire("Open")
            this:Remove()
        end

        if v:GetClass() == "func_button" then
            v:Fire("Press")
            this:Remove()
        end


    end

    -- debugoverlay.Sphere(this:GetPos() - capOffset, 20, 0.1, Color(255,0,0), true)

end

function ENT:SetupDataTables()
    self:NetworkVar("Bool", 0, "IsFlying")
    self:NetworkVar("Vector", 0, "StartPos")
    self:NetworkVar("Vector", 1, "EndPos")
    self:NetworkVar("Bool", 1, "ShouldRemove")
end


