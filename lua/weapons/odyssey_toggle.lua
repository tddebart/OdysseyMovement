
SWEP.PrintName = "odyssey movement toggle"
SWEP.Author = "Boss Sloth"
SWEP.Instructions = "Left click to activate/deactivate. Toggles odyssey movement"
SWEP.Category = "Other"
SWEP.Spawnable = true
SWEP.AdminOnly = false
SWEP.DrawAmmo = false
SWEP.UseHands = true
SWEP.ViewModel = "models/weapons/c_pistol.mdl"
SWEP.WorldModel = "models/weapons/w_pistol.mdl"

function SWEP:Initialize()
   self:SetHoldType("normal")
end

function SWEP:Deploy()
   self:SendWeaponAnim(ACT_VM_DRAW)
   return true
end

function SWEP:Holster()
   return true
end

function SWEP:PrimaryAttack()
   self:SetNextPrimaryFire(CurTime() + 1)
   local ply = self:GetOwner()

   if SERVER then
      ply:SetOdyEnabled(!ply:GetOdyEnabled())
   end
   if ply:GetOdyEnabled() then
      self:DisplayMessage("Odysey movement enabled")
   else
      self:DisplayMessage("Odysey movement disabled")
   end
end

function SWEP:SecondaryAttack()
   -- Do nothing
end

function SWEP:DisplayMessage(message)
   if SERVER then
       local ply = self:GetOwner()
       if IsValid(ply) then
           ply:ChatPrint(message)
       end
   end
end
