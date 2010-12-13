require "Resources\\sampler\\models\\calendar"
require "Resources\\sampler\\models\\character"
require "Resources\\sampler\\models\\schedulemanager"

dofile("Resources/Sampler/init_csv.lua")

calendar = Calendar:New();
calendar:SetYear(1217);
calendar:SetMonth("June");
calendar:SetDay(5);

character = Character:New();
character:SetFirstName("�ȳ�");
character:SetLastName("��");
character:SetAge(12);
character:SetGold(1000);
character:SetStress(50);
character:SetMana(100);

scheduleManager = ScheduleManager:New();
scheduleManager:Load()