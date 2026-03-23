--[[
    NecroUI - Main script loaded remotely (Version 2.0 Tier-1)
]]
local NecroUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/bad-tr1p1/NecroUI-Library/main/init.lua?t=" .. tostring(tick())))()

local Window = NecroUI:CreateWindow({
    Name = "NecroUI V2 Pro",
    ThemeColor = Color3.fromRGB(90, 19, 95),
    LoadingScreen = true,
    SaveConfig = true,
    ConfigFolder = "NecroConfigs"
})




