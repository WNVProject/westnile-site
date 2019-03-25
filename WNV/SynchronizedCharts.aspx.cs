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
    public partial class SynchronizedCharts : System.Web.UI.Page
    {
        private string cs = ConfigurationManager.ConnectionStrings["CString"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            ddlYearFill();
            ddlCountyFill();
            //ddlCasesFill();
            if (!IsPostBack)
            {
            }
        }

        protected void ddlCountyFill()
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
                            ddlCounty.DataSource = dt;
                            ddlCounty.DataValueField = "TrapCounty";
                            ddlCounty.DataTextField = "TrapCounty";
                            ddlCounty.DataBind();
                            ddlCounty.SelectedIndex = 0;
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

        protected void ddlCounty_SelectedIndexChanged(object sender, EventArgs e)
        {
            ddlCountyFill();
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
            Hashtable trapCountParams = new Hashtable();
            Hashtable weatherParams = new Hashtable();
            Hashtable casesParams = new Hashtable();
            trapCountParams.Add("TrapYear", ddlYear.SelectedValue.ToString() + "-01-01");
            trapCountParams.Add("TrapCounty", ddlCounty.SelectedValue);
            weatherParams.Add("WeatherYear", ddlYear.SelectedValue.ToString() + "-01-01");
            weatherParams.Add("WeatherCounty", ddlCounty.SelectedValue);
            casesParams.Add("CaseYear", ddlYear.SelectedValue.ToString() + "-01-01");
            casesParams.Add("CaseCounty", ddlCounty.SelectedValue);
            //parameters2.Add("WeatherVariable", ddlWeather.SelectedValue.ToString());
            //Add the WNV Cases when they are done
            generateTrapCountJSON("USP_Get_Select_TotalMosquitoCountByYear", trapCountParams);
            generateWeatherJSON("USP_Get_Select_WeatherByYear", weatherParams);
            generateCasesJSON("USP_Get_Select_WNVCaseCountByYear", casesParams);
            //TODO: 
            //the weather variable that is selected
            //cases from the selected county and type 
        }

        protected void generateTrapCountJSON(string procedure, Hashtable parameters)
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

                    String trapCountJSON = "";
                    trapCountJSON += "{\"chart\":{\"id\":\"chrtTrapCountOptions\",\"group\":\"syncChartsGroup\",\"type\":\"line\"}," +
                                     "\"legend\":{\"show\":true,\"showForSingleSeries\":true,\"position\":\"top\"}," +
                                     "\"colors\":[\"#A4D8A6\", \"#8CC58E\", \"#75B277\", \"#5D9F60\", \"#468C48\", \"#2E7931\", \"#17661A\", \"#005403\"],\"series\":[";

                    if (ddlMosquitoSpecies.SelectedValue.Equals("All"))
                    {
                        foreach (DataColumn column in dt.Columns)
                        {
                            if (!(column.ColumnName.Equals("County") || column.ColumnName.Equals("TrapYear") || column.ColumnName.Equals("Week")))
                            {
                                trapCountJSON += "{\"name\":\"" + column.ColumnName + "\",\"data\":[";
                                foreach (DataRow row in dt.Rows)
                                {
                                    trapCountJSON += "[\"" + row["Week"].ToString().Replace(" 12:00:00 AM", "") + "\",\"" + row[column.ColumnName] + "\"],";
                                }
                                trapCountJSON = trapCountJSON.Remove(trapCountJSON.Length - 1);
                                trapCountJSON += "]},";
                            }
                        }
                        trapCountJSON = trapCountJSON.Remove(trapCountJSON.Length - 1);
                        trapCountJSON += "],\"yaxis\":{\"lables\":{\"minWidth\":40}}}";
                    }
                    else
                    {
                        trapCountJSON += "{\"name\":\"" + ddlMosquitoSpecies.SelectedValue + "\",\"data\":[";

                        foreach (DataRow row in dt.Rows)
                        {
                            trapCountJSON += "[\"" + row["Week"].ToString().Replace("12:00:00 AM", "") + "\"," + row[ddlMosquitoSpecies.SelectedValue.ToString()] + "],";
                        }
                        trapCountJSON = trapCountJSON.Remove(trapCountJSON.Length - 1);
                        trapCountJSON += "]}],\"yaxis\":{\"lables\":{\"minWidth\":40}}}";
                    }

                    hfTrapCountJSON.Value = trapCountJSON;
                }
            }
        }
        protected void generateWeatherJSON(string procedure, Hashtable parameters)
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

                    String weatherJSON = "";
                    weatherJSON += "{\"chart\":{\"id\":\"chrtWeatherOptions\",\"group\":\"syncChartsGroup\",\"type\":\"line\"}," +
                                   "\"legend\":{\"show\":true,\"showForSingleSeries\":true,\"position\":\"top\"}," +
                                   "\"colors\":[\"#3d5192\"],\"series\":[{\"name\":\"" + ddlWeather.SelectedValue + "\",\"data\":[";
                    
                    foreach (DataRow row in dt.Rows)
                    {
                        weatherJSON += "[\"" + row["Week"].ToString().Replace(" 12:00:00 AM", "") + "\"," + row[ddlWeather.SelectedValue.ToString()] + "],";
                    }
                    weatherJSON = weatherJSON.Remove(weatherJSON.Length - 1);
                    weatherJSON += "]}],\"yaxis\":{\"lables\":{\"minWidth\":40}}}";


                    hfWeatherJSON.Value = weatherJSON;
                }
            }
        }
        protected void generateCasesJSON(string procedure, Hashtable parameters)
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

                    String casesJSON = "";
                    casesJSON += "{\"chart\":{\"id\":\"chrtCasesOptions\",\"group\":\"syncChartsGroup\",\"type\":\"line\"}," +
                                 "\"legend\":{\"show\":true,\"showForSingleSeries\":true,\"position\":\"top\"}," +
                                 "\"colors\":[\"#FF7575\", \"#DD4E4E\", \"#BC2727\", \"#9B0000\"],\"series\":[";

                    if (ddlWNVCases.SelectedValue.Equals("All"))
                    {
                        foreach (DataColumn column in dt.Columns)
                        {
                            if (!(column.ColumnName.Equals("County") || column.ColumnName.Equals("Week")))
                            {
                                casesJSON += "{\"name\":\"" + column.ColumnName + "\",\"data\":[";
                                foreach (DataRow row in dt.Rows)
                                {
                                    casesJSON += "[\"" + row["Week"].ToString().Replace(" 12:00:00 AM", "") + "\",\"" + row[column.ColumnName] + "\"],";
                                }
                                casesJSON = casesJSON.Remove(casesJSON.Length - 1);
                                casesJSON += "]},";
                            }
                        }
                        casesJSON = casesJSON.Remove(casesJSON.Length - 1);
                        casesJSON += "],\"yaxis\":{\"lables\":{\"minWidth\":40}}}";
                    }
                    else
                    {
                        casesJSON += "{\"name\":\"" + ddlWNVCases.SelectedValue + "\",\"data\":[";

                        foreach (DataRow row in dt.Rows)
                        {
                            casesJSON += "[\"" + row["Week"].ToString().Replace(" 12:00:00 AM", "") + "\"," + row[ddlWNVCases.SelectedValue.ToString()] + "],";
                        }
                        casesJSON = casesJSON.Remove(casesJSON.Length - 1);
                        casesJSON += "]}],\"yaxis\":{\"lables\":{\"minWidth\":40}}}";
                    }


                    hfCasesJSON.Value = casesJSON;
                }
            }
        }
    }


}