-- Listen for the network message
net.Receive("player_dummy_network", function()
    local player_dummy = net.ReadEntity()
    if not IsValid(player_dummy) then return end
    local player_dummy_pos = net.ReadVector()

    print(player_dummy)
    print(player_dummy_pos)

    -- Function to draw a circle at the specified position
    local function DrawCircle(pos, radius, color)
        local segments = 64  -- The number of segments to create a smooth circle
        local circle = {}
        local step = 2 * math.pi / segments

        for i = 1, segments do
            local x = math.cos(i * step) * radius + pos.x
            local y = math.sin(i * step) * radius + pos.y
            table.insert(circle, {x = x, y = y})
        end

        -- Draw the circle
        surface.SetDrawColor(color)
        draw.NoTexture()
        surface.DrawPoly(circle)
    end

    timer.Create("PlayerPositionThink", 0.1, 0, function()
        if IsValid(player_dummy) then
            print("TRUE")
            player_dummy_pos = player_dummy:GetPos()
        end
    end)

    -- Draw the circle at the playerDummy's position
    hook.Add("PostDrawOpaqueRenderables", "DrawPlayerDummyCircle", function()
        if not IsValid(player_dummy) then return end

        local tr = util.TraceLine({
            start = player_dummy_pos + Vector(0, 0, 20), -- Start slightly above the entity
            endpos = player_dummy_pos - Vector(0, 0, 1000), -- Cast a ray downward
            mask = MASK_SOLID,   -- Use the modified trace mask
            filter = player_dummy,
        })

        local groundPos = Vector(player_dummy:GetPos().x, player_dummy:GetPos().y, tr.HitPos.z + 2)

        local eyePos = LocalPlayer():EyePos()
        local distance = eyePos:Distance(player_dummy_pos)

        -- Adjust the circle's size based on distance
        local circleRadius = 20 + (distance / 50)  -- You can adjust the scaling factor as needed

        cam.Start3D2D(groundPos, Angle(0, 0, 0), 1)
        DrawCircle(Vector(0, 0), circleRadius, Color(255, 0, 0, 150))  -- Change color and alpha as needed
        cam.End3D2D()
    end)
end)

-- hook.Remove("PostDrawOpaqueRenderables", "DrawPlayerDummyCircle")
if timer.Exists("PlayerPositionThink") then
    timer.Remove("PlayerPositionThink")
end
