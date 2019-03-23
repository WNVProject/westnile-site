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
    public partial class Treemap : Page
    {
        private string cs = ConfigurationManager.ConnectionStrings["CString"].ConnectionString;
        static string csv = string.Empty;
        static string timeType = "";
        static string sqlType = "";
        
        protected void Page_Load(object sender, EventArgs e)
        {

            string gdv = gradientDropdownValue.Value;
            if (!IsPostBack)
            {
                chkShowLabels.Checked = true;
                chkShowTrackingTooltip.Checked = true;
                ScriptManager.RegisterStartupScript(this, GetType(), "toggleStationaryTooltip", "toggleStationaryTooltip();", true);
                timeType = "Years";
                gradientDropdownValue.Value = "YlGn";
                fillYearDDLs(timeType);
                fillLocationDDL("Counties");
            }
            else
            {
                if (!chkShowLabels.Checked)
                {
                    ScriptManager.RegisterStartupScript(this, GetType(), "toggleLabels", "toggleLabels();", true);
                }
                if (!chkShowTrackingTooltip.Checked)
                {
                    ScriptManager.RegisterStartupScript(this, GetType(), "toggleTrackingTooltip", "toggleTrackingTooltip();", true);
                }
                if (!chkShowStationaryTooltip.Checked)
                {
                    ScriptManager.RegisterStartupScript(this, GetType(), "toggleStationaryTooltip", "toggleStationaryTooltip();", true);
                }
            }
            //ScriptManager.RegisterStartupScript(this, GetType(), "alert", "generateTreeMap(\"" + ddlGradientDropdownValue.SelectedValue + "\",$(\"#valLabelSize\").val());setActiveGradient(\"" + ddlGradientDropdownValue.SelectedValue + "\");updateGradientDropdownToggleBackground(\""+ ddlGradientDropdownValue.SelectedValue + "\"); ", true);
        }


        //TODO - Rework to allow the specific weeks via ddlTimeType
        protected void fillYearDDLs(String type)
        {
            try
            {
                if (IsPostBack || !IsPostBack)
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
                            if (type.Equals("Weeks"))
                            {
                                ddlYearForWeeks.DataSource = dt;
                                ddlYearForWeeks.DataValueField = "TrapYear";
                                ddlYearForWeeks.DataTextField = "TrapYear";
                                ddlYearForWeeks.DataBind();
                                ddlYearForWeeks.SelectedIndex = 0;
                            }
                            else
                            {
                                ddlYearStart.DataSource = dt;
                                ddlYearEnd.DataSource = dt;
                                ddlYearStart.DataValueField = "TrapYear";
                                ddlYearEnd.DataValueField = "TrapYear";
                                ddlYearStart.DataTextField = "TrapYear";
                                ddlYearEnd.DataTextField = "TrapYear";
                                ddlYearStart.DataBind();
                                ddlYearEnd.DataBind();
                                ddlYearStart.SelectedIndex = 0;
                                ddlYearEnd.SelectedIndex = ddlYearEnd.Items.Count - 1;
                            }
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

        protected void fillWeekDDLs()
        {
            {
                try
                {
                    if (IsPostBack)
                    {
                        using (MySqlConnection conn = new MySqlConnection(cs))
                        {

                            var procedure = "USP_Get_Select_TrapWeekStart";
                            MySqlCommand cmd = new MySqlCommand(procedure, conn);
                            cmd.CommandType = CommandType.StoredProcedure;
                            cmd.Parameters.AddWithValue("TrapYear", ddlYearForWeeks.SelectedValue);

                            var procedure2 = "USP_Get_Select_TrapWeekEnd";
                            MySqlCommand cmd2 = new MySqlCommand(procedure2, conn);
                            cmd2.CommandType = CommandType.StoredProcedure;
                            cmd2.Parameters.AddWithValue("TrapYear", ddlYearForWeeks.SelectedValue);

                            using (MySqlDataAdapter da = new MySqlDataAdapter(cmd))
                            {
                                DataTable dt = new DataTable();
                                da.Fill(dt);

                                ddlYearStart.DataSource = dt;
                                ddlYearStart.DataValueField = "TrapWeekStart";
                                ddlYearStart.DataTextField = "TrapWeekStart";
                                ddlYearStart.DataBind();
                                ddlYearStart.SelectedIndex = 0;
                                
                            }

                            using (MySqlDataAdapter da = new MySqlDataAdapter(cmd2))
                            {
                                DataTable dt = new DataTable();
                                da.Fill(dt);

                                ddlYearEnd.DataSource = dt;
                                ddlYearEnd.DataValueField = "TrapWeekEnd";
                                ddlYearEnd.DataTextField = "TrapWeekEnd";
                                ddlYearEnd.DataBind();
                                ddlYearEnd.SelectedIndex = ddlYearEnd.Items.Count - 1;

                            }
                        }
                    }
                }
                catch (MySqlException ex)
                {
                    lblError.Text = "Could not retrieve Weeks: " + ex.ToString();
                    lblError.Visible = true;
                }
            }
        }

        protected void fillLocationDDL(String type)
        {
            try
            {
                using (MySqlConnection conn = new MySqlConnection(cs))
                {
                    var procedure = "USP_Select_" + type;
                    MySqlCommand cmd = new MySqlCommand(procedure, conn);
                    cmd.CommandType = CommandType.StoredProcedure;

                    using (MySqlDataAdapter da = new MySqlDataAdapter(cmd))
                    {
                        DataTable dt = new DataTable();
                        da.Fill(dt);
                        ddlFocusOn.DataSource = dt;
                        if(type.Equals("Counties"))
                        {
                            ddlFocusOn.DataValueField = "TrapCounty";
                            ddlFocusOn.DataTextField = "TrapCounty";
                        }
                        else if (type.Equals("TrapLocations"))
                        {
                            ddlFocusOn.DataValueField = "name";
                            ddlFocusOn.DataTextField = "name";
                        }
                        else if (type.Equals("WeeksOfSummer"))
                        {
                            ddlFocusOn.DataValueField = "Week";
                            ddlFocusOn.DataTextField = "Week";
                        }
                        ddlFocusOn.DataBind();
                        ddlFocusOn.Items.Insert(0,new ListItem("All", "%"));
                        ddlFocusOn.SelectedIndex = 0;
                    }
                }
            }
            catch (MySqlException ex)
            {
                lblError.Text = "Could not retrieve Counties/Traps/Weeks of Summer: " + ex.ToString();
                lblError.Visible = true;
            }
        }

        protected void renderBtn_Click(object sender, EventArgs e)
        {
            //if((ddlColorRepresents.SelectedValue.ToString().Contains("1") && !ddlFocusOn.SelectedValue.ToString().Equals("%") && !ddlSizeRepresents.SelectedValue.ToString().Equals("Species")))
            //{
            //    ScriptManager.RegisterStartupScript(this, GetType(), "alert", "alert('Please select \"All\" in the \"Focus On\" dropdown when doing one specie for optimal results.')", true);
            //    return;
            //}

            if ((ddlColorRepresents.SelectedValue.ToString().Contains("1") && !ddlFocusOn.SelectedValue.ToString().Equals("%") && ddlSizeRepresents.SelectedValue.ToString().Equals("Species")))
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "alert", "alert('Please select \"Species Count\" in the \"Color Represents\" dropdown when doing a single location for optimal results.')", true);
                return;
            }
            System.Diagnostics.Debug.Print(timeType);
            /*
            string strt = "";
            string end = "";
            if (timeType.Equals("Weeks"))
            {
                int index = ddlYearEnd.SelectedValue.ToString().IndexOf(" ");
                if (index >= 0)
                    strt = ddlYearStart.SelectedValue.ToString().Remove(index);

                index = ddlYearEnd.SelectedValue.ToString().IndexOf(" ");
                if (index >= 0)
                    end = ddlYearStart.SelectedValue.ToString().Remove(index);
            }
            */
            if ((ddlSizeRepresents.Text.Contains("Species") && ddlColorRepresents.Text.Contains("Species")) || (ddlSizeRepresents.Text.Contains("Tarsalis") && ddlColorRepresents.Text.Contains("Tarsalis")))
            {
                //TODO - FIX PLS
                //ScriptManager.RegisterStartupScript(this, GetType(), "alert", "alert('Please select only one weather variable in the \"Size Represents\" and \"Color Represents\" dropdowns.')", true);
                //return;
            }
            else if ((!ddlSizeRepresents.Text.Contains("Species") && !ddlColorRepresents.Text.Contains("Species")) || (!ddlSizeRepresents.Text.Contains("Tarsalis") && !ddlColorRepresents.Text.Contains("Tarsalis")))
            {
                //TODO - FIX PLS
                //ScriptManager.RegisterStartupScript(this, GetType(), "alert", "alert('Please select only one weather variable in the \"Size Represents\" and \"Color Represents\" dropdowns.')", true);
                //return;
            }

            csvBtn.Enabled = true;

            Hashtable parameters = new Hashtable();
            if (ddlCategorizeBy.SelectedValue.Equals("TrapLocations"))
            {
                parameters.Add("TrapArea", ddlFocusOn.SelectedValue.ToString());
                sqlType = "TrapLocations";
                if (timeType.Equals("Weeks"))
                {
                    DateTime startWeek = Convert.ToDateTime(ddlYearStart.SelectedValue);
                    DateTime endWeek = Convert.ToDateTime(ddlYearEnd.SelectedValue);
                    string startWeekYear = startWeek.Year.ToString();
                    string startWeekMonth = startWeek.Month.ToString();
                    string startWeekDay = startWeek.Day.ToString();
                    string endWeekYear = endWeek.Year.ToString();
                    string endWeekMonth = endWeek.Month.ToString();
                    string endWeekDay = endWeek.Day.ToString();
                    
                    parameters.Add("StartWeek", startWeekYear + "-" + startWeekMonth + "-" + startWeekDay);
                    parameters.Add("EndWeek", endWeekYear + "-" + endWeekMonth + "-" + endWeekDay);
                }
                else
                {
                    parameters.Add("StartWeek", ddlYearStart.SelectedValue.ToString() + "-01-01");
                    parameters.Add("EndWeek", ddlYearEnd.SelectedValue.ToString() + "-12-31");
                }
                generateTreeMapJson("USP_Get_Select_TreeMapCategorizedByTrap", parameters, "TreeMapData.json");
            }
            else if (ddlCategorizeBy.SelectedValue.Equals("Counties"))
            {
                parameters.Add("TrapCounty", ddlFocusOn.SelectedValue.ToString());
                sqlType = "Counties";
                if (timeType.Equals("Weeks"))
                {
                    DateTime startWeek = Convert.ToDateTime(ddlYearStart.SelectedValue);
                    DateTime endWeek = Convert.ToDateTime(ddlYearEnd.SelectedValue);
                    string startWeekYear = startWeek.Year.ToString();
                    string startWeekMonth = startWeek.Month.ToString();
                    string startWeekDay = startWeek.Day.ToString();
                    string endWeekYear = endWeek.Year.ToString();
                    string endWeekMonth = endWeek.Month.ToString();
                    string endWeekDay = endWeek.Day.ToString();

                    parameters.Add("StartWeek", startWeekYear + "-" + startWeekMonth + "-" + startWeekDay);
                    parameters.Add("EndWeek", endWeekYear + "-" + endWeekMonth + "-" + endWeekDay);
                }
                else
                {
                    parameters.Add("StartWeek", ddlYearStart.SelectedValue.ToString() + "-01-01");
                    parameters.Add("EndWeek", ddlYearEnd.SelectedValue.ToString() + "-12-31");
                }
                generateTreeMapJson("USP_Get_Select_TreeMapCategorizedByCounty", parameters, "TreeMapData.json");
            }
            else if (ddlCategorizeBy.SelectedValue.Equals("WeeksOfSummer"))
            {
                sqlType = "WeeksOfSummer";
                parameters.Add("TrapArea", "%");
                parameters.Add("WeekOfSummer", ddlFocusOn.SelectedValue.ToString());
                parameters.Add("StartWeek", ddlYearStart.SelectedValue.ToString() + "-01-01");
                parameters.Add("EndWeek", ddlYearEnd.SelectedValue.ToString() + "-12-31");
                generateTreeMapJson("USP_Get_Select_TreeMapCategorizedByWeekOfSummerByTrap", parameters, "TreeMapData.json");
            }
            //ScriptManager.RegisterStartupScript(this, GetType(), "alert", "generateTreeMap(\"" + ddlGradientDropdownValue.SelectedValue + "\",$(\"#valLabelSize\").val());setActiveGradient(\"" + ddlGradientDropdownValue.SelectedValue + "\");updateGradientDropdownToggleBackground(\"" + ddlGradientDropdownValue.SelectedValue + "\"); ", true);
        }
        
        protected void generateTreeMapJson(String procedure, Hashtable parameters, String fileName)
        {
            csv = "";
            String sizeBy = ddlSizeRepresents.SelectedValue.TrimEnd('1'); ;
            String colorBy = ddlColorRepresents.SelectedValue.TrimEnd('1');
            String categorizeBy = ddlCategorizeBy.SelectedValue;
            String colorUnit = "";
            String sizeUnit = "";
            String category = "";
            String categoryPlural = "";
            String focusOn = ddlFocusOn.SelectedValue.ToString();

            if (colorBy.Equals("Mean Temp") || colorBy.Equals("Max Temp") || colorBy.Equals("Min Temp") || colorBy.Equals("Bare Soil Temp") || colorBy.Equals("Turf Soil Temp") || colorBy.Equals("Dew Point") || colorBy.Equals("Wind Chill"))
            {
                colorUnit = " (F\x00B0)";
            }
            else if (colorBy.Equals("Mean Wind Speed") || colorBy.Equals("Max Wind Speed"))
            {
                colorUnit = " (mph)";
            }
            else if (colorBy.Equals("Solar Rad"))
            {
                colorUnit = " (W/m\xB2)";
            }
            else if (colorBy.Equals("Rainfall"))
            {
                colorUnit = " (in)";
            }

            if (sizeBy.Equals("Mean Temp") || sizeBy.Equals("Max Temp") || sizeBy.Equals("Min Temp") || sizeBy.Equals("Bare Soil Temp") || sizeBy.Equals("Turf Soil Temp") || sizeBy.Equals("Dew Point") || sizeBy.Equals("Wind Chill"))
            {
                sizeUnit = " (F\x00B0)";
            }
            else if (sizeBy.Equals("Mean Wind Speed") || sizeBy.Equals("Max Wind Speed"))
            {
                sizeUnit = " (mph)";
            }
            else if (sizeBy.Equals("Solar Rad"))
            {
                sizeUnit = " (W/m\xB2)";
            }
            else if (sizeBy.Equals("Rainfall"))
            {
                sizeUnit = " (in)";
            }

            if (categorizeBy.Equals("TrapLocations"))
            {
                category = "Trap";
                categoryPlural = "All Traps";
            }
            else if (categorizeBy.Equals("Counties"))
            {
                category = "County";
                categoryPlural = "All Counties";
            }
            else if (categorizeBy.Equals("WeeksOfSummer"))
            {
                category = "Week";
                categoryPlural = "All Weeks";
            }

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
                            cmd.Parameters.AddWithValue(param.Key.ToString(), param.Value);
                        }
                    }
                    using (MySqlDataAdapter da = new MySqlDataAdapter(cmd))
                    {
                        DataTable dt = new DataTable();
                        da.Fill(dt);
                        foreach(DataColumn column in dt.Columns)
                        {
                            csvColumns(column, sizeBy, colorBy);                       
                        }
                        csv += "\r\n";
                        System.Diagnostics.Debug.WriteLine(csv);
                       
                        
                        StringBuilder treeMapJson = new StringBuilder();
                        treeMapJson.Append("{\"name\":\""+ categoryPlural + "\",\"children\":[{");

                        bool itemHasData = false;
                        int speciesDomainMax = -1;
                        int speciesDomainMin = -1;
                        double weatherDomainMax = -1.0;
                        double weatherDomainMin = -1.0;
                                                               
                        foreach (DataRow row in dt.Rows)
                        {
                            string trapArea = "";
                            string county = "";
                            string week = "";
                            int num;
                            if (categorizeBy.Equals("TrapLocations"))
                            {
                                trapArea = "\"name\":\"" + row["Trap Area"] + "\",\"county\":\"" + row["County"] + "\",\"children\":[{";
                                bool mosquitoTypeAdded = false;
                                foreach (DataColumn col in dt.Columns)
                                {
                                    csvRows(row, col, sizeBy, colorBy);
                                    
                                    string columnName = col.ColumnName;
                                    string columnValue = row[col.ColumnName].ToString();
                                    if (sizeBy.Equals("Species"))
                                    {
                                        if (columnName.Equals("Aedes") || columnName.Equals("Aedes Vexans") || columnName.Equals("Anopheles") || columnName.Equals("Culex") || columnName.Equals("Culex Salinarius") || columnName.Equals("Culex Tarsalis") || columnName.Equals("Culiseta") || columnName.Equals("Other"))
                                        //if (columnName.Equals("Culex Tarsalis"))
                                        {
                                            if (!columnValue.Equals("0") && !columnValue.Equals(""))
                                            {
                                                if (colorBy.Equals("Species"))
                                                {
                                                    if (speciesDomainMax == -1 && speciesDomainMin == -1)
                                                    {
                                                        speciesDomainMax = Int32.Parse(columnValue);
                                                        speciesDomainMin = Int32.Parse(columnValue);
                                                    }
                                                    else if (speciesDomainMax < Int32.Parse(columnValue))
                                                    {
                                                        speciesDomainMax = Int32.Parse(columnValue);
                                                    }
                                                    else if (speciesDomainMin > Int32.Parse(columnValue))
                                                    {
                                                        speciesDomainMin = Int32.Parse(columnValue);
                                                    }
                                                    trapArea = trapArea + "\"name\":\"" + columnName + "\"," + "\"size\":\"" + row[columnName].ToString() + "\"," + "\"colorValue\":\"" + columnValue.ToString() + "\"," + "\"colorUnit\":\"" + "Count" + "\"," + "\"sizeUnit\":\"" + sizeBy + sizeUnit + "\"," + "\"category\":\"" + category + "\"," + "\"categoryPlural\":\"" + categoryPlural + "\"},{";
                                                    mosquitoTypeAdded = true;
                                                    itemHasData = true;
                                                }
                                                else
                                                {
                                                    if (weatherDomainMax == -1 && weatherDomainMin == -1)
                                                    {
                                                        weatherDomainMax = Double.Parse(row[colorBy].ToString());
                                                        weatherDomainMin = Double.Parse(row[colorBy].ToString());
                                                    }
                                                    else if (weatherDomainMax < Double.Parse(row[colorBy].ToString()))
                                                    {
                                                        weatherDomainMax = Double.Parse(row[colorBy].ToString());
                                                    }
                                                    else if (weatherDomainMin > Double.Parse(row[colorBy].ToString()))
                                                    {
                                                        weatherDomainMin = Double.Parse(row[colorBy].ToString());
                                                    }
                                                    if (!colorBy.Equals("Species"))
                                                    {
                                                        trapArea = trapArea + "\"name\":\"" + columnName + "\"," + "\"size\":\"" + columnValue + "\"," + "\"colorValue\":\"" + row[colorBy].ToString() + "\"," + "\"colorUnit\":\"" + colorBy + colorUnit + "\"," + "\"sizeUnit\":\"" + "Count" + "\"," + "\"category\":\"" + category + "\"," + "\"categoryPlural\":\"" + categoryPlural + "\"},{";
                                                    }
                                                    else
                                                    {
                                                        trapArea = trapArea + "\"name\":\"" + columnName + "\"," + "\"size\":\"" + columnValue + "\"," + "\"category\":\"" + category + "\"," + "\"categoryPlural\":\"" + categoryPlural + "\"},{";
                                                    }
                                                    mosquitoTypeAdded = true;
                                                    itemHasData = true;
                                                }
                                            }
                                        }
                                    }
                                    //When size represents a singular specie
                                    else if(!(Int32.TryParse(sizeBy.Substring(sizeBy.Length - 1), out num)) && !ddlColorRepresents.SelectedValue.ToString().Equals("Species"))
                                    {
                                        if (columnName.Equals(sizeBy))
                                        {
                                            if (!columnValue.Equals("0") && !columnValue.Equals(""))
                                            {
                                                colorBy = colorBy.TrimEnd('1');
                                                if (weatherDomainMax == -1 && weatherDomainMin == -1)
                                                {
                                                    weatherDomainMax = Double.Parse(row[colorBy].ToString());
                                                    weatherDomainMin = Double.Parse(row[colorBy].ToString());
                                                }
                                                else if (weatherDomainMax < Double.Parse(row[colorBy].ToString()))
                                                {
                                                    weatherDomainMax = Double.Parse(row[colorBy].ToString());
                                                }
                                                else if (weatherDomainMin > Double.Parse(row[colorBy].ToString()))
                                                {
                                                    weatherDomainMin = Double.Parse(row[colorBy].ToString());
                                                }
                                                if (!colorBy.Equals("Species"))
                                                {
                                                    trapArea = trapArea + "\"name\":\"" + columnName + "\"," + "\"size\":\"" + columnValue + "\"," + "\"colorValue\":\"" + row[colorBy].ToString() + "\"," + "\"colorUnit\":\"" + colorBy + colorUnit + "\"," + "\"sizeUnit\":\"" + "Count" + "\"," + "\"category\":\"" + category + "\"," + "\"categoryPlural\":\"" + categoryPlural + "\"},{";
                                                }
                                                else
                                                {
                                                    trapArea = trapArea + "\"name\":\"" + columnName + "\"," + "\"size\":\"" + columnValue + "\"," + "\"category\":\"" + category + "\"," + "\"categoryPlural\":\"" + categoryPlural + "\"},{";
                                                }
                                                mosquitoTypeAdded = true;
                                                itemHasData = true;
                                            }
                                        }
                                    }
                                    else
                                    {
                                        if (columnName.Equals("Aedes") || columnName.Equals("Aedes Vexans") || columnName.Equals("Anopheles") || columnName.Equals("Culex") || columnName.Equals("Culex Salinarius") || columnName.Equals("Culex Tarsalis") || columnName.Equals("Culiseta") || columnName.Equals("Other"))
                                        //if (columnName.Equals("Culex Tarsalis"))
                                        {
                                            if (!columnValue.Equals("0") && !columnValue.Equals(""))
                                            {
                                                if (speciesDomainMax == -1 && speciesDomainMin == -1)
                                                {
                                                    speciesDomainMax = Int32.Parse(columnValue);
                                                    speciesDomainMin = Int32.Parse(columnValue);
                                                }
                                                else if (speciesDomainMax < Int32.Parse(columnValue))
                                                {
                                                    speciesDomainMax = Int32.Parse(columnValue);
                                                }
                                                else if (speciesDomainMin > Int32.Parse(columnValue))
                                                {
                                                    speciesDomainMin = Int32.Parse(columnValue);
                                                }
                                                if (colorBy.Equals("Species"))
                                                {
                                                    trapArea = trapArea + "\"name\":\"" + columnName + "\"," + "\"size\":\"" + row[sizeBy].ToString() + "\"," + "\"colorValue\":\"" + columnValue.ToString() + "\"," + "\"colorUnit\":\"" + "Count" + "\"," + "\"sizeUnit\":\"" + sizeBy + sizeUnit + "\"," + "\"category\":\"" + category + "\"," + "\"categoryPlural\":\"" + categoryPlural + "\"},{";
                                                }
                                                else
                                                {
                                                    trapArea = trapArea + "\"name\":\"" + columnName + "\"," + "\"size\":\"" + columnValue + "\"," + "\"category\":\"" + category + "\"," + "\"categoryPlural\":\"" + categoryPlural + "\"},{";
                                                }
                                                mosquitoTypeAdded = true;
                                                itemHasData = true;
                                            }
                                        }
                                    }
                                }
                                if (mosquitoTypeAdded)
                                {
                                    treeMapJson.Append(trapArea);
                                    treeMapJson.Remove(treeMapJson.Length - 2, 2);
                                    treeMapJson.Append("]},{");
                                }
                            }
                            else if (categorizeBy.Equals("Counties"))
                            {
                                county = "\"name\":\"" + row["County"] + "\",\"children\":[{";
                                bool mosquitoTypeAdded = false;
                                foreach (DataColumn col in dt.Columns)
                                {
                                    csvRows(row, col, sizeBy, colorBy);

                                    string columnName = col.ColumnName;
                                    string columnValue = row[col.ColumnName].ToString();
                                    if (sizeBy.Equals("Species"))
                                    {
                                        if (columnName.Equals("Aedes") || columnName.Equals("Aedes Vexans") || columnName.Equals("Anopheles") || columnName.Equals("Culex") || columnName.Equals("Culex Salinarius") || columnName.Equals("Culex Tarsalis") || columnName.Equals("Culiseta") || columnName.Equals("Other"))
                                        //if (columnName.Equals("Culex Tarsalis"))
                                        {
                                            if (!columnValue.Equals("0") && !columnValue.Equals(""))
                                            {
                                                if (colorBy.Equals("Species"))
                                                {
                                                    if (speciesDomainMax == -1 && speciesDomainMin == -1)
                                                    {
                                                        speciesDomainMax = Int32.Parse(columnValue);
                                                        speciesDomainMin = Int32.Parse(columnValue);
                                                    }
                                                    else if (speciesDomainMax < Int32.Parse(columnValue))
                                                    {
                                                        speciesDomainMax = Int32.Parse(columnValue);
                                                    }
                                                    else if (speciesDomainMin > Int32.Parse(columnValue))
                                                    {
                                                        speciesDomainMin = Int32.Parse(columnValue);
                                                    }
                                                    county = county + "\"name\":\"" + columnName + "\"," + "\"size\":\"" + row[columnName].ToString() + "\"," + "\"colorValue\":\"" + columnValue.ToString() + "\"," + "\"colorUnit\":\"" + "Count" + "\"," + "\"sizeUnit\":\"" + sizeBy + sizeUnit + "\"," + "\"category\":\"" + category + "\"," + "\"categoryPlural\":\"" + categoryPlural + "\"},{";
                                                    mosquitoTypeAdded = true;
                                                    itemHasData = true;
                                                }
                                                else
                                                {
                                                    if (weatherDomainMax == -1 && weatherDomainMin == -1)
                                                    {
                                                        weatherDomainMax = Double.Parse(row[colorBy].ToString());
                                                        weatherDomainMin = Double.Parse(row[colorBy].ToString());
                                                    }
                                                    else if (weatherDomainMax < Double.Parse(row[colorBy].ToString()))
                                                    {
                                                        weatherDomainMax = Double.Parse(row[colorBy].ToString());
                                                    }
                                                    else if (weatherDomainMin > Double.Parse(row[colorBy].ToString()))
                                                    {
                                                        weatherDomainMin = Double.Parse(row[colorBy].ToString());
                                                    }
                                                    if (!colorBy.Equals("Species"))
                                                    {
                                                        county = county + "\"name\":\"" + columnName + "\"," + "\"size\":\"" + columnValue + "\"," + "\"colorValue\":\"" + row[colorBy].ToString() + "\"," + "\"colorUnit\":\"" + colorBy + colorUnit + "\"," + "\"sizeUnit\":\"" + "Count" + "\"," + "\"category\":\"" + category + "\"," + "\"categoryPlural\":\"" + categoryPlural + "\"},{";
                                                    }
                                                    else
                                                    {
                                                        county = county + "\"name\":\"" + columnName + "\"," + "\"size\":\"" + columnValue + "\"," + "\"category\":\"" + category + "\"," + "\"categoryPlural\":\"" + categoryPlural + "\"},{";
                                                    }
                                                    mosquitoTypeAdded = true;
                                                    itemHasData = true;
                                                }
                                            }
                                        }
                                    }
                                    //When size represents a singular specie
                                    else if (!(Int32.TryParse(sizeBy.Substring(sizeBy.Length - 1), out num)) && !ddlColorRepresents.SelectedValue.ToString().Equals("Species"))
                                    {
                                        if (columnName.Equals(sizeBy))
                                        {
                                            if (!columnValue.Equals("0") && !columnValue.Equals(""))
                                            {
                                                colorBy = colorBy.TrimEnd('1');
                                                if (weatherDomainMax == -1 && weatherDomainMin == -1)
                                                {
                                                    weatherDomainMax = Double.Parse(row[colorBy].ToString());
                                                    weatherDomainMin = Double.Parse(row[colorBy].ToString());
                                                }
                                                else if (weatherDomainMax < Double.Parse(row[colorBy].ToString()))
                                                {
                                                    weatherDomainMax = Double.Parse(row[colorBy].ToString());
                                                }
                                                else if (weatherDomainMin > Double.Parse(row[colorBy].ToString()))
                                                {
                                                    weatherDomainMin = Double.Parse(row[colorBy].ToString());
                                                }
                                                if (!colorBy.Equals("Species"))
                                                {
                                                    county = county + "\"name\":\"" + columnName + "\"," + "\"size\":\"" + columnValue + "\"," + "\"colorValue\":\"" + row[colorBy].ToString() + "\"," + "\"colorUnit\":\"" + colorBy + colorUnit + "\"," + "\"sizeUnit\":\"" + "Count" + "\"," + "\"category\":\"" + category + "\"," + "\"categoryPlural\":\"" + categoryPlural + "\"},{";
                                                }
                                                else
                                                {
                                                    county = county + "\"name\":\"" + columnName + "\"," + "\"size\":\"" + columnValue + "\"," + "\"category\":\"" + category + "\"," + "\"categoryPlural\":\"" + categoryPlural + "\"},{";
                                                }
                                                mosquitoTypeAdded = true;
                                                itemHasData = true;
                                            }
                                        }
                                    }
                                    else
                                    {
                                        if (columnName.Equals("Aedes") || columnName.Equals("Aedes Vexans") || columnName.Equals("Anopheles") || columnName.Equals("Culex") || columnName.Equals("Culex Salinarius") || columnName.Equals("Culex Tarsalis") || columnName.Equals("Culiseta") || columnName.Equals("Other"))
                                        //if (columnName.Equals("Culex Tarsalis"))
                                        {
                                            if (!columnValue.Equals("0") && !columnValue.Equals(""))
                                            {
                                                if (speciesDomainMax == -1 && speciesDomainMin == -1)
                                                {
                                                    speciesDomainMax = Int32.Parse(columnValue);
                                                    speciesDomainMin = Int32.Parse(columnValue);
                                                }
                                                else if (speciesDomainMax < Int32.Parse(columnValue))
                                                {
                                                    speciesDomainMax = Int32.Parse(columnValue);
                                                }
                                                else if (speciesDomainMin > Int32.Parse(columnValue))
                                                {
                                                    speciesDomainMin = Int32.Parse(columnValue);
                                                }
                                                if (colorBy.Equals("Species"))
                                                {
                                                    county = county + "\"name\":\"" + columnName + "\"," + "\"size\":\"" + row[sizeBy].ToString() + "\"," + "\"colorValue\":\"" + columnValue.ToString() + "\"," + "\"colorUnit\":\"" + "Count" + "\"," + "\"sizeUnit\":\"" + sizeBy + sizeUnit + "\"," + "\"category\":\"" + category + "\"," + "\"categoryPlural\":\"" + categoryPlural + "\"},{";
                                                }
                                                else
                                                {
                                                    county = county + "\"name\":\"" + columnName + "\"," + "\"size\":\"" + columnValue + "\"," + "\"category\":\"" + category + "\"," + "\"categoryPlural\":\"" + categoryPlural + "\"},{";
                                                }
                                                mosquitoTypeAdded = true;
                                                itemHasData = true;
                                            }
                                        }
                                    }
                                }
                                if (mosquitoTypeAdded)
                                {
                                    treeMapJson.Append(county);
                                    treeMapJson.Remove(treeMapJson.Length - 2, 2);
                                    treeMapJson.Append("]},{");
                                }
                            }
                            else if (categorizeBy.Equals("WeeksOfSummer"))
                            {
                                week = "\"name\":\"" + "Week " + row["Trap Week Of Summer"] + "\",\"children\":[{";
                                bool mosquitoTypeAdded = false;
                                foreach (DataColumn col in dt.Columns)
                                {
                                    csvRows(row, col, sizeBy, colorBy);

                                    string columnName = col.ColumnName;
                                    string columnValue = row[col.ColumnName].ToString();
                                    if (sizeBy.Equals("Species"))
                                    {
                                        if (columnName.Equals("Aedes") || columnName.Equals("Aedes Vexans") || columnName.Equals("Anopheles") || columnName.Equals("Culex") || columnName.Equals("Culex Salinarius") || columnName.Equals("Culex Tarsalis") || columnName.Equals("Culiseta") || columnName.Equals("Other"))
                                        //if (columnName.Equals("Culex Tarsalis"))
                                        {
                                            if (!columnValue.Equals("0") && !columnValue.Equals(""))
                                            {
                                                if (colorBy.Equals("Species"))
                                                {
                                                    if (speciesDomainMax == -1 && speciesDomainMin == -1)
                                                    {
                                                        speciesDomainMax = Int32.Parse(columnValue);
                                                        speciesDomainMin = Int32.Parse(columnValue);
                                                    }
                                                    else if (speciesDomainMax < Int32.Parse(columnValue))
                                                    {
                                                        speciesDomainMax = Int32.Parse(columnValue);
                                                    }
                                                    else if (speciesDomainMin > Int32.Parse(columnValue))
                                                    {
                                                        speciesDomainMin = Int32.Parse(columnValue);
                                                    }
                                                    week = week + "\"name\":\"" + columnName + "\"," + "\"size\":\"" + row[columnName].ToString() + "\"," + "\"colorValue\":\"" + columnValue.ToString() + "\"," + "\"colorUnit\":\"" + "Count" + "\"," + "\"sizeUnit\":\"" + sizeBy + sizeUnit + "\"," + "\"category\":\"" + category + "\"," + "\"categoryPlural\":\"" + categoryPlural + "\"},{";
                                                    mosquitoTypeAdded = true;
                                                    itemHasData = true;
                                                }
                                                else
                                                {
                                                    if (weatherDomainMax == -1 && weatherDomainMin == -1)
                                                    {
                                                        weatherDomainMax = Double.Parse(row[colorBy].ToString());
                                                        weatherDomainMin = Double.Parse(row[colorBy].ToString());
                                                    }
                                                    else if (weatherDomainMax < Double.Parse(row[colorBy].ToString()))
                                                    {
                                                        weatherDomainMax = Double.Parse(row[colorBy].ToString());
                                                    }
                                                    else if (weatherDomainMin > Double.Parse(row[colorBy].ToString()))
                                                    {
                                                        weatherDomainMin = Double.Parse(row[colorBy].ToString());
                                                    }
                                                    if (!colorBy.Equals("Species"))
                                                    {
                                                        week = week + "\"name\":\"" + columnName + "\"," + "\"size\":\"" + columnValue + "\"," + "\"colorValue\":\"" + row[colorBy].ToString() + "\"," + "\"colorUnit\":\"" + colorBy + colorUnit + "\"," + "\"sizeUnit\":\"" + "Count" + "\"," + "\"category\":\"" + category + "\"," + "\"categoryPlural\":\"" + categoryPlural + "\"},{";
                                                    }
                                                    else
                                                    {
                                                        week = week + "\"name\":\"" + columnName + "\"," + "\"size\":\"" + columnValue + "\"," + "\"category\":\"" + category + "\"," + "\"categoryPlural\":\"" + categoryPlural + "\"},{";
                                                    }
                                                    mosquitoTypeAdded = true;
                                                    itemHasData = true;
                                                }
                                            }
                                        }
                                    }
                                    //When size represents a singular specie
                                    else if (!(Int32.TryParse(sizeBy.Substring(sizeBy.Length - 1), out num)) && !ddlColorRepresents.SelectedValue.ToString().Equals("Species"))
                                    {
                                        if (columnName.Equals(sizeBy))
                                        {
                                            if (!columnValue.Equals("0") && !columnValue.Equals(""))
                                            {
                                                colorBy = colorBy.TrimEnd('1');
                                                if (weatherDomainMax == -1 && weatherDomainMin == -1)
                                                {
                                                    weatherDomainMax = Double.Parse(row[colorBy].ToString());
                                                    weatherDomainMin = Double.Parse(row[colorBy].ToString());
                                                }
                                                else if (weatherDomainMax < Double.Parse(row[colorBy].ToString()))
                                                {
                                                    weatherDomainMax = Double.Parse(row[colorBy].ToString());
                                                }
                                                else if (weatherDomainMin > Double.Parse(row[colorBy].ToString()))
                                                {
                                                    weatherDomainMin = Double.Parse(row[colorBy].ToString());
                                                }
                                                if (!colorBy.Equals("Species"))
                                                {
                                                    week = week + "\"name\":\"" + columnName + "\"," + "\"size\":\"" + columnValue + "\"," + "\"colorValue\":\"" + row[colorBy].ToString() + "\"," + "\"colorUnit\":\"" + colorBy + colorUnit + "\"," + "\"sizeUnit\":\"" + "Count" + "\"," + "\"category\":\"" + category + "\"," + "\"categoryPlural\":\"" + categoryPlural + "\"},{";
                                                }
                                                else
                                                {
                                                    week = week + "\"name\":\"" + columnName + "\"," + "\"size\":\"" + columnValue + "\"," + "\"category\":\"" + category + "\"," + "\"categoryPlural\":\"" + categoryPlural + "\"},{";
                                                }
                                                mosquitoTypeAdded = true;
                                                itemHasData = true;
                                            }
                                        }
                                    }
                                    else
                                    {
                                        if (columnName.Equals("Aedes") || columnName.Equals("Aedes Vexans") || columnName.Equals("Anopheles") || columnName.Equals("Culex") || columnName.Equals("Culex Salinarius") || columnName.Equals("Culex Tarsalis") || columnName.Equals("Culiseta") || columnName.Equals("Other"))
                                        //if (columnName.Equals("Culex Tarsalis"))
                                        {
                                            if (!columnValue.Equals("0") && !columnValue.Equals(""))
                                            {
                                                if (speciesDomainMax == -1 && speciesDomainMin == -1)
                                                {
                                                    speciesDomainMax = Int32.Parse(columnValue);
                                                    speciesDomainMin = Int32.Parse(columnValue);
                                                }
                                                else if (speciesDomainMax < Int32.Parse(columnValue))
                                                {
                                                    speciesDomainMax = Int32.Parse(columnValue);
                                                }
                                                else if (speciesDomainMin > Int32.Parse(columnValue))
                                                {
                                                    speciesDomainMin = Int32.Parse(columnValue);
                                                }
                                                if (colorBy.Equals("Species"))
                                                {
                                                    week = week + "\"name\":\"" + columnName + "\"," + "\"size\":\"" + row[sizeBy].ToString() + "\"," + "\"colorValue\":\"" + columnValue.ToString() + "\"," + "\"colorUnit\":\"" + "Count" + "\"," + "\"sizeUnit\":\"" + sizeBy + sizeUnit + "\"," + "\"category\":\"" + category + "\"," + "\"categoryPlural\":\"" + categoryPlural + "\"},{";
                                                }
                                                else
                                                {
                                                    week = week + "\"name\":\"" + columnName + "\"," + "\"size\":\"" + columnValue + "\"," + "\"category\":\"" + category + "\"," + "\"categoryPlural\":\"" + categoryPlural + "\"},{";
                                                }
                                                mosquitoTypeAdded = true;
                                                itemHasData = true;
                                            }
                                        }
                                    }
                                }
                                if (mosquitoTypeAdded)
                                {
                                    treeMapJson.Append(week);
                                    treeMapJson.Remove(treeMapJson.Length - 2, 2);
                                    treeMapJson.Append("]},{");
                                }
                            }
                            csv += "\r\n";
                        }
                        treeMapJson.Remove(treeMapJson.Length - 2, 2);
                        if (colorBy.Equals("Species"))
                        {
                            treeMapJson.Append("],\"max\":\"" + speciesDomainMax + "\"," + "\"min\":\"" + speciesDomainMin + "\"," + "\"colorUnit\":\"" + colorUnit + "\"}");
                        }
                        else
                        {
                            treeMapJson.Append("],\"max\":\"" + weatherDomainMax + "\"," + "\"min\":\"" + weatherDomainMin + "\"," + "\"colorUnit\":\"" + colorUnit + "\"}");
                        }

                        if (itemHasData)
                        {
                            hfTreeMapJSON.Value = treeMapJson.ToString();
                        }
                        else
                        {
                            hfTreeMapJSON.Value = "";
                            ScriptManager.RegisterStartupScript(this, GetType(), "alert", "alert('No data exists for these parameters.');", true);
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "alert", "alert('" + ex.Message + "');", true);
            }
        }

        private void csvColumns(DataColumn column, string sizeBy, string colorBy)
        {
            if (sqlType.Equals("TrapLocations"))
            {
                if (column.ColumnName.Equals("Trap Area"))
                    csv += Regex.Replace(column.ColumnName, @"\s+", "") + ',';
                if (column.ColumnName.Equals("County"))
                    csv += Regex.Replace(column.ColumnName, @"\s+", "") + ',';

                if (sizeBy.Equals("Species"))
                {
                    if (column.ColumnName.Equals("Aedes"))
                        csv += Regex.Replace(column.ColumnName, @"\s+", "") + ',';
                    if (column.ColumnName.Equals("Aedes Vexans"))
                        csv += Regex.Replace(column.ColumnName, @"\s+", "") + ',';
                    if (column.ColumnName.Equals("Anopheles"))
                        csv += Regex.Replace(column.ColumnName, @"\s+", "") + ',';
                    if (column.ColumnName.Equals("Culex"))
                        csv += Regex.Replace(column.ColumnName, @"\s+", "") + ',';
                    if (column.ColumnName.Equals("Culex Salinarius"))
                        csv += Regex.Replace(column.ColumnName, @"\s+", "") + ',';
                    if (column.ColumnName.Equals("Culex Tarsalis"))
                        csv += Regex.Replace(column.ColumnName, @"\s+", "") + ',';
                    if (column.ColumnName.Equals("Culiseta"))
                        csv += Regex.Replace(column.ColumnName, @"\s+", "") + ',';
                    if (column.ColumnName.Equals("Other"))
                        csv += Regex.Replace(column.ColumnName, @"\s+", "") + ',';
                }
                else
                {
                    if (column.ColumnName.Equals(sizeBy))
                        csv += Regex.Replace(column.ColumnName, @"\s+", "") + ',';
                }

                if (colorBy.Equals("Species") && sizeBy.Equals("Species"))
                {
                    //Do nothing, since species already enetered before
                }
                else
                {
                    if (colorBy.Equals("Species"))
                    {
                        if (column.ColumnName.Equals("Aedes"))
                            csv += Regex.Replace(column.ColumnName, @"\s+", "") + ',';
                        if (column.ColumnName.Equals("Aedes Vexans"))
                            csv += Regex.Replace(column.ColumnName, @"\s+", "") + ',';
                        if (column.ColumnName.Equals("Anopheles"))
                            csv += Regex.Replace(column.ColumnName, @"\s+", "") + ',';
                        if (column.ColumnName.Equals("Culex"))
                            csv += Regex.Replace(column.ColumnName, @"\s+", "") + ',';
                        if (column.ColumnName.Equals("Culex Salinarius"))
                            csv += Regex.Replace(column.ColumnName, @"\s+", "") + ',';
                        if (column.ColumnName.Equals("Culex Tarsalis"))
                            csv += Regex.Replace(column.ColumnName, @"\s+", "") + ',';
                        if (column.ColumnName.Equals("Culiseta"))
                            csv += Regex.Replace(column.ColumnName, @"\s+", "") + ',';
                        if (column.ColumnName.Equals("Other"))
                            csv += Regex.Replace(column.ColumnName, @"\s+", "") + ',';
                    }
                    else
                    {
                        if (column.ColumnName.Equals(colorBy))
                            csv += Regex.Replace(column.ColumnName, @"\s+", "") + ',';
                    }
                }

            }
            else if (sqlType.Equals("Counties"))
            {
                if (column.ColumnName.Equals("County"))
                    csv += Regex.Replace(column.ColumnName, @"\s+", "") + ',';

                if (sizeBy.Equals("Species"))
                {
                    if (column.ColumnName.Equals("Aedes"))
                        csv += Regex.Replace(column.ColumnName, @"\s+", "") + ',';
                    if (column.ColumnName.Equals("Aedes Vexans"))
                        csv += Regex.Replace(column.ColumnName, @"\s+", "") + ',';
                    if (column.ColumnName.Equals("Anopheles"))
                        csv += Regex.Replace(column.ColumnName, @"\s+", "") + ',';
                    if (column.ColumnName.Equals("Culex"))
                        csv += Regex.Replace(column.ColumnName, @"\s+", "") + ',';
                    if (column.ColumnName.Equals("Culex Salinarius"))
                        csv += Regex.Replace(column.ColumnName, @"\s+", "") + ',';
                    if (column.ColumnName.Equals("Culex Tarsalis"))
                        csv += Regex.Replace(column.ColumnName, @"\s+", "") + ',';
                    if (column.ColumnName.Equals("Culiseta"))
                        csv += Regex.Replace(column.ColumnName, @"\s+", "") + ',';
                    if (column.ColumnName.Equals("Other"))
                        csv += Regex.Replace(column.ColumnName, @"\s+", "") + ',';
                }
                else
                {
                    if (column.ColumnName.Equals(sizeBy))
                        csv += Regex.Replace(column.ColumnName, @"\s+", "") + ',';
                }

                if (colorBy.Equals("Species") && sizeBy.Equals("Species"))
                {
                    //Do nothing, since species already enetered before
                }
                else
                {
                    if (colorBy.Equals("Species"))
                    {
                        if (column.ColumnName.Equals("Aedes"))
                            csv += Regex.Replace(column.ColumnName, @"\s+", "") + ',';
                        if (column.ColumnName.Equals("Aedes Vexans"))
                            csv += Regex.Replace(column.ColumnName, @"\s+", "") + ',';
                        if (column.ColumnName.Equals("Anopheles"))
                            csv += Regex.Replace(column.ColumnName, @"\s+", "") + ',';
                        if (column.ColumnName.Equals("Culex"))
                            csv += Regex.Replace(column.ColumnName, @"\s+", "") + ',';
                        if (column.ColumnName.Equals("Culex Salinarius"))
                            csv += Regex.Replace(column.ColumnName, @"\s+", "") + ',';
                        if (column.ColumnName.Equals("Culex Tarsalis"))
                            csv += Regex.Replace(column.ColumnName, @"\s+", "") + ',';
                        if (column.ColumnName.Equals("Culiseta"))
                            csv += Regex.Replace(column.ColumnName, @"\s+", "") + ',';
                        if (column.ColumnName.Equals("Other"))
                            csv += Regex.Replace(column.ColumnName, @"\s+", "") + ',';
                    }
                    else
                    {
                        if (column.ColumnName.Equals(colorBy))
                            csv += Regex.Replace(column.ColumnName, @"\s+", "") + ',';
                    }
                }

            }
            else if (sqlType.Equals("WeeksOfSummer"))
            {
                if (column.ColumnName.Equals("Trap Week Of Summer"))
                    csv += "WeekOfSummer" + ',';

                if (sizeBy.Equals("Species"))
                {
                    if (column.ColumnName.Equals("Aedes"))
                        csv += Regex.Replace(column.ColumnName, @"\s+", "") + ',';
                    if (column.ColumnName.Equals("Aedes Vexans"))
                        csv += Regex.Replace(column.ColumnName, @"\s+", "") + ',';
                    if (column.ColumnName.Equals("Anopheles"))
                        csv += Regex.Replace(column.ColumnName, @"\s+", "") + ',';
                    if (column.ColumnName.Equals("Culex"))
                        csv += Regex.Replace(column.ColumnName, @"\s+", "") + ',';
                    if (column.ColumnName.Equals("Culex Salinarius"))
                        csv += Regex.Replace(column.ColumnName, @"\s+", "") + ',';
                    if (column.ColumnName.Equals("Culex Tarsalis"))
                        csv += Regex.Replace(column.ColumnName, @"\s+", "") + ',';
                    if (column.ColumnName.Equals("Culiseta"))
                        csv += Regex.Replace(column.ColumnName, @"\s+", "") + ',';
                    if (column.ColumnName.Equals("Other"))
                        csv += Regex.Replace(column.ColumnName, @"\s+", "") + ',';
                }
                else
                {
                    if (column.ColumnName.Equals(sizeBy))
                        csv += Regex.Replace(column.ColumnName, @"\s+", "") + ',';
                }

                if (colorBy.Equals("Species") && sizeBy.Equals("Species"))
                {
                    //Do nothing, since species already enetered before
                }
                else
                {
                    if (colorBy.Equals("Species"))
                    {
                        if (column.ColumnName.Equals("Aedes"))
                            csv += Regex.Replace(column.ColumnName, @"\s+", "") + ',';
                        if (column.ColumnName.Equals("Aedes Vexans"))
                            csv += Regex.Replace(column.ColumnName, @"\s+", "") + ',';
                        if (column.ColumnName.Equals("Anopheles"))
                            csv += Regex.Replace(column.ColumnName, @"\s+", "") + ',';
                        if (column.ColumnName.Equals("Culex"))
                            csv += Regex.Replace(column.ColumnName, @"\s+", "") + ',';
                        if (column.ColumnName.Equals("Culex Salinarius"))
                            csv += Regex.Replace(column.ColumnName, @"\s+", "") + ',';
                        if (column.ColumnName.Equals("Culex Tarsalis"))
                            csv += Regex.Replace(column.ColumnName, @"\s+", "") + ',';
                        if (column.ColumnName.Equals("Culiseta"))
                            csv += Regex.Replace(column.ColumnName, @"\s+", "") + ',';
                        if (column.ColumnName.Equals("Other"))
                            csv += Regex.Replace(column.ColumnName, @"\s+", "") + ',';
                    }
                    else
                    {
                        if (column.ColumnName.Equals(colorBy))
                            csv += Regex.Replace(column.ColumnName, @"\s+", "") + ',';
                    }
                }

            }
        }

        private void csvRows(DataRow row, DataColumn col, string sizeBy, string colorBy)
        {
            if (sqlType.Equals("TrapLocations"))
            {
                if (col.ColumnName.Equals("Trap Area"))
                    csv += row[col.ColumnName].ToString().Replace(",", ";") + ',';
                if (col.ColumnName.Equals("County"))
                    csv += row[col.ColumnName].ToString().Replace(",", ";") + ',';

                if (sizeBy.Equals("Species"))
                {
                    if (col.ColumnName.Equals("Aedes"))
                        csv += row[col.ColumnName].ToString().Replace(",", ";") + ',';
                    if (col.ColumnName.Equals("Aedes Vexans"))
                        csv += row[col.ColumnName].ToString().Replace(",", ";") + ',';
                    if (col.ColumnName.Equals("Anopheles"))
                        csv += row[col.ColumnName].ToString().Replace(",", ";") + ',';
                    if (col.ColumnName.Equals("Culex"))
                        csv += row[col.ColumnName].ToString().Replace(",", ";") + ',';
                    if (col.ColumnName.Equals("Culex Salinarius"))
                        csv += row[col.ColumnName].ToString().Replace(",", ";") + ',';
                    if (col.ColumnName.Equals("Culex Tarsalis"))
                        csv += row[col.ColumnName].ToString().Replace(",", ";") + ',';
                    if (col.ColumnName.Equals("Culiseta"))
                        csv += row[col.ColumnName].ToString().Replace(",", ";") + ',';
                    if (col.ColumnName.Equals("Other"))
                        csv += row[col.ColumnName].ToString().Replace(",", ";") + ',';
                }
                else
                {
                    if (col.ColumnName.Equals(sizeBy))
                        csv += row[col.ColumnName].ToString().Replace(",", ";") + ',';
                }

                if (colorBy.Equals("Species") && sizeBy.Equals("Species"))
                {
                    //Do nothing, since species already enetered before
                }
                else
                {
                    if (colorBy.Equals("Species"))
                    {
                        if (col.ColumnName.Equals("Aedes"))
                            csv += row[col.ColumnName].ToString().Replace(",", ";") + ',';
                        if (col.ColumnName.Equals("Aedes Vexans"))
                            csv += row[col.ColumnName].ToString().Replace(",", ";") + ',';
                        if (col.ColumnName.Equals("Anopheles"))
                            csv += row[col.ColumnName].ToString().Replace(",", ";") + ',';
                        if (col.ColumnName.Equals("Culex"))
                            csv += row[col.ColumnName].ToString().Replace(",", ";") + ',';
                        if (col.ColumnName.Equals("Culex Salinarius"))
                            csv += row[col.ColumnName].ToString().Replace(",", ";") + ',';
                        if (col.ColumnName.Equals("Culex Tarsalis"))
                            csv += row[col.ColumnName].ToString().Replace(",", ";") + ',';
                        if (col.ColumnName.Equals("Culiseta"))
                            csv += row[col.ColumnName].ToString().Replace(",", ";") + ',';
                        if (col.ColumnName.Equals("Other"))
                            csv += row[col.ColumnName].ToString().Replace(",", ";") + ',';
                    }
                    else
                    {
                        if (col.ColumnName.Equals(colorBy))
                            csv += row[col.ColumnName].ToString().Replace(",", ";") + ',';
                    }
                }
            }
            else if(sqlType.Equals("Counties")) {
                if (col.ColumnName.Equals("County"))
                    csv += row[col.ColumnName].ToString().Replace(",", ";") + ',';

                if (sizeBy.Equals("Species"))
                {
                    if (col.ColumnName.Equals("Aedes"))
                        csv += row[col.ColumnName].ToString().Replace(",", ";") + ',';
                    if (col.ColumnName.Equals("Aedes Vexans"))
                        csv += row[col.ColumnName].ToString().Replace(",", ";") + ',';
                    if (col.ColumnName.Equals("Anopheles"))
                        csv += row[col.ColumnName].ToString().Replace(",", ";") + ',';
                    if (col.ColumnName.Equals("Culex"))
                        csv += row[col.ColumnName].ToString().Replace(",", ";") + ',';
                    if (col.ColumnName.Equals("Culex Salinarius"))
                        csv += row[col.ColumnName].ToString().Replace(",", ";") + ',';
                    if (col.ColumnName.Equals("Culex Tarsalis"))
                        csv += row[col.ColumnName].ToString().Replace(",", ";") + ',';
                    if (col.ColumnName.Equals("Culiseta"))
                        csv += row[col.ColumnName].ToString().Replace(",", ";") + ',';
                    if (col.ColumnName.Equals("Other"))
                        csv += row[col.ColumnName].ToString().Replace(",", ";") + ',';
                }
                else
                {
                    if (col.ColumnName.Equals(sizeBy))
                        csv += row[col.ColumnName].ToString().Replace(",", ";") + ',';
                }

                if (colorBy.Equals("Species") && sizeBy.Equals("Species"))
                {
                    //Do nothing, since species already enetered before
                }
                else
                {
                    if (colorBy.Equals("Species"))
                    {
                        if (col.ColumnName.Equals("Aedes"))
                            csv += row[col.ColumnName].ToString().Replace(",", ";") + ',';
                        if (col.ColumnName.Equals("Aedes Vexans"))
                            csv += row[col.ColumnName].ToString().Replace(",", ";") + ',';
                        if (col.ColumnName.Equals("Anopheles"))
                            csv += row[col.ColumnName].ToString().Replace(",", ";") + ',';
                        if (col.ColumnName.Equals("Culex"))
                            csv += row[col.ColumnName].ToString().Replace(",", ";") + ',';
                        if (col.ColumnName.Equals("Culex Salinarius"))
                            csv += row[col.ColumnName].ToString().Replace(",", ";") + ',';
                        if (col.ColumnName.Equals("Culex Tarsalis"))
                            csv += row[col.ColumnName].ToString().Replace(",", ";") + ',';
                        if (col.ColumnName.Equals("Culiseta"))
                            csv += row[col.ColumnName].ToString().Replace(",", ";") + ',';
                        if (col.ColumnName.Equals("Other"))
                            csv += row[col.ColumnName].ToString().Replace(",", ";") + ',';
                    }
                    else
                    {
                        if (col.ColumnName.Equals(colorBy))
                            csv += row[col.ColumnName].ToString().Replace(",", ";") + ',';
                    }
                }
            }
            else if (sqlType.Equals("WeeksOfSummer"))
            {
                if (col.ColumnName.Equals("Trap Week Of Summer"))
                    csv += row[col.ColumnName].ToString().Replace(",", ";") + ',';

                if (sizeBy.Equals("Species"))
                {
                    if (col.ColumnName.Equals("Aedes"))
                        csv += row[col.ColumnName].ToString().Replace(",", ";") + ',';
                    if (col.ColumnName.Equals("Aedes Vexans"))
                        csv += row[col.ColumnName].ToString().Replace(",", ";") + ',';
                    if (col.ColumnName.Equals("Anopheles"))
                        csv += row[col.ColumnName].ToString().Replace(",", ";") + ',';
                    if (col.ColumnName.Equals("Culex"))
                        csv += row[col.ColumnName].ToString().Replace(",", ";") + ',';
                    if (col.ColumnName.Equals("Culex Salinarius"))
                        csv += row[col.ColumnName].ToString().Replace(",", ";") + ',';
                    if (col.ColumnName.Equals("Culex Tarsalis"))
                        csv += row[col.ColumnName].ToString().Replace(",", ";") + ',';
                    if (col.ColumnName.Equals("Culiseta"))
                        csv += row[col.ColumnName].ToString().Replace(",", ";") + ',';
                    if (col.ColumnName.Equals("Other"))
                        csv += row[col.ColumnName].ToString().Replace(",", ";") + ',';
                }
                else
                {
                    if (col.ColumnName.Equals(sizeBy))
                        csv += row[col.ColumnName].ToString().Replace(",", ";") + ',';
                }

                if (colorBy.Equals("Species") && sizeBy.Equals("Species"))
                {
                    //Do nothing, since species already enetered before
                }
                else
                {
                    if (colorBy.Equals("Species"))
                    {
                        if (col.ColumnName.Equals("Aedes"))
                            csv += row[col.ColumnName].ToString().Replace(",", ";") + ',';
                        if (col.ColumnName.Equals("Aedes Vexans"))
                            csv += row[col.ColumnName].ToString().Replace(",", ";") + ',';
                        if (col.ColumnName.Equals("Anopheles"))
                            csv += row[col.ColumnName].ToString().Replace(",", ";") + ',';
                        if (col.ColumnName.Equals("Culex"))
                            csv += row[col.ColumnName].ToString().Replace(",", ";") + ',';
                        if (col.ColumnName.Equals("Culex Salinarius"))
                            csv += row[col.ColumnName].ToString().Replace(",", ";") + ',';
                        if (col.ColumnName.Equals("Culex Tarsalis"))
                            csv += row[col.ColumnName].ToString().Replace(",", ";") + ',';
                        if (col.ColumnName.Equals("Culiseta"))
                            csv += row[col.ColumnName].ToString().Replace(",", ";") + ',';
                        if (col.ColumnName.Equals("Other"))
                            csv += row[col.ColumnName].ToString().Replace(",", ";") + ',';
                    }
                    else
                    {
                        if (col.ColumnName.Equals(colorBy))
                            csv += row[col.ColumnName].ToString().Replace(",", ";") + ',';
                    }
                }
            }
        }

        protected void ddlTimeType_SelectedIndexChanged(object sender, EventArgs e)
        {
            timeType = ddlTimeType.SelectedItem.Value.ToString();
            if (timeType.Equals("Weeks"))
            {
                targetYear.Text = "Target Year";
                ddlYearForWeeks.Visible = true;
                ddlYearForWeeks.Enabled = true;
                ddlCategorizeBy.Items.FindByValue("WeeksOfSummer").Enabled = false;
                fillYearDDLs(ddlTimeType.SelectedItem.Value.ToString());
                ddlYearStart.DataTextFormatString = "{0:MMMM d, yyyy}";
                ddlYearEnd.DataTextFormatString = "{0:MMMM d, yyyy}";
                fillWeekDDLs();

            }
            else
            {
                targetYear.Text = "";
                ddlYearForWeeks.Visible = false;
                ddlYearForWeeks.Enabled = false;
                ddlCategorizeBy.Items.FindByValue("WeeksOfSummer").Enabled = true;
                ddlYearStart.DataTextFormatString = "{0:D}";
                ddlYearEnd.DataTextFormatString = "{0:D}";
                fillYearDDLs(ddlTimeType.SelectedItem.Value.ToString());

            }
            if (!chkShowLabels.Checked)
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "toggleLabels", "toggleLabels();", true);
            }
            if (!chkShowTrackingTooltip.Checked)
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "toggleTrackingTooltip", "toggleTrackingTooltip();", true);
            }
            if (!chkShowStationaryTooltip.Checked)
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "toggleStationaryTooltip", "toggleStationaryTooltip();", true);
            }
        }

        protected void ddlCategorizeBy_SelectedIndexChanged(object sender, EventArgs e)
        {
            fillLocationDDL(ddlCategorizeBy.SelectedItem.Value.ToString());
        }

        protected void ddlYearForWeeks_SelectedIndexChanged(object sender, EventArgs e)
        {
            fillWeekDDLs();
        }

        protected void csvBtn_Click(object sender, EventArgs e)
        {
            string fileName = "";
            string sizeBy = ddlSizeRepresents.SelectedValue.TrimEnd('1'); ;
            string colorBy = ddlColorRepresents.SelectedValue.TrimEnd('1');
            string categorizeBy = ddlCategorizeBy.SelectedValue;
            
            //Date
            if(ddlTimeType.SelectedValue.Equals("Weeks"))
            {
                DateTime weekStart = Convert.ToDateTime(ddlYearStart.Text);
                DateTime weekEnd = Convert.ToDateTime(ddlYearEnd.Text);
                string weekStartFix = weekStart.ToString("yyyy-MM-dd");
                string weekEndFix = weekEnd.ToString("yyyy-MM-dd");

                if (weekStart.Equals(weekEndFix))
                {
                    fileName += weekStartFix + "TreemapData-For";
                }
                else
                {
                    fileName += weekStartFix + "Thru" + weekEndFix + "TreemapData-For";
                }
            }
            else
            {
                if(ddlYearStart.Text.Equals(ddlYearEnd.Text))
                {
                    fileName += ddlYearStart.Text;
                }
                else
                {
                    fileName += ddlYearStart.Text + "Thru" + ddlYearEnd.Text + "TreemapData-For";
                }
            }

            //Focus on
            if (ddlFocusOn.SelectedValue.Equals("%"))
            {
                if(categorizeBy.Equals("WeeksOfSummer"))
                {
                    fileName += "WholeState(ByWeeks)";
                }
                else if(categorizeBy.Equals("Counties"))
                {
                    fileName += "WholeState(ByCounty)";
                }
                else
                {
                    fileName += "WholeState(ByTrap)";
                }
            }
            else
            {
                if(categorizeBy.Equals("WeeksOfSummer"))
                {
                    fileName += "Week" + ddlFocusOn.Text;
                }
                else
                {
                    fileName += Regex.Replace(ddlFocusOn.Text, @"\s+", "");
                }
            }
            
            //Size
            if(sizeBy.Equals("Species"))
            {
                fileName += "-SizeByAllMosquitoes";
            }
            else
            {
                fileName += "-SizeBy" + Regex.Replace(sizeBy, @"\s+", "");
            }

            //Color
            if(colorBy.Equals("Species"))
            {
                fileName += "-ColorByAllMosquitoes";
            }
            else
            {
                fileName += "-ColorBy" + Regex.Replace(colorBy, @"\s+", "");
            }

            Response.Clear();
            Response.Buffer = true;
            Response.AddHeader("content-disposition", "attachment;filename=" + fileName + ".csv");
            Response.Charset = "";
            Response.ContentType = "application/text";
            Response.Output.Write(csv);
            Response.Flush();
            Response.End();

        }
    }
}