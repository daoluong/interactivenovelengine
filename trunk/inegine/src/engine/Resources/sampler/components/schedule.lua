-- schedule UI component implemented in lua
require "Resources\\sampler\\components\\tabview"
require "Resources\\sampler\\components\\flowview"

ScheduleView = {}

function ScheduleView:New (name, font, parent)
	local o = {}
	setmetatable(o, self)
	self.__index = self
	
	o.parent = parent;
	o.name = name
	o.font = font;
	
	o:Init();
	
	return o
end

function ScheduleView:Init()
	local gamestate = CurrentState();
	local parent = self.parent;
	local font = self.font; 
	local name = self.name;
	
	self.frame = View()
	self.frame.Name = name
	
	self.frame.X = 0;
	self.frame.Y = 0;
	self.frame.Width = GetWidth();
	self.frame.Height = GetHeight();
	self.frame.alpha = 155
	self.frame.layer = 3
	
	self.frame.Visible = false
	self.frame.Enabled = false
	self.frame.MouseLeave =
		function(target, event, args)
			Trace("mouse leave: " .. target.Name)	
		end
	
	parent:AddComponent(self.frame)
	
	local tabviewframe = TextWindow()
	self.tabviewframe = tabviewframe;
	self.tabviewframe.Name = "tabviewframe"
	
	self.tabviewframe.X = 10;
	self.tabviewframe.Y = 300;
	self.tabviewframe.Width = 400
	self.tabviewframe.Height = 290
	self.tabviewframe.alpha = 155
	self.tabviewframe.layer = 3
	
	self.frame:AddComponent(self.tabviewframe)
	
	
	local tabView = Tabview:New("tabView", GetFont("default"));
	tabView.frame.relative = true
	tabView.frame.X = 0;
	tabView.frame.Y = 0;
	tabView.frame.Width = self.tabviewframe.Width;
	tabView.frame.Height = self.tabviewframe.Height - 50;
	tabView.frame.layer = 5;
	tabviewframe:AddComponent(tabView.frame);
	tabView:Show();
	
	
	local background = TextWindow()
	background.name = "backround"
	background.relative = true;
	background.width = self.tabviewframe.width - 10;
	background.height = self.tabviewframe.height - 50 - 50;
	background.x = 5;
	background.y = 50;
	background.alpha = 155
	background.layer = 4;
	tabviewframe:AddComponent(background);
		
	local educationView = Flowview:New("educationview")
	educationView.frame.relative = true;
	educationView.frame.width = tabView.frame.width - 10;
	educationView.frame.height = tabView.frame.height - 50 - 50;
	educationView.frame.x = 5;
	educationView.frame.y = 50;
	educationView.frame.layer = 10;
	educationView.spacing = 5;
	educationView.padding = 10;
	educationView.frame.visible = true;
	educationView.frame.enabled = true;
	self.educationView = educationView;
	tabView:AddTab("education", educationView.frame);
	
	local workView = Flowview:New("workview")
	workView.frame.relative = true;
	workView.frame.width = tabView.frame.width - 10;
	workView.frame.height = tabView.frame.height - 50 - 50;
	workView.frame.x = 5;
	workView.frame.y = 50;
	workView.frame.alpha = 155
	workView.frame.layer = 4;
	workView.spacing = 5;
	workView.padding = 10;
	workView.frame.visible = false;
	workView.frame.enabled = false;
	self.workView = workView;
	tabView:AddTab("work", workView.frame);
	
	local vacationView = Flowview:New("vacationview");
	vacationView.frame.relative = true;
	vacationView.frame.width = tabView.frame.width - 10;
	vacationView.frame.height = tabView.frame.height - 50 - 50;
	vacationView.frame.x = 5;
	vacationView.frame.y = 50;
	vacationView.frame.alpha = 155
	vacationView.frame.layer = 4;	
	vacationView.spacing = 5;
	vacationView.padding = 10;
	vacationView.frame.visible = false;
	vacationView.frame.enabled = false;
	self.vacationView = vacationView;
	tabView:AddTab("vacation", vacationView.frame);

	local repeatButton = Button()
	repeatButton.Relative = true;
	repeatButton.Name = "repeatButton"
	repeatButton.Texture = "Resources/sampler/resources/button.png"	
	repeatButton.Layer = 4;
	repeatButton.X = tabviewframe.width - 125;
	repeatButton.Y = tabviewframe.height - 45;
	repeatButton.Width = 120;
	repeatButton.Height = 40;
	repeatButton.State = {}
	repeatButton.MouseDown = 
		function (repeatButton, luaevent, args)
			repeatButton.State["mouseDown"] = true
			repeatButton.Pushed = true
		end
	repeatButton.MouseUp = 
		function (repeatButton, luaevent, args)
			if (repeatButton.State["mouseDown"]) then
				repeatButton.Pushed = false
				Trace("repeatButton click!")
			end
		end
	repeatButton.Text = "Repeat";
	repeatButton.Font = font
	repeatButton.TextColor = 0xEEEEEE
	
	self.repeatButton = repeatButton;
	tabviewframe:AddComponent(repeatButton);
	
	local selectionframe = TextWindow()
	self.selectionframe = selectionframe;
	selectionframe.Name = "selectionframe"
	
	selectionframe.X = 415;
	selectionframe.Y = 200;
	selectionframe.Width = 380
	selectionframe.Height = 230
	selectionframe.alpha = 155
	selectionframe.layer = 3
	
	self.frame:AddComponent(selectionframe)
	
	local closeButton = Button()
	closeButton.Relative = true;
	closeButton.Name = "closeButton"
	closeButton.Texture = "Resources/sampler/resources/button.png"	
	closeButton.Layer = 4;
	closeButton.X = 5;
	closeButton.Y = selectionframe.height - 45;
	closeButton.Width = 120;
	closeButton.Height = 40;
	closeButton.State = {}
	closeButton.MouseDown = 
		function (closeButton, luaevent, args)
			closeButton.State["mouseDown"] = true
			closeButton.Pushed = true
		end
	closeButton.MouseUp = 
		function (closeButton, luaevent, args)
			if (closeButton.State["mouseDown"]) then
				closeButton.Pushed = false
				Trace("closeButton click!")
			end
		end
	closeButton.Text = "Cancel";
	closeButton.Font = font
	closeButton.TextColor = 0xEEEEEE
	
	self.closebutton = closeButton;
	selectionframe:AddComponent(closeButton);
	
	
	local deleteButton = Button()
	deleteButton.Relative = true;
	deleteButton.Name = "deleteButton"
	deleteButton.Texture = "Resources/sampler/resources/button.png"	
	deleteButton.Layer = 4;
	deleteButton.X = 130;
	deleteButton.Y = selectionframe.height - 45;
	deleteButton.Width = 120;
	deleteButton.Height = 40;
	deleteButton.State = {}
	deleteButton.MouseDown = 
		function (deleteButton, luaevent, args)
			deleteButton.State["mouseDown"] = true
			deleteButton.Pushed = true
		end
	deleteButton.MouseUp = 
		function (deleteButton, luaevent, args)
			if (deleteButton.State["mouseDown"]) then
				deleteButton.Pushed = false
				Trace("deleteButton click!")
			end
		end
	deleteButton.Text = "Delete";
	deleteButton.Font = font
	deleteButton.TextColor = 0xEEEEEE
	
	self.deleteButton = deleteButton;
	selectionframe:AddComponent(deleteButton);
	
	local executeButton = Button()
	executeButton.Relative = true;
	executeButton.Name = "executeButton"
	executeButton.Texture = "Resources/sampler/resources/button.png"	
	executeButton.Layer = 4;
	executeButton.X = 255;
	executeButton.Y = selectionframe.height - 45;
	executeButton.Width = 120;
	executeButton.Height = 40;
	executeButton.State = {}
	executeButton.MouseDown = 
		function (executeButton, luaevent, args)
			executeButton.State["mouseDown"] = true
			executeButton.Pushed = true
		end
	executeButton.MouseUp = 
		function (executeButton, luaevent, args)
			if (executeButton.State["mouseDown"]) then
				executeButton.Pushed = false
				Trace("executeButton click!")
			end
		end
	executeButton.Text = "Run";
	executeButton.Font = font
	executeButton.TextColor = 0xEEEEEE
	
	self.executeButton = executeButton;
	selectionframe:AddComponent(executeButton);
	
	
	local detailviewframe = TextWindow()
	self.detailviewframe = detailviewframe;
	detailviewframe.Name = "detailviewframe"
	
	detailviewframe.X = 415;
	detailviewframe.Y = 440;
	detailviewframe.Width = 380
	detailviewframe.Height = 150
	detailviewframe.alpha = 155
	detailviewframe.layer = 3
	
	self.frame:AddComponent(detailviewframe)
	
	
	
	
	self:AddTestEducationItems();
end

function ScheduleView:SetClosingEvent(event)
	self.closebutton.MouseUp = event;
end

function ScheduleView:Dispose()
	self.parent:RemoveComponent(self.name)
end

function ScheduleView:Show()
	Trace("showing schedule!")
	self.frame.Visible = true
	self.frame.Enabled = true
end


function ScheduleView:Hide()
	self.frame.Visible = false
	self.frame.Enabled = false
end


function ScheduleView:AddTestEducationItems()
	local educationView = self.educationView;
	local testButton = Button()
	
	Trace("adding test items to : " .. educationView.frame.Name);
	
	testButton.Relative = true;
	testButton.Name = "testButton"
	testButton.Texture = "Resources/sampler/resources/button.png"	
	testButton.Layer = 3
	testButton.X = 0;
	testButton.Y = 0;
	testButton.Width = 120;
	testButton.Height = 40;
	testButton.State = {}
	testButton.MouseDown = 
		function (testButton, luaevent, args)
			testButton.State["mouseDown"] = true
			testButton.Pushed = true
		end
	testButton.MouseUp = 
		function (testButton, luaevent, args)
			if (testButton.State["mouseDown"]) then
				testButton.Pushed = false
				Trace("dress 1")
				-- todo : connect to character controller insetead of main view
				main:SetTachieBody("Resources/sampler/images/1.png");
			end
		end
	testButton.Text = "Dress 1";
	testButton.Font = GetFont("menu"); --menuFont
	testButton.TextColor = 0xEEEEEE
	
	educationView:Add(testButton);
	
	
	testButton = Button()
	testButton.Relative = true;
	testButton.Name = "testButton2"
	testButton.Texture = "Resources/sampler/resources/button.png"	
	testButton.Layer = 3
	testButton.X = 0;
	testButton.Y = 0;
	testButton.Width = 120;
	testButton.Height = 40;
	testButton.State = {}
	testButton.MouseDown = 
		function (testButton, luaevent, args)
			testButton.State["mouseDown"] = true
			testButton.Pushed = true
		end
	testButton.MouseUp = 
		function (testButton, luaevent, args)
			if (testButton.State["mouseDown"]) then
				testButton.Pushed = false
				Trace("dress 2")
				-- todo : connect to character controller insetead of main view
				main:SetTachieBody("Resources/sampler/images/2.png");
			end
		end
	testButton.Text = "Dress 2";
	testButton.Font = GetFont("menu"); --menuFont
	testButton.TextColor = 0xEEEEEE
	
	educationView:Add(testButton);
	
	
	
	testButton = Button()
	testButton.Relative = true;
	testButton.Name = "testButton3"
	testButton.Texture = "Resources/sampler/resources/button.png"	
	testButton.Layer = 3
	testButton.X = 0;
	testButton.Y = 0;
	testButton.Width = 120;
	testButton.Height = 40;
	testButton.State = {}
	testButton.MouseDown = 
		function (testButton, luaevent, args)
			testButton.State["mouseDown"] = true
			testButton.Pushed = true
		end
	testButton.MouseUp = 
		function (testButton, luaevent, args)
			if (testButton.State["mouseDown"]) then
				testButton.Pushed = false
				Trace("Dress 3!");
			
				-- todo : connect to character controller insetead of main view
				main:SetTachieBody("Resources/sampler/images/3.png");
			end
		end
	testButton.Text = "Dress 3";
	testButton.Font = GetFont("menu"); --menuFont
	testButton.TextColor = 0xEEEEEE
	
	educationView:Add(testButton);
	
		
	testButton = Button()
	testButton.Relative = true;
	testButton.Name = "testButton4"
	testButton.Texture = "Resources/sampler/resources/button.png"	
	testButton.Layer = 3
	testButton.X = 0;
	testButton.Y = 0;
	testButton.Width = 120;
	testButton.Height = 40;
	testButton.State = {}
	testButton.MouseDown = 
		function (testButton, luaevent, args)
			testButton.State["mouseDown"] = true
			testButton.Pushed = true
		end
	testButton.MouseUp = 
		function (testButton, luaevent, args)
			if (testButton.State["mouseDown"]) then
				testButton.Pushed = false
				Trace("testButton click!")
			end
		end
	testButton.Text = "Dummy";
	testButton.Font = GetFont("menu"); --menuFont
	testButton.TextColor = 0xEEEEEE
	
	educationView:Add(testButton);
	
		testButton = Button()
	testButton.Relative = true;
	testButton.Name = "testButton5"
	testButton.Texture = "Resources/sampler/resources/button.png"	
	testButton.Layer = 3
	testButton.X = 0;
	testButton.Y = 0;
	testButton.Width = 120;
	testButton.Height = 40;
	testButton.State = {}
	testButton.MouseDown = 
		function (testButton, luaevent, args)
			testButton.State["mouseDown"] = true
			testButton.Pushed = true
		end
	testButton.MouseUp = 
		function (testButton, luaevent, args)
			if (testButton.State["mouseDown"]) then
				testButton.Pushed = false
				Trace("testButton click!")
			end
		end
	testButton.Text = "Dummy";
	testButton.Font = GetFont("menu"); --menuFont
	testButton.TextColor = 0xEEEEEE
	
	educationView:Add(testButton);
	
		testButton = Button()
	testButton.Relative = true;
	testButton.Name = "testButton6"
	testButton.Texture = "Resources/sampler/resources/button.png"	
	testButton.Layer = 3
	testButton.X = 0;
	testButton.Y = 0;
	testButton.Width = 120;
	testButton.Height = 40;
	testButton.State = {}
	testButton.MouseDown = 
		function (testButton, luaevent, args)
			testButton.State["mouseDown"] = true
			testButton.Pushed = true
		end
	testButton.MouseUp = 
		function (testButton, luaevent, args)
			if (testButton.State["mouseDown"]) then
				testButton.Pushed = false
				Trace("testButton click!")
			end
		end
	testButton.Text = "Dummy";
	testButton.Font = GetFont("menu"); --menuFont
	testButton.TextColor = 0xEEEEEE
	
	educationView:Add(testButton);
	
	testButton = Button()
	testButton.Relative = true;
	testButton.Name = "testButton7"
	testButton.Texture = "Resources/sampler/resources/button.png"	
	testButton.Layer = 3
	testButton.X = 0;
	testButton.Y = 0;
	testButton.Width = 120;
	testButton.Height = 40;
	testButton.State = {}
	testButton.MouseDown = 
		function (testButton, luaevent, args)
			testButton.State["mouseDown"] = true
			testButton.Pushed = true
		end
	testButton.MouseUp = 
		function (testButton, luaevent, args)
			if (testButton.State["mouseDown"]) then
				testButton.Pushed = false
				Trace("testButton click!")
			end
		end
	testButton.Text = "Dummy";
	testButton.Font = GetFont("menu"); --menuFont
	testButton.TextColor = 0xEEEEEE
	
	
	educationView:Add(testButton);
	
	
	testButton = Button()
	testButton.Relative = true;
	testButton.Name = "testButton8"
	testButton.Texture = "Resources/sampler/resources/button.png"	
	testButton.Layer = 3
	testButton.X = 0;
	testButton.Y = 0;
	testButton.Width = 120;
	testButton.Height = 40;
	testButton.State = {}
	testButton.MouseDown = 
		function (testButton, luaevent, args)
			testButton.State["mouseDown"] = true
			testButton.Pushed = true
		end
	testButton.MouseUp = 
		function (testButton, luaevent, args)
			if (testButton.State["mouseDown"]) then
				testButton.Pushed = false
				Trace("testButton click!")
			end
		end
	testButton.Text = "Dummy";
	testButton.Font = GetFont("menu"); --menuFont
	testButton.TextColor = 0xEEEEEE
	
	
	educationView:Add(testButton);
	
end