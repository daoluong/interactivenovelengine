ExecutionPresenter = {}

function ExecutionPresenter:New()
	local o = {}
	setmetatable(o, self)
	self.__index = self
	return o
end
function ExecutionPresenter:SetClosingEvent(event)
	self.closingEvent = event;
end

function ExecutionPresenter:Init(main, executionView, scheduleManager)
	self.main = main;
	self.executionView = executionView;
	self.scheduleManager = scheduleManager;

	main:Disable();
	main:ToggleMainMenu(false);
	executionView:Show();

    self:RegisterEvents();
    self:Update();
end

function ExecutionPresenter:Close()
	if (self.closingEvent ~= nil) then
		self.closingEvent();
	end
    self:DeregisterEvents();
end

function ExecutionPresenter:RegisterEvents()
	Trace("registering execution presenter events!");
    local executionView = self.executionView;
    local main = self.main;
    local scheduleManager = self.scheduleManager;
    
    main:SetKeyDownEvent(function(handler, luaevent, args) self:HandleKeyDown(handler, luaevent, args) end)
end

function ExecutionPresenter:HandleKeyDown(handler, luaevent, args)
	local code = args[0];
	Trace("key down! : " .. code);
	if (code == 32) then --space
		self.executionView:Advance();
	end
end

function ExecutionPresenter:DeregisterEvents()
	Trace("deregistering execution presenter events!");
    main:SetKeyDownEvent(nil)
end

function ExecutionPresenter:Update()
    local executionView = self.executionView;
    local main = self.main;
    local scheduleManager = self.scheduleManager;

    self.selectedSchedules = scheduleManager:GetSelectedSchedules();
    self.currentScheduleIndex = 1;

    self:RunSchedule();
end

function ExecutionPresenter:RunSchedule()
    if (self.currentScheduleIndex > #(self.selectedSchedules)) then
		calendar:AdvanceMonth()
        self.executionView:Dispose();
		self:Close();
    else
        local scheduleName, success, result, animation = self.scheduleManager:ProcessSchedule(self.selectedSchedules[self.currentScheduleIndex]);
        
        self.executionView:SetExecutionOverEvent(
		    function ()
        		calendar:AdvanceWeek()
                self:RunSchedule();
            end
        )
        local dialog2 = "";
        local portrait2 = "";
        local sound = "";
        if (success) then
            dialog2 = "이번주는 잘 되었습니다!\n아버지도 기뻐하실거에요.@"
            portrait2 = "Resources/sampler/resources/images/f2.png"
            sound = "failure";
        else
            dialog2 = "이번주는 잘 안되었습니다!\n아버지가 슬퍼하실거에요.@"
            portrait2 = "Resources/sampler/resources/images/f1.png"
            sound = "failure";
        end

	    self.executionView:ExecuteSchedule("규브", "이번주의 일정은 " ..  scheduleName .. "입니다.\n열심히 하세요.@",
							      "Resources/sampler/resources/images/f3.png", 
							      animation,
							      result,
							      dialog2,
							      portrait2,
							      sound,
							      function()
									self.main:InvalidateStatus();
							      end);
        self.currentScheduleIndex = self.currentScheduleIndex + 1;
    end 
end

