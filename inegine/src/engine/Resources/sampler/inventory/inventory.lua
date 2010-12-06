-- InventoryView UI component implemented in lua
require "Resources\\sampler\\components\\luaview"
require "Resources\\sampler\\components\\tabview"
require "Resources\\sampler\\components\\flowview"

InventoryView = LuaView:New();

function InventoryView:Init()
	local gamestate = CurrentState();
	
	local parent = self.parent;
	local font = GetFont("default"); 
	self.font = font;
	local name = self.name;
	
	self.frame = View()
	self.frame.Name = name
	
	self.frame.x = 50;
	self.frame.y = 160;
	self.frame.Width = 400
	self.frame.Height = 430
	self.frame.alpha = 155
	self.frame.layer = 6
	
	self.frame.Visible = false
	self.frame.Enabled = false
	self.frame.MouseLeave =
		function(target, event, args)
			Trace("mouse leave: " .. target.Name)	
		end
	
	parent:AddComponent(self.frame)
	
	
	local background = ImageWindow()
	background.name = "backround"
	background.relative = true;
	background.width = self.frame.width - 10;
	background.height = self.frame.height - 50 - 50;
	background.x = 5;
	background.y = 50;
    background.WindowTexture = "Resources/sampler/resources/window.png"
    background.RectSize = 40
    background.BackgroundColor = 0xFFFFFF
	background.alpha = 255
	background.layer = 6;
	self.frame:AddComponent(background);
	
	
	local tabView = Tabview:New("tabView", GetFont("default"));
	tabView.frame.relative = true
	tabView.frame.X = 0;
	tabView.frame.Y = 0;
	tabView.frame.Width = self.frame.Width;
	tabView.frame.Height = self.frame.Height - 50;
	tabView.frame.layer = 10;
	self.frame:AddComponent(tabView.frame);
	tabView:Show();
		
	local dressView = Flowview:New("dressview")
	dressView.frame.relative = true;
	dressView.frame.width = self.frame.width - 10;
	dressView.frame.height = self.frame.height - 50 - 50;
	dressView.frame.x = 5;
	dressView.frame.y = 50;
	dressView.frame.layer = 10;
	dressView.spacing = 5;
	dressView.padding = 10;
	dressView.frame.visible = true;
	dressView.frame.enabled = true;
	self.dressView = dressView;
	tabView:AddTab("Dress", dressView.frame);
	
	local itemView = Flowview:New("itemview")
	itemView.frame.relative = true;
	itemView.frame.width = self.frame.width - 10;
	itemView.frame.height = self.frame.height - 50 - 50;
	itemView.frame.x = 5;
	itemView.frame.y = 50;
	itemView.frame.alpha = 155
	itemView.frame.layer = 4;
	itemView.spacing = 5;
	itemView.padding = 10;
	itemView.frame.visible = false;
	itemView.frame.enabled = false;
	self.itemView = itemView;
	tabView:AddTab("Item", itemView.frame);
	
	local furnitureView = Flowview:New("furnitureview");
	furnitureView.frame.relative = true;
	furnitureView.frame.width = self.frame.width - 10;
	furnitureView.frame.height = self.frame.height - 50 - 50;
	furnitureView.frame.x = 5;
	furnitureView.frame.y = 50;
	furnitureView.frame.alpha = 155
	furnitureView.frame.layer = 4;	
	furnitureView.spacing = 5;
	furnitureView.padding = 10;
	furnitureView.frame.visible = false;
	furnitureView.frame.enabled = false;
	self.furnitureView = furnitureView;
	tabView:AddTab("Furniture", furnitureView.frame);
	
	local closeButton = self:CreateButton("closeButton", "Close",
		function (closeButton, luaevent, args)
			self:Dispose();
		end)
	closeButton.Layer = 4;
	closeButton.X = self.frame.width - 125;
	closeButton.Y = self.frame.height - 45;
	self.closebutton = closeButton;
	
	self.frame:AddComponent(closeButton);
end


function InventoryView:CreateButton(buttonName, buttonText, event)
	local newButton = Button()
	newButton.Relative = true;
	newButton.Name = buttonName;
	newButton.Texture = "Resources/sampler/resources/button/button.png"	
	newButton.Layer = 5
	newButton.X = 0;
	newButton.Y = 0;
	newButton.Width = 100;
	newButton.Height = 40;
	newButton.State = {}
	newButton.MouseDown = 
		function (newButton, luaevent, args)
			newButton.State["mouseDown"] = true
			newButton.Pushed = true
		end
	newButton.MouseUp = 
		function (button, luaevent, args)
			if (button.State["mouseDown"]) then
				button.Pushed = false;
                if (event~=nil) then 
					event(button, luaevent, args);
				end
			end
		end
	newButton.Text = buttonText;
	newButton.Font = GetFont("menu"); --menuFont
	newButton.TextColor = 0xEEEEEE
	return newButton;
end


function InventoryView:CreateItem(id, text, icon)
	local frame = View();
	frame.Name = id;
	frame.Relative = true;
	frame.Width = 80;
	frame.Height = 69;
	frame.Enabled = true;
	
	local pic = Button();
	pic.Name = "picture";
	pic.Texture = icon
	pic.Visible = true;
	pic.Width = 48;
	pic.Height = 48;
	pic.X = (frame.Width - pic.Width) / 2;
	pic.State = {}
	pic.MouseDown = 
		function (button, luaevent, args)
			Trace("mouse down!");
			button.State["mouseDown"] = true
			button.Pushed = true;
		end
	pic.MouseUp = 
		function (button, luaevent, args)
			if (button.State["mouseDown"]) then
				Trace("mouse up!");
				button.Pushed = false;
				self.selectedEvent(button, luaevent, id);
			end
		end
	frame:AddComponent(pic);
	
	local button = Button();
	button.Name = "text"
	button.Width = 80;
	button.Height = 21;
	button.X = 0;
	button.Y = pic.Height;
	button.font = GetFont("verysmall");
	button.TextColor = 0xFFFFFF
	button.Text = text;
	button.Alignment = 1;
	button.VerticalAlignment = 1;
	frame:AddComponent(button);
	return frame;
end

function InventoryView:AddDressItem(buttonName, buttonText, icon)
	self.dressView:Add(self:CreateItem(buttonName, buttonText, icon));
end

function InventoryView:AddItemItem(buttonName, buttonText, icon)
	self.itemView:Add(self:CreateItem(buttonName, buttonText, icon));
end

function InventoryView:AddFurnitureItem(buttonName, buttonText, icon)
	self.furnitureView:Add(self:CreateItem(buttonName, buttonText, icon));
end

function InventoryView:SetSelectedEvent(event)
	self.selectedEvent = event;
end
