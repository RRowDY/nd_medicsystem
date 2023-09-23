print(".")

-- hook.Add("OnPlayerChat", "TestCommand", function(ply, text, teamChat, isDead)
--     if not IsValid(ply) then return end

--     local args = string.Explode(" ", text)
--     PrintTable(args)

--     if args[1] ~= string.lower("/text") then return end

--     net.Start("SendPlayerRagdollToServer")
--     net.WriteEntity(ply)
--     net.SendToServer()
-- end)
