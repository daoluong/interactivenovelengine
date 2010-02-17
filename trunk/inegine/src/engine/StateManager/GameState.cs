﻿using System;
using System.Collections.Generic;
using System.Text;
using SampleFramework;
using INovelEngine.Script;
using INovelEngine.Effector;

namespace INovelEngine.StateManager
{

    // GameState class representing a game state. 
    public class GameState : AbstractLuaEventHandler, IResource, IGameComponent
    {
        public GameState()
        {
            this.handleMyself = true;
        }

        public string id
        {
            get;
            set;
        }

        private ResourceCollection resources = new ResourceCollection();
        /* components sorted in z-order */
        private List<AbstractGUIComponent> components = new List<AbstractGUIComponent>();
        public Dictionary<String, AbstractGUIComponent> guiComponents = 
            new Dictionary<string, AbstractGUIComponent>();

        #region IResource Members

        void IResource.Initialize(GraphicsDeviceManager graphicsDeviceManager)
        {
            resources.Initialize(graphicsDeviceManager);
        }

        void IResource.LoadContent()
        {
            resources.LoadContent();
        }

        void IResource.UnloadContent()
        {
            resources.UnloadContent();
        }

        #endregion

        #region IDisposable Members

        void IDisposable.Dispose()
        {
            resources.Dispose();
        }

        #endregion

        #region IGameComponent Members

        public void Draw()
        {
            foreach (IGameComponent component in components)
            {
                component.Draw();
            }
        }

        public void Update(GameTime gameTime)
        {
            foreach (IGameComponent component in components)
            {
                component.Update(gameTime);
            }
        }

        #endregion
        
        public void AddComponent(AbstractGUIComponent component)
        {
            if (guiComponents.ContainsKey(component.id)) return;

            component.managingState = this;

            components.Add(component);
            resources.Add(component);
            guiComponents.Add(component.id, component);

            InvalidateZOrder();
        }

        public AbstractGUIComponent GetComponent(string id)
        {
            if (guiComponents.ContainsKey(id))
            {
                return guiComponents[id];
            }
            else
            {
                return null;
            }
        }

        public void InvalidateZOrder()
        {
            components.Sort(); // sort them according to z-order (higher, higher)
        }

        private AbstractLuaEventHandler mouseDownLocked;

        public override AbstractLuaEventHandler GetHandler(ScriptEvents luaevent, params object[] args)
        {
            AbstractLuaEventHandler handler = this;
            switch (luaevent)
            {
                case ScriptEvents.KeyPress:
                    handler = this;
                    break;
                case ScriptEvents.MouseMove:
                    if (mouseDownLocked != null) handler = mouseDownLocked;
                    else
                    {
                        handler = GetCollidingComponent((int)args[0], (int)args[1]);
                        if (handler == null) handler = this;
                    }
                    break;
                case ScriptEvents.MouseDown:
                    handler = GetCollidingComponent((int)args[0], (int)args[1]);
                    if (handler == null) handler = this;
                    mouseDownLocked = handler;
                    break;
                case ScriptEvents.MouseUp:
                    if (mouseDownLocked != null) handler = mouseDownLocked;
                    break;
                case ScriptEvents.MouseClick:
                    handler = GetCollidingComponent((int)args[0], (int)args[1]);
                    if (handler == null) handler = this;
                    break;
                default:
                    handler = this;
                    break;
            }
            return handler;
        }

        public AbstractGUIComponent GetCollidingComponent(int x, int y)
        {
            AbstractGUIComponent component;
            // do it in reverse order because components sorted in z order...
            for (int i = components.Count - 1; i >= 0; i--)
            {
                component = components[i];
                if (component.x <= x && component.y <= y &&
                    component.x + component.width >= x &&
                    component.y + component.height >= y) return component;
            }
            return null;
        }
    }
}
