LoadScript "Resources\\sampler\\models\\calendar.lua"
LoadScript "Resources\\sampler\\models\\character.lua"
LoadScript "Resources\\sampler\\models\\schedulemanager.lua"
LoadScript "Resources\\sampler\\models\\itemmanager.lua"
LoadScript "Resources\\sampler\\models\\inventorymanager.lua"
LoadScript "Resources\\sampler\\models\\shopmanager.lua"
LoadScript "Resources\\sampler\\models\\savemanager.lua"

--game master data
scheduleManager = ScheduleManager:New();
scheduleManager:Load()

itemManager = ItemManager:New();
itemManager:Load();

shopManager = ShopManager:New();
shopManager:Load();

--save manager
saveManager = SaveManager:New();