luanet.load_assembly("System.Windows.Forms");
luanet.load_assembly("INovelEngine");
GameState = luanet.import_type("INovelEngine.StateManager.GameState");
TextWindow = luanet.import_type("INovelEngine.Effector.TextWindow");
ImageWindow = luanet.import_type("INovelEngine.Effector.ImageWindow");
SpriteBase = luanet.import_type("INovelEngine.Effector.SpriteBase");
AnimatedSprite = luanet.import_type("INovelEngine.Effector.AnimatedSprite")
ScriptEvents = luanet.import_type("INovelEngine.Script.ScriptEvents");
ScriptManager = luanet.import_type("INovelEngine.Script.ScriptManager");
Texture = luanet.import_type("INovelEngine.ResourceManager.INETexture");
Font = luanet.import_type("INovelEngine.ResourceManager.INEFont");

function AddResource(resource)
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

function BeginESS(script)
	if (TextOut == nil or Clear == nil) then
		Trace "ESS interface undefined!"
		return
	end
	Trace(script)
	Trace "trying to load another script..."
	local co = coroutine.create(assert(loadstring(LoadESS(script))))
	Trace "resuming!..."
	if (CurrentState().state == nil) then
		CurrentState().state = {};
	end
	CurrentState().state["ess"] = co;
	ResumeEss();
end

-- todo: need more elaborate error tracking system...
function ResumeEss()
	if (CurrentState().state["ess"] ~= nil) then
		--Trace "resuming!..."
		local success, msg = coroutine.resume(CurrentState().state["ess"])
		if (success == false) then
			Trace "error in ESS - terminating!"
			Trace(msg);
		end
	end
end

function YieldESS()
	Trace "yielding..."
	coroutine.yield();
end

function Wait(delay)
	Delay(delay, function() ResumeEss() end)
	coroutine.yield();
end