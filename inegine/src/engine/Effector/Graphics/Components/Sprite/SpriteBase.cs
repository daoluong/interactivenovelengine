﻿using System;
using System.Drawing;
using System.Collections.Generic;
using System.Drawing.Imaging;
using System.IO;
using System.Text;
using INovelEngine.ResourceManager;
using SampleFramework;
using SlimDX;
using SlimDX.Direct3D9;
using INovelEngine.Core;

namespace INovelEngine.Effector
{
    public class SpriteBase : AbstractGUIComponent, IComparable
    {
        protected Sprite sprite;

        protected INETexture textureManager;
        protected Rectangle sourceArea;

        public SpriteBase()
        {
            sourceArea = new Rectangle();
        }

        public string Texture
        {
            get
            {
                if (textureManager != null) return textureManager.TextureFile;
                else return null;
            }
            set
            {
                textureManager = new INETexture();
                resources.Add(textureManager);
                textureManager.TextureFile = value;
                SetDimensions();
            }
        }

        protected virtual void SetDimensions()
        {
            sourceArea.Width = textureManager.Width;
            sourceArea.Height = textureManager.Height;
            Width = textureManager.Width;
            Height = textureManager.Height;
        }

        #region IGameComponent Members

        protected override void DrawInternal()
        {
            if (this.textureManager.Texture == null) return;
            sprite.Begin(SpriteFlags.AlphaBlend);
  
            sprite.Draw(this.textureManager.Texture, this.sourceArea, new Vector3(), new Vector3(RealX, RealY, 0), renderColor);
            sprite.End();
        }

        public override void Update(GameTime gameTime)
        {
            base.Update(gameTime);
        }

        #endregion

        /// <summary>
        /// Initializes the resource.
        /// </summary>
        /// <param name="graphicsDeviceManager">The graphics device manager.</param>
        public override void Initialize(GraphicsDeviceManager graphicsDeviceManager)
        {
            base.Initialize(graphicsDeviceManager);
            sprite = new Sprite(manager.Direct3D9.Device);
            this.textureManager.Initialize(graphicsDeviceManager);
        }

        /// <summary>
        /// Allows the resource to load any short-term graphical content.
        /// </summary>
        public override void LoadContent()
        {
            base.LoadContent();
            sprite.OnResetDevice();
            textureManager.LoadContent();
        }

        /// <summary>
        /// Allows the resource to unload any short-term graphical content.
        /// </summary>
        public override void UnloadContent()
        {
            base.UnloadContent();
            sprite.OnLostDevice();
        }


        /// <summary>
        /// Performs application-defined tasks associated with freeing, releasing, or resetting unmanaged resources.
        /// </summary>
        public override void Dispose()
        {
            base.Dispose();
            sprite.Dispose();
            GC.SuppressFinalize(this);
        }
    }
}
