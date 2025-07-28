-- Not Mine!

local RequireService = cloneref or function(clone) return clone end
local BlockInstance = function(ez) ez.Name = "BlockedInstance_"..math.random(0,500000).."" ez.Parent = RequireService(game:GetService("LogService")) ez:Destroy() end

local game = game or Ugc
local Players = RequireService(game:GetService("Players"))
local Player = Players.LocalPlayer
local PlayerScripts = Player:WaitForChild("PlayerScripts")
local StarterPlayer = RequireService(game:GetService("StarterPlayer"))
local StarterPlayerScripts = StarterPlayer:WaitForChild("StarterPlayerScripts")
local ReplicatedStorage = RequireService(game:GetService("ReplicatedStorage"))
local ReplicatedFirst = RequireService(game:GetService("ReplicatedFirst"))

local function DestroyGrabLocalScript()
if ReplicatedFirst and ReplicatedFirst:FindFirstChild("Client") and ReplicatedFirst.Client:FindFirstChild("GrabLocal") then
BlockInstance(game.ReplicatedFirst.Client.GrabLocal)
end
end

local function BypassMobileClientAntiCheat()
if StarterPlayerScripts and StarterPlayerScripts:FindFirstChild("ClientAnticheat") and StarterPlayerScripts.ClientAnticheat:FindFirstChild("AntiMobileExploits") then
BlockInstance(StarterPlayerScripts.ClientAnticheat.AntiMobileExploits)
BlockInstance(StarterPlayerScripts.ClientAnticheat)
end
end


if game.PlaceId == 9431156611 then -- Slap Royale
if hookmetamethod and getnamecallmethod then
local Namecall
Namecall = hookmetamethod(game, "__namecall", function(self, ...)
   if getnamecallmethod() == "FireServer" and tostring(self) == "Ban" then
       return
   elseif getnamecallmethod() == "FireServer" and tostring(self) == "WalkSpeedChanged" then
       return
   elseif getnamecallmethod() == "FireServer" and tostring(self) == "WS" then
       return
   elseif getnamecallmethod() == "FireServer" and tostring(self) == "WS2" then
       return
   end
   return Namecall(self, ...)
end)
else
local AmountOfBlockedRemotes = 0
if game:GetService("ReplicatedStorage").Events:FindFirstChild("Ban") then
BlockInstance(game:GetService("ReplicatedStorage").Events.Ban)
AmountOfBlockedRemotes = AmountOfBlockedRemotes + 1
end
if game:GetService("ReplicatedStorage").Events:FindFirstChild("WS") then
BlockInstance(game:GetService("ReplicatedStorage").Events.WS)
AmountOfBlockedRemotes = AmountOfBlockedRemotes + 1
end
if game:GetService("ReplicatedStorage").Events:FindFirstChild("AdminGUI") then
BlockInstance(game:GetService("ReplicatedStorage").Events.AdminGUI)
AmountOfBlockedRemotes = AmountOfBlockedRemotes + 1
end
if game:GetService("ReplicatedStorage").Events:FindFirstChild("WS2") then
BlockInstance(game:GetService("ReplicatedStorage").Events["WS2"])
AmountOfBlockedRemotes = AmountOfBlockedRemotes + 1
end
end
DestroyGrabLocalScript()
BypassMobileClientAntiCheat()


elseif game.PlaceId == 11520107397 or game.PlaceId == 9015014224 or game.PlaceId == 6403373529 or game.PlaceId == 124596094333302 then
if hookmetamethod and getnamecallmethod then
local Namecall
Namecall = hookmetamethod(game, "__namecall", function(self, ...)
   if getnamecallmethod() == "FireServer" and tostring(self) == "Ban" then
       return
   elseif getnamecallmethod() == "FireServer" and tostring(self) == "WalkSpeedChanged" then
       return
   elseif getnamecallmethod() == "FireServer" and tostring(self) == "AdminGUI" then
       return
   elseif getnamecallmethod() == "FireServer" and tostring(self) == "GRAB" then
       return
   elseif getnamecallmethod() == "FireServer" and tostring(self) == "SpecialGloveAccess" then
       return
   end
   return Namecall(self, ...)
end)
else
local AmountOfBlockedRemotes = 0
if game:GetService("ReplicatedStorage"):FindFirstChild("Ban") then
BlockInstance(game:GetService("ReplicatedStorage").Ban)
AmountOfBlockedRemotes = AmountOfBlockedRemotes + 1
end
if game:GetService("ReplicatedStorage"):FindFirstChild("WalkSpeedChanged") then
BlockInstance(game:GetService("ReplicatedStorage").WalkSpeedChanged)
AmountOfBlockedRemotes = AmountOfBlockedRemotes + 1
end
if game:GetService("ReplicatedStorage"):FindFirstChild("AdminGUI") then
BlockInstance(game:GetService("ReplicatedStorage").AdminGUI)
AmountOfBlockedRemotes = AmountOfBlockedRemotes + 1
end
if game:GetService("ReplicatedStorage"):FindFirstChild("GRAB") then
BlockInstance(game:GetService("ReplicatedStorage").GRAB)
AmountOfBlockedRemotes = AmountOfBlockedRemotes + 1
end
if game:GetService("ReplicatedStorage"):FindFirstChild("SpecialGloveAccess") then
BlockInstance(game:GetService("ReplicatedStorage").SpecialGloveAccess)
AmountOfBlockedRemotes = AmountOfBlockedRemotes + 1
end
end
DestroyGrabLocalScript()
BypassMobileClientAntiCheat()
end