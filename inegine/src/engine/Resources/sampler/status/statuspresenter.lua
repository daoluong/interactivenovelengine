StatusPresenter = {}

function StatusPresenter:New()
	local o = {}
	setmetatable(o, self)
	self.__index = self
	return o
end

function StatusPresenter:SetClosingEvent(event)
	self.closingEvent = event;
end

function StatusPresenter:Init(main, statusView, character)
	self.main = main;
	self.statusView = statusView;
	self.character = character;

	main:ToggleMainMenu(false);
	statusView:Show();

    self:RegisterEvents();
    self:Update();
end

function StatusPresenter:RegisterEvents()
    local statusView = self.statusView;
    local main = self.main;
    local character = self.character;

	statusView:SetClosingEvent(
		function()
			if (self.closingEvent ~= nil) then
				self.closingEvent();
			end

			statusView:Hide();
			main:ToggleMainMenu(true);
		end
	);

end

function StatusPresenter:Update()
    if (self.statusView ~= nil) then
		self:AddItems();
    end
end

function StatusPresenter:AddItems()
	local descriptionText = self.character:GetFirstName() .. ", " .. self.character:GetLastName();
	self.statusView:SetDescriptionText(descriptionText);
	self.statusView:AddGraphItem("��ǰ", "900", 50, 0x990000);
	self.statusView:AddGraphItem("�̸�", "300", 100, 0x0099CC);
end