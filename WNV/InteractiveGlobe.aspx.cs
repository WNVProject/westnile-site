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
    public partial class _InteractiveMap : Page
    {
        private string cs = ConfigurationManager.ConnectionStrings["CString"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            fillYearDropdowns();

            if (!IsPostBack)
            {
                string procedure = "";
                string geometryType = "";
                string fileName = "";

                procedure = "USP_Select_TrapLocations";
                fileName = "trapLocations.json";
                geometryType = "Point";

                generateGeoJsonFromDataTable(procedure, new Hashtable(), geometryType, fileName);
                ScriptManager.RegisterStartupScript(this, GetType(), "createTraps", "createTrapLocations('" + fileName + "');", true);
            }
        }

        protected void fillYearDropdowns()
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

                            ddlUniHeatStartYear.DataSource = dt;
                            ddlUniHeatEndYear.DataSource = dt;
                            ddlUniExtrStartYear.DataSource = dt;
                            ddlUniExtrEndYear.DataSource = dt;
                            ddlPearsonHeatStartYear.DataSource = dt;
                            ddlPearsonHeatEndYear.DataSource = dt;

                            ddlUniHeatStartYear.DataValueField = "TrapYear";
                            ddlUniHeatEndYear.DataValueField = "TrapYear";
                            ddlUniExtrStartYear.DataValueField = "TrapYear";
                            ddlUniExtrEndYear.DataValueField = "TrapYear";
                            ddlPearsonHeatStartYear.DataValueField = "TrapYear";
                            ddlPearsonHeatEndYear.DataValueField = "TrapYear";

                            ddlUniHeatStartYear.DataTextField = "TrapYear";
                            ddlUniHeatEndYear.DataTextField = "TrapYear";
                            ddlUniExtrStartYear.DataTextField = "TrapYear";
                            ddlUniExtrEndYear.DataTextField = "TrapYear";
                            ddlPearsonHeatStartYear.DataTextField = "TrapYear";
                            ddlPearsonHeatEndYear.DataTextField = "TrapYear";

                            ddlUniHeatStartYear.DataBind();
                            ddlUniHeatEndYear.DataBind();
                            ddlUniExtrStartYear.DataBind();
                            ddlUniExtrEndYear.DataBind();
                            ddlPearsonHeatStartYear.DataBind();
                            ddlPearsonHeatEndYear.DataBind();

                            ddlUniHeatStartYear.SelectedIndex = 0;
                            ddlUniHeatEndYear.SelectedIndex = ddlUniHeatEndYear.Items.Count - 1;
                            ddlUniExtrStartYear.SelectedIndex = 0;
                            ddlUniExtrEndYear.SelectedIndex = ddlUniHeatEndYear.Items.Count - 1;
                            ddlPearsonHeatStartYear.SelectedIndex = 0;
                            ddlPearsonHeatEndYear.SelectedIndex = ddlUniHeatEndYear.Items.Count - 1;
                        }
                    }
                }
            }
            catch (MySqlException ex)
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "alert", "alert('Could not retrieve Years: " + ex.Message + "');", true);
            }
        }



        protected void btnRender_Click(object sender, EventArgs e)
        {
            string procedure = "";
            Hashtable parameters;
            string geometryType = "";
            string fileName = "";

            procedure = "USP_Get_Select_MeanCountsByStateByDateRange";
            parameters = new Hashtable()
            {
                {"StartWeek","2006-01-01"},
                {"EndWeek","2019-12-31"}
            };

            if (ddlVisType.SelectedValue == "1")
            {
                if (ddlUniHeatStat.SelectedValue == "Mean")
                {
                    procedure = "USP_Get_Select_MeanCountsByStateByDateRange";
                    parameters = new Hashtable()
                    {
                        {"StartWeek",ddlUniHeatStartYear.SelectedValue.ToString()+"-01-01"},
                        {"EndWeek",ddlUniHeatEndYear.SelectedValue.ToString()+"-12-31"}
                    };
                    String jsonToRender = generateJSONFromDataTable(procedure, parameters);
                    ScriptManager.RegisterStartupScript(this, GetType(), "renderUnivariateHeatmap", "renderUnivariateHeatmap('" + jsonToRender + "','" + ddlUniHeatStat.SelectedValue + "');", true);
                }
                if (ddlUniHeatStat.SelectedValue == "Total")
                {
                    procedure = "USP_Get_Select_TotalCountsByStateByDateRange";
                    parameters = new Hashtable()
                    {
                        {"StartWeek",ddlUniHeatStartYear.SelectedValue.ToString()+"-01-01"},
                        {"EndWeek",ddlUniHeatEndYear.SelectedValue.ToString()+"-12-31"}
                    };
                    String jsonToRender = generateJSONFromDataTable(procedure, parameters);
                    ScriptManager.RegisterStartupScript(this, GetType(), "renderUnivariateHeatmap", "renderUnivariateHeatmap('" + jsonToRender + "','" + ddlUniHeatStat.SelectedValue + "');", true);
                }
            }
            else if (ddlVisType.SelectedValue == "2")
            {
                if (ddlUniExtrStat.SelectedValue == "Mean")
                {
                    procedure = "USP_Get_Select_MeanCountsByStateByDateRange";
                    parameters = new Hashtable()
                    {
                        {"StartWeek",ddlUniExtrStartYear.SelectedValue.ToString()+"-01-01"},
                        {"EndWeek",ddlUniExtrEndYear.SelectedValue.ToString()+"-12-31"}
                    };
                    String jsonToRender = generateJSONFromDataTable(procedure, parameters);
                    ScriptManager.RegisterStartupScript(this, GetType(), "renderUnivariateExtrusion", "renderUnivariateExtrusion('" + jsonToRender + "','" + ddlUniExtrStat.SelectedValue + "');", true);
                }
                if (ddlUniExtrStat.SelectedValue == "Total")
                {
                    procedure = "USP_Get_Select_TotalCountsByStateByDateRange";
                    parameters = new Hashtable()
                    {
                        {"StartWeek",ddlUniExtrStartYear.SelectedValue.ToString()+"-01-01"},
                        {"EndWeek",ddlUniExtrEndYear.SelectedValue.ToString()+"-12-31"}
                    };
                    String jsonToRender = generateJSONFromDataTable(procedure, parameters);
                    ScriptManager.RegisterStartupScript(this, GetType(), "renderUnivariateExtrusion", "renderUnivariateExtrusion('" + jsonToRender + "','" + ddlUniExtrStat.SelectedValue + "');", true);
                }
            }
            else if (ddlVisType.SelectedValue == "3")
            {
                //procedure = "USP_Get_Select_MeanCountsByStateByDateRange";
                //parameters = new Hashtable()
                //{
                //    {"StartWeek",ddlUniExtrStartYear.SelectedValue.ToString()+"-01-01"},
                //    {"EndWeek",ddlUniExtrEndYear.SelectedValue.ToString()+"-12-31"}
                //};
                //String mosquitoJsonToRender = generateJSONFromDataTable(procedure, parameters);
                //ScriptManager.RegisterStartupScript(this, GetType(), "renderUnivariateExtrusion", "renderUnivariateExtrusion('" + mosquitoJsonToRender + "','" + ddlUniExtrStat.SelectedValue + "');", true);


                //procedure = "USP_Get_Select_TotalCountsByStateByDateRange";
                //parameters = new Hashtable()
                //{
                //    {"StartWeek",ddlUniExtrStartYear.SelectedValue.ToString()+"-01-01"},
                //    {"EndWeek",ddlUniExtrEndYear.SelectedValue.ToString()+"-12-31"}
                //};
                //String weatherJsonToRender = generateJSONFromDataTable(procedure, parameters);
                //ScriptManager.RegisterStartupScript(this, GetType(), "renderUnivariateExtrusion", "renderUnivariateExtrusion('" + weatherJsonToRender + "','" + ddlUniExtrStat.SelectedValue + "');", true);
            }
        }

        protected void generateGeoJsonFromDataTable(String procedure, Hashtable parameters, String geometryType, String fileName)
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
                        
                        StringBuilder geoJson = new StringBuilder();
                        geoJson.Append("{\"type\":\"FeatureCollection\",\"features\":[{");
                        double longitude = 0.0;
                        double latitude = 0.0;
                        foreach (DataRow row in dt.Rows)
                        {
                            geoJson.Append("\"type\":\"Feature\",\"properties\":{");
                            foreach (DataColumn col in dt.Columns)
                            {
                                string columnName = col.ColumnName;
                                string columnValue = row[col.ColumnName].ToString();
                                if (columnName.Equals("Longitude"))
                                {
                                    longitude = Convert.ToDouble(columnValue);
                                    continue;
                                }
                                if (columnName.Equals("Latitude"))
                                {
                                    latitude = Convert.ToDouble(columnValue);
                                    continue;
                                }
                                geoJson.Append("\"" + columnName + "\":\"" + columnValue + "\",");
                            }
                            geoJson.Remove(geoJson.Length - 1, 1);
                            if ("Point".Equals(geometryType))
                            {
                                geoJson.Append("},\"geometry\":{\"type\":\"" + geometryType + "\",\"coordinates\":[" + longitude + ", " + latitude + "]}},{");
                            }
                        }
                        geoJson.Remove(geoJson.Length - 2, 2);
                        geoJson.Append("]}");
                        geoJson.Replace(" 12:00:00 AM", "");

                        //var json = JsonConvert.SerializeObject(dt);
                        using (StreamWriter sr = new StreamWriter(Server.MapPath("/Scripts/GeoJSON/"+fileName)))
                        {
                            sr.Write(geoJson);
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

        protected string generateJSONFromDataTable(String procedure, Hashtable parameters)
        {
            string json = "";
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

                        json = JsonConvert.SerializeObject(dt);
                    }
                }
            }
            catch (Exception ex)
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "alert", "alert('" + ex.Message + "');", true);
            }
            return json;
        }

    }
}