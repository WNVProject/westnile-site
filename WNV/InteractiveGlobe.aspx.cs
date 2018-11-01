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
            //fillPearsonWeekDropdowns();
            

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

                            ddlUniHeatStartYear.DataValueField = "TrapYear";
                            ddlUniHeatEndYear.DataValueField = "TrapYear";
                            ddlUniExtrStartYear.DataValueField = "TrapYear";
                            ddlUniExtrEndYear.DataValueField = "TrapYear";

                            ddlUniHeatStartYear.DataTextField = "TrapYear";
                            ddlUniHeatEndYear.DataTextField = "TrapYear";
                            ddlUniExtrStartYear.DataTextField = "TrapYear";
                            ddlUniExtrEndYear.DataTextField = "TrapYear";

                            ddlUniHeatStartYear.DataBind();
                            ddlUniHeatEndYear.DataBind();
                            ddlUniExtrStartYear.DataBind();
                            ddlUniExtrEndYear.DataBind();

                            ddlUniHeatStartYear.SelectedIndex = 0;
                            ddlUniHeatEndYear.SelectedIndex = ddlUniHeatEndYear.Items.Count - 1;
                            ddlUniExtrStartYear.SelectedIndex = 0;
                            ddlUniExtrEndYear.SelectedIndex = ddlUniHeatEndYear.Items.Count - 1;
                        }

                        //procedure = "USP_Select_WeatherYear";
                        //cmd = new MySqlCommand(procedure, conn);
                        //cmd.CommandType = CommandType.StoredProcedure;

                        //using (MySqlDataAdapter da = new MySqlDataAdapter(cmd))
                        //{
                        //    DataTable dt = new DataTable();
                        //    da.Fill(dt);
                            
                        //    ddlPearsonHeatYear.DataSource = dt;

                        //    ddlPearsonHeatYear.DataValueField = "WeatherYear";

                        //    ddlPearsonHeatYear.DataTextField = "WeatherYear";

                        //    ddlPearsonHeatYear.DataBind();

                        //    ddlPearsonHeatYear.SelectedIndex = 0;
                        //    ddlPearsonHeatYear.SelectedIndex = ddlUniHeatEndYear.Items.Count - 1;
                        //}
                    }
                }
            }
            catch (MySqlException ex)
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "alert", "alert('Could not retrieve Years: " + ex.Message + "');", true);
            }
        }
        protected void fillPearsonWeekDropdowns()
        {
            ddlPearsonWeekStartFill();
            ddlPearsonWeekEndFill();
        }

        protected void ddlPearsonWeekStartFill()
        {
            //try
            //{
            //    using (MySqlConnection conn = new MySqlConnection(cs))
            //    {
            //        var procedure = "USP_Get_Select_WeatherWeekStart";
            //        MySqlCommand cmd = new MySqlCommand(procedure, conn);
            //        cmd.CommandType = CommandType.StoredProcedure;
            //        cmd.Parameters.AddWithValue("WeatherYear", ddlPearsonHeatYear.SelectedValue);

            //        using (MySqlDataAdapter da = new MySqlDataAdapter(cmd))
            //        {
            //            DataTable dt = new DataTable();
            //            da.Fill(dt);
            //            ddlPearsonHeatWeekStart.DataSource = dt;
            //            ddlPearsonHeatWeekStart.DataValueField = "WeekStart";
            //            ddlPearsonHeatWeekStart.DataTextField = "WeekStart";
            //            ddlPearsonHeatWeekStart.DataBind();
            //        }
            //    }
            //}
            //catch (MySqlException ex)
            //{
            //    ScriptManager.RegisterStartupScript(this, GetType(), "alert", "alert('Could not retrieve Start Weeks: " + ex.Message + "');", true);
            //}
        }
        protected void ddlPearsonWeekEndFill()
        {
            //try
            //{
            //    using (MySqlConnection conn = new MySqlConnection(cs))
            //    {
            //        var procedure = "USP_Get_Select_WeatherWeekEnd";
            //        MySqlCommand cmd = new MySqlCommand(procedure, conn);
            //        cmd.CommandType = CommandType.StoredProcedure;
            //        cmd.Parameters.AddWithValue("WeatherYear", ddlPearsonHeatYear.SelectedValue);

            //        using (MySqlDataAdapter da = new MySqlDataAdapter(cmd))
            //        {
            //            DataTable dt = new DataTable();
            //            da.Fill(dt);
            //            ddlPearsonHeatWeekEnd.DataSource = dt;
            //            ddlPearsonHeatWeekEnd.DataValueField = "WeekEnd";
            //            ddlPearsonHeatWeekEnd.DataTextField = "WeekEnd";
            //            ddlPearsonHeatWeekEnd.DataBind();
            //            ddlPearsonHeatWeekEnd.SelectedIndex = ddlPearsonHeatWeekEnd.Items.Count - 1;
            //        }
            //    }
            //}
            //catch (MySqlException ex)
            //{
            //    ScriptManager.RegisterStartupScript(this, GetType(), "alert", "alert('Could not retrieve End Weeks: " + ex.Message + "');", true);
            //}
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
                DataTable counties = new DataTable();
                string currentCounty = "";
                List<double> mosquitoVarDiffsFromAvg = new List<double>();
                List<double> weatherVarDiffsFromAvg = new List<double>();
                List<double> allPearsonCoefficients = new List<double>();
                StringBuilder jsonToRender = new StringBuilder();

                try
                {
                    using (MySqlConnection conn = new MySqlConnection(cs))
                    {
                        procedure = "USP_Select_Counties";
                        MySqlCommand cmd = new MySqlCommand(procedure, conn);
                        cmd.CommandType = CommandType.StoredProcedure;

                        using (MySqlDataAdapter da = new MySqlDataAdapter(cmd))
                        {
                            da.Fill(counties);
                        }
                    }
                }
                catch (MySqlException ex)
                {
                    ScriptManager.RegisterStartupScript(this, GetType(), "alert", "alert('Could not retrieve Counties: " + ex.Message + "');", true);
                }

                jsonToRender.Append("[");
                foreach (DataRow county in counties.Rows)
                {
                    currentCounty = county["CountyName"].ToString();
                    int weekOfInterest = Convert.ToInt32(ddlPearsonHeatWeekOfInterest.Value);
                    string mosquitoVar = ddlPearsonHeatMosquitoVar.Value;
                    string weatherVar = ddlPearsonHeatWeatherVar.Value;
                    DataTable mosquitoDiffsFromAvg = new DataTable();
                    DataTable weatherDiffsFromAvg = new DataTable();

                    try
                    {
                        using (MySqlConnection conn = new MySqlConnection(cs))
                        {
                            procedure = "USP_Get_Select_CountyMosquitoVarDiffFromAvgByWeekOfSummer";
                            MySqlCommand cmd = new MySqlCommand(procedure, conn);
                            cmd.CommandType = CommandType.StoredProcedure;
                            cmd.Parameters.AddWithValue("WeekOfSummer", weekOfInterest);
                            cmd.Parameters.AddWithValue("CountyName", currentCounty);
                            cmd.Parameters.AddWithValue("VariableChosen", mosquitoVar);

                            using (MySqlDataAdapter da = new MySqlDataAdapter(cmd))
                            {
                                da.Fill(mosquitoDiffsFromAvg);
                            }
                        }
                        using (MySqlConnection conn = new MySqlConnection(cs))
                        {
                            procedure = "USP_Get_Select_CountyWeatherVarDiffFromAvgByWeekOfSummer";
                            MySqlCommand cmd = new MySqlCommand(procedure, conn);
                            cmd.CommandType = CommandType.StoredProcedure;
                            cmd.Parameters.AddWithValue("WeekOfSummer", weekOfInterest);
                            cmd.Parameters.AddWithValue("CountyName", currentCounty);
                            cmd.Parameters.AddWithValue("VariableChosen", weatherVar);

                            using (MySqlDataAdapter da = new MySqlDataAdapter(cmd))
                            {
                                da.Fill(weatherDiffsFromAvg);
                            }
                        }
                    }
                    catch (MySqlException ex)
                    {
                        ScriptManager.RegisterStartupScript(this, GetType(), "alert", "alert('Could not retrieve diffs from average: " + ex.Message + "');", true);
                    }

                    bool skipThisCounty = false;
                    int mosquitoRowCount = 0;
                    int weatherRowCount = 0;

                    foreach (DataRow mosquitoRow in mosquitoDiffsFromAvg.Rows)
                    {
                        try
                        {
                            mosquitoVarDiffsFromAvg.Add(Convert.ToDouble(mosquitoRow["DiffFromAvg"]));
                        }
                        catch
                        {
                            skipThisCounty = true;
                        }
                    }
                    foreach (DataRow weatherRow in weatherDiffsFromAvg.Rows)
                    {
                        try
                        {
                            weatherVarDiffsFromAvg.Add(Convert.ToDouble(weatherRow["DiffFromAvg"]));
                        }
                        catch
                        {
                            skipThisCounty = true;
                        }
                    }
                    if (skipThisCounty)
                    {
                        mosquitoVarDiffsFromAvg.Clear();
                        weatherVarDiffsFromAvg.Clear();
                        continue;
                    }

                    mosquitoRowCount = mosquitoVarDiffsFromAvg.Count;
                    weatherRowCount = weatherVarDiffsFromAvg.Count;

                    int leastRowCount = mosquitoRowCount;
                    if (weatherVarDiffsFromAvg.Count < leastRowCount)
                    {
                        leastRowCount = weatherRowCount;
                    }

                    double covariance = 0.0;
                    double mosquitoVariance = 0.0;
                    double weatherVariance = 0.0;
                    double mosquitoStdDeviation = 0.0;
                    double weatherStdDeviation = 0.0;
                    double pearsonCorrelationCoefficient = 0.0;

                    for (int i = 0; i < leastRowCount; i++)
                    {
                        covariance += Math.Round((mosquitoVarDiffsFromAvg[i] * weatherVarDiffsFromAvg[i]), 5);
                        mosquitoVariance += Math.Round(Math.Pow(mosquitoVarDiffsFromAvg[i], 2), 5);
                        weatherVariance += Math.Round(Math.Pow(weatherVarDiffsFromAvg[i], 2), 5);
                    }
                    mosquitoStdDeviation = Math.Sqrt(mosquitoVariance);
                    weatherStdDeviation = Math.Sqrt(weatherVariance);

                    if (mosquitoStdDeviation == 0.0 || weatherStdDeviation == 0.0 || leastRowCount < 3)
                    {
                        skipThisCounty = true;
                    }
                    else
                    {
                        pearsonCorrelationCoefficient = Math.Round(covariance / (mosquitoStdDeviation * weatherStdDeviation), 3);
                        allPearsonCoefficients.Add(pearsonCorrelationCoefficient);
                    }

                    mosquitoVarDiffsFromAvg.Clear();
                    weatherVarDiffsFromAvg.Clear();

                    if (!skipThisCounty)
                    {
                        jsonToRender.Append("{\"name\":\"" + currentCounty + "\",\"WeekOfSummer\":" + weekOfInterest + ",\"MosquitoVar\":\"" + mosquitoVar + "\",\"WeatherVar\":\"" + weatherVar + "\",");
                        jsonToRender.Append("\"MosquitoRowCount\":" + mosquitoRowCount + ",");
                        jsonToRender.Append("\"WeatherRowCount\":" + weatherRowCount + ",");
                        jsonToRender.Append("\"LeastRowCount\":" + leastRowCount + ",");
                        jsonToRender.Append("\"PearsonCoefficient\":\"" + pearsonCorrelationCoefficient + "\"},");
                    }
                }
                double avgPearsonCorrelation = 0.0;
                for (int i = 0; i < allPearsonCoefficients.Count; i++)
                {
                    avgPearsonCorrelation += allPearsonCoefficients[i];
                }
                avgPearsonCorrelation = Math.Round(avgPearsonCorrelation / allPearsonCoefficients.Count, 3);

                jsonToRender.Remove(jsonToRender.Length - 1, 1);
                jsonToRender.Append("]");

                using (StreamWriter sr = new StreamWriter(Server.MapPath("/Scripts/GeoJSON/testPearson.json")))
                {
                    sr.Write(jsonToRender);
                    sr.Dispose();
                    ScriptManager.RegisterStartupScript(this, GetType(), "alert", "alert('Average Pearson Correlation: r = "+avgPearsonCorrelation+"');", true);
                }




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
                //using (StreamWriter sr = new StreamWriter(Server.MapPath("/Scripts/GeoJSON/serializedJsonExample.json")))
                //{
                //    sr.Write(json);
                //    sr.Dispose();
                //}
            }
            catch (Exception ex)
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "alert", "alert('" + ex.Message + "');", true);
            }
            return json;
        }

        protected void ddlPearsonHeatYear_SelectedIndexChanged(object sender, EventArgs e)
        {
            fillPearsonWeekDropdowns();
        }
    }
}