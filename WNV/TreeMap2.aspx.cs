using System;
using System.Configuration;
using System.Data;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using MySql;
using MySql.Data;
using MySql.Data.MySqlClient;
using System.Web.UI.DataVisualization.Charting;
using Newtonsoft.Json;
using System.IO;
using System.Text;
using System.Text.RegularExpressions;

namespace WNV
{
    public partial class TreeMap2 : Page
    {
        private string cs = ConfigurationManager.ConnectionStrings["CString"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            fillYearDDLs();
            fillLocationDDL();
        }

        protected void fillYearDDLs()
        {
            try
            {
                if (!IsPostBack)
                {
                    using (MySqlConnection conn = new MySqlConnection(cs))
                    {
                        var procedure = "USP_Select_TrapYear";
                        MySqlCommand cmd = new MySqlCommand(procedure, conn);
                        cmd.CommandType = CommandType.StoredProcedure;

                        using (MySqlDataAdapter da = new MySqlDataAdapter(cmd))
                        {
                            DataTable dt = new DataTable();
                            da.Fill(dt);
                            ddlYearStart.DataSource = dt;
                            ddlYearEnd.DataSource = dt;
                            ddlYearStart.DataValueField = "TrapYear";
                            ddlYearEnd.DataValueField = "TrapYear";
                            ddlYearStart.DataTextField = "TrapYear";
                            ddlYearEnd.DataTextField = "TrapYear";
                            ddlYearStart.DataBind();
                            ddlYearEnd.DataBind();
                            ddlYearStart.Items.Insert(0, new ListItem("Select...", ""));
                            ddlYearEnd.Items.Insert(0, new ListItem("Select...", ""));
                        }
                    }
                }
            }
            catch (MySqlException ex)
            {
                lblError.Text = "Could not retrieve Years: " + ex.ToString();
                lblError.Visible = true;
            }
        }


        protected void fillLocationDDL()
        {
            if (!IsPostBack)
            {
                try
                {
                    using (MySqlConnection conn = new MySqlConnection(cs))
                    {
                        MySqlCommand cmd = new MySqlCommand("SELECT TrapLocationID, TrapArea from trap_locations ORDER BY TrapArea", conn);
                        cmd.CommandType = CommandType.Text;
                        DataSet ds = new DataSet();

                        using (MySqlDataAdapter da = new MySqlDataAdapter(cmd))
                        {
                            da.Fill(ds, "trap_locations");
                        }
                        ddlLocation.DataSource = ds.Tables["trap_locations"];
                        ddlLocation.DataValueField = "TrapArea";
                        ddlLocation.DataTextField = "TrapArea";
                        ddlLocation.DataBind();
                        ddlLocation.Items.Insert(0, new ListItem("Select...", ""));
                    }
                }
                catch (Exception ex)
                {
                    lblError.ForeColor = System.Drawing.Color.Red;
                    lblError.Text = "Could not retrieve Trap Locations: " + ex.ToString();
                }
            }
        }


        protected void chkStatewide_CheckChanged(object sender, EventArgs e)
        {
            if (chkStatewide.Checked)
            {
                ddlLocation.Enabled = false;
                rfvLocation.Enabled = false;
            }
            else
            {
                ddlLocation.Enabled = true;
                rfvLocation.Enabled = true;
            }
        }

        protected void renderBtn_Click(object sender, EventArgs e)
        {
            Hashtable parameters = new Hashtable();
            parameters.Add("TrapArea", chkStatewide.Checked ? "%" : ddlLocation.SelectedValue);
            parameters.Add("StartWeek", ddlYearStart.SelectedValue.ToString() + "-01-01");
            parameters.Add("EndWeek", ddlYearEnd.SelectedValue.ToString() + "-12-31");

            generateTreeMapJson("USP_Get_Select_MosquitoCountsByTrapByDate", parameters, "TreeMapData.json");
        }




        protected void generateTreeMapJson(String procedure, Hashtable parameters, String fileName)
        {
            try
            {
                using (MySqlConnection conn = new MySqlConnection(cs))
                {
                    MySqlCommand cmd = new MySqlCommand(procedure, conn);
                    cmd.CommandType = CommandType.StoredProcedure;
                    if (parameters.Count > 0)
                    {
                        foreach (DictionaryEntry param in parameters)
                        {
                            cmd.Parameters.AddWithValue(param.Key.ToString(), param.Value.ToString());
                        }
                    }

                    using (MySqlDataAdapter da = new MySqlDataAdapter(cmd))
                    {
                        DataTable dt = new DataTable();
                        da.Fill(dt);

                        StringBuilder treeMapJson = new StringBuilder();
                        treeMapJson.Append("{\"name\":\"AllMosquitoes\",\"children\":[{");
                        bool trapHasData = false;
                        int domainMax = -1;
                        int domainMin = -1;
                        foreach (DataRow row in dt.Rows)
                        {
                            string trapArea = "\"name\":\"" + row["Trap Area"] + "\",\"children\":[{";
                            bool mosquitoTypeAdded = false;
                            foreach (DataColumn col in dt.Columns)
                            {
                                string columnName = col.ColumnName;
                                string columnValue = row[col.ColumnName].ToString();
                                if (!columnName.Equals("Trap Area") && !columnName.Equals("Males") && !columnName.Equals("Females") && !columnName.Equals("Total Mosquitoes") && !columnValue.Equals("0"))
                                {
                                    if (domainMax == -1 && domainMax == -1)
                                    {
                                        domainMax = Int32.Parse(columnValue);
                                        domainMin = Int32.Parse(columnValue);
                                    }
                                    else if (domainMax < Int32.Parse(columnValue))
                                    {
                                        domainMax = Int32.Parse(columnValue);
                                    }
                                    else if (domainMin > Int32.Parse(columnValue))
                                    {
                                        domainMin = Int32.Parse(columnValue);
                                    }
                                    
                                    trapArea = trapArea + "\"name\":\"" + columnName + "\","+ "\"size\":\"" + columnValue + "\"},{";
                                    mosquitoTypeAdded = true;
                                    trapHasData = true;
                                }
                            }
                            if (mosquitoTypeAdded)
                            {
                                treeMapJson.Append(trapArea);
                                treeMapJson.Remove(treeMapJson.Length - 2, 2);
                                treeMapJson.Append("]},{");
                            }
                        }
                        treeMapJson.Remove(treeMapJson.Length - 2, 2);
                        treeMapJson.Append("],\"max\":\"" + domainMax + "\"," + "\"min\":\"" + domainMin + "\"}");

                        //var json = JsonConvert.SerializeObject(dt);
                        using (StreamWriter sr = new StreamWriter(Server.MapPath("/Scripts/TreeMapJSON/" + fileName)))
                        {
                            if (trapHasData)
                            {
                                sr.Write(treeMapJson);
                            }
                            else
                            {
                                sr.Write("");
                                ScriptManager.RegisterStartupScript(this, GetType(), "alert", "alert('No data exists for these parameters.');", true);
                            }
                            sr.Dispose();
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "alert", "alert('" + ex.Message + "');", true);
            }
        }
    }
}