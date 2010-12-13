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

ScriptEvents = luanet.import_type("INovelEngine.Script.ScriptEvents");
ScriptManager = luanet.import_type("INovelEngine.Script.ScriptManager");

Supervisor = Supervisor()

function dofile (filename)
	local f = assert(loadfile(filename))
	return f()
end

function InitResource(resource)
	if (resource.name == nil) then
		Trace "Resource name undefined!"
		return
	end	
    CurrentState():AddResource(resource);
end;

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
	if (component.name == nil) then
		Trace "Component name undefined!"
		return
	end	
    CurrentState():AddComponent(component);
end;

function RemoveComponent(id)
    return CurrentState():RemoveComponent(id);
end

function GetComponent(id)
    return CurrentState():GetComponent(id);
end

function DebugString(level)
	local info = debug.getinfo(level)
	local source = info.source;
	return string.sub(source, 2) .. ":" .. info.currentline;
end

function try(call, error)
	local ok, res = pcall(call)
	if ok then
		return true;
	else
		local info = DebugString(4);
        if (res ~= nil) then
            Trace(info .. ": " .. error);
            Trace("> " .. res:toString() .. "\n");
        else
		    Trace(info .. ": " .. error);
        end
		return false;
	end 
end

require "BaseScripts\\ESS"
require "BaseScripts\\Selector"
require "BaseScripts\\font"
require "BaseScripts\\csv"