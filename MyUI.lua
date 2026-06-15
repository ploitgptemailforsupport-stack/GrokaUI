--// ============================================ //--
--//         Groka UI Library v5 Classic          //--
--//  Stud Background • Square Buttons • Keys     //--
--//  Credits: Groka / ploitgptemailforsupport    //--
--// ============================================ //--

local GrokaUI = {}

GrokaUI.Theme = {
	Background   = Color3.fromRGB(196, 196, 196), -- classic LEGO light grey
	Surface      = Color3.fromRGB(220, 220, 220),
	SurfaceHover = Color3.fromRGB(210, 210, 210),
	Topbar       = Color3.fromRGB(160, 160, 160),
	Accent       = Color3.fromRGB(0, 85, 180),    -- classic LEGO blue
	AccentDark   = Color3.fromRGB(0, 60, 140),
	AccentGlow   = Color3.fromRGB(0, 100, 210),
	Success      = Color3.fromRGB(0, 150, 60),
	Danger       = Color3.fromRGB(200, 30, 30),
	Text         = Color3.fromRGB(20, 20, 20),
	SubText      = Color3.fromRGB(80, 80, 80),
	Border       = Color3.fromRGB(120, 120, 120),
	BorderLight  = Color3.fromRGB(150, 150, 150),
	TabActive    = Color3.fromRGB(180, 180, 180),
	TabInactive  = Color3.fromRGB(196, 196, 196),
	Input        = Color3.fromRGB(240, 240, 240),
	Track        = Color3.fromRGB(160, 160, 160),
	StudTop      = Color3.fromRGB(210, 210, 210), -- stud highlight
	StudSide     = Color3.fromRGB(150, 150, 150), -- stud shadow
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

GrokaUI.Credits = "Groka UI v5 Classic • by Groka"

local TweenService = game:GetService("TweenService")
local UIS          = game:GetService("UserInputService")
local Players      = game:GetService("Players")

local Player    = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

local function tween(obj, props, t, style, dir)
	return TweenService:Create(obj, TweenInfo.new(
		t     or 0.15,
		style or Enum.EasingStyle.Quad,
		dir   or Enum.EasingDirection.Out
	), props)
end

-- Square corners (studs are square!)
local function addCorner(parent, radius)
	local c = Instance.new("UICorner")
	c.CornerRadius = UDim.new(0, radius or 0)
	c.Parent = parent
	return c
end

local function addStroke(parent, color, transparency, thickness)
	local s = Instance.new("UIStroke")
	s.Color           = color
	s.Transparency    = transparency or 0
	s.Thickness       = thickness or 2
	s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	s.Parent          = parent
	return s
end

local function parseAssetId(icon)
	if not icon then return nil end
	local iconStr = tostring(icon)
	return iconStr:match("rbxassetid://(%d+)") or iconStr:match("^(%d+)$")
end

-- Creates a stud pattern on a parent frame using repeating dot-like frames
local function addStudPattern(parent, T, columns, rows, studSize, spacing)
	columns  = columns  or 6
	rows     = rows     or 4
	studSize = studSize or 10
	spacing  = spacing  or 18

	local patternFrame = Instance.new("Frame")
	patternFrame.Size                   = UDim2.new(1, 0, 1, 0)
	patternFrame.BackgroundTransparency = 1
	patternFrame.ClipsDescendants       = true
	patternFrame.ZIndex                 = 0
	patternFrame.Parent                 = parent

	for r = 0, rows do
		for c = 0, columns do
			local stud = Instance.new("Frame")
			stud.Size             = UDim2.new(0, studSize, 0, studSize)
			stud.Position         = UDim2.new(0, spacing/2 + c * spacing, 0, spacing/2 + r * spacing)
			stud.BackgroundColor3 = T.StudTop
			stud.BorderSizePixel  = 0
			stud.ZIndex           = 1
			stud.Parent           = patternFrame
			addCorner(stud, studSize // 2)

			-- stud shadow ring
			local shadow = Instance.new("Frame")
			shadow.Size             = UDim2.new(0, studSize + 2, 0, studSize + 2)
			shadow.Position         = UDim2.new(0, spacing/2 + c * spacing - 1, 0, spacing/2 + r * spacing - 1)
			shadow.BackgroundColor3 = T.StudSide
			shadow.BorderSizePixel  = 0
			shadow.ZIndex           = 0
			shadow.Parent           = patternFrame
			addCorner(shadow, (studSize + 2) // 2)
		end
	end
	return patternFrame
end

local function addRipple(btn, color)
	btn.MouseButton1Down:Connect(function(x, y)
		local ripple = Instance.new("Frame")
		ripple.AnchorPoint            = Vector2.new(0.5, 0.5)
		ripple.Position               = UDim2.fromOffset(x - btn.AbsolutePosition.X, y - btn.AbsolutePosition.Y)
		ripple.Size                   = UDim2.new(0, 0, 0, 0)
		ripple.BackgroundColor3       = color or Color3.new(1,1,1)
		ripple.BackgroundTransparency = 0.7
		ripple.ZIndex                 = 999
		ripple.Parent                 = btn
		tween(ripple, { Size = UDim2.new(0,300,0,300), BackgroundTransparency = 1 }, 0.35, Enum.EasingStyle.Quad):Play()
		task.delay(0.35, function() ripple:Destroy() end)
	end)
end

--// ============================
--//  NOTIFICATIONS
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
NotifyLayout.Padding             = UDim.new(0, 8)
NotifyLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
NotifyLayout.VerticalAlignment   = Enum.VerticalAlignment.Bottom
NotifyLayout.SortOrder           = Enum.SortOrder.LayoutOrder
NotifyLayout.Parent              = NotifyHolder

function GrokaUI:Notify(title, text, duration, typ)
	local T = self.Theme
	duration = duration or 4
	typ      = typ      or "info"
	local colors = {
		info    = Color3.fromRGB(0, 85, 180),
		success = Color3.fromRGB(0, 150, 60),
		error   = Color3.fromRGB(200, 30, 30),
		warning = Color3.fromRGB(210, 140, 0),
	}
	local accentColor = colors[typ] or colors.info
	local frame = Instance.new("Frame")
	frame.Size             = UDim2.new(0, 380, 0, 60)
	frame.BackgroundColor3 = T.Surface
	frame.BorderSizePixel  = 0
	frame.Parent           = NotifyHolder
	addStroke(frame, accentColor, 0, 2)

	-- stud accent bar on left
	local sideBar = Instance.new("Frame")
	sideBar.Size             = UDim2.new(0, 5, 1, 0)
	sideBar.BackgroundColor3 = accentColor
	sideBar.BorderSizePixel  = 0
	sideBar.Parent           = frame

	local titleLbl = Instance.new("TextLabel")
	titleLbl.BackgroundTransparency = 1
	titleLbl.Size                   = UDim2.new(1, -20, 0, 20)
	titleLbl.Position               = UDim2.new(0, 14, 0, 8)
	titleLbl.Text                   = tostring(title)
	titleLbl.Font                   = Enum.Font.GothamBold
	titleLbl.TextColor3             = T.Text
	titleLbl.TextSize               = 14
	titleLbl.TextXAlignment         = Enum.TextXAlignment.Left
	titleLbl.Parent                 = frame
	local body = Instance.new("TextLabel")
	body.BackgroundTransparency = 1
	body.Size                   = UDim2.new(1, -20, 0, 24)
	body.Position               = UDim2.new(0, 14, 0, 30)
	body.Text                   = tostring(text)
	body.Font                   = Enum.Font.Gotham
	body.TextColor3             = T.SubText
	body.TextSize               = 12
	body.TextWrapped            = true
	body.TextXAlignment         = Enum.TextXAlignment.Left
	body.Parent                 = frame

	local bar = Instance.new("Frame")
	bar.Size             = UDim2.new(1, 0, 0, 3)
	bar.Position         = UDim2.new(0, 0, 1, -3)
	bar.BackgroundColor3 = accentColor
	bar.BorderSizePixel  = 0
	bar.Parent           = frame

	tween(bar, { Size = UDim2.new(0, 0, 0, 3) }, duration, Enum.EasingStyle.Linear):Play()
	task.delay(duration, function()
		tween(frame, { BackgroundTransparency = 1 }, 0.2):Play()
		task.wait(0.25)
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

	-- Main window — flat square, classic plate grey
	local main = Instance.new("Frame")
	main.Size             = UDim2.new(0, 580, 0, 480)
	main.Position         = UDim2.new(0.5, -290, 0.5, -240)
	main.BackgroundColor3 = T.Background
	main.BorderSizePixel  = 0
	main.ClipsDescendants = false
	main.Parent           = sg
	-- Bevel-style border (thick outer, lighter top-left, darker bottom-right)
	addStroke(main, T.Border, 0, 3)

	-- Subtle drop shadow
	local shadow = Instance.new("Frame")
	shadow.Size                   = UDim2.new(0, 586, 0, 486)
	shadow.Position               = UDim2.new(0.5, -290, 0.5, -237)
	shadow.BackgroundColor3       = Color3.fromRGB(60, 60, 60)
	shadow.BackgroundTransparency = 0.7
	shadow.BorderSizePixel        = 0
	shadow.ZIndex                 = -1
	shadow.Parent                 = sg

	-- Stud pattern on the main background
	addStudPattern(main, T, 12, 9, 8, 20)

	-- TOP BAR (classic LEGO-blue header)
	local topBar = Instance.new("Frame")
	topBar.Size             = UDim2.new(1, 0, 0, 44)
	topBar.BackgroundColor3 = T.Accent
	topBar.BorderSizePixel  = 0
	topBar.ZIndex           = 5
	topBar.Parent           = main

	-- Bottom border on topbar
	local topBarBorder = Instance.new("Frame")
	topBarBorder.Size             = UDim2.new(1, 0, 0, 3)
	topBarBorder.Position         = UDim2.new(0, 0, 1, -3)
	topBarBorder.BackgroundColor3 = T.AccentDark
	topBarBorder.BorderSizePixel  = 0
	topBarBorder.ZIndex           = 6
	topBarBorder.Parent           = topBar

	-- Window title in topbar
	local winTitle = Instance.new("TextLabel")
	winTitle.BackgroundTransparency = 1
	winTitle.Size                   = UDim2.new(1, -110, 1, 0)
	winTitle.Position               = UDim2.new(0, 12, 0, 0)
	winTitle.Text                   = title or "Groka UI"
	winTitle.Font                   = Enum.Font.GothamBold
	winTitle.TextSize               = 14
	winTitle.TextColor3             = Color3.new(1, 1, 1)
	winTitle.TextXAlignment         = Enum.TextXAlignment.Left
	winTitle.ZIndex                 = 6
	winTitle.Parent                 = topBar

	-- Square chrome buttons (stud style)
	local function makeChromeBtn(text, posX, bgColor, hoverColor)
		local btn = Instance.new("TextButton")
		btn.Size             = UDim2.new(0, 28, 0, 28)
		btn.Position         = UDim2.new(1, posX, 0.5, -14)
		btn.BackgroundColor3 = bgColor or T.Surface
		btn.Text             = text
		btn.Font             = Enum.Font.GothamBold
		btn.TextColor3       = T.Text
		btn.TextSize         = 13
		btn.AutoButtonColor  = false
		btn.BorderSizePixel  = 0
		btn.ZIndex           = 7
		btn.Parent           = topBar
		addStroke(btn, T.StudSide, 0, 2)
		btn.MouseEnter:Connect(function()
			tween(btn, { BackgroundColor3 = hoverColor or T.SurfaceHover }, 0.1):Play()
		end)
		btn.MouseLeave:Connect(function()
			tween(btn, { BackgroundColor3 = bgColor or T.Surface }, 0.1):Play()
		end)
		return btn
	end

	local close    = makeChromeBtn("✕", -34, Color3.fromRGB(220, 60, 60), Color3.fromRGB(255, 80, 80))
	local minimise = makeChromeBtn("—", -68, T.Surface, T.SurfaceHover)
	close.TextColor3    = Color3.new(1, 1, 1)
	minimise.TextSize   = 15

	close.MouseButton1Click:Connect(function()
		tween(main,   { Size = UDim2.new(0,0,0,0), Position = UDim2.new(0.5,0,0.5,0) }, 0.2):Play()
		tween(shadow, { BackgroundTransparency = 1 }, 0.2):Play()
		task.wait(0.25)
		sg:Destroy()
	end)

	-- Tabs row in top bar
	local tabsScrollFrame = Instance.new("ScrollingFrame")
	tabsScrollFrame.Size                       = UDim2.new(1, -130, 1, -8)
	tabsScrollFrame.Position                   = UDim2.new(0, 8, 0, 4)
	tabsScrollFrame.BackgroundTransparency     = 1
	tabsScrollFrame.BorderSizePixel            = 0
	tabsScrollFrame.ScrollingDirection         = Enum.ScrollingDirection.X
	tabsScrollFrame.AutomaticCanvasSize        = Enum.AutomaticSize.X
	tabsScrollFrame.CanvasSize                 = UDim2.new(0,0,0,0)
	tabsScrollFrame.ScrollBarThickness         = 3
	tabsScrollFrame.ScrollBarImageColor3       = Color3.new(1,1,1)
	tabsScrollFrame.ScrollBarImageTransparency = 0.5
	tabsScrollFrame.ZIndex                     = 6
	tabsScrollFrame.Parent                     = topBar

	local tabsRow = Instance.new("Frame")
	tabsRow.Size                   = UDim2.new(0, 0, 1, 0)
	tabsRow.AutomaticSize          = Enum.AutomaticSize.X
	tabsRow.BackgroundTransparency = 1
	tabsRow.ZIndex                 = 6
	tabsRow.Parent                 = tabsScrollFrame

	local tabsRowLayout = Instance.new("UIListLayout")
	tabsRowLayout.FillDirection     = Enum.FillDirection.Horizontal
	tabsRowLayout.Padding           = UDim.new(0, 3)
	tabsRowLayout.VerticalAlignment = Enum.VerticalAlignment.Center
	tabsRowLayout.SortOrder         = Enum.SortOrder.LayoutOrder
	tabsRowLayout.Parent            = tabsRow

	tabsRowLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
		tabsScrollFrame.CanvasSize = UDim2.new(0, tabsRowLayout.AbsoluteContentSize.X + 12, 0, 0)
	end)

	-- Minimise
	local minimised = false
	local fullH     = 480
	local miniH     = 44

	minimise.MouseButton1Click:Connect(function()
		minimised = not minimised
		if minimised then
			tween(main,   { Size = UDim2.new(0, 580, 0, miniH) }, 0.2):Play()
			tween(shadow, { Size = UDim2.new(0, 586, 0, miniH + 6) }, 0.2):Play()
			minimise.Text = "□"
		else
			tween(main,   { Size = UDim2.new(0, 580, 0, fullH) }, 0.2):Play()
			tween(shadow, { Size = UDim2.new(0, 586, 0, fullH + 6) }, 0.2):Play()
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
				main.Position   = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
				shadow.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y + 3)
			end
		end)
		table.insert(connections, c)
	end

	-- CONTENT AREA (below topbar)
	local contentArea = Instance.new("Frame")
	contentArea.Size                   = UDim2.new(1, 0, 1, -44 - 32)
	contentArea.Position               = UDim2.new(0, 0, 0, 44)
	contentArea.BackgroundTransparency = 1
	contentArea.ClipsDescendants       = true
	contentArea.Parent                 = main

	-- Left sidebar
	local sidebar = Instance.new("Frame")
	sidebar.Size             = UDim2.new(0, 148, 1, 0)
	sidebar.BackgroundColor3 = T.Topbar
	sidebar.BorderSizePixel  = 0
	sidebar.Parent           = contentArea
	addStroke(sidebar, T.Border, 0.2, 2)

	-- Stud pattern in sidebar
	addStudPattern(sidebar, T, 5, 10, 7, 18)

	local windowNumericId = parseAssetId(icon)
	if windowNumericId then
		local iconBg = Instance.new("Frame")
		iconBg.Size             = UDim2.new(0, 48, 0, 48)
		iconBg.Position         = UDim2.new(0.5, -24, 0, 14)
		iconBg.BackgroundColor3 = T.Surface
		iconBg.BorderSizePixel  = 0
		iconBg.ZIndex           = 4
		iconBg.Parent           = sidebar
		addStroke(iconBg, T.Border, 0, 2)
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

	local sideTitleY = windowNumericId and 72 or 14
	local sideTitle = Instance.new("TextLabel")
	sideTitle.BackgroundTransparency = 1
	sideTitle.Size                   = UDim2.new(1, -8, 0, 22)
	sideTitle.Position               = UDim2.new(0, 4, 0, sideTitleY)
	sideTitle.Text                   = title or "Groka UI"
	sideTitle.Font                   = Enum.Font.GothamBold
	sideTitle.TextSize               = 13
	sideTitle.TextColor3             = T.Text
	sideTitle.TextXAlignment         = Enum.TextXAlignment.Center
	sideTitle.ZIndex                 = 4
	sideTitle.Parent                 = sidebar

	if subtitle then
		local sideSub = Instance.new("TextLabel")
		sideSub.BackgroundTransparency = 1
		sideSub.Size                   = UDim2.new(1, -8, 0, 16)
		sideSub.Position               = UDim2.new(0, 4, 0, sideTitleY + 24)
		sideSub.Text                   = subtitle
		sideSub.Font                   = Enum.Font.Gotham
		sideSub.TextSize               = 10
		sideSub.TextColor3             = T.SubText
		sideSub.TextXAlignment         = Enum.TextXAlignment.Center
		sideSub.TextWrapped            = true
		sideSub.ZIndex                 = 4
		sideSub.Parent                 = sidebar
	end

	-- Sidebar divider
	local sideDiv = Instance.new("Frame")
	sideDiv.Size             = UDim2.new(0, 2, 1, -10)
	sideDiv.Position         = UDim2.new(0, 148, 0, 5)
	sideDiv.BackgroundColor3 = T.Border
	sideDiv.BorderSizePixel  = 0
	sideDiv.Parent           = contentArea

	-- Pages
	local pages = Instance.new("Frame")
	pages.BackgroundTransparency = 1
	pages.Size                   = UDim2.new(1, -156, 1, 0)
	pages.Position               = UDim2.new(0, 154, 0, 0)
	pages.Parent                 = contentArea

	local pagePad = Instance.new("UIPadding")
	pagePad.PaddingRight = UDim.new(0, 6)
	pagePad.PaddingTop   = UDim.new(0, 6)
	pagePad.Parent       = pages

	-- BOTTOM BAR
	local bottomBar = Instance.new("Frame")
	bottomBar.Size             = UDim2.new(1, 0, 0, 32)
	bottomBar.Position         = UDim2.new(0, 0, 1, -32)
	bottomBar.BackgroundColor3 = T.Topbar
	bottomBar.BorderSizePixel  = 0
	bottomBar.ZIndex           = 5
	bottomBar.Parent           = main

	local bottomBorder = Instance.new("Frame")
	bottomBorder.Size             = UDim2.new(1, 0, 0, 2)
	bottomBorder.BackgroundColor3 = T.Border
	bottomBorder.BorderSizePixel  = 0
	bottomBorder.ZIndex           = 6
	bottomBorder.Parent           = bottomBar

	local avatarImg = Instance.new("ImageLabel")
	avatarImg.Size             = UDim2.new(0, 22, 0, 22)
	avatarImg.Position         = UDim2.new(0, 8, 0.5, -11)
	avatarImg.BackgroundColor3 = T.Surface
	avatarImg.BorderSizePixel  = 0
	avatarImg.Image            = "https://www.roblox.com/headshot-thumbnail/image?userId=" .. tostring(Player.UserId) .. "&width=48&height=48&format=png"
	avatarImg.ScaleType        = Enum.ScaleType.Crop
	avatarImg.ZIndex           = 6
	avatarImg.Parent           = bottomBar
	addStroke(avatarImg, T.Border, 0, 1)

	local playerNameLbl = Instance.new("TextLabel")
	playerNameLbl.BackgroundTransparency = 1
	playerNameLbl.Size                   = UDim2.new(0, 150, 1, 0)
	playerNameLbl.Position               = UDim2.new(0, 36, 0, 0)
	playerNameLbl.Text                   = Player.DisplayName
	playerNameLbl.Font                   = Enum.Font.GothamBold
	playerNameLbl.TextSize               = 11
	playerNameLbl.TextColor3             = T.SubText
	playerNameLbl.TextXAlignment         = Enum.TextXAlignment.Left
	playerNameLbl.ZIndex                 = 6
	playerNameLbl.Parent                 = bottomBar

	local creditsLbl = Instance.new("TextLabel")
	creditsLbl.BackgroundTransparency = 1
	creditsLbl.Size                   = UDim2.new(0, 200, 1, 0)
	creditsLbl.Position               = UDim2.new(1, -208, 0, 0)
	creditsLbl.Text                   = GrokaUI.Credits
	creditsLbl.Font                   = Enum.Font.Gotham
	creditsLbl.TextSize               = 10
	creditsLbl.TextColor3             = T.SubText
	creditsLbl.TextXAlignment         = Enum.TextXAlignment.Right
	creditsLbl.ZIndex                 = 6
	creditsLbl.Parent                 = bottomBar

	-- WINDOW OBJECT
	local Window       = {}
	local tabButtons   = {}
	local tabPages     = {}
	local activeTabIdx = 0

	local function selectTab(index)
		activeTabIdx = index
		for i, p in ipairs(tabPages) do
			p.Visible = (i == index)
			local tb = tabButtons[i]
			if i == index then
				tween(tb.btn,  { BackgroundColor3 = Color3.fromRGB(255,255,255) }, 0.12):Play()
				tween(tb.name, { TextColor3 = T.Accent }, 0.12):Play()
			else
				tween(tb.btn,  { BackgroundColor3 = T.TabInactive }, 0.12):Play()
				tween(tb.name, { TextColor3 = T.SubText }, 0.12):Play()
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
		button.Size             = UDim2.new(0, 0, 0, 28)
		button.AutomaticSize    = Enum.AutomaticSize.X
		button.BackgroundColor3 = T.TabInactive
		button.Text             = ""
		button.AutoButtonColor  = false
		button.BorderSizePixel  = 0
		button.ZIndex           = 7
		button.Parent           = tabsRow
		addStroke(button, Color3.fromRGB(80, 60, 200), 0.5, 1)

		local btnPad = Instance.new("UIPadding")
		btnPad.PaddingLeft  = UDim.new(0, 10)
		btnPad.PaddingRight = UDim.new(0, 10)
		btnPad.Parent       = button

		local btnInner = Instance.new("Frame")
		btnInner.Size                   = UDim2.new(0, 0, 1, 0)
		btnInner.AutomaticSize          = Enum.AutomaticSize.X
		btnInner.BackgroundTransparency = 1
		btnInner.ZIndex                 = 8
		btnInner.Parent                 = button

		local btnInnerLayout = Instance.new("UIListLayout")
		btnInnerLayout.FillDirection     = Enum.FillDirection.Horizontal
		btnInnerLayout.Padding           = UDim.new(0, 5)
		btnInnerLayout.VerticalAlignment = Enum.VerticalAlignment.Center
		btnInnerLayout.SortOrder         = Enum.SortOrder.LayoutOrder
		btnInnerLayout.Parent            = btnInner

		local tabNumericId = parseAssetId(icon) or parseAssetId(GrokaUI.Icons.Info)
		local tabIcon = Instance.new("ImageLabel")
		tabIcon.Size                   = UDim2.new(0, 14, 0, 14)
		tabIcon.BackgroundTransparency = 1
		tabIcon.Image                  = "rbxassetid://" .. tabNumericId
		tabIcon.ImageColor3            = Color3.new(1,1,1)
		tabIcon.ScaleType              = Enum.ScaleType.Fit
		tabIcon.ZIndex                 = 9
		tabIcon.Parent                 = btnInner

		local tabName = Instance.new("TextLabel")
		tabName.BackgroundTransparency = 1
		tabName.Size                   = UDim2.new(0, 0, 1, 0)
		tabName.AutomaticSize          = Enum.AutomaticSize.X
		tabName.Text                   = name
		tabName.Font                   = Enum.Font.GothamBold
		tabName.TextSize               = 11
		tabName.TextColor3             = Color3.new(1,1,1)
		tabName.ZIndex                 = 9
		tabName.Parent                 = btnInner

		local tabIndex = #tabPages + 1
		table.insert(tabButtons, { btn = button, name = tabName, icon = tabIcon })

		button.MouseEnter:Connect(function()
			if tabIndex ~= activeTabIdx then
				tween(button, { BackgroundColor3 = Color3.fromRGB(80, 110, 220) }, 0.1):Play()
			end
		end)
		button.MouseLeave:Connect(function()
			if tabIndex ~= activeTabIdx then
				tween(button, { BackgroundColor3 = T.TabInactive }, 0.1):Play()
			end
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
		layout.Padding = UDim.new(0, 8)
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

		-- Classic square card (white block with stud pattern)
		local function makeCard(h)
			local card = Instance.new("Frame")
			card.Size             = UDim2.new(1, -2, 0, h or 50)
			card.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			card.BorderSizePixel  = 0
			card.ClipsDescendants = true
			card.Parent           = page
			addStroke(card, T.Border, 0.2, 2)
			-- subtle stud dots in card background
			addStudPattern(card, {
				StudTop  = Color3.fromRGB(238, 238, 238),
				StudSide = Color3.fromRGB(210, 210, 210),
			}, 18, math.ceil(h / 18), 5, 14)
			return card
		end

		local function makeLabel(parent, text, x, y, size, bold, color)
			local lbl = Instance.new("TextLabel")
			lbl.BackgroundTransparency = 1
			lbl.Position               = UDim2.new(0, x or 12, 0, y or 0)
			lbl.Size                   = UDim2.new(1, -20, 0, 20)
			lbl.Text                   = tostring(text)
			lbl.Font                   = bold and Enum.Font.GothamBold or Enum.Font.Gotham
			lbl.TextColor3             = color or T.Text
			lbl.TextSize               = size or 13
			lbl.TextXAlignment         = Enum.TextXAlignment.Left
			lbl.ZIndex                 = 3
			lbl.Parent                 = parent
			return lbl
		end

		-- SECTION: title label + white block with stud background
		function Elements:AddSection(text)
			-- Section title row
			local titleHolder = Instance.new("Frame")
			titleHolder.Size                   = UDim2.new(1, -2, 0, 24)
			titleHolder.BackgroundColor3       = T.Accent
			titleHolder.BorderSizePixel        = 0
			titleHolder.Parent                 = page
			addStroke(titleHolder, T.AccentDark, 0, 2)

			local titleLbl = Instance.new("TextLabel")
			titleLbl.BackgroundTransparency = 1
			titleLbl.Size                   = UDim2.new(1, -16, 1, 0)
			titleLbl.Position               = UDim2.new(0, 10, 0, 0)
			titleLbl.Text                   = text
			titleLbl.Font                   = Enum.Font.GothamBold
			titleLbl.TextSize               = 11
			titleLbl.TextColor3             = Color3.new(1, 1, 1)
			titleLbl.TextXAlignment         = Enum.TextXAlignment.Left
			titleLbl.ZIndex                 = 4
			titleLbl.Parent                 = titleHolder
		end

		-- AddButton
		function Elements:AddButton(text, iconOrDesc, descOrCallback, callbackOrNil)
			local btnIcon, desc, callback
			if type(iconOrDesc) == "string" and (iconOrDesc:find("rbxassetid://") or iconOrDesc:match("^%d+$")) then
				btnIcon  = iconOrDesc
				desc     = type(descOrCallback) == "string" and descOrCallback or nil
				callback = type(descOrCallback) == "function" and descOrCallback or callbackOrNil
			else
				btnIcon  = nil
				desc     = type(iconOrDesc) == "string" and iconOrDesc or nil
				callback = type(iconOrDesc) == "function" and iconOrDesc or (type(descOrCallback) == "function" and descOrCallback or callbackOrNil)
			end

			local h    = desc and 60 or 44
			local card = makeCard(h)

			local textOffsetX = 12
			if btnIcon then
				local numId = parseAssetId(btnIcon)
				if numId then
					local iconLbl = Instance.new("ImageLabel")
					iconLbl.Size                   = UDim2.new(0, 16, 0, 16)
					iconLbl.Position               = desc and UDim2.new(0, 12, 0, 14) or UDim2.new(0, 12, 0.5, -8)
					iconLbl.BackgroundTransparency = 1
					iconLbl.Image                  = "rbxassetid://" .. numId
					iconLbl.ImageColor3            = T.Accent
					iconLbl.ScaleType              = Enum.ScaleType.Fit
					iconLbl.ZIndex                 = 4
					iconLbl.Parent                 = card
					textOffsetX = 34
				end
			end

			makeLabel(card, text, textOffsetX, desc and 10 or 12, 13, true, T.Text)
			if desc then makeLabel(card, desc, textOffsetX, 28, 11, false, T.SubText) end

			-- Classic square action arrow
			local actionHint = Instance.new("TextLabel")
			actionHint.BackgroundTransparency = 1
			actionHint.Size                   = UDim2.new(0, 20, 0, 20)
			actionHint.Position               = UDim2.new(1, -28, 0.5, -10)
			actionHint.Text                   = "›"
			actionHint.Font                   = Enum.Font.GothamBold
			actionHint.TextSize               = 16
			actionHint.TextColor3             = T.Border
			actionHint.ZIndex                 = 4
			actionHint.Parent                 = card

			local btn = Instance.new("TextButton")
			btn.BackgroundTransparency = 1
			btn.Size                   = UDim2.new(1, 0, 1, 0)
			btn.Text                   = ""
			btn.ZIndex                 = 5
			btn.Parent                 = card
			addRipple(btn, T.Accent)
			btn.MouseEnter:Connect(function()
				tween(card,       { BackgroundColor3 = Color3.fromRGB(240, 245, 255) }, 0.1):Play()
				tween(actionHint, { TextColor3 = T.Accent }, 0.1):Play()
			end)
			btn.MouseLeave:Connect(function()
				tween(card,       { BackgroundColor3 = Color3.fromRGB(255, 255, 255) }, 0.1):Play()
				tween(actionHint, { TextColor3 = T.Border }, 0.1):Play()
			end)
			btn.MouseButton1Click:Connect(function() if callback then callback() end end)
		end

		function Elements:AddToggle(text, desc, default, callback)
			local state = default or false
			local card  = makeCard(desc and 60 or 44)
			makeLabel(card, text, 12, desc and 9 or 12, 13, true, T.Text)
			if desc then makeLabel(card, desc, 12, 27, 11, false, T.SubText) end

			-- Square toggle (classic style)
			local trackOuter = Instance.new("Frame")
			trackOuter.Size             = UDim2.new(0, 44, 0, 22)
			trackOuter.Position         = UDim2.new(1, -56, 0.5, -11)
			trackOuter.BackgroundColor3 = state and T.Success or T.Track
			trackOuter.BorderSizePixel  = 0
			trackOuter.ZIndex           = 4
			trackOuter.Parent           = card
			addStroke(trackOuter, T.Border, 0.2, 2)

			local knob = Instance.new("Frame")
			knob.Size             = UDim2.new(0, 18, 0, 18)
			knob.Position         = state and UDim2.new(1,-20,0.5,-9) or UDim2.new(0,2,0.5,-9)
			knob.BackgroundColor3 = Color3.new(1,1,1)
			knob.BorderSizePixel  = 0
			knob.ZIndex           = 5
			knob.Parent           = trackOuter
			addStroke(knob, T.Border, 0.3, 1)

			local btn = Instance.new("TextButton")
			btn.BackgroundTransparency = 1
			btn.Size                   = UDim2.new(1, 0, 1, 0)
			btn.Text                   = ""
			btn.ZIndex                 = 6
			btn.Parent                 = card
			local function applyState()
				tween(trackOuter, { BackgroundColor3 = state and T.Success or T.Track }, 0.15):Play()
				tween(knob, { Position = state and UDim2.new(1,-20,0.5,-9) or UDim2.new(0,2,0.5,-9) }, 0.15):Play()
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
			local card  = makeCard(38)
			local label = makeLabel(card, text, 12, 9, 12, false, T.Text)
			local Label = {}
			function Label:Set(t) label.Text = tostring(t) end
			return Label
		end

		function Elements:AddParagraph(title, text)
			local card = makeCard(80)
			makeLabel(card, title, 12, 10, 13, true, T.Text)
			local body = makeLabel(card, text, 12, 30, 11, false, T.SubText)
			body.TextWrapped = true
			body.Size        = UDim2.new(1, -24, 0, 44)
		end

		function Elements:AddSlider(text, min, max, default, callback)
			local value = math.clamp(default or min, min, max)
			local range = max - min
			local card  = makeCard(68)
			makeLabel(card, text, 12, 10, 13, true, T.Text)

			local valueBg = Instance.new("Frame")
			valueBg.Size             = UDim2.new(0, 40, 0, 20)
			valueBg.Position         = UDim2.new(1, -50, 0, 8)
			valueBg.BackgroundColor3 = T.Input
			valueBg.BorderSizePixel  = 0
			valueBg.ZIndex           = 4
			valueBg.Parent           = card
			addStroke(valueBg, T.Border, 0.2, 1)

			local valueLbl = Instance.new("TextLabel")
			valueLbl.BackgroundTransparency = 1
			valueLbl.Size                   = UDim2.new(1, 0, 1, 0)
			valueLbl.Text                   = tostring(value)
			valueLbl.Font                   = Enum.Font.GothamBold
			valueLbl.TextColor3             = T.Accent
			valueLbl.TextSize               = 11
			valueLbl.ZIndex                 = 5
			valueLbl.Parent                 = valueBg

			local bar = Instance.new("Frame")
			bar.Size             = UDim2.new(1, -24, 0, 8)
			bar.Position         = UDim2.new(0, 12, 0, 44)
			bar.BackgroundColor3 = T.Track
			bar.BorderSizePixel  = 0
			bar.ZIndex           = 4
			bar.Parent           = card
			addStroke(bar, T.Border, 0.3, 1)

			local fill = Instance.new("Frame")
			fill.Size             = UDim2.new((value - min) / range, 0, 1, 0)
			fill.BackgroundColor3 = T.Accent
			fill.BorderSizePixel  = 0
			fill.ZIndex           = 5
			fill.Parent           = bar

			local thumb = Instance.new("Frame")
			thumb.Size             = UDim2.new(0, 14, 0, 14)
			thumb.AnchorPoint      = Vector2.new(0.5, 0.5)
			thumb.Position         = UDim2.new((value - min) / range, 0, 0.5, 0)
			thumb.BackgroundColor3 = Color3.new(1,1,1)
			thumb.BorderSizePixel  = 0
			thumb.ZIndex           = 6
			thumb.Parent           = bar
			addStroke(thumb, T.Accent, 0, 2)

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
			local card = makeCard(64)
			makeLabel(card, text, 12, 8, 13, true, T.Text)
			local box = Instance.new("TextBox")
			box.Size              = UDim2.new(1, -24, 0, 28)
			box.Position          = UDim2.new(0, 12, 0, 30)
			box.BackgroundColor3  = T.Input
			box.BorderSizePixel   = 0
			box.PlaceholderText   = placeholder or "Type..."
			box.Text              = ""
			box.ClearTextOnFocus  = false
			box.TextColor3        = T.Text
			box.PlaceholderColor3 = T.SubText
			box.Font              = Enum.Font.Gotham
			box.TextSize          = 12
			box.ZIndex            = 4
			box.Parent            = card
			local boxStroke = addStroke(box, T.Border, 0.2, 2)
			pcall(function()
				box.Focused:Connect(function()
					tween(boxStroke, { Color = T.Accent, Transparency = 0 }, 0.12):Play()
				end)
			end)
			box.FocusLost:Connect(function()
				tween(boxStroke, { Color = T.Border, Transparency = 0.2 }, 0.12):Play()
				if callback then callback(box.Text) end
			end)
		end

		function Elements:AddDropdown(text, options, callback)
			local current    = options[1] or "Select"
			local open       = false
			local collapsedH = 48
			local optionH    = 34
			local optionGap  = 4
			local headerH    = 48
			local function getOpenHeight()
				return headerH + 6 + (#options * (optionH + optionGap))
			end
			local card = makeCard(collapsedH)
			card.ClipsDescendants = false
			makeLabel(card, text, 12, 14, 13, true, T.Text)

			local selectedLbl = Instance.new("TextLabel")
			selectedLbl.BackgroundTransparency = 1
			selectedLbl.Size                   = UDim2.new(0, 130, 0, 18)
			selectedLbl.Position               = UDim2.new(1, -158, 0, 15)
			selectedLbl.Text                   = current
			selectedLbl.Font                   = Enum.Font.Gotham
			selectedLbl.TextSize               = 11
			selectedLbl.TextColor3             = T.SubText
			selectedLbl.TextXAlignment         = Enum.TextXAlignment.Right
			selectedLbl.ZIndex                 = 4
			selectedLbl.Parent                 = card

			local arrow = Instance.new("TextLabel")
			arrow.BackgroundTransparency = 1
			arrow.Size                   = UDim2.new(0, 18, 0, 18)
			arrow.Position               = UDim2.new(1, -24, 0, 15)
			arrow.Text                   = "▾"
			arrow.Font                   = Enum.Font.GothamBold
			arrow.TextSize               = 11
			arrow.TextColor3             = T.Accent
			arrow.ZIndex                 = 4
			arrow.Parent                 = card

			local holder = Instance.new("Frame")
			holder.BackgroundTransparency = 1
			holder.Position               = UDim2.new(0, 8, 0, headerH)
			holder.Size                   = UDim2.new(1, -16, 0, #options * (optionH + optionGap))
			holder.Visible                = false
			holder.ZIndex                 = 10
			holder.Parent                 = card

			local optLayout = Instance.new("UIListLayout")
			optLayout.Padding = UDim.new(0, optionGap)
			optLayout.Parent  = holder

			local optButtons = {}
			local function refreshOptions()
				for _, entry in ipairs(optButtons) do
					local isSel = entry.value == current
					entry.btn.BackgroundColor3 = isSel and Color3.fromRGB(220,230,255) or T.Input
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
				ob.TextSize         = 12
				ob.BorderSizePixel  = 0
				ob.AutoButtonColor  = false
				ob.ZIndex           = 11
				ob.Parent           = holder
				addStroke(ob, T.Border, 0.2, 1)
				ob.MouseEnter:Connect(function()
					if current ~= tostring(opt) then
						tween(ob, { BackgroundColor3 = Color3.fromRGB(230,235,255), TextColor3 = T.Text }, 0.1):Play()
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
			toggleBtn.ZIndex                 = 5
			toggleBtn.Parent                 = card
			setOpen = function(state)
				open                = state
				holder.Visible      = open
				selectedLbl.Visible = not open
				arrow.Text          = open and "▴" or "▾"
				tween(card, { Size = UDim2.new(1, -2, 0, open and getOpenHeight() or collapsedH) }, 0.18):Play()
			end
			toggleBtn.MouseButton1Click:Connect(function() setOpen(not open) end)
		end

		function Elements:AddKeybind(text, default, callback)
			local key     = default or Enum.KeyCode.RightShift
			local card    = makeCard(44)
			local waiting = false
			makeLabel(card, text, 12, 12, 13, true, T.Text)
			local bindBtn = Instance.new("TextButton")
			bindBtn.Size             = UDim2.new(0, 90, 0, 24)
			bindBtn.Position         = UDim2.new(1, -100, 0.5, -12)
			bindBtn.BackgroundColor3 = T.Input
			bindBtn.Text             = key.Name
			bindBtn.Font             = Enum.Font.GothamBold
			bindBtn.TextColor3       = T.Accent
			bindBtn.TextSize         = 11
			bindBtn.BorderSizePixel  = 0
			bindBtn.AutoButtonColor  = false
			bindBtn.ZIndex           = 4
			bindBtn.Parent           = card
			local bindStroke = addStroke(bindBtn, T.Border, 0.2, 2)
			bindBtn.MouseEnter:Connect(function() tween(bindBtn, { BackgroundColor3 = Color3.fromRGB(230,235,255) }, 0.1):Play() end)
			bindBtn.MouseLeave:Connect(function()
				if not waiting then tween(bindBtn, { BackgroundColor3 = T.Input }, 0.1):Play() end
			end)
			bindBtn.MouseButton1Click:Connect(function()
				if waiting then return end
				waiting      = true
				bindBtn.Text = "..."
				tween(bindStroke, { Color = T.Accent, Transparency = 0 }, 0.1):Play()
				local c
				c = UIS.InputBegan:Connect(function(input, gp)
					if gp then return end
					if input.UserInputType == Enum.UserInputType.Keyboard then
						key          = input.KeyCode
						bindBtn.Text = key.Name
						waiting      = false
						tween(bindStroke, { Color = T.Border, Transparency = 0.2 }, 0.1):Play()
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

		--// ============================
		--//  ADD KEY
		--// ============================
		--[[
		    Usage:
		    GrokaUI:AddKey(
		        Title
		        Your Key
		        Description
		        Copy Link button URL
		        Enter Key button text
		    )
		    
		    Example:
		    GrokaUI:AddKey(
		        "Game Pass Key",
		        "GRK-XXXX-XXXX-XXXX",
		        "Enter your key to unlock premium features.",
		        "https://example.com/getkey",
		        "Activate Key"
		    )
		]]
		function Elements:AddKey(keyTitle, keyValue, keyDesc, copyLinkUrl, enterKeyText)
			local cardH = 120
			local card  = makeCard(cardH)

			-- Title
			local titleLbl = Instance.new("TextLabel")
			titleLbl.BackgroundTransparency = 1
			titleLbl.Size                   = UDim2.new(1, -16, 0, 20)
			titleLbl.Position               = UDim2.new(0, 12, 0, 8)
			titleLbl.Text                   = keyTitle or "Key"
			titleLbl.Font                   = Enum.Font.GothamBold
			titleLbl.TextSize               = 13
			titleLbl.TextColor3             = T.Text
			titleLbl.TextXAlignment         = Enum.TextXAlignment.Left
			titleLbl.ZIndex                 = 4
			titleLbl.Parent                 = card

			-- Description
			local descLbl = Instance.new("TextLabel")
			descLbl.BackgroundTransparency = 1
			descLbl.Size                   = UDim2.new(1, -16, 0, 16)
			descLbl.Position               = UDim2.new(0, 12, 0, 28)
			descLbl.Text                   = keyDesc or ""
			descLbl.Font                   = Enum.Font.Gotham
			descLbl.TextSize               = 11
			descLbl.TextColor3             = T.SubText
			descLbl.TextXAlignment         = Enum.TextXAlignment.Left
			descLbl.ZIndex                 = 4
			descLbl.Parent                 = card

			-- Key input box
			local keyBox = Instance.new("TextBox")
			keyBox.Size              = UDim2.new(1, -24, 0, 26)
			keyBox.Position          = UDim2.new(0, 12, 0, 50)
			keyBox.BackgroundColor3  = T.Input
			keyBox.BorderSizePixel   = 0
			keyBox.PlaceholderText   = "Enter key..."
			keyBox.Text              = keyValue or ""
			keyBox.ClearTextOnFocus  = false
			keyBox.TextColor3        = T.Text
			keyBox.PlaceholderColor3 = T.SubText
			keyBox.Font              = Enum.Font.GothamBold
			keyBox.TextSize          = 12
			keyBox.ZIndex            = 4
			keyBox.Parent            = card
			local keyStroke = addStroke(keyBox, T.Border, 0.2, 2)
			pcall(function()
				keyBox.Focused:Connect(function()
					tween(keyStroke, { Color = T.Accent, Transparency = 0 }, 0.1):Play()
				end)
				keyBox.FocusLost:Connect(function()
					tween(keyStroke, { Color = T.Border, Transparency = 0.2 }, 0.1):Play()
				end)
			end)

			-- Buttons row
			local btnRow = Instance.new("Frame")
			btnRow.Size                   = UDim2.new(1, -24, 0, 26)
			btnRow.Position               = UDim2.new(0, 12, 0, 84)
			btnRow.BackgroundTransparency = 1
			btnRow.ZIndex                 = 4
			btnRow.Parent                 = card

			local btnLayout = Instance.new("UIListLayout")
			btnLayout.FillDirection = Enum.FillDirection.Horizontal
			btnLayout.Padding       = UDim.new(0, 8)
			btnLayout.Parent        = btnRow

			-- Copy Link button
			local copyBtn = Instance.new("TextButton")
			copyBtn.Size             = UDim2.new(0, 120, 1, 0)
			copyBtn.BackgroundColor3 = T.Surface
			copyBtn.BorderSizePixel  = 0
			copyBtn.Text             = "📋 Copy Link"
			copyBtn.Font             = Enum.Font.GothamBold
			copyBtn.TextColor3       = T.Accent
			copyBtn.TextSize         = 11
			copyBtn.AutoButtonColor  = false
			copyBtn.ZIndex           = 5
			copyBtn.Parent           = btnRow
			addStroke(copyBtn, T.Accent, 0.2, 2)
			copyBtn.MouseEnter:Connect(function()
				tween(copyBtn, { BackgroundColor3 = Color3.fromRGB(220,230,255) }, 0.1):Play()
			end)
			copyBtn.MouseLeave:Connect(function()
				tween(copyBtn, { BackgroundColor3 = T.Surface }, 0.1):Play()
			end)
			copyBtn.MouseButton1Click:Connect(function()
				if copyLinkUrl then
					-- On Roblox, setclipboard may not work everywhere; use pcall
					pcall(function() setclipboard(tostring(copyLinkUrl)) end)
					GrokaUI:Notify("Copied!", "Key link copied to clipboard.", 2, "success")
				end
			end)

			-- Enter Key button
			local enterBtn = Instance.new("TextButton")
			enterBtn.Size             = UDim2.new(0, 120, 1, 0)
			enterBtn.BackgroundColor3 = T.Accent
			enterBtn.BorderSizePixel  = 0
			enterBtn.Text             = enterKeyText or "Enter Key"
			enterBtn.Font             = Enum.Font.GothamBold
			enterBtn.TextColor3       = Color3.new(1,1,1)
			enterBtn.TextSize         = 11
			enterBtn.AutoButtonColor  = false
			enterBtn.ZIndex           = 5
			enterBtn.Parent           = btnRow
			addStroke(enterBtn, T.AccentDark, 0.2, 2)
			enterBtn.MouseEnter:Connect(function()
				tween(enterBtn, { BackgroundColor3 = T.AccentDark }, 0.1):Play()
			end)
			enterBtn.MouseLeave:Connect(function()
				tween(enterBtn, { BackgroundColor3 = T.Accent }, 0.1):Play()
			end)
			enterBtn.MouseButton1Click:Connect(function()
				local enteredKey = keyBox.Text
				GrokaUI:Notify("Key Submitted", "Key: " .. tostring(enteredKey), 3, "info")
			end)
		end

		return Elements
	end -- CreateTab

	return Window
end -- CreateWindow

return GrokaUI
