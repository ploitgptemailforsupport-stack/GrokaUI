--// ============================================ //--
--//         Groka UI Library v5                  //--
--//  Beautiful • Smooth • Feature-Rich • Fixed   //--
--//  Credits: Groka / ploitgptemailforsupport    //--
--// ============================================ //--

local GrokaUI = {}

GrokaUI.Theme = {
	Background   = Color3.fromRGB(10, 10, 16),
	Surface      = Color3.fromRGB(18, 18, 28),
	SurfaceHover = Color3.fromRGB(24, 24, 38),
	Topbar       = Color3.fromRGB(14, 14, 22),
	Accent       = Color3.fromRGB(108, 138, 255),
	AccentDark   = Color3.fromRGB(72, 96, 220),
	AccentGlow   = Color3.fromRGB(108, 138, 255),
	Success      = Color3.fromRGB(52, 210, 128),
	Danger       = Color3.fromRGB(235, 72, 72),
	Text         = Color3.fromRGB(245, 245, 252),
	SubText      = Color3.fromRGB(130, 132, 165),
	Border       = Color3.fromRGB(36, 38, 58),
	BorderLight  = Color3.fromRGB(52, 54, 78),
	TabActive    = Color3.fromRGB(28, 30, 48),
	TabInactive  = Color3.fromRGB(16, 16, 26),
	Input        = Color3.fromRGB(22, 22, 36),
	Track        = Color3.fromRGB(32, 34, 52),
}

GrokaUI.Icons = {
	Shop     = "rbxassetid://14736132203",
	Combat   = "rbxassetid://1506618227",
	Player   = "rbxassetid://2243841665",
	Settings = "rbxassetid://18801194979",
	Home     = "rbxassetid://1249553442",
	Star     = "rbxassetid://17843890299",
	Warning  = "rbxassetid://6031071057",
	Info     = "rbxassetid://6031075049",
	Close    = "rbxassetid://6031094676",
	Add      = "rbxassetid://6031068420",
	Check    = "rbxassetid://6031068426",
	Lock     = "rbxassetid://6031068433",
	Eye      = "rbxassetid://6031225088",
	Search   = "rbxassetid://6031225090",
	Edit     = "rbxassetid://6031094674",
	Trash    = "rbxassetid://6031094670",
	Heart    = "rbxassetid://6031225084",
	Flash    = "rbxassetid://6031225086",
	Map      = "rbxassetid://6031225082",
	Music    = "rbxassetid://6031225080",
}

GrokaUI.Credits = "Groka UI v5 • by Groka"

local TweenService = game:GetService("TweenService")
local UIS          = game:GetService("UserInputService")
local Players      = game:GetService("Players")

local Player    = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

local function tween(obj, props, t, style, dir)
	return TweenService:Create(obj, TweenInfo.new(
		t     or 0.2,
		style or Enum.EasingStyle.Quart,
		dir   or Enum.EasingDirection.Out
	), props)
end

local function addCorner(parent, radius)
	local c = Instance.new("UICorner")
	c.CornerRadius = UDim.new(0, radius or 10)
	c.Parent = parent
	return c
end

local function addStroke(parent, color, transparency, thickness)
	local s = Instance.new("UIStroke")
	s.Color           = color
	s.Transparency    = transparency or 0.5
	s.Thickness       = thickness or 1
	s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	s.Parent          = parent
	return s
end

-- Accepts: "rbxassetid://123", "123", 123
local function parseAssetId(icon)
	if not icon then return nil end
	local iconStr = tostring(icon)
	return iconStr:match("rbxassetid://(%d+)") or iconStr:match("^(%d+)$")
end

local function addRipple(btn, color)
	btn.MouseButton1Down:Connect(function(x, y)
		local ripple = Instance.new("Frame")
		ripple.AnchorPoint            = Vector2.new(0.5, 0.5)
		ripple.Position               = UDim2.fromOffset(x - btn.AbsolutePosition.X, y - btn.AbsolutePosition.Y)
		ripple.Size                   = UDim2.new(0, 0, 0, 0)
		ripple.BackgroundColor3       = color or Color3.new(1,1,1)
		ripple.BackgroundTransparency = 0.6
		ripple.ZIndex                 = 999
		ripple.Parent                 = btn
		Instance.new("UICorner", ripple).CornerRadius = UDim.new(1, 0)
		tween(ripple, { Size = UDim2.new(0,400,0,400), BackgroundTransparency = 1 }, 0.45, Enum.EasingStyle.Quad):Play()
		task.delay(0.45, function() ripple:Destroy() end)
	end)
end

--// ============================
--//  NOTIFICATIONS (unchanged)
--// ============================

local NotifyGui = Instance.new("ScreenGui")
NotifyGui.Name           = "GrokaNotifications"
NotifyGui.ResetOnSpawn   = false
NotifyGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
NotifyGui.Parent         = PlayerGui

local NotifyHolder = Instance.new("Frame")
NotifyHolder.BackgroundTransparency = 1
NotifyHolder.Size                   = UDim2.new(0, 420, 0, 500)
NotifyHolder.AnchorPoint            = Vector2.new(0.5, 1)
NotifyHolder.Position               = UDim2.new(0.5, 0, 1, -20)
NotifyHolder.Parent                 = NotifyGui

local NotifyLayout = Instance.new("UIListLayout")
NotifyLayout.Padding             = UDim.new(0, 9)
NotifyLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
NotifyLayout.VerticalAlignment   = Enum.VerticalAlignment.Bottom
NotifyLayout.SortOrder           = Enum.SortOrder.LayoutOrder
NotifyLayout.Parent              = NotifyHolder

function GrokaUI:Notify(title, text, duration, typ)
	duration = duration or 4
	typ      = typ      or "info"
	local colors = {
		info    = Color3.fromRGB(100, 130, 255),
		success = Color3.fromRGB(60,  200, 120),
		error   = Color3.fromRGB(220, 70,  70),
		warning = Color3.fromRGB(255, 180, 60),
	}
	local accentColor = colors[typ] or colors.info
	local frame = Instance.new("Frame")
	frame.Size             = UDim2.new(0, 500, 0, 50)
	frame.BackgroundColor3 = Color3.fromRGB(18, 18, 28)
	frame.Position         = UDim2.new(0.5, -250, 0, 100)
	frame.ClipsDescendants = true
	frame.Parent           = NotifyHolder
	local s = Instance.new("UIStroke")
	s.Color        = accentColor
	s.Transparency = 0.4
	s.Parent       = frame
	local titleLbl = Instance.new("TextLabel")
	titleLbl.BackgroundTransparency = 1
	titleLbl.Size                   = UDim2.new(1, -20, 0, 20)
	titleLbl.Position               = UDim2.new(0, 12, 0, 7)
	titleLbl.Text                   = tostring(title)
	titleLbl.Font                   = Enum.Font.GothamBold
	titleLbl.TextColor3             = Color3.new(1,1,1)
	titleLbl.TextSize               = 15
	titleLbl.TextXAlignment         = Enum.TextXAlignment.Left
	titleLbl.Parent                 = frame
	local body = Instance.new("TextLabel")
	body.BackgroundTransparency = 1
	body.Size                   = UDim2.new(1, -20, 0, 32)
	body.Position               = UDim2.new(0, 12, 0, 24)
	body.Text                   = tostring(text)
	body.Font                   = Enum.Font.Gotham
	body.TextColor3             = Color3.fromRGB(190, 190, 210)
	body.TextSize               = 13
	body.TextWrapped            = true
	body.TextXAlignment         = Enum.TextXAlignment.Left
	body.Parent                 = frame
	local bar = Instance.new("Frame")
	bar.Size             = UDim2.new(1, -16, 0, 2)
	bar.Position         = UDim2.new(0, 8, 1, 6)
	bar.BackgroundColor3 = accentColor
	bar.BorderSizePixel  = 0
	bar.Parent           = frame
	Instance.new("UICorner", bar).CornerRadius = UDim.new(1, 0)
	tween(frame, { Position = UDim2.new(0, 0, 0, 0) }, 0.3, Enum.EasingStyle.Back):Play()
	tween(bar,   { Size = UDim2.new(0, 0, 0, 2) }, duration, Enum.EasingStyle.Quart):Play()
	task.delay(duration, function()
		tween(frame, { Position = UDim2.new(0, 0, 0, 100), BackgroundTransparency = 1 }, 0.25):Play()
		task.wait(0.3)
		frame:Destroy()
	end)
end

--// ============================
--//  CREATE WINDOW
--// ============================

function GrokaUI:CreateWindow(title, subtitle, icon)
	local T           = self.Theme
	local connections = {}

	local sg = Instance.new("ScreenGui")
	sg.Name            = "GrokaUI"
	sg.ResetOnSpawn    = false
	sg.ZIndexBehavior  = Enum.ZIndexBehavior.Sibling
	sg.Parent          = PlayerGui

	local shadowOuter = Instance.new("Frame")
	shadowOuter.Size                   = UDim2.new(0, 610, 0, 510)
	shadowOuter.Position               = UDim2.new(0.5, -305, 0.5, -255)
	shadowOuter.BackgroundColor3       = T.Accent
	shadowOuter.BackgroundTransparency = 0.92
	shadowOuter.BorderSizePixel        = 0
	shadowOuter.Parent                 = sg
	addCorner(shadowOuter, 24)

	local shadow = Instance.new("Frame")
	shadow.Size                   = UDim2.new(0, 596, 0, 496)
	shadow.Position               = UDim2.new(0.5, -298, 0.5, -248)
	shadow.BackgroundColor3       = Color3.new(0, 0, 0)
	shadow.BackgroundTransparency = 0.55
	shadow.BorderSizePixel        = 0
	shadow.Parent                 = sg
	addCorner(shadow, 22)

	local main = Instance.new("Frame")
	main.Size             = UDim2.new(0, 580, 0, 480)
	main.Position         = UDim2.new(0.5, -290, 0.5, -240)
	main.BackgroundColor3 = T.Background
	main.ClipsDescendants = true
	main.Parent           = sg
	addCorner(main, 18)
	addStroke(main, T.Border, 0.35, 1)

	main.Size     = UDim2.new(0, 560, 0, 460)
	main.Position = UDim2.new(0.5, -280, 0.5, -230)
	tween(main, { Size = UDim2.new(0, 580, 0, 480), Position = UDim2.new(0.5, -290, 0.5, -240) }, 0.35, Enum.EasingStyle.Back):Play()

	-- TOP BAR
	local topBar = Instance.new("Frame")
	topBar.Size             = UDim2.new(1, 0, 0, 46)
	topBar.Position         = UDim2.new(0, 0, 0, 0)
	topBar.BackgroundColor3 = T.Topbar
	topBar.BorderSizePixel  = 0
	topBar.ZIndex           = 5
	topBar.Parent           = main
	addCorner(topBar, 18)

	local topBarFix = Instance.new("Frame")
	topBarFix.Size             = UDim2.new(1, 0, 0, 18)
	topBarFix.Position         = UDim2.new(0, 0, 1, -18)
	topBarFix.BackgroundColor3 = T.Topbar
	topBarFix.BorderSizePixel  = 0
	topBarFix.Parent           = topBar

	local accentLine = Instance.new("Frame")
	accentLine.Size             = UDim2.new(1, 0, 0, 2)
	accentLine.Position         = UDim2.new(0, 0, 1, -2)
	accentLine.BackgroundColor3 = T.Accent
	accentLine.BorderSizePixel  = 0
	accentLine.ZIndex           = 6
	accentLine.Parent           = topBar
	local accentGrad = Instance.new("UIGradient")
	accentGrad.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0,   T.Accent),
		ColorSequenceKeypoint.new(0.5, Color3.fromRGB(140, 120, 255)),
		ColorSequenceKeypoint.new(1,   T.AccentDark),
	})
	accentGrad.Parent = accentLine

	-- Chrome buttons
	local function makeChromeBtn(text, posX, hoverColor)
		local btn = Instance.new("TextButton")
		btn.Size             = UDim2.new(0, 30, 0, 30)
		btn.Position         = UDim2.new(1, posX, 0.5, -15)
		btn.BackgroundColor3 = T.Surface
		btn.Text             = text
		btn.Font             = Enum.Font.GothamBold
		btn.TextColor3       = T.SubText
		btn.TextSize         = 13
		btn.AutoButtonColor  = false
		btn.ZIndex           = 6
		btn.Parent           = topBar
		addCorner(btn, 9)
		local st = addStroke(btn, T.Border, 0.5)
		btn.MouseEnter:Connect(function()
			tween(btn, { BackgroundColor3 = hoverColor or T.SurfaceHover, TextColor3 = T.Text }, 0.15):Play()
			tween(st,  { Transparency = 0.2 }, 0.15):Play()
		end)
		btn.MouseLeave:Connect(function()
			tween(btn, { BackgroundColor3 = T.Surface, TextColor3 = T.SubText }, 0.15):Play()
			tween(st,  { Transparency = 0.5 }, 0.15):Play()
		end)
		return btn
	end

	local close    = makeChromeBtn("✕", -28, T.Danger)
	local minimise = makeChromeBtn("—", -66)
	minimise.TextSize = 15

	close.MouseEnter:Connect(function() tween(close, { BackgroundColor3 = T.Danger, TextColor3 = Color3.new(1,1,1) }, 0.15):Play() end)
	close.MouseLeave:Connect(function() tween(close, { BackgroundColor3 = T.Surface, TextColor3 = T.SubText }, 0.15):Play() end)
	close.MouseButton1Click:Connect(function()
		tween(main,        { Size = UDim2.new(0,0,0,0), Position = UDim2.new(0.5,0,0.5,0) }, 0.25):Play()
		tween(shadow,      { BackgroundTransparency = 1 }, 0.25):Play()
		tween(shadowOuter, { BackgroundTransparency = 1 }, 0.25):Play()
		task.wait(0.3)
		sg:Destroy()
	end)

	-- Tabs row in top bar
	local tabsScrollFrame = Instance.new("ScrollingFrame")
	tabsScrollFrame.Size                   = UDim2.new(1, -130, 1, -8)
tabsScrollFrame.Position               = UDim2.new(0, 8, 0, 4)
tabsScrollFrame.BackgroundTransparency = 1
tabsScrollFrame.BorderSizePixel        = 0

tabsScrollFrame.ScrollingDirection     = Enum.ScrollingDirection.X
tabsScrollFrame.AutomaticCanvasSize    = Enum.AutomaticSize.X
tabsScrollFrame.CanvasSize             = UDim2.new(0,0,0,0)

tabsScrollFrame.ScrollBarThickness     = 4
tabsScrollFrame.ScrollBarImageColor3   = T.Accent
tabsScrollFrame.ScrollBarImageTransparency = 0.3

tabsScrollFrame.ZIndex                 = 5
tabsScrollFrame.Parent                 = topBar

	local tabsRow = Instance.new("Frame")
tabsRow.Size                   = UDim2.new(0, 0, 1, 0)
tabsRow.AutomaticSize          = Enum.AutomaticSize.X
	tabsRow.BackgroundTransparency = 1
	tabsRow.ZIndex                 = 5
	tabsRow.Parent                 = tabsScrollFrame

	local tabsRowLayout = Instance.new("UIListLayout")
	tabsRowLayout.FillDirection     = Enum.FillDirection.Horizontal
	tabsRowLayout.Padding           = UDim.new(0, 4)
	tabsRowLayout.VerticalAlignment = Enum.VerticalAlignment.Center
	tabsRowLayout.SortOrder         = Enum.SortOrder.LayoutOrder
	tabsRowLayout.Parent            = tabsRow

	tabsRowLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
	tabsScrollFrame.CanvasSize = UDim2.new(
		0,
		tabsRowLayout.AbsoluteContentSize.X + 20,
		0,
		0
	)
end)

	-- Minimise
	local minimised = false
	local fullH     = 480
	local miniH     = 46

	minimise.MouseButton1Click:Connect(function()
		minimised = not minimised
		if minimised then
			tween(main,        { Size = UDim2.new(0, 580, 0, miniH) }, 0.25):Play()
			tween(shadow,      { Size = UDim2.new(0, 596, 0, miniH + 14) }, 0.25):Play()
			tween(shadowOuter, { Size = UDim2.new(0, 610, 0, miniH + 28) }, 0.25):Play()
			minimise.Text = "□"
		else
			tween(main,        { Size = UDim2.new(0, 580, 0, fullH) }, 0.25):Play()
			tween(shadow,      { Size = UDim2.new(0, 596, 0, fullH + 14) }, 0.25):Play()
			tween(shadowOuter, { Size = UDim2.new(0, 610, 0, fullH + 28) }, 0.25):Play()
			minimise.Text = "—"
		end
	end)

	-- Drag
	do
		local dragging, dragStart, startPos = false
		topBar.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 then
				dragging  = true
				dragStart = input.Position
				startPos  = main.Position
				input.Changed:Connect(function()
					if input.UserInputState == Enum.UserInputState.End then dragging = false end
				end)
			end
		end)
		local c = UIS.InputChanged:Connect(function(input)
			if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
				local d = input.Position - dragStart
				main.Position        = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
				shadow.Position      = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X - 6, startPos.Y.Scale, startPos.Y.Offset + d.Y - 6)
				shadowOuter.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X - 9, startPos.Y.Scale, startPos.Y.Offset + d.Y - 9)
			end
		end)
		table.insert(connections, c)
	end

	-- MIDDLE SECTION
	local middleArea = Instance.new("Frame")
	middleArea.Size                   = UDim2.new(1, 0, 1, -46 - 36)
	middleArea.Position               = UDim2.new(0, 0, 0, 46)
	middleArea.BackgroundTransparency = 1
	middleArea.Parent                 = main

	-- Left sidebar
	local sidebar = Instance.new("Frame")
	sidebar.Size             = UDim2.new(0, 158, 1, 0)
	sidebar.BackgroundColor3 = T.Topbar
	sidebar.BorderSizePixel  = 0
	sidebar.Parent           = middleArea

	local sidebarDivider = Instance.new("Frame")
	sidebarDivider.Size                   = UDim2.new(0, 1, 1, -20)
	sidebarDivider.Position               = UDim2.new(0, 158, 0, 10)
	sidebarDivider.BackgroundColor3       = T.Border
	sidebarDivider.BackgroundTransparency = 0.3
	sidebarDivider.BorderSizePixel        = 0
	sidebarDivider.Parent                 = middleArea

	-- Script icon in sidebar — accepts ANY rbxassetid the user passes
	local windowNumericId = parseAssetId(icon)
	if windowNumericId then
		local iconBg = Instance.new("Frame")
		iconBg.Size             = UDim2.new(0, 52, 0, 52)
		iconBg.Position         = UDim2.new(0.5, -26, 0, 20)
		iconBg.BackgroundColor3 = T.Surface
		iconBg.ZIndex           = 4
		iconBg.Parent           = sidebar
		addCorner(iconBg, 14)
		addStroke(iconBg, T.BorderLight, 0.5)

		local img = Instance.new("ImageLabel")
		img.Size                   = UDim2.new(0, 30, 0, 30)
		img.Position               = UDim2.new(0.5, -15, 0.5, -15)
		img.BackgroundTransparency = 1
		img.Image                  = "rbxassetid://" .. windowNumericId
		img.ImageColor3            = Color3.new(1, 1, 1)
		img.ScaleType              = Enum.ScaleType.Fit
		img.ZIndex                 = 5
		img.Parent                 = iconBg
	end

	local sideTitleY = windowNumericId and 82 or 20
	local sideTitle = Instance.new("TextLabel")
	sideTitle.BackgroundTransparency = 1
	sideTitle.Size                   = UDim2.new(1, -16, 0, 22)
	sideTitle.Position               = UDim2.new(0, 8, 0, sideTitleY)
	sideTitle.Text                   = title or "Groka UI"
	sideTitle.Font                   = Enum.Font.GothamBold
	sideTitle.TextSize               = 15
	sideTitle.TextColor3             = T.Text
	sideTitle.TextXAlignment         = Enum.TextXAlignment.Center
	sideTitle.Parent                 = sidebar

	if subtitle then
		local sideSub = Instance.new("TextLabel")
		sideSub.BackgroundTransparency = 1
		sideSub.Size                   = UDim2.new(1, -16, 0, 16)
		sideSub.Position               = UDim2.new(0, 8, 0, sideTitleY + 26)
		sideSub.Text                   = subtitle
		sideSub.Font                   = Enum.Font.Gotham
		sideSub.TextSize               = 11
		sideSub.TextColor3             = T.SubText
		sideSub.TextXAlignment         = Enum.TextXAlignment.Center
		sideSub.TextWrapped            = true
		sideSub.Parent                 = sidebar
	end

	-- Pages
	local pages = Instance.new("Frame")
	pages.BackgroundTransparency = 1
	pages.Size                   = UDim2.new(1, -168, 1, 0)
	pages.Position               = UDim2.new(0, 164, 0, 0)
	pages.Parent                 = middleArea

	local pagePad = Instance.new("UIPadding")
	pagePad.PaddingRight = UDim.new(0, 6)
	pagePad.PaddingTop   = UDim.new(0, 4)
	pagePad.Parent       = pages

	-- BOTTOM BAR
	local bottomBar = Instance.new("Frame")
	bottomBar.Size             = UDim2.new(1, 0, 0, 36)
	bottomBar.Position         = UDim2.new(0, 0, 1, -36)
	bottomBar.BackgroundColor3 = T.Topbar
	bottomBar.BorderSizePixel  = 0
	bottomBar.ZIndex           = 5
	bottomBar.Parent           = main
	addCorner(bottomBar, 18)

	local bottomBarFix = Instance.new("Frame")
	bottomBarFix.Size             = UDim2.new(1, 0, 0, 18)
	bottomBarFix.Position         = UDim2.new(0, 0, 0, 0)
	bottomBarFix.BackgroundColor3 = T.Topbar
	bottomBarFix.BorderSizePixel  = 0
	bottomBarFix.Parent           = bottomBar

	local bottomLine = Instance.new("Frame")
	bottomLine.Size                   = UDim2.new(1, 0, 0, 1)
	bottomLine.Position               = UDim2.new(0, 0, 0, 0)
	bottomLine.BackgroundColor3       = T.Border
	bottomLine.BackgroundTransparency = 0.3
	bottomLine.BorderSizePixel        = 0
	bottomLine.ZIndex                 = 6
	bottomLine.Parent                 = bottomBar

	local avatarImg = Instance.new("ImageLabel")
	avatarImg.Size             = UDim2.new(0, 24, 0, 24)
	avatarImg.Position         = UDim2.new(0, 10, 0.5, -12)
	avatarImg.BackgroundColor3 = T.Surface
	avatarImg.Image            = "https://www.roblox.com/headshot-thumbnail/image?userId=" .. tostring(Player.UserId) .. "&width=48&height=48&format=png"
	avatarImg.ScaleType        = Enum.ScaleType.Crop
	avatarImg.ZIndex           = 6
	avatarImg.Parent           = bottomBar
	addCorner(avatarImg, 12)
	addStroke(avatarImg, T.BorderLight, 0.5)

	local playerNameLbl = Instance.new("TextLabel")
	playerNameLbl.BackgroundTransparency = 1
	playerNameLbl.Size                   = UDim2.new(0, 160, 1, 0)
	playerNameLbl.Position               = UDim2.new(0, 40, 0, 0)
	playerNameLbl.Text                   = Player.DisplayName
	playerNameLbl.Font                   = Enum.Font.GothamBold
	playerNameLbl.TextSize               = 12
	playerNameLbl.TextColor3             = T.SubText
	playerNameLbl.TextXAlignment         = Enum.TextXAlignment.Left
	playerNameLbl.ZIndex                 = 6
	playerNameLbl.Parent                 = bottomBar

	local creditsLbl = Instance.new("TextLabel")
	creditsLbl.BackgroundTransparency = 1
	creditsLbl.Size                   = UDim2.new(0, 200, 1, 0)
	creditsLbl.Position               = UDim2.new(1, -210, 0, 0)
	creditsLbl.Text                   = GrokaUI.Credits
	creditsLbl.Font                   = Enum.Font.Gotham
	creditsLbl.TextSize               = 11
	creditsLbl.TextColor3             = T.SubText
	creditsLbl.TextXAlignment         = Enum.TextXAlignment.Right
	creditsLbl.ZIndex                 = 6
	creditsLbl.Parent                 = bottomBar

	-- WINDOW OBJECT
	local Window       = {}
	local tabButtons   = {}
	local tabPages     = {}
	local activeTabIdx = 0

	local function tweenTabIcon(tb, color)
		tween(tb.icon, { ImageColor3 = color }, 0.15):Play()
	end

	local function selectTab(index)
		activeTabIdx = index
		for i, p in ipairs(tabPages) do
			p.Visible = (i == index)
			local tb = tabButtons[i]
			if i == index then
				tween(tb.btn,       { BackgroundColor3 = T.TabActive }, 0.15):Play()
				tween(tb.indicator, { BackgroundTransparency = 0 }, 0.2):Play()
				tweenTabIcon(tb, Color3.new(1, 1, 1))
				tween(tb.name, { TextColor3 = T.Text }, 0.15):Play()
			else
				tween(tb.btn,       { BackgroundColor3 = T.TabInactive }, 0.15):Play()
				tween(tb.indicator, { BackgroundTransparency = 1 }, 0.15):Play()
				tweenTabIcon(tb, Color3.fromRGB(180, 180, 200))
				tween(tb.name, { TextColor3 = T.SubText }, 0.15):Play()
			end
		end
	end

	function Window:Destroy()
		for _, c in pairs(connections) do pcall(function() c:Disconnect() end) end
		sg:Destroy()
	end

	-- CREATE TAB
	function Window:CreateTab(name, icon)

		local button = Instance.new("TextButton")
		button.Size             = UDim2.new(0, 0, 1, -8)
		button.AutomaticSize    = Enum.AutomaticSize.X
		button.BackgroundColor3 = T.TabInactive
		button.Text             = ""
		button.AutoButtonColor  = false
		button.ZIndex           = 6
		button.Parent           = tabsRow
		addCorner(button, 9)

		local btnPad = Instance.new("UIPadding")
		btnPad.PaddingLeft  = UDim.new(0, 10)
		btnPad.PaddingRight = UDim.new(0, 10)
		btnPad.Parent       = button

		local btnInner = Instance.new("Frame")
		btnInner.Size                   = UDim2.new(0, 0, 1, 0)
		btnInner.AutomaticSize          = Enum.AutomaticSize.X
		btnInner.BackgroundTransparency = 1
		btnInner.ZIndex                 = 7
		btnInner.Parent                 = button

		local btnInnerLayout = Instance.new("UIListLayout")
		btnInnerLayout.FillDirection     = Enum.FillDirection.Horizontal
		btnInnerLayout.Padding           = UDim.new(0, 6)
		btnInnerLayout.VerticalAlignment = Enum.VerticalAlignment.Center
		btnInnerLayout.SortOrder         = Enum.SortOrder.LayoutOrder
		btnInnerLayout.Parent            = btnInner

		local indicator = Instance.new("Frame")
		indicator.Size                   = UDim2.new(0, 6, 0, 6)
		indicator.BackgroundColor3       = T.Accent
		indicator.BackgroundTransparency = 1
		indicator.ZIndex                 = 8
		indicator.Parent                 = btnInner
		addCorner(indicator, 3)

		local tabNumericId = parseAssetId(icon) or parseAssetId(GrokaUI.Icons.Info)

		local tabIcon = Instance.new("ImageLabel")
		tabIcon.Size                   = UDim2.new(0, 16, 0, 16)
		tabIcon.BackgroundTransparency = 1
		tabIcon.Image                  = "rbxassetid://" .. tabNumericId
		tabIcon.ImageColor3            = Color3.fromRGB(180, 180, 200)
		tabIcon.ScaleType              = Enum.ScaleType.Fit
		tabIcon.ZIndex                 = 8
		tabIcon.Parent                 = btnInner

		local tabName = Instance.new("TextLabel")
		tabName.BackgroundTransparency = 1
		tabName.Size                   = UDim2.new(0, 0, 1, 0)
		tabName.AutomaticSize          = Enum.AutomaticSize.X
		tabName.Text                   = name
		tabName.Font                   = Enum.Font.GothamBold
		tabName.TextSize               = 12
		tabName.TextColor3             = T.SubText
		tabName.ZIndex                 = 8
		tabName.Parent                 = btnInner

		local tabIndex = #tabPages + 1
		table.insert(tabButtons, { btn = button, indicator = indicator, icon = tabIcon, name = tabName })

		button.MouseEnter:Connect(function()
			if tabIndex ~= activeTabIdx then tween(button, { BackgroundColor3 = T.Surface }, 0.12):Play() end
		end)
		button.MouseLeave:Connect(function()
			if tabIndex ~= activeTabIdx then tween(button, { BackgroundColor3 = T.TabInactive }, 0.12):Play() end
		end)

		local page = Instance.new("ScrollingFrame")
		page.Size                       = UDim2.new(1, 0, 1, 0)
		page.BackgroundTransparency     = 1
		page.BorderSizePixel            = 0
		page.CanvasSize                 = UDim2.new(0, 0, 0, 0)
		page.ScrollBarThickness         = 4
		page.ScrollBarImageColor3       = T.Accent
		page.ScrollBarImageTransparency = 0.3
		page.Visible                    = false
		page.Parent                     = pages
		table.insert(tabPages, page)

		local layout = Instance.new("UIListLayout")
		layout.Padding = UDim.new(0, 10)
		layout.Parent  = page

		local pageContentPad = Instance.new("UIPadding")
		pageContentPad.PaddingLeft = UDim.new(0, 2)
		pageContentPad.Parent      = page

		layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
			page.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 14)
		end)

		button.MouseButton1Click:Connect(function() selectTab(tabIndex) end)
		if tabIndex == 1 then selectTab(1) end

		-- ELEMENTS
		local Elements = {}

		local function makeCard(h)
			local card = Instance.new("Frame")
			card.Size             = UDim2.new(1, -2, 0, h or 50)
			card.BackgroundColor3 = T.Surface
			card.BorderSizePixel  = 0
			card.Parent           = page
			addCorner(card, 12)
			addStroke(card, T.Border, 0.55)
			card.MouseEnter:Connect(function() tween(card, { BackgroundColor3 = T.SurfaceHover }, 0.15):Play() end)
			card.MouseLeave:Connect(function() tween(card, { BackgroundColor3 = T.Surface }, 0.15):Play() end)
			return card
		end

		local function makeLabel(parent, text, x, y, size, bold, color)
			local lbl = Instance.new("TextLabel")
			lbl.BackgroundTransparency = 1
			lbl.Position               = UDim2.new(0, x or 16, 0, y or 0)
			lbl.Size                   = UDim2.new(1, -24, 0, 20)
			lbl.Text                   = tostring(text)
			lbl.Font                   = bold and Enum.Font.GothamBold or Enum.Font.Gotham
			lbl.TextColor3             = color or T.Text
			lbl.TextSize               = size or 14
			lbl.TextXAlignment         = Enum.TextXAlignment.Left
			lbl.Parent                 = parent
			return lbl
		end

		function Elements:AddSection(text)
			local holder = Instance.new("Frame")
			holder.Size                   = UDim2.new(1, -2, 0, 28)
			holder.BackgroundTransparency = 1
			holder.Parent                 = page
			local line = Instance.new("Frame")
			line.Size                   = UDim2.new(1, -12, 0, 1)
			line.Position               = UDim2.new(0, 6, 0.5, 0)
			line.BackgroundColor3       = T.Border
			line.BackgroundTransparency = 0.4
			line.BorderSizePixel        = 0
			line.Parent                 = holder
			local label = Instance.new("TextLabel")
			label.AutomaticSize    = Enum.AutomaticSize.X
			label.Size             = UDim2.new(0, 0, 1, 0)
			label.Position         = UDim2.new(0, 12, 0, 0)
			label.BackgroundColor3 = T.Background
			label.Text             = "  " .. text .. "  "
			label.Font             = Enum.Font.GothamBold
			label.TextSize         = 11
			label.TextColor3       = T.Accent
			label.Parent           = holder
		end

		-- AddButton: optional icon before text
		-- Usage: Elements:AddButton("My Button", "desc", callback)
		--    or: Elements:AddButton("My Button", GrokaUI.Icons.Star, "desc", callback)
		--    or: Elements:AddButton("My Button", GrokaUI.Icons.Star, nil, callback)
		function Elements:AddButton(text, iconOrDesc, descOrCallback, callbackOrNil)
			local btnIcon, desc, callback

			-- detect if 2nd arg is an icon (string containing rbxassetid or numeric string)
			if type(iconOrDesc) == "string" and (iconOrDesc:find("rbxassetid://") or iconOrDesc:match("^%d+$")) then
				btnIcon  = iconOrDesc
				desc     = type(descOrCallback) == "string" and descOrCallback or nil
				callback = type(descOrCallback) == "function" and descOrCallback or callbackOrNil
			else
				btnIcon  = nil
				desc     = type(iconOrDesc) == "string" and iconOrDesc or nil
				callback = type(iconOrDesc) == "function" and iconOrDesc or (type(descOrCallback) == "function" and descOrCallback or callbackOrNil)
			end

			local h    = desc and 64 or 48
			local card = makeCard(h)

			-- Icon image before text
			local textOffsetX = 16
			if btnIcon then
				local numId = parseAssetId(btnIcon)
				if numId then
					local iconLbl = Instance.new("ImageLabel")
					iconLbl.Size                   = UDim2.new(0, 18, 0, 18)
					iconLbl.Position               = UDim2.new(0, 14, desc and 0 or 0.5, desc and 0 or -9)
					if desc then iconLbl.Position = UDim2.new(0, 14, 0, 15) end
					iconLbl.BackgroundTransparency = 1
					iconLbl.Image                  = "rbxassetid://" .. numId
					iconLbl.ImageColor3            = T.Accent
					iconLbl.ScaleType              = Enum.ScaleType.Fit
					iconLbl.ZIndex                 = 4
					iconLbl.Parent                 = card
					textOffsetX = 38
				end
			end

			makeLabel(card, text, textOffsetX, desc and 10 or 14, 14, true, T.Text)
			if desc then makeLabel(card, desc, textOffsetX, 32, 12, false, T.SubText) end

			local actionHint = Instance.new("TextLabel")
			actionHint.BackgroundTransparency = 1
			actionHint.Size                   = UDim2.new(0, 24, 0, 24)
			actionHint.Position               = UDim2.new(1, -36, 0.5, -12)
			actionHint.Text                   = "›"
			actionHint.Font                   = Enum.Font.GothamBold
			actionHint.TextSize               = 18
			actionHint.TextColor3             = T.BorderLight
			actionHint.Parent                 = card

			local btn = Instance.new("TextButton")
			btn.BackgroundTransparency = 1
			btn.Size                   = UDim2.new(1, 0, 1, 0)
			btn.Text                   = ""
			btn.Parent                 = card
			addRipple(btn, T.Accent)
			btn.MouseEnter:Connect(function() tween(actionHint, { TextColor3 = T.Accent }, 0.15):Play() end)
			btn.MouseLeave:Connect(function() tween(actionHint, { TextColor3 = T.BorderLight }, 0.15):Play() end)
			btn.MouseButton1Click:Connect(function() if callback then callback() end end)
		end

		function Elements:AddToggle(text, desc, default, callback)
			local state = default or false
			local card  = makeCard(desc and 64 or 48)
			makeLabel(card, text, 16, desc and 10 or 14, 14, true, T.Text)
			if desc then makeLabel(card, desc, 16, 32, 12, false, T.SubText) end
			local track = Instance.new("Frame")
			track.Size             = UDim2.new(0, 48, 0, 26)
			track.Position         = UDim2.new(1, -62, 0.5, -13)
			track.BackgroundColor3 = state and T.Success or T.Track
			track.Parent           = card
			addCorner(track, 13)
			addStroke(track, T.Border, 0.6)
			local knob = Instance.new("Frame")
			knob.Size             = UDim2.new(0, 20, 0, 20)
			knob.Position         = state and UDim2.new(1,-23,0.5,-10) or UDim2.new(0,3,0.5,-10)
			knob.BackgroundColor3 = Color3.new(1,1,1)
			knob.Parent           = track
			addCorner(knob, 10)
			local btn = Instance.new("TextButton")
			btn.BackgroundTransparency = 1
			btn.Size                   = UDim2.new(1, 0, 1, 0)
			btn.Text                   = ""
			btn.Parent                 = card
			local function applyState()
				tween(track, { BackgroundColor3 = state and T.Success or T.Track }, 0.18):Play()
				tween(knob,  { Position = state and UDim2.new(1,-23,0.5,-10) or UDim2.new(0,3,0.5,-10) }, 0.18, Enum.EasingStyle.Back):Play()
			end
			btn.MouseButton1Click:Connect(function()
				state = not state
				applyState()
				if callback then callback(state) end
			end)
			local Toggle = {}
			function Toggle:Set(v) state = v applyState() if callback then callback(state) end end
			function Toggle:Get() return state end
			return Toggle
		end

		function Elements:AddLabel(text)
			local card  = makeCard(42)
			local label = makeLabel(card, text, 16, 11, 13, false, T.Text)
			local Label = {}
			function Label:Set(t) label.Text = tostring(t) end
			return Label
		end

		function Elements:AddParagraph(title, text)
			local card = makeCard(84)
			makeLabel(card, title, 16, 12, 14, true, T.Text)
			local body = makeLabel(card, text, 16, 36, 12, false, T.SubText)
			body.TextWrapped = true
			body.Size        = UDim2.new(1, -32, 0, 40)
		end

		function Elements:AddSlider(text, min, max, default, callback)
			local value = math.clamp(default or min, min, max)
			local range = max - min
			local card  = makeCard(72)
			makeLabel(card, text, 16, 12, 14, true, T.Text)
			local valueBg = Instance.new("Frame")
			valueBg.Size             = UDim2.new(0, 44, 0, 22)
			valueBg.Position         = UDim2.new(1, -58, 0, 10)
			valueBg.BackgroundColor3 = T.Input
			valueBg.Parent           = card
			addCorner(valueBg, 6)
			addStroke(valueBg, T.Border, 0.5)
			local valueLbl = Instance.new("TextLabel")
			valueLbl.BackgroundTransparency = 1
			valueLbl.Size                   = UDim2.new(1, 0, 1, 0)
			valueLbl.Text                   = tostring(value)
			valueLbl.Font                   = Enum.Font.GothamBold
			valueLbl.TextColor3             = T.Accent
			valueLbl.TextSize               = 12
			valueLbl.Parent                 = valueBg
			local bar = Instance.new("Frame")
			bar.Size             = UDim2.new(1, -32, 0, 8)
			bar.Position         = UDim2.new(0, 16, 0, 46)
			bar.BackgroundColor3 = T.Track
			bar.Parent           = card
			addCorner(bar, 4)
			local fill = Instance.new("Frame")
			fill.Size             = UDim2.new((value - min) / range, 0, 1, 0)
			fill.BackgroundColor3 = T.Accent
			fill.Parent           = bar
			addCorner(fill, 4)
			local fillGrad = Instance.new("UIGradient")
			fillGrad.Color  = ColorSequence.new(T.Accent, T.AccentDark)
			fillGrad.Parent = fill
			local thumb = Instance.new("Frame")
			thumb.Size             = UDim2.new(0, 14, 0, 14)
			thumb.AnchorPoint      = Vector2.new(0.5, 0.5)
			thumb.Position         = UDim2.new((value - min) / range, 0, 0.5, 0)
			thumb.BackgroundColor3 = Color3.new(1, 1, 1)
			thumb.ZIndex           = 2
			thumb.Parent           = bar
			addCorner(thumb, 7)
			addStroke(thumb, T.Accent, 0.3, 2)
			local dragging = false
			local function setVisual(pos)
				value          = math.floor(min + range * pos)
				fill.Size      = UDim2.new(pos, 0, 1, 0)
				thumb.Position = UDim2.new(pos, 0, 0.5, 0)
				valueLbl.Text  = tostring(value)
			end
			local function finishDrag()
				if not dragging then return end
				dragging = false
				if callback then callback(value) end
			end
			bar.InputBegan:Connect(function(i)
				if i.UserInputType == Enum.UserInputType.MouseButton1 then
					dragging = true
					setVisual(math.clamp((i.Position.X - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1))
				end
			end)
			bar.InputEnded:Connect(function(i)
				if i.UserInputType == Enum.UserInputType.MouseButton1 then finishDrag() end
			end)
			local c1 = UIS.InputChanged:Connect(function(i)
				if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then
					setVisual(math.clamp((i.Position.X - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1))
				end
			end)
			local c2 = UIS.InputEnded:Connect(function(i)
				if i.UserInputType == Enum.UserInputType.MouseButton1 then finishDrag() end
			end)
			table.insert(connections, c1)
			table.insert(connections, c2)
		end

		function Elements:AddInput(text, placeholder, callback)
			local card = makeCard(68)
			makeLabel(card, text, 16, 10, 14, true, T.Text)
			local box = Instance.new("TextBox")
			box.Size              = UDim2.new(1, -32, 0, 32)
			box.Position          = UDim2.new(0, 16, 0, 32)
			box.BackgroundColor3  = T.Input
			box.PlaceholderText   = placeholder or "Type..."
			box.Text              = ""
			box.ClearTextOnFocus  = false
			box.TextColor3        = T.Text
			box.PlaceholderColor3 = T.SubText
			box.Font              = Enum.Font.Gotham
			box.TextSize          = 13
			box.Parent            = card
			addCorner(box, 9)
			local boxStroke = addStroke(box, T.Border, 0.55)
			pcall(function()
				box.Focused:Connect(function()
					tween(boxStroke, { Color = T.Accent, Transparency = 0.2 }, 0.15):Play()
					tween(box, { BackgroundColor3 = T.SurfaceHover }, 0.15):Play()
				end)
			end)
			box.FocusLost:Connect(function()
				tween(boxStroke, { Color = T.Border, Transparency = 0.55 }, 0.15):Play()
				tween(box, { BackgroundColor3 = T.Input }, 0.15):Play()
				if callback then callback(box.Text) end
			end)
		end

		function Elements:AddDropdown(text, options, callback)
			local current    = options[1] or "Select"
			local open       = false
			local collapsedH = 52
			local optionH    = 38
			local optionGap  = 6
			local headerH    = 52
			local function getOpenHeight()
				return headerH + 8 + (#options * (optionH + optionGap))
			end
			local card = makeCard(collapsedH)
			card.ClipsDescendants = false
			makeLabel(card, text, 16, 14, 14, true, T.Text)
			local selectedLbl = Instance.new("TextLabel")
			selectedLbl.BackgroundTransparency = 1
			selectedLbl.Size                   = UDim2.new(0, 140, 0, 20)
			selectedLbl.Position               = UDim2.new(1, -170, 0, 16)
			selectedLbl.Text                   = current
			selectedLbl.Font                   = Enum.Font.Gotham
			selectedLbl.TextSize               = 12
			selectedLbl.TextColor3             = T.SubText
			selectedLbl.TextXAlignment         = Enum.TextXAlignment.Right
			selectedLbl.Parent                 = card
			local arrow = Instance.new("TextLabel")
			arrow.BackgroundTransparency = 1
			arrow.Size                   = UDim2.new(0, 20, 0, 20)
			arrow.Position               = UDim2.new(1, -28, 0, 16)
			arrow.Text                   = "▾"
			arrow.Font                   = Enum.Font.GothamBold
			arrow.TextSize               = 12
			arrow.TextColor3             = T.Accent
			arrow.Parent                 = card
			local holder = Instance.new("Frame")
			holder.BackgroundTransparency = 1
			holder.Position               = UDim2.new(0, 12, 0, headerH)
			holder.Size                   = UDim2.new(1, -24, 0, #options * (optionH + optionGap))
			holder.Visible                = false
			holder.Parent                 = card
			local optLayout = Instance.new("UIListLayout")
			optLayout.Padding = UDim.new(0, optionGap)
			optLayout.Parent  = holder
			local optButtons = {}
			local function refreshOptions()
				for _, entry in ipairs(optButtons) do
					local isSel = entry.value == current
					entry.btn.BackgroundColor3 = isSel and T.TabActive or T.Input
					entry.btn.TextColor3       = isSel and T.Accent or T.SubText
				end
				selectedLbl.Text = current
			end
			local setOpen
			for _, opt in ipairs(options) do
				local ob = Instance.new("TextButton")
				ob.Size             = UDim2.new(1, 0, 0, optionH)
				ob.BackgroundColor3 = T.Input
				ob.Text             = tostring(opt)
				ob.TextColor3       = T.SubText
				ob.Font             = Enum.Font.Gotham
				ob.TextSize         = 13
				ob.AutoButtonColor  = false
				ob.Parent           = holder
				addCorner(ob, 10)
				addStroke(ob, T.Border, 0.7)
				ob.MouseEnter:Connect(function()
					if current ~= tostring(opt) then
						tween(ob, { BackgroundColor3 = T.SurfaceHover, TextColor3 = T.Text }, 0.12):Play()
					end
				end)
				ob.MouseLeave:Connect(function() refreshOptions() end)
				ob.MouseButton1Click:Connect(function()
					current = tostring(opt)
					refreshOptions()
					setOpen(false)
					if callback then callback(opt) end
				end)
				table.insert(optButtons, { btn = ob, value = tostring(opt) })
			end
			refreshOptions()
			local toggleBtn = Instance.new("TextButton")
			toggleBtn.BackgroundTransparency = 1
			toggleBtn.Size                   = UDim2.new(1, 0, 0, headerH)
			toggleBtn.Text                   = ""
			toggleBtn.Parent                 = card
			setOpen = function(state)
				open                = state
				holder.Visible      = open
				selectedLbl.Visible = not open
				arrow.Text          = open and "▴" or "▾"
				tween(card, { Size = UDim2.new(1, -2, 0, open and getOpenHeight() or collapsedH) }, 0.22):Play()
			end
			toggleBtn.MouseButton1Click:Connect(function() setOpen(not open) end)
		end

		function Elements:AddKeybind(text, default, callback)
			local key     = default or Enum.KeyCode.RightShift
			local card    = makeCard(48)
			local waiting = false
			makeLabel(card, text, 16, 14, 14, true, T.Text)
			local bindBtn = Instance.new("TextButton")
			bindBtn.Size             = UDim2.new(0, 96, 0, 28)
			bindBtn.Position         = UDim2.new(1, -110, 0.5, -14)
			bindBtn.BackgroundColor3 = T.Input
			bindBtn.Text             = key.Name
			bindBtn.Font             = Enum.Font.GothamBold
			bindBtn.TextColor3       = T.Accent
			bindBtn.TextSize         = 12
			bindBtn.AutoButtonColor  = false
			bindBtn.Parent           = card
			addCorner(bindBtn, 8)
			local bindStroke = addStroke(bindBtn, T.Border, 0.5)
			bindBtn.MouseEnter:Connect(function() tween(bindBtn, { BackgroundColor3 = T.SurfaceHover }, 0.12):Play() end)
			bindBtn.MouseLeave:Connect(function()
				if not waiting then tween(bindBtn, { BackgroundColor3 = T.Input }, 0.12):Play() end
			end)
			bindBtn.MouseButton1Click:Connect(function()
				if waiting then return end
				waiting      = true
				bindBtn.Text = "..."
				tween(bindStroke, { Color = T.Accent, Transparency = 0.2 }, 0.15):Play()
				local c
				c = UIS.InputBegan:Connect(function(input, gp)
					if gp then return end
					if input.UserInputType == Enum.UserInputType.Keyboard then
						key          = input.KeyCode
						bindBtn.Text = key.Name
						waiting      = false
						tween(bindStroke, { Color = T.Border, Transparency = 0.5 }, 0.15):Play()
						c:Disconnect()
					end
				end)
			end)
			local c = UIS.InputBegan:Connect(function(input, gp)
				if gp then return end
				if input.KeyCode == key and callback then callback() end
			end)
			table.insert(connections, c)
		end

		return Elements
	end -- CreateTab

	return Window
end -- CreateWindow

return GrokaUI
