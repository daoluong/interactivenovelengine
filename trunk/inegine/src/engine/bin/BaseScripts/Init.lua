luanet.load_assembly("System.Windows.Forms");
luanet.load_assembly("INovelEngine");

GameState = luanet.import_type("INovelEngine.StateManager.GameState");
TextWindow = luanet.import_type("INovelEngine.Effector.TextWindow");
ImageWindow = luanet.import_type("INovelEngine.Effector.ImageWindow");
WindowBase = luanet.import_type("INovelEngine.Effector.WindowBase");
SpriteBase = luanet.import_type("INovelEngine.Effector.SpriteBase");
AnimatedSprite = luanet.import_type("INovelEngine.Effector.AnimatedSprite")
Button = luanet.import_type("INovelEngine.Effector.Button")
Label = luanet.import_type("INovelEngine.Effector.Label")
View = luanet.import_type("INovelEngine.Effector.View")
Tachie = luanet.import_type("INovelEngine.Effector.Tachie")
FadingSprite = luanet.import_type("INovelEngine.Effector.FadingSprite")
Sound = luanet.import_type("INovelEngine.ResourceManager.INESound")

ScriptEvents = luanet.import_type("INovelEngine.Script.ScriptEvents");
ScriptManager = luanet.import_type("INovelEngine.Script.ScriptManager");

Supervisor = Supervisor()

function OpenState(name, script, arg, closingEvt)
    argument = arg;
    closingEvent = closingEvt;
    LoadState(name, script); --create a new state using script
    argument = nil;
    closingEvent = nil;
end

function dofile (filename)
	local f = assert(loadfile(filename))
	return f()
end

function InitResource(resource)
    CurrentState():AddResource(resource);
end

function RemoveResource(id)
    return CurrentState():RemoveResource(id);
end

function GetResource(id)
    return CurrentState():GetResource(id);
end

function InitComponent(component)
    AddComponent(component);
end

function AddComponent(component)
    CurrentState():AddComponent(component);
end;

function RemoveComponent(id)
    return CurrentState():RemoveComponent(id);
end

function GetComponent(id)
    return CurrentState():GetComponent(id);
end

function FadeOutIn(duration, color)
    if color == nil then color = 0xFFFFFF end
    GetFader():FadeOutIn(GetWidth(), GetHeight(), duration, color);
end

function FadeOut(duration, color)
    if color == nil then color = 0xFFFFFF end
    GetFader():Fade(GetWidth(), GetHeight(), duration, false, color);
end

function FadeIn(duration, color)
    if color == nil then color = 0xFFFFFF end
    GetFader():Fade(GetWidth(), GetHeight(), duration, true, color);
end

function DebugString(level)
	local info = debug.getinfo(level)
	local source = info.short_src;
	return string.sub(source, 1) .. ":" .. info.currentline;
end

function try(call, error, level)
	if level == nil then level = 4 end;
	local ok, res = pcall(call)
	if ok then
		return true;
	else
		local info = DebugString(level);
			Error(type("test"));
        if (res ~= nil and type(res) == "string") then
            Error(info .. ": " .. error);
            Error(" " .. res .. "\n");
        else
		    Error(info .. ": " .. error);
        end
		return false;
	end 
end

LoadScript "BaseScripts/ESS.lua"
LoadScript "BaseScripts/font.lua"
LoadScript "BaseScripts/csv.lua"
LoadScript "BaseScripts/sound.lua"
LoadScript "BaseScripts/save.lua"