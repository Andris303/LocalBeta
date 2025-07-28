-- Beta | Slap Battles Hub

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

-- Code

-- Locals

local localplayer = game:GetService("Players").LocalPlayer
local leaderstats = localplayer:WaitForChild("leaderstats")
local rep_storage = game:GetService("ReplicatedStorage")

-- Runs functions on a different thread

local function run(...)
    task.spawn(...)
end

-- Basic root position changing

local function tp(x, y, z)
    if localplayer.Character:FindFirstChild("HumanoidRootPart") then -- if root is present
        local root = localplayer.Character:WaitForChild("HumanoidRootPart")
        root.Anchored = true
        root.CFrame = CFrame.new(x, y, z)
        task.wait(.1)
        root.Anchored = false
    end
end

-- Notify user through rayfield's notification system

local function notify(title, content)
    Rayfield:Notify({
        Title = title,
        Content = content,
        Duration = 6.5,
        Image = 4483362458,
    })
end

-- Create Divider

local function divider(tab)
    tab:CreateDivider()
end

-- Checks if NIE is setup, if it isn't, it sets NIE up (Network Instance Equipping)

local function setup_NIE()
    if getgenv().BETA_NIE_INSTANCE then -- checks if NIE is already setup
        notify("NIE setup successful", "NIE setup has been successful")
        return
    end

    workspace.Lobby.Teleport1.Parent = rep_storage
    workspace.Lobby.Teleport2.Parent = rep_storage

    local network_folder = rep_storage:WaitForChild("_NETWORK")
    local current_glove = leaderstats:WaitForChild("Glove").Value
    local glove_to_equip

    if current_glove == "Default" then glove_to_equip = "spin" -- Sets up which gloves it should test NIE on
    else glove_to_equip = "Default" 
    end

    for _, inst in pairs(network_folder:GetChildren()) do
        if string.match(inst.Name, "{") then -- checks if instance is a network instance
            inst:FireServer(glove_to_equip)
            task.wait(.3)
            if leaderstats:WaitForChild("Glove").Value == glove_to_equip then
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
    notify("NIE setup failure", "Features using NIE will not work")
end

-- Main equip function, if fails to equip, then returns

local function equip(glove)
    if leaderstats:WaitForChild("Glove").Value == glove then return end -- if glove is equipped already, return
    local use_NIE = false
    if getgenv().BETA_NIE_INSTANCE then use_NIE = true end

    if use_NIE then
        getgenv().BETA_NIE_INSTANCE:FireServer(glove)
        task.wait(.1)
        if leaderstats:WaitForChild("Glove").Value == glove then
            return
        else
            use_NIE = false
        end
    end
    if not use_NIE then
        if workspace.Lobby:FindFirstChild(glove) then
            fireclickdetector(workspace.Lobby[glove]:WaitForChild("ClickDetector"))
        end
    end
end

-- Initialize setup_NIE()

run(function()
    if not localplayer.Character:WaitForChild("isInArena").Value or getgenv().BETA_NIE_INSTANCE then
        run(setup_NIE)
        return
    end
    notify("NIE setup halted", "NIE setup will be halted until you are in the lobby")
    workspace.ChildAdded:Connect(function(child)
        task.wait()
        if child.Name == localplayer.Name then
            repeat task.wait()
            until localplayer.Character:WaitForChild("isInArena").Value == false
            run(setup_NIE)
            return
        end
    end)
end)

-- Create Safespot

if workspace:FindFirstChild("Safespot") == nil then
    local Safespot = Instance.new("Part",workspace)
    Safespot.Name = "Safespot"
    Safespot.Position = Vector3.new(10000,-50,10000)
    Safespot.Size = Vector3.new(5000,10,5000)
    Safespot.Anchored = true
    Safespot.CanCollide = true
    Safespot.Transparency = .5

    -- Also create a duplicate so rob doesn't fall through the baseplate :)

    local Bobspot = Instance.new("Part",workspace)
    Bobspot.Name = "Bobspot"
    Bobspot.Position = Vector3.new(10000,-50,10000)
    Bobspot.Size = Vector3.new(5000,10,5000)
    Bobspot.Anchored = true
    Bobspot.CanCollide = true
    Bobspot.Transparency = .5
    Bobspot.CollisionGroup = "Bobstuff"
end

-- Create Tabs

local Main = Window:CreateTab("Main")

local Gloves = Window:CreateTab("Gloves")

local Troll = Window:CreateTab("Troll")

-- Create elements in tabs

-- Main

divider(Main)

-- Text box for equipping gloves

local equip_text_box = Main:CreateInput({
    Name = "Glove",
    CurrentValue = "",
    PlaceholderText = "Eg: Default",
    RemoveTextAfterFocusLost = false,
    Callback = function(Text) end,
})

-- Button for equipping gloves

local equip_button = Main:CreateButton({
    Name = "Equip Glove",
    Callback = function()
        run(equip, equip_text_box.CurrentValue)
    end,
})

-- Forward declare reset_TP_dropdown

local reset_TP_dropdown

-- TP dropdown

local TP_dropdown = Main:CreateDropdown({
    Name = "Teleport",
    Options = {"Arena","Lobby","Safespot","Hitman Safespot","Cannon Island","Slapple Island"},
    CurrentOption = {},
    MultipleOptions = false,
    Callback = function(Options)
        if Options[1] == "Arena" then
            run(tp, 0, -5, 0)
        elseif Options[1] == "Lobby" then
            run(tp, -997, 328, -2)
        elseif Options[1] == "Safespot" then
            run(tp, 10000, -45, 10000)
        elseif Options[1] == "Hitman Safespot" then
            run(tp, 17893, -24, -3548)
        elseif Options[1] == "Cannon Island" then
            run(tp, 264, 34, 199)
        elseif Options[1] == "Slapple Island" then
            run(tp, -403, 51, -15)
        end
        run(reset_TP_dropdown)
    end,
})

-- lol

function reset_TP_dropdown()
    TP_dropdown:Set({""})
end

-- Toggle death barriers

local remove_death_barriers_toggle = Main:CreateToggle({
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

divider(Main)

-- Gloves

divider(Gloves)

-- workspace["\195\133TycoonBeggarsBazookaTF2"]

-- Auto click your own tycoon

-- locals to trick my own code lmao

local auto_click = {CurrentValue = nil}
local auto_destroy = {CurrentValue = nil}

-- function to auto click specific tycoon

function auto_click_tycoon(inst)
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

function destroy_tycoon(inst)
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
        until inst:WaitForChild("SDCounter"):WaitForChild("Counter"):WaitForChild("SurfaceGui"):WaitForChild("TextLabel").Text == "100"
    end
end

-- auto click tycoons toggle

auto_click = Gloves:CreateToggle({
    Name = "Auto click tycoon",
    CurrentValue = false,
    Callback = function(Value)
        if workspace:FindFirstChild("\195\133Tycoon" .. localplayer.Name) then
            run(auto_click_tycoon, workspace:FindFirstChild("\195\133Tycoon" .. localplayer.Name))
        end
    end,
})

-- auto destroy tycoons toggle

auto_destroy = Gloves:CreateToggle({
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

-- function to find tycoons to click

local function find_tycoons()
    workspace.ChildAdded:Connect(function(child)
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
end

-- initialize find tycoons

run(find_tycoons)

divider(Gloves)

-- Troll

divider(Troll)

local troll_placeholder = Troll:CreateButton({
    Name = "Placeholder",
    Callback = function()
        -- Empty on purpose
    end,
})

divider(Troll)