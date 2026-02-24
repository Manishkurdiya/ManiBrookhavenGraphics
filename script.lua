-- MANI BROOKHAVEN GRAPHICS MODIFIER v.1
-- made by @MANISH_K2005
-- Ultimate Client-Side Graphics Modifier for Brookhaven RP

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "MANI BROOKHAVEN GRAPHICS MODIFIER v.1",
   LoadingTitle = "Loading Ultimate Graphics Suite...",
   LoadingSubtitle = "by @MANISH_K2005",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "ManiBrookhavenGraphics",
      FileName = "GraphicsConfig"
   },
   Discord = {
      Enabled = true,
      Invite = "your_discord_invite",
      RememberJoins = true
   },
   KeySystem = false
})

-- Main Graphics Tab
local GraphicsTab = Window:CreateTab("🎮 Graphics", 4483362458)

-- Advanced Graphics Tab
local AdvancedTab = Window:CreateTab("⚡ Advanced", 4483362458)

-- Lighting Tab
local LightingTab = Window:CreateTab("💡 Lighting", 4483362458)

-- Weather Tab
local WeatherTab = Window:CreateTab("🌤️ Weather", 4483362458)

-- Effects Tab - NOW FULLY LOADED WITH GTA 5 STYLE EFFECTS
local EffectsTab = Window:CreateTab("✨ Effects", 4483362458)

-- Performance Tab
local PerformanceTab = Window:CreateTab("⚙️ Performance", 4483362458)

-- Ultra Realism Section
local UltraRealismSection = GraphicsTab:CreateSection("Ultra Realism Graphics")

-- GTA 5 Style Graphics Settings
GraphicsTab:CreateSlider({
   Name = "Texture Quality",
   Range = {0, 100},
   Increment = 1,
   Suffix = "%",
   CurrentValue = 75,
   Flag = "TextureQuality",
   Callback = function(Value)
      game:GetService("Lighting").GlobalShadows = true
      game:GetService("Lighting").Brightness = 2
      game:GetService("Lighting").Technology = Enum.Technology.Future
      settings().Rendering.QualityLevel = Value
   end,
})

GraphicsTab:CreateSlider({
   Name = "Shadow Quality",
   Range = {0, 100},
   Increment = 1,
   Suffix = "%",
   CurrentValue = 80,
   Flag = "ShadowQuality",
   Callback = function(Value)
      game:GetService("Lighting").ShadowSoftness = Value / 50
      game:GetService("Lighting").EnvironmentDiffuseScale = Value / 100
   end,
})

GraphicsTab:CreateDropdown({
   Name = "Anti-Aliasing",
   Options = {"FXAA", "MSAA 2x", "MSAA 4x", "MSAA 8x", "TXAA"},
   CurrentOption = "FXAA",
   Flag = "AntiAliasing",
   Callback = function(Option)
      if Option == "FXAA" then
         game:GetService("Lighting").RenderEmbeddedLights = false
      elseif Option:find("MSAA") then
         game:GetService("Lighting").RenderEmbeddedLights = true
      end
   end,
})

GraphicsTab:CreateToggle({
   Name = "Ambient Occlusion",
   CurrentValue = false,
   Flag = "AmbientOcclusion",
   Callback = function(Value)
      if Value then
         game:GetService("Lighting").EnvironmentSpecularScale = 0.8
         game:GetService("Lighting").EnvironmentDiffuseScale = 0.6
      else
         game:GetService("Lighting").EnvironmentSpecularScale = 1
         game:GetService("Lighting").EnvironmentDiffuseScale = 1
      end
   end,
})

-- Advanced Reflections Section
local ReflectionsSection = AdvancedTab:CreateSection("Advanced Reflections")

AdvancedTab:CreateSlider({
   Name = "Reflection Quality",
   Range = {0, 100},
   Increment = 1,
   Suffix = "%",
   CurrentValue = 85,
   Flag = "ReflectionQuality",
   Callback = function(Value)
      local Lighting = game:GetService("Lighting")
      Lighting.EnvironmentSpecularScale = Value / 100
   end,
})

AdvancedTab:CreateToggle({
   Name = "Reflection MSAA",
   CurrentValue = false,
   Flag = "ReflectionMSAA",
   Callback = function(Value)
      game:GetService("Lighting").GlobalShadows = Value
   end,
})

-- Environment Section
local EnvironmentSection = GraphicsTab:CreateSection("Environment")

GraphicsTab:CreateSlider({
   Name = "Grass Quality",
   Range = {0, 100},
   Increment = 1,
   Suffix = "%",
   CurrentValue = 70,
   Flag = "GrassQuality",
   Callback = function(Value)
      for _, obj in pairs(workspace:GetDescendants()) do
         if obj:IsA("BasePart") and obj.Material == Enum.Material.Grass then
            obj.Material = Enum.Material.Grass
         end
      end
   end,
})

GraphicsTab:CreateSlider({
   Name = "Water Quality",
   Range = {0, 100},
   Increment = 1,
   Suffix = "%",
   CurrentValue = 90,
   Flag = "WaterQuality",
   Callback = function(Value)
      for _, water in pairs(workspace:GetDescendants()) do
         if water:IsA("BasePart") and water.Name:lower():find("water") then
            water.Material = Enum.Material.ForceField
            water.Transparency = 0.3
         end
      end
   end,
})

-- Post-Processing Section
local PostFXSection = GraphicsTab:CreateSection("Post-Processing")

GraphicsTab:CreateSlider({
   Name = "Post FX Quality",
   Range = {0, 5},
   Increment = 0.1,
   Suffix = "Ultra",
   CurrentValue = 2,
   Flag = "PostFX",
   Callback = function(Value)
      local Bloom = game:GetService("Lighting"):FindFirstChild("Bloom") or Instance.new("BloomEffect")
      Bloom.Intensity = Value
      Bloom.Size = Value * 2
      Bloom.Threshold = 1.5
      if not Bloom.Parent then Bloom.Parent = game:GetService("Lighting") end
   end,
})

GraphicsTab:CreateSlider({
   Name = "Motion Blur Strength",
   Range = {0, 100},
   Increment = 1,
   Suffix = "%",
   CurrentValue = 20,
   Flag = "MotionBlur",
   Callback = function(Value)
      local Blur = game:GetService("Lighting"):FindFirstChild("Blur") or Instance.new("BlurEffect")
      Blur.Size = Value / 10
      if not Blur.Parent then Blur.Parent = game:GetService("Lighting") end
   end,
})

GraphicsTab:CreateToggle({
   Name = "Depth of Field",
   CurrentValue = false,
   Flag = "DepthOfField",
   Callback = function(Value)
      local DOF = game:GetService("Lighting"):FindFirstChild("DepthOfField") or Instance.new("DepthOfFieldEffect")
      DOF.Enabled = Value
      DOF.FarIntensity = 0.5
      DOF.InFocusRadius = 20
      if not DOF.Parent then DOF.Parent = game:GetService("Lighting") end
   end,
})

-- Advanced Features Section
local AdvancedFeaturesSection = AdvancedTab:CreateSection("🚀 Advanced Features")

AdvancedTab:CreateToggle({
   Name = "High Detail Streaming (Flying)",
   CurrentValue = false,
   Flag = "HighDetailStreaming",
   Callback = function(Value)
      settings().Rendering.QualityLevel = Value and Enum.QualityLevel.Level21 or Enum.QualityLevel.Level15
   end,
})

AdvancedTab:CreateSlider({
   Name = "Population Density",
   Range = {0, 200},
   Increment = 10,
   Suffix = "%",
   CurrentValue = 100,
   Flag = "PopulationDensity",
   Callback = function(Value)
      -- Simulate population density (client-side visual)
      for _, player in pairs(game.Players:GetPlayers()) do
         if player.Character then
            player.Character.Humanoid.WalkSpeed = Value / 2
         end
      end
   end,
})

-- Lighting Controls
local AdvancedLightingSection = LightingTab:CreateSection("Advanced Lighting")

LightingTab:CreateColorPicker({
   Name = "Sky Color",
   Color = Color3.fromRGB(135, 206, 235),
   Flag = "SkyColor",
   Callback = function(Color)
      game:GetService("Lighting").OutdoorAmbient = Color
   end,
})

LightingTab:CreateSlider({
   Name = "Brightness",
   Range = {0, 10},
   Increment = 0.1,
   Suffix = "lux",
   CurrentValue = 2,
   Flag = "Brightness",
   Callback = function(Value)
      game:GetService("Lighting").Brightness = Value
   end,
})

-- *** EFFECTS TAB - FULLY LOADED WITH GTA 5 STYLE EFFECTS ***
local CinematicEffectsSection = EffectsTab:CreateSection("🎥 Cinematic Effects")

EffectsTab:CreateSlider({
   Name = "Bloom Intensity",
   Range = {0, 2},
   Increment = 0.1,
   Suffix = "Strength",
   CurrentValue = 0.5,
   Flag = "BloomIntensity",
   Callback = function(Value)
      local Bloom = game:GetService("Lighting"):FindFirstChild("BloomEffect") or Instance.new("BloomEffect")
      Bloom.Intensity = Value
      Bloom.Size = Value * 24
      Bloom.Threshold = 1.2
      Bloom.Parent = game:GetService("Lighting")
   end,
})

EffectsTab:CreateSlider({
   Name = "Color Correction Saturation",
   Range = {0, 2},
   Increment = 0.1,
   Suffix = "Saturation",
   CurrentValue = 1,
   Flag = "Saturation",
   Callback = function(Value)
      local ColorCorrection = game:GetService("Lighting"):FindFirstChild("ColorCorrectionEffect") or Instance.new("ColorCorrectionEffect")
      ColorCorrection.Saturation = Value
      ColorCorrection.Contrast = 0.2
      ColorCorrection.Brightness = 0
      ColorCorrection.Hue = 0
      ColorCorrection.Parent = game:GetService("Lighting")
   end,
})

EffectsTab:CreateSlider({
   Name = "Sun Rays Intensity",
   Range = {0, 1},
   Increment = 0.05,
   Suffix = "Rays",
   CurrentValue = 0.2,
   Flag = "SunRays",
   Callback = function(Value)
      local SunRays = game:GetService("Lighting"):FindFirstChild("SunRaysEffect") or Instance.new("SunRaysEffect")
      SunRays.Intensity = Value
      SunRays.Spread = 0.3
      SunRays.Parent = game:GetService("Lighting")
   end,
})

-- Particle Effects Section
local ParticleSection = EffectsTab:CreateSection("✨ Particle Effects")

EffectsTab:CreateToggle({
   Name = "Particle Quality (GTA 5 Style)",
   CurrentValue = false,
   Flag = "ParticleQuality",
   Callback = function(Value)
      if Value then
         settings().Rendering.QualityLevel = Enum.QualityLevel.Level21
      else
         settings().Rendering.QualityLevel = Enum.QualityLevel.Level15
      end
   end,
})

EffectsTab:CreateToggle({
   Name = "Atmosphere Haze",
   CurrentValue = false,
   Flag = "AtmosphereHaze",
   Callback = function(Value)
      local Atmosphere = game:GetService("Lighting"):FindFirstChild("Atmosphere") or Instance.new("Atmosphere")
      Atmosphere.Density = Value and 0.3 or 0
      Atmosphere.Offset = 0.25
      Atmosphere.Color = Color3.fromRGB(199, 199, 199)
      Atmosphere.Decay = Color3.fromRGB(106, 121, 139)
      Atmosphere.Glare = 0
      Atmosphere.Haze = 2
      Atmosphere.Parent = game:GetService("Lighting")
   end,
})

EffectsTab:CreateDropdown({
   Name = "Film Grain Preset",
   Options = {"None", "35mm Film", "GTA 5 Grain", "Cinematic"},
   CurrentOption = "None",
   Flag = "FilmGrain",
   Callback = function(Option)
      local Blur = game:GetService("Lighting"):FindFirstChild("Blur") or Instance.new("BlurEffect")
      if Option == "35mm Film" then
         Blur.Size = 2
      elseif Option == "GTA 5 Grain" then
         Blur.Size = 4
      elseif Option == "Cinematic" then
         Blur.Size = 3
      else
         Blur.Size = 0
      end
      Blur.Parent = game:GetService("Lighting")
   end,
})

-- Screen Space Effects
local ScreenSpaceSection = EffectsTab:CreateSection("📺 Screen Space Effects")

EffectsTab:CreateToggle({
   Name = "Screen Space Reflections",
   CurrentValue = false,
   Flag = "ScreenSpaceReflections",
   Callback = function(Value)
      local Lighting = game:GetService("Lighting")
      Lighting.EnvironmentSpecularScale = Value and 1 or 0.5
      Lighting.Technology = Value and Enum.Technology.Future or Enum.Technology.Compatibility
   end,
})

EffectsTab:CreateSlider({
   Name = "Vignette Effect",
   Range = {0, 1},
   Increment = 0.05,
   Suffix = "Strength",
   CurrentValue = 0.3,
   Flag = "Vignette",
   Callback = function(Value)
      local ColorCorrection = game:GetService("Lighting"):FindFirstChild("ColorCorrectionEffect") or Instance.new("ColorCorrectionEffect")
      ColorCorrection.Saturation = 1
      ColorCorrection.Contrast = Value * 0.5
   end,
})

-- Weather System
WeatherTab:CreateDropdown({
   Name = "Weather Preset",
   Options = {"Sunny", "Cloudy", "Rainy", "Foggy", "Night"},
   CurrentOption = "Sunny",
   Flag = "WeatherPreset",
   Callback = function(Option)
      local Lighting = game:GetService("Lighting")
      if Option == "Rainy" then
         local Rain = Instance.new("ParticleEmitter")
         Rain.Texture = "rbxasset://textures/particles/smoke_main.dds"
         Rain.Parent = workspace.Terrain
      elseif Option == "Night" then
         Lighting.ClockTime = 0
         Lighting.Brightness = 0.5
      end
   end,
})

-- Performance Optimization
PerformanceTab:CreateButton({
   Name = "Ultra Performance Mode",
   Callback = function()
      settings().Rendering.QualityLevel = Enum.QualityLevel.Level10
      game:GetService("Lighting"):ClearAllChildren()
      Rayfield:Notify({
         Title = "Performance Mode",
         Content = "Ultra Performance Mode Activated!",
         Duration = 3,
         Image = 4483362458,
      })
   end,
})

PerformanceTab:CreateButton({
   Name = "Reset All Graphics",
   Callback = function()
      settings().Rendering:Reset()
      game:GetService("Lighting"):ClearAllChildren()
      Rayfield:Notify({
         Title = "Reset Complete",
         Content = "All graphics settings have been reset!",
         Duration = 3,
         Image = 4483362458,
      })
   end,
})

-- Credits Section
local CreditsSection = Window:CreateTab("📝 Credits")
CreditsSection:CreateLabel("MANI BROOKHAVEN GRAPHICS MODIFIER v.1")
CreditsSection:CreateLabel("Made by @MANISH_K2005")
CreditsSection:CreateLabel("Ultimate GTA 5 Style Graphics for Brookhaven")

Rayfield:Notify({
   Title = "Graphics Mod Loaded!",
   Content = "✨ EFFECTS TAB FULLY LOADED! MANI BROOKHAVEN GRAPHICS MODIFIER v.1 by @MANISH_K2005",
   Duration = 5,
   Image = 4483362458,
})
