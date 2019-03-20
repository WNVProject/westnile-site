using System;
using System.Configuration;
using System.Data;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.HtmlControls;
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
    public partial class SynchronizedCharts1 : System.Web.UI.Page
    {
        private string cs = ConfigurationManager.ConnectionStrings["CString"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            ddlYearFill();
            ddlTrapCountyFill();
            //ddlCasesFill();
        }

        protected void ddlTrapCountyFill()
        {
            try
            {
                if (!IsPostBack)
                {
                    using (MySqlConnection conn = new MySqlConnection(cs))
                    {
                        var procedure = "USP_Select_Counties";
                        MySqlCommand cmd = new MySqlCommand(procedure, conn);
                        cmd.CommandType = CommandType.StoredProcedure;

                        using (MySqlDataAdapter da = new MySqlDataAdapter(cmd))
                        {
                            DataTable dt = new DataTable();
                            da.Fill(dt);
                            ddlTrapCounty.DataSource = dt;
                            ddlTrapCounty.DataValueField = "TrapCounty";
                            ddlTrapCounty.DataTextField = "TrapCounty";
                            ddlTrapCounty.DataBind();
                            ddlTrapCounty.SelectedIndex = 0;
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
        protected void ddlYearFill()
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
                            ddlYear.DataSource = dt;
                            ddlYear.DataSource = dt;
                            ddlYear.DataValueField = "TrapYear";
                            ddlYear.DataValueField = "TrapYear";
                            ddlYear.DataTextField = "TrapYear";
                            ddlYear.DataTextField = "TrapYear";
                            ddlYear.DataBind();
                            ddlYear.DataBind();
                            ddlYear.SelectedIndex = 0;
                            ddlYear.SelectedIndex = ddlYear.Items.Count - 1;
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

        protected void ddlTrapCounty_SelectedIndexChanged(object sender, EventArgs e)
        {
            ddlTrapCountyFill();
        }
        protected void ddlMosquitoSpecies_SelectedIndexChanged(object sender, EventArgs e)
        {

        }

        protected void ddlWeather_SelectedIndexChanged(object sender, EventArgs e)
        {

        }
        protected void ddlYear_SelectedIndexChanged(object sender, EventArgs e)
        {
            ddlYearFill();
        }
        protected void ddlWNVCases_SelectedIndexChanged(object sender, EventArgs e)
        {

        }

        protected void renderBtn_Click(object sender, EventArgs e)
        {
            Hashtable parameters = new Hashtable();
            Hashtable parameters2 = new Hashtable();
            parameters.Add("MosquitoSpecies", ddlMosquitoSpecies.SelectedValue.ToString());
            parameters.Add("TrapYear", ddlYear.SelectedValue.ToString());
            //parameters2.Add("WeatherVariable", ddlWeather.SelectedValue.ToString());
            //Add the WNV Cases when they are done
            generateJSON("USP_Get_TotalMosquitoCountByYear",parameters, "SyncCharts.json");
            //TODO: 
                //the weather variable that is selected
                //cases from the selected county and type 
        }

        protected void generateJSON(string procedure, Hashtable parameters, string fileName)
        {
            using (MySqlConnection conn = new MySqlConnection(cs))
            {
                MySqlCommand cmd = new MySqlCommand(procedure, conn);
                cmd.CommandType = CommandType.StoredProcedure;
                if(parameters.Count > 0)
                {
                    foreach(DictionaryEntry param in parameters)
                    {
                        cmd.Parameters.AddWithValue(param.Key.ToString(), param.Value.ToString());
                    }
                }
                using (MySqlDataAdapter da = new MySqlDataAdapter(cmd))
                {
                    DataTable dt = new DataTable();
                    da.Fill(dt);

                    StringBuilder syncChartsJson = new StringBuilder();
                    syncChartsJson.Append("{\"chart\":\"type\": line }, \"colors\": ['#008FFB'], \"series\": [{ \"data\": [");
                    //add the data from the database for a selected species

                    //from here we just need to 
                }
            }
        }
    }


}