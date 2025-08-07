-- Beta | Slap Battles Hub

-- Locals

local bool_use_clickdetector = false -- Use fireclickdetector for equipping gloves
local localplayer = game:GetService("Players").LocalPlayer
local rep_storage = game:GetService("ReplicatedStorage")
local tween_service = game:GetService("TweenService")
local pos_table = { -- Dictionary of all positions and spots ingame
    Arena = {0, -5, 0},
    Lobby = {-997, 328, -2},
    Safespot = {10000, -45, 10000},
    Safespot2 = {-10000, -45, -10000},
    Hitman = {17893, -24, -3548},
    Cannon = {264, 34, 199},
    Slapple = {-403, 51, -15},
    EvilBarzil = {0, 0, 0},
    Tower = {0, 0, 0},
}

-- Set hub instance number to break connections

getgenv().BETA_INSTANCE_NUMBER = "BETA_" .. math.random(1000000, 9999999)
local current_instance_number = getgenv().BETA_INSTANCE_NUMBER

-- Load Lib

loadstring(game:HttpGet("https://raw.githubusercontent.com/Andris303/LocalBeta/refs/heads/main/Lib.lua",true))()

-- Load Rayfield

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Emo Hub",
   Icon = "banana",
   LoadingTitle = "Emo Hub",
   LoadingSubtitle = "by EmoSad999",
   ShowText = "Emo Hub",
   Theme = "Amethyst",

   ToggleUIKeybind = "K",

   DisableRayfieldPrompts = false,
   DisableBuildWarnings = false,

   ConfigurationSaving = {
      Enabled = false,
      FolderName = nil,
      FileName = "Beta"
   },

   Discord = {
      Enabled = false,
      Invite = "noinvitelink",
      RememberJoins = true
   },

   KeySystem = false,
   KeySettings = {
      Title = "Untitled",
      Subtitle = "Key System",
      Note = "No method of obtaining the key is provided",
      FileName = "Key",
      SaveKey = true,
      GrabKeyFromSite = false,
      Key = {"Hello"}
   }
})

-- Simply notify the user through rayfield

local function notify(title, content)
    Rayfield:Notify({
        Title = title,
        Content = content,
        Duration = 6.5,
        Image = 4483362458,
    })
end

-- Runs functions on a different thread

local function run(...)
    task.spawn(...)
end

-- Basic root position changing

local function tp(x, y, z)
    if localplayer.Character:FindFirstChild("HumanoidRootPart") then -- if root is present
        local root = localplayer.Character.HumanoidRootPart
        root.CFrame = CFrame.new(x, y, z)
    end
end

if game.PlaceId == 6403373529 then -- check if were in main slap battles

-- Safespot create function

local function create_safespot(name, bool_bob, posx, posy, posz)
    local Safespot = Instance.new("Part",workspace)
    Safespot.Name = "name"
    Safespot.Position = Vector3.new(posx,posy,posz)
    Safespot.Size = Vector3.new(5000,10,5000)
    Safespot.Anchored = true
    Safespot.CanCollide = true
    Safespot.Transparency = .5
    if bool_bob then Safespot.CollisionGroup = "Bobstuff" end
end

-- Code

-- Checks if NIE is setup, if it isn't, it sets NIE up (Network Instance Equipping)

local function setup_NIE()
    if getgenv().BETA_NIE_INSTANCE then -- checks if NIE is already setup
        notify("NIE setup successful", "NIE setup has been successful")
        return
    end

    workspace.Lobby.Teleport1.Parent = rep_storage
    workspace.Lobby.Teleport2.Parent = rep_storage

    local network_folder
    if rep_storage:FindFirstChild("_NETWORK") then
        network_folder = rep_storage["_NETWORK"]
    else
        for _, inst in pairs(rep_storage:GetChildren()) do
            if string.match(inst.Name, "{") then
                network_folder = inst
            end
        end
    end
    local current_glove = localplayer:WaitForChild("leaderstats"):WaitForChild("Glove").Value
    local glove_to_equip = "bus"

    for _, inst in pairs(network_folder:GetChildren()) do
        if string.match(inst.Name, "{") and inst.ClassName == "RemoteEvent" then -- checks if instance is a network instance
            inst:FireServer(glove_to_equip)
            task.wait(.3)
            if localplayer:WaitForChild("leaderstats"):WaitForChild("Glove").Value == glove_to_equip then
                getgenv().BETA_NIE_INSTANCE = inst
                rep_storage.Teleport1.Parent = workspace.Lobby
                rep_storage.Teleport2.Parent = workspace.Lobby
                inst:FireServer(current_glove)
                notify("NIE setup successful", "NIE setup has been successful")
                return
            end
        end
    end
    rep_storage.Teleport1.Parent = workspace.Lobby
    rep_storage.Teleport2.Parent = workspace.Lobby

    bool_use_clickdetector = true

    notify("NIE setup failure", "Features using NIE will not work")
end

-- Main equip function, if fails to equip, then returns

local function equip(glove)
    if localplayer:WaitForChild("leaderstats"):WaitForChild("Glove").Value == glove then return end -- if glove is equipped already, return

    if getgenv().BETA_NIE_INSTANCE and not bool_use_clickdetector then
        getgenv().BETA_NIE_INSTANCE:FireServer(glove)
        task.wait(.1)
        if localplayer:WaitForChild("leaderstats"):WaitForChild("Glove").Value == glove then
            return
        else
            use_NIE = false
        end
    elseif bool_use_clickdetector then
        fireclickdetector(workspace.Lobby:FindFirstChild(glove).ClickDetector)
    else
        notify("NIE not setup", "Features using NIE won\'t work")
    end
end

-- Initialize setup_NIE()

run(function()
    if not localplayer.Character.isInArena.Value or getgenv().BETA_NIE_INSTANCE then
        run(setup_NIE)
        return
    end
    notify("NIE setup halted", "NIE setup will be halted until you are in the lobby")
    workspace.ChildAdded:Connect(function(child)
        if current_instance_number ~= getgenv().BETA_INSTANCE_NUMBER then return end
        task.wait()
        if child.Name == localplayer.Name then
            repeat task.wait()
            until localplayer.Character.isInArena.Value == false
            run(setup_NIE)
            return
        end
    end)
end)

-- Create Safespot

if workspace:FindFirstChild("Safespot") == nil then
    run(create_safespot, "Safespot", false, 10000, -50, 10000)
    run(create_safespot, "Bobspot", true, 10000, -50, 10000) -- Also create a duplicate so rob doesn't fall through the baseplate :)
end

if workspace:FindFirstChild("Safespot2") == nil then
    run(create_safespot, "Safespot2", false, -10000, -50, -10000)
    run(create_safespot, "Bobspot2", true, -10000, -50, -10000) -- Also create a duplicate so rob doesn't fall through the baseplate :)
end

-- Replace barzil with fake (anti barzil)

for _, inst in pairs(workspace.Lobby.brazil:GetChildren()) do
    inst:Destroy()
end

local fake_barzil = Instance.new("Part", workspace)
fake_barzil.Name = "fake_barzil"
fake_barzil.Position = Vector3.new(-924, 304.53, -1.9)
fake_barzil.Rotation = Vector3.new(-90, 0, 90)
fake_barzil.Size = Vector3.new(24, 28, 4)
fake_barzil.Anchored = true
fake_barzil.CanCollide = true
fake_barzil.Transparency = .5

-- Create Tabs

local Misc = Window:CreateTab("Misc")

local Target = Window:CreateTab("Target")

local Abuse = Window:CreateTab("Abuse")

local Glove = Window:CreateTab("Glove")

local Helper = Window:CreateTab("Helper")

local Places = Window:CreateTab("Places")

-- Create elements in tabs

-- Misc

Misc:CreateDivider()

-- Text box for equipping gloves

local equip_text_box = Misc:CreateInput({
    Name = "Glove",
    CurrentValue = "",
    PlaceholderText = "Eg: Default",
    RemoveTextAfterFocusLost = false,
    Callback = function(Text) end,
})

-- Button for equipping gloves

local equip_button = Misc:CreateButton({
    Name = "Equip Glove",
    Callback = function()
        run(equip, equip_text_box.CurrentValue)
    end,
})

-- Forward declare reset_TP_dropdown

local reset_TP_dropdown

-- TP dropdown

local TP_dropdown = Misc:CreateDropdown({
    Name = "Teleport",
    Options = {"Safespot","Arena","Lobby","Hitman","Cannon","Slapple"},
    CurrentOption = {},
    MultipleOptions = false,
    Callback = function(Options)
        if Options[1] == "None" then return end
        run(tp, table.unpack(pos_table[Options[1]]))
        run(reset_TP_dropdown)
    end,
})

-- reset_TP_dropdown is here now

function reset_TP_dropdown()
    TP_dropdown:Set({"None"})
end

-- Toggle death barriers

local remove_death_barriers_toggle = Misc:CreateToggle({
    Name = "Remove death barriers",
    CurrentValue = false,
    Callback = function(Value)
        local bad_boy_table = {"AntiDefaultArena", "Antidream", "ArenaBarrier", "DEATHBARRIER", "DEATHBARRIER2", "dedBarrier"}
        for _, inst in pairs(bad_boy_table) do
            if Value then
                workspace[inst].Parent = rep_storage
            else
                rep_storage[inst].Parent = workspace
            end
        end
    end,
})

-- Locals for saving between features

local bool_auto_enter = false
local bool_equip_saved_glove_grab = false
local grab_glove_save
local bool_help_kill = false
local target_help
local bool_help_run = false
local bool_ready_run = false
local bool_help_rob = false
local bool_ready_rob = false

-- Auto enter arena

local auto_enter_arena = Misc:CreateToggle({
    Name = "Auto enter arena",
    CurrentValue = false,
    Callback = function(Value)
        if not localplayer.Character.isInArena.Value then
            firetouchinterest(localplayer.Character:WaitForChild("HumanoidRootPart"), workspace.Lobby.Teleport1, 0)
        end
        bool_auto_enter = Value
    end,
})

-- Used by auto enter arena watch for change
-- Used by grab barzil to change gloves after reset
-- Used by kill farm help
-- Used by farm run mastery

run(function()
    workspace.ChildAdded:Connect(function(child)
        if current_instance_number ~= getgenv().BETA_INSTANCE_NUMBER then return end

        task.wait(.1)

        if child.Name == "RunArea" and workspace:FindFirstChild("Orb") and bool_ready_run then
            bool_ready_run = false

            task.wait(1.5)

            run(tp, child.One.Position.X, child.One.Position.Y + 9, child.One.Position.Z)

            task.wait(3)

            if workspace:FindFirstChild(target_help .. "\'s Labyrinth") then
                local hitbox = workspace[target_help]:WaitForChild("Skull"):WaitForChild("Hitbox")

                repeat
                    run(tp, hitbox.Position.X, hitbox.Position.Y, hitbox.Position.Z)
                    task.wait(.1)
                until localplayer.Character:WaitForChild("Humanoid").Health == 0
            end
        end

        if child.Name ~= localplayer.Name then return end

        if bool_auto_enter then
            repeat
                firetouchinterest(localplayer.Character:WaitForChild("HumanoidRootPart"), workspace.Lobby.Teleport1, 0)
                task.wait(.1)
            until localplayer.Character.isInArena.Value
        end
        if bool_equip_saved_glove_grab then
            task.wait(.5)

            for c = 0, 10, 1 do
                run(equip, grab_glove_save)
                task.wait(.1)

                if localplayer.leaderstats.Glove.Value == grab_glove_save then break end
            end
        end
        if bool_help_kill then
            repeat
                firetouchinterest(localplayer.Character:WaitForChild("HumanoidRootPart"), workspace.Lobby.Teleport1, 0)
                task.wait(.1)
            until localplayer.Character.isInArena.Value

            localplayer.Character:WaitForChild("HumanoidRootPart").CFrame = game:GetService("Players")[target_help].Character.HumanoidRootPart.CFrame * CFrame.new(0,0,-4) -- Teleport to target slightly forward
            
            task.wait(.4)

            localplayer.Reset:FireServer()
        end
        if bool_help_run then
            repeat
                firetouchinterest(localplayer.Character:WaitForChild("HumanoidRootPart"), workspace.Lobby.Teleport1, 0)
                task.wait(.1)
            until localplayer.Character.isInArena.Value

            task.wait(.1)

            run(tp, table.unpack(pos_table.Safespot))

            bool_ready_run = true
        end
        if bool_help_rob then
            repeat
                firetouchinterest(localplayer.Character:WaitForChild("HumanoidRootPart"), workspace.Lobby.Teleport1, 0)
                task.wait(.1)
            until localplayer.Character.isInArena.Value

            task.wait(.1)

            run(tp, table.unpack(pos_table.Safespot))

            bool_ready_rob = true
        end
    end)
end)

-- Descendant added for workspace because rob mas help is very stupid

run(function()
    workspace.DescendantAdded:Connect(function(descendant)
        if current_instance_number ~= getgenv().BETA_INSTANCE_NUMBER then return end

        if target_help == nil then return end

        task.wait(.1)

        if workspace:FindFirstChild(target_help) and descendant.Name == "RobTransformed" then
            if descendant.Parent == workspace[target_help] and bool_ready_rob then
                task.wait(2.8)

                local root = workspace[target_help]:WaitForChild("HumanoidRootPart")
                run(tp, root.Position.X, root.Position.Y, root.Position.Z)
            end
        end
    end)
end)

Misc:CreateDivider()

-- Target

Target:CreateDivider()

-- Dynamic playerlist

local playerlist_dropdown = Target:CreateDropdown({
    Name = "Select player",
    Options = {"Loading..."},
    CurrentOption = {},
    MultipleOptions = false,
    Callback = function(Options)
        -- Empty
    end,
})

-- Function to update playerlist

local function update_playerlist()
    local playerlist_table = {}
    local table_counter = 1
    for _, inst in pairs(game:GetService("Players"):GetChildren()) do
        if inst.Name ~= localplayer.Name then
            playerlist_table[table_counter] = inst.DisplayName .. " (" .. inst.Name .. ")"
            table_counter = table_counter + 1
        end
    end
    playerlist_dropdown:Refresh(playerlist_table)
end

-- Initialize playerlist

run(update_playerlist)

-- Watch for change in playerlist

game:GetService("Players").ChildAdded:Connect(function(_unused)
    if current_instance_number ~= getgenv().BETA_INSTANCE_NUMBER then return end
    run(update_playerlist)
end)

game:GetService("Players").ChildRemoved:Connect(function(_unused)
    if current_instance_number ~= getgenv().BETA_INSTANCE_NUMBER then return end
    run(update_playerlist)
end)

-- Kill selected player with rob

local molest = Target:CreateButton({
    Name = "Molest™",
    Callback = function()
        local glove_save = localplayer:WaitForChild("leaderstats"):WaitForChild("Glove").Value
        local in_arena = localplayer.Character.isInArena.Value

        if in_arena then
            notify("Not in lobby", "Molest doesn\'t work in arena")
            return
        end

        local _unused, target_name = string.match(playerlist_dropdown.CurrentOption[1], "(.+)%s%((.+)%)")

        if not game:GetService("Players")[target_name].Character:WaitForChild("isInArena").Value then
            notify("Target not in lobby", "Molest doesn\'t work when target is in lobby")
            return
        end

        if not game:GetService("Players")[target_name].Character:FindFirstChild("Humanoid") then
            notify("Target has no humanoid", "Likely due to using diamond or megarock")
            return
        end

        run(tp, table.unpack(pos_table.Safespot)) -- TP to safespot

        run(equip, "rob") -- Equip rob

        task.wait(.05)

        if not localplayer:WaitForChild("leaderstats"):WaitForChild("Glove").Value == "rob" then return end -- If equip failed then return

        rep_storage.rob:FireServer(false) -- Use ability

        task.wait(.05)

        run(equip, glove_save) -- Change back to previous glove

        task.wait(3.5) -- Wait until animation finishes

        if not game:GetService("Players")[target_name].Character.isInArena.Value or game:GetService("Players")[target_name].Character:WaitForChild("Humanoid").Health == 0 then
            notify("Target died", "Target died before rob animation finished")
            localplayer.Reset:FireServer()
            return
        end

        if not game:GetService("Players")[target_name].Character:FindFirstChild("Humanoid") then
            notify("Target has no humanoid", "Likely due to using diamond or megarock")
            return
        end

        local target_root = game:GetService("Players")[target_name].Character.HumanoidRootPart
        local target_position = {target_root.Position.X, target_root.Position.Y, target_root.Position.Z}

        run(tp, table.unpack(target_position)) -- Teleports to target's position

        task.wait(.2)

        run(tp, table.unpack(pos_table.Safespot)) -- TP back to safespot

        task.wait(.1)

        run(tp, table.unpack(pos_table.Safespot2)) -- TP to safespot2 to avoid suspicion

        task.wait(.3)

        localplayer.Reset:FireServer() -- Reset

        -- Setup changing gloves when respawning

        bool_equip_saved_glove_grab = true
        grab_glove_save = glove_save
    end,
})

-- Teleport selected player to barzil with grab glove

local grab_barzil = Target:CreateButton({
    Name = "Banish to barzil",
    Callback = function()
        local glove_save = localplayer:WaitForChild("leaderstats"):WaitForChild("Glove").Value
        local in_arena = localplayer.Character.isInArena.Value

        if in_arena then
            notify("Not in lobby", "Grab barzil doesn\'t work in arena")
            return
        end

        local _unused, target_name = string.match(playerlist_dropdown.CurrentOption[1], "(.+)%s%((.+)%)")

        if not game:GetService("Players")[target_name].Character:WaitForChild("isInArena").Value then
            notify("Target not in lobby", "Grab barzil doesn\'t work when target is in lobby")
            return
        end

        if not game:GetService("Players")[target_name].Character:FindFirstChild("Humanoid") then
            notify("Target has no humanoid", "Likely due to using diamond or megarock")
            return
        end

        run(tp, table.unpack(pos_table.Safespot)) -- TP to safespot

        run(equip, "Ghost") -- Equip ghost

        task.wait(.11)

        if not localplayer:WaitForChild("leaderstats"):WaitForChild("Glove").Value == "Ghost" then return end -- If equip failed then return

        rep_storage.Ghostinvisibilityactivated:FireServer() -- Become invisible

        task.wait(.1)

        run(equip, "Grab") -- Equip grab

        task.wait(.1)

        if not localplayer:WaitForChild("leaderstats"):WaitForChild("Glove").Value == "Grab" then return end -- If equip failed then return

        if not game:GetService("Players")[target_name].Character.isInArena.Value or game:GetService("Players")[target_name].Character:WaitForChild("Humanoid").Health == 0 then
            notify("Target died", "Target died before rob animation finished")
            localplayer.Reset:FireServer()
            return
        end

        if not game:GetService("Players")[target_name].Character:FindFirstChild("Humanoid") then
            notify("Target has no humanoid", "Likely due to using diamond or megarock")
            return
        end

        run(tp, table.unpack(pos_table.Lobby))

        task.wait(.11)

        repeat
            task.wait(.01)
            firetouchinterest(localplayer.Character:WaitForChild("HumanoidRootPart"), workspace.Lobby.Teleport1, 0)
        until localplayer.Character.isInArena.Value

        task.wait(.05)

        local target_root = game:GetService("Players")[target_name].Character.HumanoidRootPart
        localplayer.Character.HumanoidRootPart.CFrame = target_root.CFrame * CFrame.new(0,0,1) -- Teleport to target slightly behind

        fake_barzil.CanCollide = false -- Disable collision on fake barzil

        task.wait(.08)

        rep_storage.GeneralAbility:FireServer() -- Grab target

        task.wait(.1)

        run(tp, -925, 308, -2) -- TP to barzil portal

        task.wait(.3)

        localplayer.Reset:FireServer() -- Reset

        fake_barzil.CanCollide = true -- Enable collision on fake barzil

        bool_equip_saved_glove_grab = true
        grab_glove_save = glove_save

        task.wait(4.5)

        bool_equip_saved_glove_grab = false
        grab_glove_save = nil
    end,
})

Target:CreateDivider()

-- Abuse

Abuse:CreateDivider()

-- Spam "flamesloop" sounds

sound_spam = Abuse:CreateToggle({
    Name = "Sound spam",
    CurrentValue = false,
    Callback = function(Value)
        -- Empty
    end,
})

run(function()
    while true do
        if sound_spam.CurrentValue then
            rep_storage.PlaySoundRemote:InvokeServer("FlamesLoop", localplayer.Character:WaitForChild("HumanoidRootPart"))
            task.wait()
        else
            task.wait(.1)
        end
    end
end)

-- Lag server by spamming slapstick abilities, reset to stop

local lag_server = Abuse:CreateButton({
    Name = "Lag of doom and destruction",
    Callback = function()
        tp(table.unpack(pos_table.Safespot))

        task.wait(.2)

        -- Don't lag ourself :)

        localplayer.Character.ChildAdded:Connect(function(child)
            if child.Name == "runblur" then
                task.wait(.1)
                child:Destroy()
            end
        end)

        while true do
            if localplayer.Character.Humanoid.Health == 0 then break end

            rep_storage.slapstick:FireServer("runeffect")

            task.wait()
        end
    end,
})

Abuse:CreateDivider()

-- Gloves

Glove:CreateDivider()

-- Auto click your own tycoon

-- locals to trick my own code lmao

local auto_click = {CurrentValue = nil}
local auto_destroy = {CurrentValue = nil}

-- function to auto click specific tycoon

local function auto_click_tycoon(inst)
    task.wait(.2)

    if not inst:FindFirstChild("Click") or not auto_click.CurrentValue then return end

    local clicky = inst:WaitForChild("Click"):WaitForChild("ClickDetector")

    while true do
        task.wait()
        if not inst:FindFirstChild("Click") or not auto_click.CurrentValue then break end
        fireclickdetector(clicky)
    end
end

-- function to destroy specific tycoon

local function destroy_tycoon(inst)
    task.wait(.2)

    if not inst:FindFirstChild("Destruct") or not auto_destroy.CurrentValue then return end

    local destructy = inst:WaitForChild("Destruct"):WaitForChild("ClickDetector")
    local counter = inst:WaitForChild("Counter"):WaitForChild("Part"):WaitForChild("SurfaceGui"):WaitForChild("TextLabel")

    if tonumber(counter.Text) < 499 then
        fireclickdetector(destructy)
    else
        repeat
            task.wait()
            fireclickdetector(destructy)
        until inst.SDCounter.Counter.SurfaceGui.TextLabel.Text == "100"
    end
end

-- auto click tycoons toggle

auto_click = Glove:CreateToggle({
    Name = "Auto click tycoon",
    CurrentValue = false,
    Callback = function(Value)
        if workspace:FindFirstChild("\195\133Tycoon" .. localplayer.Name) then
            run(auto_click_tycoon, workspace:FindFirstChild("\195\133Tycoon" .. localplayer.Name))
        end
    end,
})

-- Auto destroy tycoons toggle

auto_destroy = Glove:CreateToggle({
    Name = "Auto destroy tycoons",
    CurrentValue = false,
    Callback = function(Value)
        for _, inst in pairs(workspace:GetChildren()) do
            if string.match(inst.Name, "\195\133Tycoon") and inst.Name ~= "\195\133Tycoon" .. localplayer.Name then
                run(destroy_tycoon, inst)
            end
        end
    end,
})

-- Function to find tycoons to click in a good or avery dark and twisted way

run(function()
    workspace.ChildAdded:Connect(function(child)
        if current_instance_number ~= getgenv().BETA_INSTANCE_NUMBER then return end
        task.wait(.1)
        if child.Name == "\195\133Tycoon" .. localplayer.Name then
            if auto_click.CurrentValue then
                run(auto_click_tycoon, child)
            end
        end
        if string.match(child.Name, "\195\133Tycoon") and child.Name ~= "\195\133Tycoon" .. localplayer.Name  then
            if auto_destroy.CurrentValue then
                run(destroy_tycoon, child)
            end
        end
    end)
end)

-- 100 times more powerful jet ability

jet_powered_fan = Glove:CreateToggle({
    Name = "JET POWERED FAN",
    CurrentValue = false,
    Callback = function(Value)
        if Value then run(equip, "Fan") end
    end,
})

run(function()
    while true do
        if jet_powered_fan.CurrentValue then
            rep_storage:WaitForChild("GeneralAbility"):FireServer()
            task.wait()
        else
            task.wait(.1)
        end
    end
end)

Glove:CreateDivider()

-- Helper

Helper:CreateDivider()

-- Text box to select player

local select_player_textbox = Helper:CreateInput({
    Name = "Player to help",
    CurrentValue = "",
    PlaceholderText = "Eg: BaconHair123",
    RemoveTextAfterFocusLost = false,
    Callback = function(Text)
        target_help = Text
    end,
})

local help_farm_kill_toggle = Helper:CreateToggle({
    Name = "Help player farm kills",
    CurrentValue = false,
    Callback = function(Value)
        bool_help_kill = Value

        if Value and not localplayer.Character.isInArena.Value then
            repeat
                firetouchinterest(localplayer.Character:WaitForChild("HumanoidRootPart"), workspace.Lobby.Teleport1, 0)
                task.wait(.1)
            until localplayer.Character.isInArena.Value

            localplayer.Character:WaitForChild("HumanoidRootPart").CFrame = game:GetService("Players")[target_help].Character.HumanoidRootPart.CFrame * CFrame.new(0,0,-4) -- Teleport to target slightly forward
            
            task.wait(.4)

            localplayer.Reset:FireServer()
        end
    end,
})

-- Forward declare reset_bring_dropdown

local reset_bring_dropdown

-- Bring selected player to a location

local bring_location_dropdown = Helper:CreateDropdown({
    Name = "Bring player to location",
    Options = {"Hitman","Cannon","Slapple","Lobby","Arena"},
    CurrentOption = {},
    MultipleOptions = false,
    Callback = function(Options)
        if Options[1] == "None" then return end

        run(reset_bring_dropdown)

        local glove_save = localplayer:WaitForChild("leaderstats"):WaitForChild("Glove").Value
        local in_arena = localplayer.Character.isInArena.Value

        if in_arena then
            notify("Not in lobby", "Grab barzil doesn\'t work in arena")
            return
        end

        local target_name = target_help

        if not game:GetService("Players")[target_name].Character:WaitForChild("isInArena").Value then
            notify("Target not in lobby", "Grab barzil doesn\'t work when target is in lobby")
            return
        end

        if not game:GetService("Players")[target_name].Character:FindFirstChild("Humanoid") then
            notify("Target has no humanoid", "Likely due to using diamond or megarock")
            return
        end

        run(tp, table.unpack(pos_table.Safespot)) -- TP to safespot

        run(equip, "Ghost") -- Equip ghost

        task.wait(.11)

        if not localplayer:WaitForChild("leaderstats"):WaitForChild("Glove").Value == "Ghost" then return end -- If equip failed then return

        rep_storage.Ghostinvisibilityactivated:FireServer() -- Become invisible

        task.wait(.1)

        run(equip, "Grab") -- Equip grab

        task.wait(.1)

        if not localplayer:WaitForChild("leaderstats"):WaitForChild("Glove").Value == "Grab" then return end -- If equip failed then return

        if not game:GetService("Players")[target_name].Character.isInArena.Value or game:GetService("Players")[target_name].Character:WaitForChild("Humanoid").Health == 0 then
            notify("Target died", "Target died before rob animation finished")
            localplayer.Reset:FireServer()
            return
        end

        if not game:GetService("Players")[target_name].Character:FindFirstChild("Humanoid") then
            notify("Target has no humanoid", "Likely due to using diamond or megarock")
            return
        end

        run(tp, table.unpack(pos_table.Lobby))

        task.wait(.11)

        repeat
            task.wait(.01)
            firetouchinterest(localplayer.Character:WaitForChild("HumanoidRootPart"), workspace.Lobby.Teleport1, 0)
        until localplayer.Character.isInArena.Value

        task.wait(.05)

        local target_root = game:GetService("Players")[target_name].Character.HumanoidRootPart
        localplayer.Character.HumanoidRootPart.CFrame = target_root.CFrame * CFrame.new(0,0,3) -- Teleport to target slightly behind

        task.wait(.08)

        rep_storage.GeneralAbility:FireServer() -- Grab target

        task.wait(.1)

        run(tp, table.unpack(pos_table[Options[1]])) -- TP to location

        task.wait(.3)

        localplayer.Reset:FireServer() -- Reset

        bool_equip_saved_glove_grab = true
        grab_glove_save = glove_save

        task.wait(4.5)

        bool_equip_saved_glove_grab = false
        grab_glove_save = nil
    end,
})

-- reset_bring_dropdown is here now

function reset_bring_dropdown()
    bring_location_dropdown:Set({"None"})
end

local help_run_mas_toggle = Helper:CreateToggle({
    Name = "Help with run mastery",
    CurrentValue = false,
    Callback = function(Value)
        bool_help_run = Value

        if not Value then
            bool_ready_run = false
            return
        end

        local in_arena = localplayer.Character.isInArena.Value

        if in_arena then
            notify("Not in lobby", "Help run doesn\'t work in arena")
            return
        end

        task.wait(.1)

        repeat
            task.wait(.01)
            firetouchinterest(localplayer.Character:WaitForChild("HumanoidRootPart"), workspace.Lobby.Teleport1, 0)
        until localplayer.Character.isInArena.Value

        task.wait(.1)

        run(tp, table.unpack(pos_table.Safespot))

        bool_ready_run = true
    end,
})

local help_rob_mas_toggle = Helper:CreateToggle({
    Name = "Help with rob mastery",
    CurrentValue = false,
    Callback = function(Value)
        bool_help_rob = Value

        if not Value then
            bool_ready_rob = false
            return
        end

        local in_arena = localplayer.Character.isInArena.Value

        if in_arena then
            notify("Not in lobby", "Help rob doesn\'t work in arena")
            return
        end

        task.wait(.1)

        repeat
            task.wait(.01)
            firetouchinterest(localplayer.Character:WaitForChild("HumanoidRootPart"), workspace.Lobby.Teleport1, 0)
        until localplayer.Character.isInArena.Value

        task.wait(.1)

        run(tp, table.unpack(pos_table.Safespot))

        bool_ready_rob = true
    end,
})

Helper:CreateDivider()

-- Places

Places:CreateDivider()

local tp_barzil = Places:CreateButton({
    Name = "Teleport to barzil",
    Callback = function()
        game:GetService("TeleportService"):Teleport(7234087065)
    end
})

Places:CreateDivider()

elseif game.PlaceId == 7234087065 then -- check if were in barzil

local Main = Window:CreateTab("Main")

Main:CreateDivider()

local tp_evil_barzil = Main:CreateButton({
    Name = "Teleport to evil barzil portal",
    Callback = function()
        run(tp, -66, 3, -161)
    end
})

local tp_tower_inside = Main:CreateButton({
    Name = "Teleport to tower (inside)",
    Callback = function()
        run(tp, 250, 94, -447)
    end
})

local tp_tower_top = Main:CreateButton({
    Name = "Teleport to tower (top)",
    Callback = function()
        run(tp, 250, 150, -458)
    end
})

Main:CreateDivider()

local tp_main = Main:CreateButton({
    Name = "Teleport to main game",
    Callback = function()
        game:GetService("TeleportService"):Teleport(6403373529)
    end
})

Main:CreateDivider()

end