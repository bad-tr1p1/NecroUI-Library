--[[
    NecroUI - Development Example
    To test this, run server.bat first, then paste this into Roblox.
]]

local NecroUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/USERNAME/REPO/main/src/init.lua"))()

local Window = NecroUI:CreateWindow("My Premium Script")

local MainTab = Window:CreateTab("Main")
local VisualsTab = Window:CreateTab("Visuals")
local SettingsTab = Window:CreateTab("Settings")

MainTab:CreateButton("Toggle Fly", function() print("Fly status toggled") end)
VisualsTab:CreateButton("ESP Enabled", function() print("ESP toggled") end)

print("NecroUI Loaded Successfully!")
