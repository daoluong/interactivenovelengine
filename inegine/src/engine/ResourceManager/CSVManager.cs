﻿
using System;
using System.Collections.Generic;
using System.Drawing;
using System.Drawing.Imaging;
using System.IO;
using System.Text;
using INovelEngine.Core;
using INovelEngine.Effector;
using INovelEngine.Effector.Audio;
using INovelEngine.Effector.Graphics.Text;
using SampleFramework;
using SlimDX;
using SlimDX.Direct3D9;
using Com.StellmanGreene.CSVReader;
using INovelEngine.Script;
using LuaInterface;

namespace INovelEngine.ResourceManager
{
    public class INECsv : AbstractResource 
    {
        public CSVReader csvReader;
        public List<string> columns;
        private Dictionary<string, int> columnMap;
        private List<Object> row;
        private List<List<Object>> rows;

        public INECsv()
        {
            this.Type = INovelEngine.Effector.ResourceType.General;
            columns = new List<string>();
            columnMap = new Dictionary<string, int>();
            rows = new List<List<object>>();
        }

        public INECsv(string fileName)
        {
            this.Type = INovelEngine.Effector.ResourceType.General;
            columns = new List<string>();
            columnMap = new Dictionary<string, int>();
            rows = new List<List<object>>();
            this.Encoding = "UTF-8";
            this.FileName = fileName;
            this.Name = fileName;
        }

        public string FileName
        {
            get;
            set;
        }

        public string Encoding
        {
            get; set;
        }

        public void readColumns()
        {
            if (next())
            {
                for (int i = 0; i < row.Count; i++)
                {
                    this.columns.Add(row[i].ToString());
                    this.columnMap[row[i].ToString()] = i;
                }
                this.row = null;
            }
        }

        public void readToEnd()
        {
            while (next())
            {
                rows.Add(this.row);
            }
        }

        private bool next()
        {
            row = this.csvReader.ReadRow();
            return (row != null);
        }

        public int Count
        {
            get
            {
                return this.rows.Count;
            }
            set
            {
            }
        }

        public int ColumnCount
        {
            get
            {
                return this.columns.Count;
            }
            set
            {
            }
        }

        public LuaInterface.LuaTable GetRow(int row, LuaTable table)
        {
            for (int i = 0; i < this.ColumnCount; i++)
            {
                Object obj = this.rows[row][i];
                string typeString = obj.GetType().ToString();
                if (typeString.Equals("System.Single"))
                {
                    table[this.columns[i]] = (float)obj;
                }
                else if (typeString.Equals("System.Byte"))
                {
                    table[this.columns[i]] = (float)(Byte)obj;
                }
                else if (typeString.Equals("System.Int16"))
                {
                    table[this.columns[i]] = (float)(short)obj;
                }
                else
                {
                    table[this.columns[i]] = obj.ToString();
                }
            }
          

            return table;
        }

        public LuaInterface.LuaTable GetRow(string key, string value, LuaTable table)
        {
            if (!columns.Contains(key))
            {
                throw new Exception(this.FileName + " : unable to find key " + key);
            }

            /* find row number */
            int row = -1;
            for (int i = 0; i < this.rows.Count; i++)
            {
                if (this.GetString(i, key).Equals(value))
                {
                    row = i;
                }
            }
            if (row == -1)
            {
                throw new Exception(this.FileName + " : unable to find " + value + " for key " + key);
            }


            table = this.GetRow(row, table);
          
            return table;
        }

        public string GetColumn(int i)
        {
            return this.columns[i].Trim();
        }

        public bool HasColumn(string columnName)
        {
            return this.columnMap.ContainsKey(columnName);
        }

        public int GetColumnID(string columnName)
        {
            if (this.columnMap.ContainsKey(columnName))
            {
                return this.columnMap[columnName];
            }
            else
            {
                throw new Exception(this.FileName + " : unable to find column " + columnMap);
            }
        }

        public string GetString(int row, string col)
        {
            Object obj = this.rows[row][GetColumnID(col)];
            return obj.ToString();
        }

        public int GetInt(int row, string col)
        {
            Object obj = this.rows[row][GetColumnID(col)];
            string typeString = obj.GetType().ToString();
            if (typeString.Equals("System.Byte"))
            {
                return (int)((Byte)obj);
            }
            else if (typeString.Equals("System.Int16"))
            {
                return (int)((short)obj);
            }
            else
            {
                return 0;
            }
        }

        public float GetFloat(int row, string col)
        {
            Object obj = this.rows[row][GetColumnID(col)];
            string typeString = obj.GetType().ToString();
            if (typeString.Equals("System.Single"))
            {
                return (float)obj;
            }
            else if (typeString.Equals("System.Byte"))
            {
                return (float)(Byte)obj;
            }
            else if (typeString.Equals("System.Int16"))
            {
                return (float)(short)obj;
            }
            else
            {
                return 0f;
            }
        }

        public bool GetBoolean(int row, string col)
        {
            Object obj = this.rows[row][GetColumnID(col)];
            string condition = obj.ToString().ToLower();
            if (condition.Equals("true") || condition.Equals("yes")
                || condition.Equals("y") || condition.Equals("o")
                || condition.Equals("1"))
            {
                return true;
            }
            else
            {
                return false;
            }
        }

        #region IResource Members

        public override void LoadContent()
        {
            base.LoadContent();
            StreamReader streamReader;
            
            streamReader = new StreamReader(ArchiveManager.GetStream(this.FileName), System.Text.Encoding.GetEncoding(this.Encoding));
            
            string fileContent = streamReader.ReadToEnd();
            streamReader.Close();
            csvReader = new CSVReader(fileContent);
            this.readColumns();
            this.readToEnd();
        }

        public override void UnloadContent()
        {
            base.UnloadContent();
        }

        #endregion

        #region IDisposable Members

        public override void Dispose()
        {
            base.Dispose();
        }

        #endregion
    }



    public class CsvManager : IResource
    {
        protected ResourceCollection resources = new ResourceCollection();
        protected Dictionary<string, AbstractResource> resourcesMap = new Dictionary<string, AbstractResource>();


        #region IResource Members for managing graphical resources

        public void Initialize(GraphicsDeviceManager graphicsDeviceManager)
        {
            Supervisor.Info("initializing csv manager!");
            resources.Initialize(graphicsDeviceManager);
        }

        public void LoadContent()
        {
            resources.LoadContent();
        }

        public void UnloadContent()
        {
            resources.UnloadContent();
        }

        #endregion


        #region IDisposable Members

        public void Dispose()
        {
            Supervisor.Info("disposing csv manager!");
            resources.Dispose();
        }

        #endregion

        #region resource management

        public void LoadCsv(string alias, string path, string encoding)
        {
            if (resourcesMap.ContainsKey(alias)) return;
            INECsv newCsv = new INECsv(path);
            newCsv.Name = alias;
            newCsv.Encoding = encoding;
            AddCsv(newCsv);
        }

        public void AddCsv(INECsv csv)
        {
            if (resourcesMap.ContainsKey(csv.Name)) return;

            resources.Add(csv);
            resourcesMap[csv.Name] = csv;
        }


        public INECsv GetCsv(string id)
        {

            if (resourcesMap.ContainsKey(id))
            {
                return (INECsv)resourcesMap[id];
            }
            else
            {
                throw new Exception("id not found!");
            }
        }

        public void RemoveCsv(string id)
        {
            if (resourcesMap.ContainsKey(id))
            {
                INECsv font = (INECsv)resourcesMap[id];
                resources.Remove(font);
                resourcesMap.Remove(id);
                font.Dispose();
            }
        }

        #endregion



    }
}