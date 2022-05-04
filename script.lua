--[=[ Checks ]=]--
if not _G.Created then
    _G.Created = true
else
    if game.CoreGui:FindFirstChild('PixelHub') then
        game.CoreGui.PixelHub:Destroy()
    end
end

if not game:IsLoaded() then
    game.Loaded:Wait()
end

_G.Key = "Developing"

if not _G.Key or _G.Key ~= "Developing" then
    game.Players.LocalPlayer:Kick('Not a valid key!')
end

--[=[ Services ]=]--
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService('TweenService')
local HttpService = game:GetService("HttpService")
local StarterGui = game:GetService("StarterGui")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")

--[=[ Varibles ]=]--
local GameId = game.PlaceId

local SettingsName = "PixelHub.txt"

local MasterSwitch = false
local CanSave = false
local CanLoad = false

-- Tables
_G.PHImportant = {}

_G.settingsTable = {
    WalkSpeed = 16,
    JumpPower = 54,
    TeleportRespawn = false,
    Toxicity = false
} 

local ScriptGUIS = {}

--[=[ Setup the GUI ]=]--

local function SetupGUI()
    -- Creates Main GUI
    local ScreenGui = Instance.new('ScreenGui')
    local Main = Instance.new('Frame')
    local Games = Instance.new('Frame')
    local TopBar = Instance.new('Frame')
    local TopBarText = Instance.new('TextButton')
    local BottomBar = Instance.new('Frame')
    local Settings = Instance.new('ImageLabel')
    local SettingsImage = Instance.new('ImageButton')

    -- Set ScreenGui
    ScreenGui.Name = "PixelHub"
    ScreenGui.Parent = CoreGui
    ScreenGui.IgnoreGuiInset = true
    ScreenGui.ResetOnSpawn = false
    ScriptGUIS["ScreenGui"] = ScreenGui

    -- Set Main
    Main.Name = "Main"
    Main.Size = UDim2.new(0.35, 0, 0.35, 0)
    Main.Position = UDim2.new(.3, 0, .3, 0)
    Main.BackgroundColor3 = Color3.new(58/255, 58/255, 58/255)
    Main.BorderSizePixel = 0
    Main.Parent = ScreenGui
    ScriptGUIS["Main"] = Main

    -- Set TopBar
    TopBar.Name = "TopBar"
    TopBar.Size = UDim2.new(1, 0, .15, 0)
    TopBar.Position = UDim2.new(0, 0, -.15, 0)
    TopBar.BackgroundColor3 = Color3.new(40/255, 40/255, 40/255)
    TopBar.BorderSizePixel = 0
    TopBar.Parent = Main

    -- Set TopBarText
    TopBarText.Name = "Text"
    TopBarText.Size = UDim2.new(1, 0, 1, 0)
    TopBarText.Position = UDim2.new(0, 0, 0, 0)
    TopBarText.TextColor3 = Color3.new(255/255, 255/255, 255/255)
    TopBarText.BackgroundTransparency = 1
    TopBarText.Text = ""
    TopBarText.Parent = TopBar
    TopBarText.TextScaled = true
    TopBarText.Font = Enum.Font.GothamSemibold
    ScriptGUIS["TopBarText"] = TopBarText

    -- Set BottomBar
    BottomBar.Name = "BottomBar"
    BottomBar.Size = UDim2.new(1, 0, .15, 0)
    BottomBar.Position = UDim2.new(0, 0, 1, 0)
    BottomBar.BackgroundColor3 = Color3.new(40/255, 40/255, 40/255)
    BottomBar.BorderSizePixel = 0
    BottomBar.Parent = Main

    -- Set Settings
    Settings.Name = "SettingsRoundify"
    Settings.ImageColor3 = Color3.new(31/255, 31/255, 31/255)
    Settings.Size = UDim2.new(.08, 0, 1, 0)
    Settings.Position = UDim2.new(.003, 0, 0, 0)
    Settings.ScaleType = Enum.ScaleType.Slice
    Settings.Image = "rbxassetid://3570695787"
    Settings.BackgroundTransparency = 1
    Settings.Parent = BottomBar

    -- Set SettingsButton
    SettingsImage.Name = "SettingsButton"
    SettingsImage.ImageColor3 = Color3.new(255/255, 255/255, 255/255)
    SettingsImage.Size = UDim2.new(.8, 0, .8, 0)
    SettingsImage.Position = UDim2.new(.1, 0, .1, 0)
    SettingsImage.BackgroundTransparency = 1
    SettingsImage.Image = "rbxassetid://9520600700"
    SettingsImage.ScaleType = Enum.ScaleType.Fit
    SettingsImage.Parent = Settings
    ScriptGUIS["Settings"] = SettingsImage
end

--[=[ Basic Functions ]=]--

local function VectorToCFrame(Vector)
    return CFrame.new(Vector.X, Vector.Y, Vector.Z)
end

local function SendMessage(Message)
    -- Sends a message to chat
    ReplicatedStorage.DefaultChatSystemChatEvents.SayMessageRequest:FireServer(Message, "All")
end

local function SendNotification(Title, Message, Duration)
    -- Sends a default roblox notification
    StarterGui:SetCore("SendNotfication",{
        Title = Title,
        Text = Text,
        Duration = Duration
    })
end

local function DisplayNameToPlayer(DisplayName)
    -- Display name to player, you'll never know when you need it!
    for i, Player in pairs(game.Players:GetPlayers()) do
        if Player.DisplayName == DisplayName then
            return Player
        end
    end
    return nil
end

local function Typewrite(Message, GUI)
    -- Typewrites for gui text
    for i = 1, string.len(Message) do
        if type(GUI) == 'string' then
            GUI = string.sub(Message, 1, i)
        else
            GUI.Text = string.sub(Message, 1, i)
        end
        task.wait(0.02)
    end
end

local function TeleportCharacterTo(Position)
    -- Teleports the character
    local Character = game.Players.LocalPlayer.Character
    Character:MoveTo(Position)
end

local function CreateTweenCharacterTo(Position, IsR6)
    -- Teleports the character
    if IsR6 == true then
        local Character = game.Players.LocalPlayer.Character
        local Tween = TweenService:Create(Character.Torso, TweenInfo.new((Character.Torso.Position - Position).Magnitude/100, Enum.EasingStyle.Linear), {CFrame = VectorToCFrame(Position)})
        return Tween
    elseif IsR6 == false then
        local Character = game.Players.LocalPlayer.Character
        local Tween = TweenService:Create(Character.HumanoidRootPart, TweenInfo.new((Character.HumanoidRootPart.Position - Position).Magnitude/100, Enum.EasingStyle.Linear), {CFrame = VectorToCFrame(Position)})
        return Tween
    end
    error('IsR6 is not a boolean')
end

local function GetCharacterPartPos(PartName)
    local Character = Players.LocalPlayer.Character
    for i, v in pairs(Character:GetChildren()) do
        if v.Name == PartName then
            return v.Position
        end
    end
end

--[=[ UI Functions ]=]--
local function CreateScrollingFrame(Name)
    local Frame = Instance.new('ScrollingFrame')
    local UIListLayout = Instance.new('UIListLayout')

    Frame.Name = Name
    Frame.BackgroundTransparency = 1
    Frame.Size = UDim2.new(1, 0, .8, 0)
    Frame.Position = UDim2.new(0, 0, .1, 0)
    Frame.ScrollBarImageTransparency = 1
    Frame.ScrollBarThickness = 0
    Frame.Parent = ScriptGUIS["Main"]
    ScriptGUIS["Scroll-" .. GameId] = Frame

    UIListLayout.Parent = Frame
    UIListLayout.Padding = UDim.new(0.05, 0)
end

local function CreateButton(Name, Text)
    local Button = Instance.new('TextButton')
    local UICorner = Instance.new('UICorner')

    Button.Name = Name
    Button.Text = Text
    Button.TextScaled = true
    Button.BackgroundColor3 = Color3.new(45/255, 45/255, 45/255)
    Button.TextColor3 = Color3.new(255/255, 255/255, 255/255)
    Button.Size = UDim2.new(1, 0, .1, 0)
    Button.Parent = ScriptGUIS["Scroll-" .. GameId]
    Button.Font = Enum.Font.GothamSemibold
    ScriptGUIS["Button-" .. Name] = Button

    UICorner.CornerRadius = UDim.new(.035, 10)
    UICorner.Parent = Button
end

--[=[ Starting Scripts ]=]--
SetupGUI()
Typewrite('Welcome, ' .. Players.LocalPlayer.Name, ScriptGUIS["TopBarText"])

UserInputService.InputBegan:Connect(function(Key)
    if Key.KeyCode == Enum.KeyCode.RightAlt then
        ScriptGUIS["Main"].Visible = not ScriptGUIS["Main"].Visible
    end
end)

--[=[ Main ]=]--
local function SetupGame()
    if GameId == 8540168650 then
        --[=[ Notes ]=]--
        -- JohnnyJoestar
        -- Dio's Diary, Requiem Arrow

        _G.PHImportant = {
            ["Items"] = workspace.Items,
            ["Characters"] = workspace.Living,
            ["Quests"] = workspace.Fartinglloll,
            ["RSEvents"] = ReplicatedStorage.Events,
        }

        _G.SURSettingsPH = {
            ["LoopCollectItems"] = false,
            ["AutoDash"] = false,
        }

        CreateScrollingFrame('SU:B')

        CreateButton('CollectItems', 'Collect all items!')
        -- CreateButton('LoopCollectItems', 'Loop Collect items!')
        CreateButton('AutoDash', 'Loop the ALT Dash!')
        CreateButton('StartAllQuests', 'Activates all Quests!')
        CreateButton('RedeemAllQuests', 'Redeems all Quests!')
        CreateButton('GotoStorage', 'Goto Storage')

        ScriptGUIS["Button-CollectItems"].MouseButton1Click:Connect(function()
            if #_G.PHImportant["Items"]:GetChildren() == 0 then SendNotification('No items found!', 'There were no items found!', 3) end
            for i, v in pairs(_G.PHImportant["Items"]:GetChildren()) do
                local Tween = CreateTweenCharacterTo(v.Handle.Position, false)
                Tween:Play()
                Tween.Completed:Wait()
                task.wait(.3)
            end
        end)

        --[[ScriptGUIS["Button-LoopCollectItems"].MouseButton1Click:Connect(function()
            _G.SURSettingsPH["AutoCollectItems"] = not _G.SURSettingsPH["AutoCollectItems"]
            if _G.SURSettingsPH["AutoCollectItems"] == true then
                ScriptGUIS["Button-LoopCollectItems"].Text = 'Unloop Collect Items'
            else
                ScriptGUIS["Button-LoopCollectItems"].Text = 'Loop Collect Items'
            end
            while true do
                if _G.SURSettingsPH["AutoCollectItems"] == true then
                    for i, v in pairs(_G.PHImportant["Items"]:GetChildren()) do
                        local Tween = CreateTweenCharacterTo(v.Handle.Position, false)
                        Tween:Play()
                        Tween.Completed:Wait()
                        task.wait(.3)
                    end
                end
                task.wait(.3)
            end
        end)]]

        ScriptGUIS["Button-AutoDash"].MouseButton1Click:Connect(function()
            _G.SURSettingsPH.AutoDash = not _G.SURSettingsPH.AutoDash
            while true do
                if _G.SURSettingsPH.AutoDash == false then ScriptGUIS["Button-LoopCollectItems"].Text = 'Loop the ALT dash' return end
                ScriptGUIS["Button-LoopCollectItems"].Text = 'Unloop the ALT dash'
                game.Players.LocalPlayer.Character["funny dash"].RemoteEvent:FireServer('f')
                task.wait(1)
            end
        end)

        ScriptGUIS["Button-StartAllQuests"].MouseButton1Click:Connect(function()
            for i, v in pairs(_G.PHImportant.Quests:GetChildren()) do
                if v:FindFirstChild('QuestDone') then
                    v.Done:FireServer('')
                end
            end
        end)

        ScriptGUIS["Button-RedeemAllQuests"].MouseButton1Click:Connect(function()
            for i, v in pairs(_G.PHImportant.Quests:GetChildren()) do
                if v:FindFirstChild('QuestDone') then
                    v.QuestDone:FireServer('')
                end
            end
        end)

        ScriptGUIS["Button-GotoStorage"].MouseButton1Click:Connect(function()
            TeleportCharacterTo(Vector3.new(-368, 23, -291), false)
        end)

        _G.PHImportant["Characters"].ChildAdded:Connect(function(Child)
            if Child.Name == "JohnnyJostar" then
                SendNotification('Important Spawn!', 'JohnnyJostar')
            end
        end)

        _G.PHImportant["Items"].ChildAdded:Connect(function(Child)
            if Child.Name == "Dio's Diary" or Child.Name == "Requiem Arrow" then
                SendNotification('Important Spawn!', Child.Name, 5)
            end
        end)
    else
        game.Players.LocalPlayer:Kick('Not a supported game!')
    end
end

SetupGame()
warn('Finished')
