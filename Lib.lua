-- Code for bypassing ****-***** censored because of github

-- Block instance function

local function block_instance(inst)
    inst.Name = "BlockedInstance_"..math.random(0,500000)
    inst.Parent = game:GetService("LogService")
    inst:Destroy()
end

-- Lib locals

local lib_SPS = game:GetService("StarterPlayer"):WaitForChild("StarterPlayerScripts")
local lib_RS = game:GetService("ReplicatedStorage")
local lib_RF = game:GetService("ReplicatedFirst")

-- Destroy grab function

local function destroy_grab()
    if lib_RF and lib_RF:FindFirstChild("Client") and lib_RF.Client:FindFirstChild("GrabLocal") then
        block_instance(lib_RF.Client.GrabLocal)
    end
end

-- Destroy mobile lib function

local function destroy_mobile_lib()
    if lib_SPS and lib_SPS:FindFirstChild("ClientAnticheat") and lib_SPS.ClientAnticheat:FindFirstChild("AntiMobileExploits") then
        block_instance(lib_SPS.ClientAnticheat.AntiMobileExploits)
        block_instance(lib_SPS.ClientAnticheat)
    end
end

-- Hook block function

local function init_hook(baad_table, baad_insts, bool_sr)
    if hookmetamethod and getnamecallmethod then
        local Namecall
        Namecall = hookmetamethod(game, "__namecall", function(self, ...)
            local t = tostring(self)
            if bool_sr then
                if getnamecallmethod() == "FireServer" and (t == "Ban" or t == "WalkSpeedChanged" or t == "WS" or t == "WS2") then return end
            else
                if getnamecallmethod() == "FireServer" and (t == "Ban" or t == "WalkSpeedChanged" or t == "AdminGUI" or t == "GRAB" or t == "SpecialGloveAccess") then return end
            end
            return Namecall(self, ...)
        end)
    else
        local events = lib_RS.Events
        for _, inst in pairs(baad_table) do
            if baad_insts:FindFirstChild(inst) then
                block_instance(baad_insts[inst])
            end
        end
    end
    destroy_grab()
    destroy_mobile_lib()
end

-- Runs init_hook how it should in each place

if game.PlaceId == 9431156611 then
    init_hook({"Ban", "WS", "AdminGUI", "WS2"}, lib_RS.Events, true)
elseif game.PlaceId == 11520107397 or game.PlaceId == 9015014224 or game.PlaceId == 6403373529 or game.PlaceId == 124596094333302 then
    init_hook({"Ban", "WalkSpeedChanged", "AdminGUI", "GRAB", "SpecialGloveAccess"}, lib_RS, false)
end

-- Functions used in Beta.lua

-- Runs functions on a different thread

function run(...)
    task.spawn(...)
end

-- Basic root position changing

function tp(x, y, z)
    if localplayer.Character:FindFirstChild("HumanoidRootPart") then -- if root is present
        local root = localplayer.Character.HumanoidRootPart
        root.CFrame = CFrame.new(x, y, z)
    end
end

-- Notify user through rayfield's notification system

function notify(title, content)
    Rayfield:Notify({
        Title = title,
        Content = content,
        Duration = 6.5,
        Image = 4483362458,
    })
end

-- Safespot create function

function create_safespot(name, bool_bob, posx, posy, posz)
    local Safespot = Instance.new("Part",workspace)
    Safespot.Name = "name"
    Safespot.Position = Vector3.new(posx,posy,posz)
    Safespot.Size = Vector3.new(5000,10,5000)
    Safespot.Anchored = true
    Safespot.CanCollide = true
    Safespot.Transparency = .5
    if bool_bob then Safespot.CollisionGroup = "Bobstuff" end
end
