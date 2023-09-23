local meta = FindMetaTable("Player")

-- Function to create a player's dummy ragdoll
function meta:CreatePlayerDummy()
    if not IsValid(self) then return end

    local ragdoll = ents.Create("prop_ragdoll")
    ragdoll:SetPos(self:GetPos())
    ragdoll:SetModel(self:GetModel())
    ragdoll:SetOwner(self)
    ragdoll:Spawn()

    for i = 0, ragdoll:GetPhysicsObjectCount() - 1 do
        local bonePhysObj = ragdoll:GetPhysicsObjectNum(i)
        if IsValid(bonePhysObj) then
            bonePhysObj:SetVelocity(self:GetVelocity() * 0.3)
        end
    end

    self.PlayerDummy = ragdoll
    return ragdoll
end

-- Function to destroy a player's dummy ragdoll
function meta:DestroyPlayerDummy()
    if IsValid(self.PlayerDummy) then
        self.PlayerDummy:Remove()
    end
end

-- Hook for handling player hurt event
hook.Add("PlayerHurt", "PlayerDummyHook", function(victim, attacker, healthRemaining, damageTaken)
    if healthRemaining <= 1 then
        victim:SetHealth(1)
        victim:GodEnable()

        local playerDummy = victim:CreatePlayerDummy()

        victim:Spectate(OBS_MODE_CHASE)
        victim:SpectateEntity(playerDummy)
        victim:StripWeapons()

        timer.Simple(5, function()
            if IsValid(victim) then
                victim:UnSpectate()
                victim:Spawn()
                victim:SetHealth(victim:GetMaxHealth() * 0.25)
                victim:GodDisable()
                victim:SetPos(playerDummy:GetPos())
                victim:DestroyPlayerDummy()
            end
        end)
    end
end)
