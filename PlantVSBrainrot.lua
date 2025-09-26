local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local ConfigFile = "khoitongdzHub_Config.json"
local Config = {}

local function SaveConfig()
    pcall(function()
        writefile(ConfigFile, HttpService:JSONEncode(Config))
    end)
end

local function LoadConfig()
    pcall(function()
        if isfile(ConfigFile) then
            Config = HttpService:JSONDecode(readfile(ConfigFile))
        end
    end)
end

LoadConfig()

if not Config.Language then
    Config.Language = "EN"
    SaveConfig()
end

local function T(en, vn)
    return Config.Language == "EN" and en or vn
end

game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "khoitongdz Hub",
    Text = "Loading UI Done!",
    Duration = 5,
    Icon = "rbxassetid://105486552530887"
})

LocalPlayer.OnTeleport:Connect(function(State)
    if State == Enum.TeleportState.Started then
        queue_on_teleport([[
            local HttpService = game:GetService("HttpService")
            local ConfigFile = "khoitongdzHub_Config.json"
            if isfile(ConfigFile) then
                Config = HttpService:JSONDecode(readfile(ConfigFile))
            end
        ]])
    end
end)

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/khoitong888/Robloxs/refs/heads/main/ui.lua"))()
local Window = Library:Window({
    Title = "khoitongdz Hub",
    Desc = T("Auto Farm", "Tự Động cày"),
    Icon = 105059922903197,
    Theme = "Dark",
    Config = { Keybind = Enum.KeyCode.K, Size = UDim2.new(0, 500, 0, 400) },
    CloseUIButton = { Enabled = true, Text = "khoitongdz" }
})

local MainTab = Window:Tab({ Title = T("Main Features", "Tính năng chính"), Icon = "star" })
do
    MainTab:Section({ Title = T("Plant Features", "Tính năng cây trồng") })
    local PlantOptions = { "Cactus Seed", "Strawberry Seed", "Pumpkin Seed", "Sunflower Seed", "Dragon Fruit Seed", "Eggplant Seed", "Watermelon Seed", "Cocotank Seed", "Carnivorous Plant Seed", "Mr Carrot Seed", "Tomatrio Seed"}
    local AutoBuyingPlants = false

    MainTab:Dropdown({
        Title = T("Select Plants", "Chọn cây trồng"),
        List = PlantOptions,
        Multi = true,
        Value = Config.SelectedPlants or {},
        Callback = function(options)
            Config.SelectedPlants = options
            SaveConfig()
        end
    })
    MainTab:Toggle({
        Title = T("Auto Buy Plants", "Tự động mua cây"),
        Desc = T("Automatically buys selected seeds", "Tự động mua hạt giống đã chọn"),
        Value = Config.AutoBuyPlants or false,
        Callback = function(v)
            Config.AutoBuyPlants = v
            SaveConfig()
            AutoBuyingPlants = v
            if AutoBuyingPlants then
                task.spawn(function()
                    while AutoBuyingPlants do
                        for _, plant in ipairs(Config.SelectedPlants or {}) do
                            game:GetService("ReplicatedStorage"):WaitForChild("BridgeNet2"):WaitForChild("dataRemoteEvent"):FireServer({ plant, "\a" })
                            task.wait(0.5)
                        end
                        task.wait(10)
                    end
                end)
            end
        end
    })

    MainTab:Section({ Title = T("Item Features", "Tính năng vật phẩm") })
    local ItemOptions = { "Water Bucket", "Banana Gun", "Frost Blower", "Carrot Launcher" }
    local AutoBuyingItems = false

    MainTab:Dropdown({
        Title = T("Select Items", "Chọn vật phẩm"),
        List = ItemOptions,
        Multi = true,
        Value = Config.SelectedItems or {},
        Callback = function(options)
            Config.SelectedItems = options
            SaveConfig()
        end
    })
    MainTab:Toggle({
        Title = T("Auto Buy Items", "Tự động mua vật phẩm"),
        Desc = T("Automatically buys selected items", "Tự động mua vật phẩm đã chọn"),
        Value = Config.AutoBuyItems or false,
        Callback = function(v)
            Config.AutoBuyItems = v
            SaveConfig()
            AutoBuyingItems = v
            if AutoBuyingItems then
                task.spawn(function()
                    while AutoBuyingItems do
                        for _, item in ipairs(Config.SelectedItems or {}) do
                            game:GetService("ReplicatedStorage"):WaitForChild("BridgeNet2"):WaitForChild("dataRemoteEvent"):FireServer({ item, " " })
                            task.wait(0.5)
                        end
                        task.wait(10)
                    end
                end)
            end
        end
    })
end

local PlayerTab = Window:Tab({ Title = T("Player", "Người chơi"), Icon = "user" })
do
    PlayerTab:Section({ Title = T("Movement", "Di chuyển") })

    local hum = function()
        return LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    end

    PlayerTab:Toggle({
        Title = T("WalkSpeed Hack", "Tốc độ chạy"),
        Desc = T("Enable / Disable custom WalkSpeed", "Bật/tắt tốc độ chạy tuỳ chỉnh"),
        Value = Config.WalkSpeedEnabled or false,
        Callback = function(state)
            Config.WalkSpeedEnabled = state
            SaveConfig()
            if hum() then
                hum().WalkSpeed = state and (Config.WalkSpeed or 16) or 16
            end
        end
    })
    PlayerTab:Slider({
        Title = T("WalkSpeed Value", "Giá trị tốc độ"),
        Min = 16,
        Max = 200,
        Value = Config.WalkSpeed or 16,
        Callback = function(val)
            Config.WalkSpeed = val
            SaveConfig()
            if Config.WalkSpeedEnabled and hum() then
                hum().WalkSpeed = val
            end
        end
    })

    PlayerTab:Toggle({
        Title = T("Jump Hack", "Độ nhảy"),
        Desc = T("Enable / Disable custom JumpPower", "Bật/tắt độ nhảy tuỳ chỉnh"),
        Value = Config.JumpEnabled or false,
        Callback = function(state)
            Config.JumpEnabled = state
            SaveConfig()
            if hum() then
                hum().JumpPower = state and (Config.JumpPower or 50) or 50
            end
        end
    })
    PlayerTab:Slider({
        Title = T("JumpPower Value", "Giá trị độ nhảy"),
        Min = 50,
        Max = 300,
        Value = Config.JumpPower or 50,
        Callback = function(val)
            Config.JumpPower = val
            SaveConfig()
            if Config.JumpEnabled and hum() then
                hum().JumpPower = val
            end
        end
    })

    PlayerTab:Toggle({
        Title = T("Infinite Jump", "Nhảy vô hạn"),
        Desc = T("Allow infinite jumping", "Cho phép nhảy vô hạn"),
        Value = Config.InfiniteJump or false,
        Callback = function(v)
            Config.InfiniteJump = v
            SaveConfig()
            if v then
                game:GetService("UserInputService").JumpRequest:Connect(function()
                    if Config.InfiniteJump and hum() then
                        hum():ChangeState(Enum.HumanoidStateType.Jumping)
                    end
                end)
            end
        end
    })

    PlayerTab:Toggle({
        Title = T("NoClip", "Xuyên tường"),
        Desc = T("Walk through walls", "Đi xuyên tường"),
        Value = Config.NoClipEnabled or false,
        Callback = function(state)
            Config.NoClipEnabled = state
            SaveConfig()
            if state then
                task.spawn(function()
                    while Config.NoClipEnabled do
                        local char = LocalPlayer.Character
                        if char then
                            for _, part in ipairs(char:GetDescendants()) do
                                if part:IsA("BasePart") then
                                    part.CanCollide = false
                                end
                            end
                        end
                        task.wait(0.2)
                    end
                end)
            end
        end
    })
end

local ServerTab = Window:Tab({ Title = T("Server Hop", "Đổi Server"), Icon = "globe" })
do
    ServerTab:Section({ Title = T("Hop Servers", "Chuyển server") })

    ServerTab:Button({
        Title = T("Hop to Low Player Server", "Chuyển đến server ít người"),
        Callback = function()
            local servers = HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100"))
            for _, s in ipairs(servers.data) do
                if s.playing < s.maxPlayers and s.id ~= game.JobId then
                    TeleportService:TeleportToPlaceInstance(game.PlaceId, s.id, LocalPlayer)
                    break
                end
            end
        end
    })

    ServerTab:Button({
        Title = T("Hop to Random Server", "Chuyển đến server ngẫu nhiên"),
        Callback = function()
            local servers = HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100"))
            local choices = {}
            for _, s in ipairs(servers.data) do
                if s.id ~= game.JobId then
                    table.insert(choices, s.id)
                end
            end
            if #choices > 0 then
                local pick = choices[math.random(1, #choices)]
                TeleportService:TeleportToPlaceInstance(game.PlaceId, pick, LocalPlayer)
            end
        end
    })
end

local SettingsTab = Window:Tab({ Title = T("Settings", "Cài đặt"), Icon = "settings" })
do
    SettingsTab:Toggle({
        Title = T("Auto Reconnect", "Tự động kết nối lại"),
        Desc = T("Reconnect automatically when kicked/disconnected", "Tự động kết nối lại khi bị kick/mất kết nối"),
        Value = Config.AutoReconnect or false,
        Callback = function(v)
            Config.AutoReconnect = v
            SaveConfig()
        end
    })

    if Config.AutoReconnect then
        LocalPlayer.OnTeleport:Connect(function(State)
            if State == Enum.TeleportState.Failed then
                TeleportService:Teleport(game.PlaceId, LocalPlayer)
            end
        end)
    end

    SettingsTab:Dropdown({
        Title = T("Language", "Ngôn ngữ"),
        List = {"EN", "VN"},
        Value = Config.Language,
        Desc = T("Note: When changing language, you need to change server", "lưu ý khi đổi ngôn ngữ cần đổi server thì mới được"),
        Callback = function(val)
            Config.Language = val
            SaveConfig()
        end
    })
end
