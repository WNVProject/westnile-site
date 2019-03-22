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
using System.Text;
using System.IO;
using System.Text.RegularExpressions;

namespace WNV
{
    public partial class _MultiaxisChart : Page
    {
        private string cs = ConfigurationManager.ConnectionStrings["CString"].ConnectionString;
        static string csvMosqCols = string.Empty;
        static string csvWeathCols = string.Empty;
        static string csvMosqRows = string.Empty;
        static string csvWeathRows = string.Empty;

        static Dictionary<string, List<string>> mosqDict = new Dictionary<string, List<string>>();
        static Dictionary<string, List<string>> weathDict = new Dictionary<string, List<string>>();

        private Hashtable chktblCounts = new Hashtable();
        private Hashtable chktblWeather = new Hashtable();

        protected void Page_Load(object sender, EventArgs e)
        {
            ddlYearFill();
            ddlCountyFill();
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
                            ddlYear.DataValueField = "TrapYear";
                            ddlYear.DataTextField = "TrapYear";
                            ddlYear.DataBind();
                            ddlYear.Items.Insert(0, new ListItem("Select...", ""));
                            ddlWeekStart.Items.Insert(0, new ListItem("Select...", ""));
                            ddlWeekEnd.Items.Insert(0, new ListItem("Select...", ""));
                        }
                    }
                    ddlWeekStart.Enabled = false;
                    ddlWeekEnd.Enabled = false;
                }
                else
                {
                    if (ddlYear.SelectedIndex == 0)
                    {
                        if (ddlWeekStart.SelectedIndex == 0)
                        {
                            ddlWeekStart.Enabled = false;
                        }
                        if (ddlWeekEnd.SelectedIndex == 0)
                        {
                            ddlWeekEnd.Enabled = false;
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
        protected void ddlWeekStartFill()
        {
            try
            {
                using (MySqlConnection conn = new MySqlConnection(cs))
                {
                    var procedure = "USP_Get_Select_TrapWeekStart";
                    MySqlCommand cmd = new MySqlCommand(procedure, conn);
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("TrapYear", ddlYear.SelectedValue);

                    using (MySqlDataAdapter da = new MySqlDataAdapter(cmd))
                    {
                        DataTable dt = new DataTable();
                        da.Fill(dt);
                        ddlWeekStart.DataSource = dt;
                        ddlWeekStart.DataValueField = "TrapWeekStart";
                        ddlWeekStart.DataTextField = "TrapWeekStart";
                        ddlWeekStart.DataBind();
                        ddlWeekStart.Items.Insert(0, new ListItem("Select...", ""));
                    }
                }
                ddlWeekStart.Enabled = true;
            }
            catch (MySqlException ex)
            {
                lblError.Text = "Could not retrieve Start Weeks: " + ex.ToString();
                lblError.Visible = true;
            }
        }
        protected void ddlWeekEndFill()
        {
            try
            {
                using (MySqlConnection conn = new MySqlConnection(cs))
                {
                    var procedure = "USP_Get_Select_TrapWeekEnd";
                    MySqlCommand cmd = new MySqlCommand(procedure, conn);
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("TrapYear", ddlYear.SelectedValue);

                    using (MySqlDataAdapter da = new MySqlDataAdapter(cmd))
                    {
                        DataTable dt = new DataTable();
                        da.Fill(dt);
                        ddlWeekEnd.DataSource = dt;
                        ddlWeekEnd.DataValueField = "TrapWeekEnd";
                        ddlWeekEnd.DataTextField = "TrapWeekEnd";
                        ddlWeekEnd.DataBind();
                        ddlWeekEnd.Items.Insert(0, new ListItem("Select...", ""));
                    }
                }
                ddlWeekEnd.Enabled = true;
            }
            catch (MySqlException ex)
            {
                lblError.Text = "Could not retrieve End Weeks: " + ex.ToString();
                lblError.Visible = true;
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
                            ddlCounty.Items.Insert(0, new ListItem("Select...", ""));
                        }
                    }
                }
            }
            catch (MySqlException ex)
            {
                lblError.Text = "Could not retrieve Counties: " + ex.ToString();
                lblError.Visible = true;
            }
        }
        
        protected void fillCheckboxLists()
        {
            chktblCounts.Add(chkMeanAedes,"MeanAedes");
            chktblCounts.Add(chkMeanAedesVexans, "MeanAedesVexans");
            chktblCounts.Add(chkMeanAnopheles, "MeanAnopheles");
            chktblCounts.Add(chkMeanCulex, "MeanCulex");
            chktblCounts.Add(chkMeanCulexSalinarius, "MeanCulexSalinarius");
            chktblCounts.Add(chkMeanCulexTarsalis, "MeanCulexTarsalis");
            chktblCounts.Add(chkMeanCuliseta, "MeanCuliseta");
            chktblCounts.Add(chkMeanOther, "MeanOther");
            chktblCounts.Add(chkMeanTotalFemales, "MeanTotalMale");
            chktblCounts.Add(chkMeanTotalMales, "MeanTotalFemale");
            chktblCounts.Add(chkMeanTotalMosquitoes, "MeanTotalMosquitos");

            chktblWeather.Add(chkMeanBareSoilTemp, "MeanBareSoilTemp");
            chktblWeather.Add(chkMeanDewPoint, "MeanDewPoint");
            chktblWeather.Add(chkMeanMaxTemp, "MeanMaxTemp");
            chktblWeather.Add(chkMeanMaxWindSpeed, "MeanMaxWindSpeed");
            chktblWeather.Add(chkMeanMinTemp, "MeanMinTemp");
            chktblWeather.Add(chkMeanTemp, "MeanTemp");
            chktblWeather.Add(chkMeanTotalRainfall, "MeanTotalRainfall");
            chktblWeather.Add(chkMeanTotalSolarRad, "MeanTotalSolarRad");
            chktblWeather.Add(chkMeanTurfSoilTemp, "MeanTurfSoilTemp");
            chktblWeather.Add(chkMeanWindChill, "MeanWindChill");
            chktblWeather.Add(chkMeanWindSpeed, "MeanWindSpeed");
        }

        protected void btnRender_Click(object sender, EventArgs e)
        {
            csvMosqCols = "";
            csvWeathCols = "";
            weathDict.Clear();
            mosqDict.Clear();

            if (Page.IsValid)
            {
                csvBtn.Enabled = true;
                fillCheckboxLists();
                Boolean needCountData = false;
                Boolean needWeatherData = false;
                Boolean needTemperatureUnitData = false;
                Boolean needWindSpeedUnitData = false;
                Boolean needRainfallUnitData = false;
                Boolean needSolarRadUnitData = false;
                String chartTitle = "";
                int weatherVariableTypeCount = 0;

                ICollection countsKeys = chktblCounts.Keys;
                foreach (HtmlInputCheckBox chkBox in countsKeys)
                {
                    if (chkBox.Checked)
                    {
                        needCountData = true;
                        break;
                    }
                }
                ICollection weatherKeys = chktblWeather.Keys;
                foreach (HtmlInputCheckBox chkBox in weatherKeys)
                {
                    if (chkBox.Checked)
                    {
                        needWeatherData = true;
                        if (chkBox.ID.Contains("Temp") || chkBox.ID.Contains("Chill") || chkBox.ID.Contains("Point"))
                        {
                            if (!needTemperatureUnitData)
                            {
                                needTemperatureUnitData = true;
                                weatherVariableTypeCount++;
                            }
                        }
                        if (chkBox.ClientID.Contains("Speed"))
                        {
                            if (!needWindSpeedUnitData)
                            {
                                needWindSpeedUnitData = true;
                                weatherVariableTypeCount++;
                            }
                        }
                        if (chkBox.ClientID.Contains("Rainfall"))
                        {
                            if (!needRainfallUnitData)
                            {
                                needRainfallUnitData = true;
                                weatherVariableTypeCount++;
                            }
                        }
                        if (chkBox.ClientID.Contains("Solar"))
                        {
                            if (!needSolarRadUnitData)
                            {
                                needSolarRadUnitData = true;
                                weatherVariableTypeCount++;
                            }
                        }
                    }
                }
                if (!needCountData)
                {
                    ScriptManager.RegisterStartupScript(this, GetType(), "alert", "alert('Please select at least 1 Mean Mosquito Count Variable.');", true);
                    return;
                }
                else if (weatherVariableTypeCount > 1)
                {
                    ScriptManager.RegisterStartupScript(this, GetType(), "alert", "alert('Please select only 1 Mean Weather Variable Type (unit).');", true);
                    return;
                }
                Boolean skipMosquitoCountData = false;
                if (needCountData)
                {
                    try
                    {
                        using (MySqlConnection conn = new MySqlConnection(cs))
                        {
                            var procedure = "USP_Get_Select_MeanCountyTrapCountsByDateRange";
                            MySqlCommand cmd = new MySqlCommand(procedure, conn);
                            cmd.CommandType = CommandType.StoredProcedure;
                            if (chkStatewide.Checked)
                            {
                                cmd.Parameters.AddWithValue("County", "%");
                                chartTitle += "North Dakota - " + ddlWeekStart.Text.Replace("12:00:00 AM", "") + "to " + ddlWeekEnd.Text.Replace("12:00:00 AM", "") + "- ";
                            }
                            else
                            {
                                cmd.Parameters.AddWithValue("County", ddlCounty.SelectedValue);
                                chartTitle += ddlCounty.SelectedValue + " County - " + ddlWeekStart.Text.Replace("12:00:00 AM", "") + "to " + ddlWeekEnd.Text.Replace("12:00:00 AM", "") + "- ";
                            }
                            cmd.Parameters.AddWithValue("StartWeek", Convert.ToDateTime(ddlWeekStart.SelectedValue));
                            cmd.Parameters.AddWithValue("EndWeek", Convert.ToDateTime(ddlWeekEnd.SelectedValue));
                            using (MySqlDataAdapter da = new MySqlDataAdapter(cmd))
                            {
                                DataTable dt = new DataTable();
                                da.Fill(dt);
                                
                                if (dt.Rows.Count == 0)
                                {
                                    String msgErrorArea = "";
                                    if (chkStatewide.Checked)
                                    {
                                        msgErrorArea += " North Dakota ";
                                    }
                                    else
                                    {
                                        msgErrorArea += " " + ddlCounty.SelectedValue + " County ";
                                    }
                                    ScriptManager.RegisterStartupScript(this, GetType(), "alert", "alert('No mosquito count data exists for" + msgErrorArea + "between " + ddlWeekStart.Text.Replace("12:00:00 AM", "") + "and " + ddlWeekEnd.Text.Replace("12:00:00 AM", "") + ".');", true);
                                    skipMosquitoCountData = true;
                                }
                                chrtMultivariate.Legends.Add(new Legend("CountsLegend") { Docking = Docking.Left });
                                chrtMultivariate.Legends["CountsLegend"].Title = "Mosquito Counts";
                                chrtMultivariate.Legends["CountsLegend"].IsTextAutoFit = true;
                                chrtMultivariate.Legends["CountsLegend"].MaximumAutoSize = 18;
                                chrtMultivariate.ChartAreas.Add("MeanCountsWithWeather");
                                chrtMultivariate.ChartAreas["MeanCountsWithWeather"].AxisX.Title = "Date";
                                chrtMultivariate.ChartAreas["MeanCountsWithWeather"].AxisX.TitleFont = new System.Drawing.Font("Arial", 11);
                                chrtMultivariate.ChartAreas["MeanCountsWithWeather"].AxisX.IsMarginVisible = false;
                                chrtMultivariate.ChartAreas["MeanCountsWithWeather"].AxisY.Title = "Mean Mosquito Count per Trap";
                                chrtMultivariate.ChartAreas["MeanCountsWithWeather"].AxisY.TitleFont = new System.Drawing.Font("Arial", 11);
                                chrtMultivariate.ChartAreas["MeanCountsWithWeather"].AxisY.IsMarginVisible = false;
                                chrtMultivariate.ChartAreas["MeanCountsWithWeather"].AxisX.IntervalType = DateTimeIntervalType.Weeks;
                                chrtMultivariate.ChartAreas["MeanCountsWithWeather"].AxisX.Interval = 1;
                                chrtMultivariate.ChartAreas["MeanCountsWithWeather"].AxisX.IntervalOffsetType = DateTimeIntervalType.Days;
                                chrtMultivariate.ChartAreas["MeanCountsWithWeather"].AxisX.IntervalOffset = 1;
                                chrtMultivariate.ChartAreas["MeanCountsWithWeather"].AxisX.MajorGrid.LineWidth = 0;

                                if (!skipMosquitoCountData)
                                {
                                    csvMosqCols += "TrapWeek,";
                                    foreach (DataColumn column in dt.Columns)
                                    {
                                        if (chkMeanAedes.Checked && column.ColumnName.Equals("MeanAedes"))
                                            csvMosqCols += Regex.Replace(column.ColumnName, @"\s+", "") + ',';

                                        if (chkMeanAedesVexans.Checked && column.ColumnName.Equals("MeanAedesVexans"))
                                            csvMosqCols += Regex.Replace(column.ColumnName, @"\s+", "") + ',';

                                        if (chkMeanAnopheles.Checked && column.ColumnName.Equals("MeanAnopheles"))
                                            csvMosqCols += Regex.Replace(column.ColumnName, @"\s+", "") + ',';

                                        if (chkMeanCulex.Checked && column.ColumnName.Equals("MeanCulex"))
                                            csvMosqCols += Regex.Replace(column.ColumnName, @"\s+", "") + ',';

                                        if (chkMeanCulexSalinarius.Checked && column.ColumnName.Equals("MeanCulexSalinarius"))
                                            csvMosqCols += Regex.Replace(column.ColumnName, @"\s+", "") + ',';

                                        if (chkMeanCulexTarsalis.Checked && column.ColumnName.Equals("MeanCulexTarsalis"))
                                            csvMosqCols += Regex.Replace(column.ColumnName, @"\s+", "") + ',';

                                        if (chkMeanCuliseta.Checked && column.ColumnName.Equals("MeanCuliseta"))
                                            csvMosqCols += Regex.Replace(column.ColumnName, @"\s+", "") + ',';

                                        if (chkMeanOther.Checked && column.ColumnName.Equals("MeanOther"))
                                            csvMosqCols += Regex.Replace(column.ColumnName, @"\s+", "") + ',';

                                        if (chkMeanTotalMales.Checked && column.ColumnName.Equals("MeanTotalMale"))
                                            csvMosqCols += Regex.Replace(column.ColumnName, @"\s+", "") + ',';

                                        if (chkMeanTotalFemales.Checked && column.ColumnName.Equals("MeanTotalFemale"))
                                            csvMosqCols += Regex.Replace(column.ColumnName, @"\s+", "") + ',';

                                        if (chkMeanTotalMosquitoes.Checked && column.ColumnName.Equals("MeanTotalMosquitoes"))
                                            csvMosqCols += Regex.Replace(column.ColumnName, @"\s+", "") + ',';
                                    }


                                    chartTitle += "Mean Mosquitoes per Trap";
                                    if (chkMeanAedes.Checked)
                                    {
                                        chrtMultivariate.Series.Add("MeanAedes");
                                        chrtMultivariate.Series["MeanAedes"].Legend = "CountsLegend";
                                        chrtMultivariate.Series["MeanAedes"].ChartArea = "MeanCountsWithWeather";
                                        chrtMultivariate.Series["MeanAedes"].ChartType = chkSplineCount.Checked ? SeriesChartType.Spline : SeriesChartType.Line;
                                        chrtMultivariate.Series["MeanAedes"].BorderWidth = 3;
                                        chrtMultivariate.Series["MeanAedes"].IsVisibleInLegend = true;
                                        chrtMultivariate.Series["MeanAedes"].LegendText = "Aedes";
                                        foreach (DataRow row in dt.Rows)
                                        {
                                            chrtMultivariate.Series["MeanAedes"].Points.AddXY(row["TrapWeekStart"], row["MeanAedes"]);
                                        }
                                    }
                                    if (chkMeanAedesVexans.Checked)
                                    {
                                        chrtMultivariate.Series.Add("MeanAedesVexans");
                                        chrtMultivariate.Series["MeanAedesVexans"].Legend = "CountsLegend";
                                        chrtMultivariate.Series["MeanAedesVexans"].ChartArea = "MeanCountsWithWeather";
                                        chrtMultivariate.Series["MeanAedesVexans"].ChartType = chkSplineCount.Checked ? SeriesChartType.Spline : SeriesChartType.Line;
                                        chrtMultivariate.Series["MeanAedesVexans"].BorderWidth = 3;
                                        chrtMultivariate.Series["MeanAedesVexans"].IsVisibleInLegend = true;
                                        chrtMultivariate.Series["MeanAedesVexans"].LegendText = "Aedes Vexans";
                                        foreach (DataRow row in dt.Rows)
                                        {
                                            chrtMultivariate.Series["MeanAedesVexans"].Points.AddXY(row["TrapWeekStart"], row["MeanAedesVexans"]);
                                        }
                                    }
                                    if (chkMeanAnopheles.Checked)
                                    {
                                        chrtMultivariate.Series.Add("MeanAnopheles");
                                        chrtMultivariate.Series["MeanAnopheles"].Legend = "CountsLegend";
                                        chrtMultivariate.Series["MeanAnopheles"].ChartArea = "MeanCountsWithWeather";
                                        chrtMultivariate.Series["MeanAnopheles"].ChartType = chkSplineCount.Checked ? SeriesChartType.Spline : SeriesChartType.Line;
                                        chrtMultivariate.Series["MeanAnopheles"].BorderWidth = 3;
                                        chrtMultivariate.Series["MeanAnopheles"].IsVisibleInLegend = true;
                                        chrtMultivariate.Series["MeanAnopheles"].LegendText = "Anopheles";
                                        foreach (DataRow row in dt.Rows)
                                        {
                                            chrtMultivariate.Series["MeanAnopheles"].Points.AddXY(row["TrapWeekStart"], row["MeanAnopheles"]);
                                        }
                                    }
                                    if (chkMeanCulex.Checked)
                                    {
                                        chrtMultivariate.Series.Add("MeanCulex");
                                        chrtMultivariate.Series["MeanCulex"].Legend = "CountsLegend";
                                        chrtMultivariate.Series["MeanCulex"].ChartArea = "MeanCountsWithWeather";
                                        chrtMultivariate.Series["MeanCulex"].ChartType = chkSplineCount.Checked ? SeriesChartType.Spline : SeriesChartType.Line;
                                        chrtMultivariate.Series["MeanCulex"].BorderWidth = 3;
                                        chrtMultivariate.Series["MeanCulex"].IsVisibleInLegend = true;
                                        chrtMultivariate.Series["MeanCulex"].LegendText = "Culex";
                                        foreach (DataRow row in dt.Rows)
                                        {
                                            chrtMultivariate.Series["MeanCulex"].Points.AddXY(row["TrapWeekStart"], row["MeanCulex"]);
                                        }
                                    }
                                    if (chkMeanCulexSalinarius.Checked)
                                    {
                                        chrtMultivariate.Series.Add("MeanCulexSalinarius");
                                        chrtMultivariate.Series["MeanCulexSalinarius"].Legend = "CountsLegend";
                                        chrtMultivariate.Series["MeanCulexSalinarius"].ChartArea = "MeanCountsWithWeather";
                                        chrtMultivariate.Series["MeanCulexSalinarius"].ChartType = chkSplineCount.Checked ? SeriesChartType.Spline : SeriesChartType.Line;
                                        chrtMultivariate.Series["MeanCulexSalinarius"].BorderWidth = 3;
                                        chrtMultivariate.Series["MeanCulexSalinarius"].IsVisibleInLegend = true;
                                        chrtMultivariate.Series["MeanCulexSalinarius"].LegendText = "Culex Salinarius";
                                        foreach (DataRow row in dt.Rows)
                                        {
                                            chrtMultivariate.Series["MeanCulexSalinarius"].Points.AddXY(row["TrapWeekStart"], row["MeanCulexSalinarius"]);
                                        }
                                    }
                                    if (chkMeanCulexTarsalis.Checked)
                                    {
                                        chrtMultivariate.Series.Add("MeanCulexTarsalis");
                                        chrtMultivariate.Series["MeanCulexTarsalis"].Color = System.Drawing.Color.Red;
                                        chrtMultivariate.Series["MeanCulexTarsalis"].Legend = "CountsLegend";
                                        chrtMultivariate.Series["MeanCulexTarsalis"].ChartArea = "MeanCountsWithWeather";
                                        chrtMultivariate.Series["MeanCulexTarsalis"].ChartType = chkSplineCount.Checked ? SeriesChartType.Spline : SeriesChartType.Line;
                                        chrtMultivariate.Series["MeanCulexTarsalis"].BorderWidth = 3;
                                        chrtMultivariate.Series["MeanCulexTarsalis"].IsVisibleInLegend = true;
                                        chrtMultivariate.Series["MeanCulexTarsalis"].LegendText = "Culex Tarsalis (WNV)";
                                        foreach (DataRow row in dt.Rows)
                                        {
                                            chrtMultivariate.Series["MeanCulexTarsalis"].Points.AddXY(row["TrapWeekStart"], row["MeanCulexTarsalis"]);
                                        }
                                    }
                                    if (chkMeanCuliseta.Checked)
                                    {
                                        chrtMultivariate.Series.Add("MeanCuliseta");
                                        chrtMultivariate.Series["MeanCuliseta"].Legend = "CountsLegend";
                                        chrtMultivariate.Series["MeanCuliseta"].ChartArea = "MeanCountsWithWeather";
                                        chrtMultivariate.Series["MeanCuliseta"].ChartType = chkSplineCount.Checked ? SeriesChartType.Spline : SeriesChartType.Line;
                                        chrtMultivariate.Series["MeanCuliseta"].BorderWidth = 3;
                                        chrtMultivariate.Series["MeanCuliseta"].IsVisibleInLegend = true;
                                        chrtMultivariate.Series["MeanCuliseta"].LegendText = "Culiseta";
                                        foreach (DataRow row in dt.Rows)
                                        {
                                            chrtMultivariate.Series["MeanCuliseta"].Points.AddXY(row["TrapWeekStart"], row["MeanCuliseta"]);
                                        }
                                    }
                                    if (chkMeanOther.Checked)
                                    {
                                        chrtMultivariate.Series.Add("MeanOther");
                                        chrtMultivariate.Series["MeanOther"].Legend = "CountsLegend";
                                        chrtMultivariate.Series["MeanOther"].ChartArea = "MeanCountsWithWeather";
                                        chrtMultivariate.Series["MeanOther"].ChartType = chkSplineCount.Checked ? SeriesChartType.Spline : SeriesChartType.Line;
                                        chrtMultivariate.Series["MeanOther"].BorderWidth = 3;
                                        chrtMultivariate.Series["MeanOther"].IsVisibleInLegend = true;
                                        chrtMultivariate.Series["MeanOther"].LegendText = "Other";
                                        foreach (DataRow row in dt.Rows)
                                        {
                                            chrtMultivariate.Series["MeanOther"].Points.AddXY(row["TrapWeekStart"], row["MeanOther"]);
                                        }
                                    }
                                    if (chkMeanTotalMales.Checked)
                                    {
                                        chrtMultivariate.Series.Add("MeanTotalMale");
                                        chrtMultivariate.Series["MeanTotalMale"].Legend = "CountsLegend";
                                        chrtMultivariate.Series["MeanTotalMale"].ChartArea = "MeanCountsWithWeather";
                                        chrtMultivariate.Series["MeanTotalMale"].ChartType = chkSplineCount.Checked ? SeriesChartType.Spline : SeriesChartType.Line;
                                        chrtMultivariate.Series["MeanTotalMale"].BorderWidth = 3;
                                        chrtMultivariate.Series["MeanTotalMale"].BorderDashStyle = ChartDashStyle.Dash;
                                        chrtMultivariate.Series["MeanTotalMale"].IsVisibleInLegend = true;
                                        chrtMultivariate.Series["MeanTotalMale"].LegendText = "Total Male";
                                        foreach (DataRow row in dt.Rows)
                                        {
                                            chrtMultivariate.Series["MeanTotalMale"].Points.AddXY(row["TrapWeekStart"], row["MeanTotalMale"]);
                                        }
                                    }
                                    if (chkMeanTotalFemales.Checked)
                                    {
                                        chrtMultivariate.Series.Add("MeanTotalFemale");
                                        chrtMultivariate.Series["MeanTotalFemale"].Legend = "CountsLegend";
                                        chrtMultivariate.Series["MeanTotalFemale"].ChartArea = "MeanCountsWithWeather";
                                        chrtMultivariate.Series["MeanTotalFemale"].ChartType = chkSplineCount.Checked ? SeriesChartType.Spline : SeriesChartType.Line;
                                        chrtMultivariate.Series["MeanTotalFemale"].BorderWidth = 3;
                                        chrtMultivariate.Series["MeanTotalFemale"].BorderDashStyle = ChartDashStyle.Dash;
                                        chrtMultivariate.Series["MeanTotalFemale"].IsVisibleInLegend = true;
                                        chrtMultivariate.Series["MeanTotalFemale"].LegendText = "Total Female";
                                        foreach (DataRow row in dt.Rows)
                                        {
                                            chrtMultivariate.Series["MeanTotalFemale"].Points.AddXY(row["TrapWeekStart"], row["MeanTotalFemale"]);
                                        }
                                    }
                                    if (chkMeanTotalMosquitoes.Checked)
                                    {
                                        chrtMultivariate.Series.Add("MeanTotalMosquitoes");
                                        chrtMultivariate.Series["MeanTotalMosquitoes"].Color = System.Drawing.Color.LightGray;
                                        chrtMultivariate.Series["MeanTotalMosquitoes"].Legend = "CountsLegend";
                                        chrtMultivariate.Series["MeanTotalMosquitoes"].ChartArea = "MeanCountsWithWeather";
                                        chrtMultivariate.Series["MeanTotalMosquitoes"].IsVisibleInLegend = true;
                                        chrtMultivariate.Series["MeanTotalMosquitoes"].LegendText = "Total Mosquitoes";
                                        foreach (DataRow row in dt.Rows)
                                        {
                                            chrtMultivariate.Series["MeanTotalMosquitoes"].Points.AddXY(row["TrapWeekStart"], row["MeanTotalMosquitoes"]);
                                        }
                                    }
                                    foreach (DataRow row in dt.Rows)
                                    {
                                        DateTime week = Convert.ToDateTime(row["TrapWeekStart"].ToString());
                                        string weekFix = week.ToString("yyyy-MM-dd");

                                        mosqDict.Add(weekFix, new List<string>());
                                        if (chkMeanAedes.Checked)
                                            mosqDict[weekFix.ToString()].Add(row["MeanAedes"].ToString());
                                        if (chkMeanAedesVexans.Checked)
                                            mosqDict[weekFix.ToString()].Add(row["MeanAedesVexans"].ToString());
                                        if (chkMeanAnopheles.Checked)
                                            mosqDict[weekFix.ToString()].Add(row["MeanAnopheles"].ToString());
                                        if (chkMeanCulex.Checked)
                                            mosqDict[weekFix.ToString()].Add(row["MeanCulex"].ToString());
                                        if (chkMeanCulexSalinarius.Checked)
                                            mosqDict[weekFix.ToString()].Add(row["MeanCulexSalinarius"].ToString());
                                        if (chkMeanCulexTarsalis.Checked)
                                            mosqDict[weekFix.ToString()].Add(row["MeanCulexTarsalis"].ToString());
                                        if (chkMeanCuliseta.Checked)
                                            mosqDict[weekFix.ToString()].Add(row["MeanCuliseta"].ToString());
                                        if (chkMeanOther.Checked)
                                            mosqDict[weekFix.ToString()].Add(row["MeanOther"].ToString());
                                        if (chkMeanTotalMales.Checked)
                                            mosqDict[weekFix.ToString()].Add(row["MeanTotalMale"].ToString());
                                        if (chkMeanTotalFemales.Checked)
                                            mosqDict[weekFix.ToString()].Add(row["MeanTotalFemale"].ToString());
                                        if (chkMeanTotalMosquitoes.Checked)
                                            mosqDict[weekFix.ToString()].Add(row["MeanTotalMosquitoes"].ToString());
                                    }
                                }
                            }
                        }

                    }
                    catch (MySqlException ex)
                    {
                        lblError.Text = "Could not retrieve Count data: " + ex.ToString();
                        lblError.Visible = true;
                    }
                }

                if (needWeatherData && weatherVariableTypeCount == 1)
                {
                    try
                    {
                        using (MySqlConnection conn = new MySqlConnection(cs))
                        {
                            var procedure = "USP_Get_Select_MeanCountyWeatherByDateRange";
                            MySqlCommand cmd = new MySqlCommand(procedure, conn);
                            cmd.CommandType = CommandType.StoredProcedure;
                            if (chkStatewide.Checked)
                            {
                                cmd.Parameters.AddWithValue("County", "%");
                            }
                            else
                            {
                                cmd.Parameters.AddWithValue("County", ddlCounty.SelectedValue);
                            }
                            cmd.Parameters.AddWithValue("StartWeek", Convert.ToDateTime(ddlWeekStart.SelectedValue));
                            cmd.Parameters.AddWithValue("EndWeek", Convert.ToDateTime(ddlWeekEnd.SelectedValue));

                            using (MySqlDataAdapter da = new MySqlDataAdapter(cmd))
                            {
                                DataTable dt = new DataTable();
                                da.Fill(dt);

                                if (dt.Rows.Count == 0)
                                {
                                    String msgErrorArea = "";
                                    if (chkStatewide.Checked)
                                    {
                                        msgErrorArea += " North Dakota ";
                                    }
                                    else
                                    {
                                        msgErrorArea += " " + ddlCounty.SelectedValue + " County ";
                                    }
                                    ScriptManager.RegisterStartupScript(this, GetType(), "alert", "alert('No weather data exists for" + msgErrorArea + "between " + ddlWeekStart.Text.Replace("12:00:00 AM", "") + "and " + ddlWeekEnd.Text.Replace("12:00:00 AM", "") + ".');", true);
                                    return;
                                }

                                chrtMultivariate.Legends.Add(new Legend("WeatherLegend") { Docking = Docking.Right });
                                chrtMultivariate.Legends["WeatherLegend"].Title = "Weather Data";
                                chrtMultivariate.Legends["WeatherLegend"].IsTextAutoFit = true;
                                chrtMultivariate.Legends["WeatherLegend"].MaximumAutoSize = 18;
                                chrtMultivariate.ChartAreas["MeanCountsWithWeather"].AxisY2.Enabled = AxisEnabled.True;
                                chrtMultivariate.ChartAreas["MeanCountsWithWeather"].AxisY2.TitleFont = new System.Drawing.Font("Arial", 11);
                                chrtMultivariate.ChartAreas["MeanCountsWithWeather"].AxisY2.IsMarginVisible = false;
                                chrtMultivariate.ChartAreas["MeanCountsWithWeather"].AxisY2.MajorGrid.LineDashStyle = ChartDashStyle.Dot;
                                chrtMultivariate.ChartAreas["MeanCountsWithWeather"].AxisY2.MajorGrid.LineWidth = 2;
                                chrtMultivariate.ChartAreas["MeanCountsWithWeather"].AxisY2.MajorGrid.LineColor = System.Drawing.Color.LightSlateGray;
                                chrtMultivariate.ChartAreas["MeanCountsWithWeather"].AxisY2.MajorTickMark.LineDashStyle = ChartDashStyle.Dot;
                                chrtMultivariate.ChartAreas["MeanCountsWithWeather"].AxisY2.MajorTickMark.LineWidth = 2;
                                chrtMultivariate.ChartAreas["MeanCountsWithWeather"].AxisY2.MajorTickMark.LineColor = System.Drawing.Color.LightSlateGray;
                                
                                foreach (DataColumn column in dt.Columns)
                                {
                                    if (chkMeanMaxTemp.Checked && column.ColumnName.Equals("MeanMaxTemp"))
                                        csvWeathCols += Regex.Replace(column.ColumnName, @"\s+", "") + ',';

                                    if (chkMeanMinTemp.Checked && column.ColumnName.Equals("MeanMinTemp"))
                                        csvWeathCols += Regex.Replace(column.ColumnName, @"\s+", "") + ',';

                                    if (chkMeanTemp.Checked && column.ColumnName.Equals("MeanTemp"))
                                        csvWeathCols += Regex.Replace(column.ColumnName, @"\s+", "") + ',';

                                    if (chkMeanBareSoilTemp.Checked && column.ColumnName.Equals("MeanBareSoilTemp"))
                                        csvWeathCols += Regex.Replace(column.ColumnName, @"\s+", "") + ',';

                                    if (chkMeanTurfSoilTemp.Checked && column.ColumnName.Equals("MeanTurfSoilTemp"))
                                        csvWeathCols += Regex.Replace(column.ColumnName, @"\s+", "") + ',';

                                    if (chkMeanWindSpeed.Checked && column.ColumnName.Equals("MeanWindSpeed"))
                                        csvWeathCols += Regex.Replace(column.ColumnName, @"\s+", "") + ',';

                                    if (chkMeanMaxWindSpeed.Checked && column.ColumnName.Equals("MeanMaxWindSpeed"))
                                        csvWeathCols += Regex.Replace(column.ColumnName, @"\s+", "") + ',';

                                    if (chkMeanTotalSolarRad.Checked && column.ColumnName.Equals("MeanTotalSolarRad"))
                                        csvWeathCols += Regex.Replace(column.ColumnName, @"\s+", "") + ',';

                                    if (chkMeanTotalRainfall.Checked && column.ColumnName.Equals("MeanTotalRainfall"))
                                        csvWeathCols += Regex.Replace(column.ColumnName, @"\s+", "") + ',';

                                    if (chkMeanDewPoint.Checked && column.ColumnName.Equals("MeanDewPoint"))
                                        csvWeathCols += Regex.Replace(column.ColumnName, @"\s+", "") + ',';

                                    if (chkMeanWindChill.Checked && column.ColumnName.Equals("MeanWindChill"))
                                        csvWeathCols += Regex.Replace(column.ColumnName, @"\s+", "") + ',';
                                }

                                if (needTemperatureUnitData)
                                {
                                    chartTitle += " vs Mean Temperature";
                                    chrtMultivariate.ChartAreas["MeanCountsWithWeather"].AxisY2.Title = "Mean Temperature (F\x00B0)";
                                    chrtMultivariate.ChartAreas["MeanCountsWithWeather"].AxisY2.Interval = 10;
                                    if (chkMeanTemp.Checked)
                                    {
                                        chrtMultivariate.Series.Add("MeanTemp");
                                        chrtMultivariate.Series["MeanTemp"].YAxisType = AxisType.Secondary;
                                        chrtMultivariate.Series["MeanTemp"].Legend = "WeatherLegend";
                                        chrtMultivariate.Series["MeanTemp"].ChartArea = "MeanCountsWithWeather";
                                        chrtMultivariate.Series["MeanTemp"].ChartType = chkSplineWeather.Checked ? SeriesChartType.Spline : SeriesChartType.Line;
                                        chrtMultivariate.Series["MeanTemp"].BorderWidth = 3;
                                        chrtMultivariate.Series["MeanTemp"].IsVisibleInLegend = true;
                                        chrtMultivariate.Series["MeanTemp"].LegendText = "Temp (F\x00B0)";
                                        foreach (DataRow row in dt.Rows)
                                        {
                                            chrtMultivariate.Series["MeanTemp"].Points.AddXY(row["WeekStart"], row["MeanTemp"]);
                                        }
                                    }
                                    if (chkMeanMaxTemp.Checked)
                                    {
                                        chrtMultivariate.Series.Add("MeanMaxTemp");
                                        chrtMultivariate.Series["MeanMaxTemp"].YAxisType = AxisType.Secondary;
                                        chrtMultivariate.Series["MeanMaxTemp"].Legend = "WeatherLegend";
                                        chrtMultivariate.Series["MeanMaxTemp"].ChartArea = "MeanCountsWithWeather";
                                        chrtMultivariate.Series["MeanMaxTemp"].ChartType = chkSplineWeather.Checked ? SeriesChartType.Spline : SeriesChartType.Line;
                                        chrtMultivariate.Series["MeanMaxTemp"].BorderWidth = 3;
                                        chrtMultivariate.Series["MeanMaxTemp"].IsVisibleInLegend = true;
                                        chrtMultivariate.Series["MeanMaxTemp"].LegendText = "Max Temp (F\x00B0)";
                                        foreach (DataRow row in dt.Rows)
                                        {
                                            chrtMultivariate.Series["MeanMaxTemp"].Points.AddXY(row["WeekStart"], row["MeanMaxTemp"]);
                                        }
                                    }
                                    if (chkMeanMinTemp.Checked)
                                    {
                                        chrtMultivariate.Series.Add("MeanMinTemp");
                                        chrtMultivariate.Series["MeanMinTemp"].YAxisType = AxisType.Secondary;
                                        chrtMultivariate.Series["MeanMinTemp"].Legend = "WeatherLegend";
                                        chrtMultivariate.Series["MeanMinTemp"].ChartArea = "MeanCountsWithWeather";
                                        chrtMultivariate.Series["MeanMinTemp"].ChartType = chkSplineWeather.Checked ? SeriesChartType.Spline : SeriesChartType.Line;
                                        chrtMultivariate.Series["MeanMinTemp"].BorderWidth = 3;
                                        chrtMultivariate.Series["MeanMinTemp"].IsVisibleInLegend = true;
                                        chrtMultivariate.Series["MeanMinTemp"].LegendText = "Min Temp (F\x00B0)";
                                        foreach (DataRow row in dt.Rows)
                                        {
                                            chrtMultivariate.Series["MeanMinTemp"].Points.AddXY(row["WeekStart"], row["MeanMinTemp"]);
                                        }
                                    }
                                    if (chkMeanBareSoilTemp.Checked)
                                    {
                                        chrtMultivariate.Series.Add("MeanBareSoilTemp");
                                        chrtMultivariate.Series["MeanBareSoilTemp"].YAxisType = AxisType.Secondary;
                                        chrtMultivariate.Series["MeanBareSoilTemp"].Legend = "WeatherLegend";
                                        chrtMultivariate.Series["MeanBareSoilTemp"].ChartArea = "MeanCountsWithWeather";
                                        chrtMultivariate.Series["MeanBareSoilTemp"].ChartType = chkSplineWeather.Checked ? SeriesChartType.Spline : SeriesChartType.Line;
                                        chrtMultivariate.Series["MeanBareSoilTemp"].BorderWidth = 3;
                                        chrtMultivariate.Series["MeanBareSoilTemp"].IsVisibleInLegend = true;
                                        chrtMultivariate.Series["MeanBareSoilTemp"].LegendText = "Bare Soil Temp (F\x00B0)";
                                        foreach (DataRow row in dt.Rows)
                                        {
                                            chrtMultivariate.Series["MeanBareSoilTemp"].Points.AddXY(row["WeekStart"], row["MeanBareSoilTemp"]);
                                        }
                                    }
                                    if (chkMeanTurfSoilTemp.Checked)
                                    {
                                        chrtMultivariate.Series.Add("MeanTurfSoilTemp");
                                        chrtMultivariate.Series["MeanTurfSoilTemp"].YAxisType = AxisType.Secondary;
                                        chrtMultivariate.Series["MeanTurfSoilTemp"].Legend = "WeatherLegend";
                                        chrtMultivariate.Series["MeanTurfSoilTemp"].ChartArea = "MeanCountsWithWeather";
                                        chrtMultivariate.Series["MeanTurfSoilTemp"].ChartType = chkSplineWeather.Checked ? SeriesChartType.Spline : SeriesChartType.Line;
                                        chrtMultivariate.Series["MeanTurfSoilTemp"].BorderWidth = 3;
                                        chrtMultivariate.Series["MeanTurfSoilTemp"].IsVisibleInLegend = true;
                                        chrtMultivariate.Series["MeanTurfSoilTemp"].LegendText = "Turf Soil Temp (F\x00B0)";
                                        foreach (DataRow row in dt.Rows)
                                        {
                                            chrtMultivariate.Series["MeanTurfSoilTemp"].Points.AddXY(row["WeekStart"], row["MeanTurfSoilTemp"]);
                                        }
                                    }
                                    if (chkMeanWindChill.Checked)
                                    {
                                        chrtMultivariate.Series.Add("MeanWindChill");
                                        chrtMultivariate.Series["MeanWindChill"].YAxisType = AxisType.Secondary;
                                        chrtMultivariate.Series["MeanWindChill"].Legend = "WeatherLegend";
                                        chrtMultivariate.Series["MeanWindChill"].ChartArea = "MeanCountsWithWeather";
                                        chrtMultivariate.Series["MeanWindChill"].ChartType = chkSplineWeather.Checked ? SeriesChartType.Spline : SeriesChartType.Line;
                                        chrtMultivariate.Series["MeanWindChill"].BorderWidth = 3;
                                        chrtMultivariate.Series["MeanWindChill"].IsVisibleInLegend = true;
                                        chrtMultivariate.Series["MeanWindChill"].LegendText = "Wind Chill (F\x00B0)";
                                        foreach (DataRow row in dt.Rows)
                                        {
                                            chrtMultivariate.Series["MeanWindChill"].Points.AddXY(row["WeekStart"], row["MeanWindChill"]);
                                        }
                                    }
                                    if (chkMeanDewPoint.Checked)
                                    {
                                        chrtMultivariate.Series.Add("MeanDewPoint");
                                        chrtMultivariate.Series["MeanDewPoint"].YAxisType = AxisType.Secondary;
                                        chrtMultivariate.Series["MeanDewPoint"].Legend = "WeatherLegend";
                                        chrtMultivariate.Series["MeanDewPoint"].ChartArea = "MeanCountsWithWeather";
                                        chrtMultivariate.Series["MeanDewPoint"].ChartType = chkSplineWeather.Checked ? SeriesChartType.Spline : SeriesChartType.Line;
                                        chrtMultivariate.Series["MeanDewPoint"].BorderWidth = 3;
                                        chrtMultivariate.Series["MeanDewPoint"].IsVisibleInLegend = true;
                                        chrtMultivariate.Series["MeanDewPoint"].LegendText = "Dew Point (F\x00B0)";
                                        foreach (DataRow row in dt.Rows)
                                        {
                                            chrtMultivariate.Series["MeanDewPoint"].Points.AddXY(row["WeekStart"], row["MeanDewPoint"]);
                                        }
                                    }
                                }
                                else if (needWindSpeedUnitData)
                                {
                                    chartTitle += " vs Mean Wind Speed";
                                    chrtMultivariate.ChartAreas["MeanCountsWithWeather"].AxisY2.Title = "Mean Speed (mph)";
                                    chrtMultivariate.ChartAreas["MeanCountsWithWeather"].AxisY2.Interval = 5;
                                    if (chkMeanMaxWindSpeed.Checked)
                                    {
                                        chrtMultivariate.Series.Add("MeanMaxWindSpeed");
                                        chrtMultivariate.Series["MeanMaxWindSpeed"].YAxisType = AxisType.Secondary;
                                        chrtMultivariate.Series["MeanMaxWindSpeed"].Legend = "WeatherLegend";
                                        chrtMultivariate.Series["MeanMaxWindSpeed"].ChartArea = "MeanCountsWithWeather";
                                        chrtMultivariate.Series["MeanMaxWindSpeed"].ChartType = chkSplineWeather.Checked ? SeriesChartType.Spline : SeriesChartType.Line;
                                        chrtMultivariate.Series["MeanMaxWindSpeed"].BorderWidth = 3;
                                        chrtMultivariate.Series["MeanMaxWindSpeed"].IsVisibleInLegend = true;
                                        chrtMultivariate.Series["MeanMaxWindSpeed"].LegendText = "Max Wind Speed (mph)";
                                        foreach (DataRow row in dt.Rows)
                                        {
                                            chrtMultivariate.Series["MeanMaxWindSpeed"].Points.AddXY(row["WeekStart"], row["MeanMaxWindSpeed"]);
                                        }
                                    }
                                    if (chkMeanWindSpeed.Checked)
                                    {
                                        chrtMultivariate.Series.Add("MeanWindSpeed");
                                        chrtMultivariate.Series["MeanWindSpeed"].YAxisType = AxisType.Secondary;
                                        chrtMultivariate.Series["MeanWindSpeed"].Legend = "WeatherLegend";
                                        chrtMultivariate.Series["MeanWindSpeed"].ChartArea = "MeanCountsWithWeather";
                                        chrtMultivariate.Series["MeanWindSpeed"].ChartType = chkSplineWeather.Checked ? SeriesChartType.Spline : SeriesChartType.Line;
                                        chrtMultivariate.Series["MeanWindSpeed"].BorderWidth = 3;
                                        chrtMultivariate.Series["MeanWindSpeed"].IsVisibleInLegend = true;
                                        chrtMultivariate.Series["MeanWindSpeed"].LegendText = "Wind Speed (mph)";
                                        foreach (DataRow row in dt.Rows)
                                        {
                                            chrtMultivariate.Series["MeanWindSpeed"].Points.AddXY(row["WeekStart"], row["MeanWindSpeed"]);
                                        }
                                    }
                                }
                                else if (needRainfallUnitData)
                                {
                                    chartTitle += " vs Mean Total Rainfall";
                                    chrtMultivariate.ChartAreas["MeanCountsWithWeather"].AxisY2.Title = "Mean Total Rainfall (in)";
                                    chrtMultivariate.ChartAreas["MeanCountsWithWeather"].AxisY2.Interval = 0.5;
                                    if (chkMeanTotalRainfall.Checked)
                                    {
                                        chrtMultivariate.Series.Add("MeanTotalRainfall");
                                        chrtMultivariate.Series["MeanTotalRainfall"].Color = System.Drawing.Color.SteelBlue;
                                        chrtMultivariate.Series["MeanTotalRainfall"].YAxisType = AxisType.Secondary;
                                        chrtMultivariate.Series["MeanTotalRainfall"].Legend = "WeatherLegend";
                                        chrtMultivariate.Series["MeanTotalRainfall"].ChartArea = "MeanCountsWithWeather";
                                        chrtMultivariate.Series["MeanTotalRainfall"].ChartType = chkSplineWeather.Checked ? SeriesChartType.Spline : SeriesChartType.Line;
                                        chrtMultivariate.Series["MeanTotalRainfall"].BorderWidth = 3;
                                        chrtMultivariate.Series["MeanTotalRainfall"].IsVisibleInLegend = true;
                                        chrtMultivariate.Series["MeanTotalRainfall"].LegendText = "Total Rainfall (in)";
                                        foreach (DataRow row in dt.Rows)
                                        {
                                            chrtMultivariate.Series["MeanTotalRainfall"].Points.AddXY(row["WeekStart"], row["MeanTotalRainfall"]);
                                        }
                                    }
                                }
                                else if (needSolarRadUnitData)
                                {
                                    chartTitle += " vs Mean Total Solar Rad.";
                                    chrtMultivariate.ChartAreas["MeanCountsWithWeather"].AxisY2.Title = "Mean Total Solar Rad (W/m\xB2)";
                                    chrtMultivariate.ChartAreas["MeanCountsWithWeather"].AxisY2.Interval = 100;
                                    if (chkMeanTotalSolarRad.Checked)
                                    {
                                        chrtMultivariate.Series.Add("MeanTotalSolarRad");
                                        chrtMultivariate.Series["MeanTotalSolarRad"].YAxisType = AxisType.Secondary;
                                        chrtMultivariate.Series["MeanTotalSolarRad"].Legend = "WeatherLegend";
                                        chrtMultivariate.Series["MeanTotalSolarRad"].ChartArea = "MeanCountsWithWeather";
                                        chrtMultivariate.Series["MeanTotalSolarRad"].ChartType = chkSplineWeather.Checked ? SeriesChartType.Spline : SeriesChartType.Line;
                                        chrtMultivariate.Series["MeanTotalSolarRad"].BorderWidth = 3;
                                        chrtMultivariate.Series["MeanTotalSolarRad"].IsVisibleInLegend = true;
                                        chrtMultivariate.Series["MeanTotalSolarRad"].LegendText = "Total Solar Rad (W/m\xB2)";
                                        foreach (DataRow row in dt.Rows)
                                        {
                                            chrtMultivariate.Series["MeanTotalSolarRad"].Points.AddXY(row["WeekStart"], row["MeanTotalSolarRad"]);
                                        }
                                    }
                                }

                                foreach (DataRow row in dt.Rows)
                                {
                                    DateTime week = Convert.ToDateTime(row["WeekStart"].ToString());
                                    string weekFix = week.ToString("yyyy-MM-dd");

                                    weathDict.Add(weekFix, new List<string>());
                                    if (chkMeanMaxTemp.Checked)
                                        weathDict[weekFix.ToString()].Add(row["MeanMaxTemp"].ToString());

                                    if (chkMeanMinTemp.Checked)
                                        weathDict[weekFix.ToString()].Add(row["MeanMinTemp"].ToString());

                                    if (chkMeanTemp.Checked)
                                        weathDict[weekFix.ToString()].Add(row["MeanTemp"].ToString());

                                    if (chkMeanBareSoilTemp.Checked)
                                        weathDict[weekFix.ToString()].Add(row["MeanBareSoilTemp"].ToString());

                                    if (chkMeanTurfSoilTemp.Checked)
                                        weathDict[weekFix.ToString()].Add(row["MeanTurfSoilTemp"].ToString());

                                    if (chkMeanWindSpeed.Checked)
                                        weathDict[weekFix.ToString()].Add(row["MeanWindSpeed"].ToString());

                                    if (chkMeanMaxWindSpeed.Checked)
                                        weathDict[weekFix.ToString()].Add(row["MeanMaxWindSpeed"].ToString());

                                    if (chkMeanTotalSolarRad.Checked)
                                        weathDict[weekFix.ToString()].Add(row["MeanTotalSolarRad"].ToString());

                                    if (chkMeanTotalRainfall.Checked)
                                        weathDict[weekFix.ToString()].Add(row["MeanTotalRainfall"].ToString());

                                    if (chkMeanDewPoint.Checked)
                                        weathDict[weekFix.ToString()].Add(row["MeanDewPoint"].ToString());

                                    if (chkMeanWindChill.Checked)
                                        weathDict[weekFix.ToString()].Add(row["MeanWindChill"].ToString());
                                }
                            }
                        }

                    }
                    catch (MySqlException ex)
                    {
                        lblError.Text = "Could not retrieve Weather data: " + ex.ToString();
                        lblError.Visible = true;
                    }
                }
                chrtMultivariate.Titles["WNVChartTitle"].Font = new System.Drawing.Font("Arial", 11);
                chrtMultivariate.Titles["WNVChartTitle"].Docking = Docking.Top;
                chrtMultivariate.Titles["WNVChartTitle"].Text = chartTitle;
            }
            else
            {
                validatePage();
            }
        }

        protected void ddlYear_SelectedIndexChanged(object sender, EventArgs e)
        {
            rfvYear.Validate();
            if (rfvYear.IsValid)
            {
                ddlWeekStartFill();
                ddlWeekEndFill();
            }
            else
            {
                ddlWeekStart.ClearSelection();
                ddlWeekEnd.ClearSelection();
                ddlWeekStart.Enabled = false;
                ddlWeekEnd.Enabled = false;
            }
        }

        protected void chkStatewide_CheckChanged(object sender, EventArgs e)
        {
            if (chkStatewide.Checked)
            {
                ddlCounty.Enabled = false;
                rfvCounty.Enabled = false;
            }
            else
            {
                ddlCounty.Enabled = true;
                rfvCounty.Enabled = true;
            }
        }

        protected void validatePage()
        {
            if (!rfvCounty.IsValid)
            {
                rfvCounty.Validate();
            }
            if (rfvEndDate.IsValid)
            {
                rfvEndDate.Validate();
            }
            if (rfvStartDate.IsValid)
            {
                rfvStartDate.Validate();
            }
            if (rfvYear.IsValid)
            {
                rfvYear.Validate();
            }
        }

        protected void csvBtn_Click(object sender, EventArgs e)
        {
            string csv = csvMosqCols + csvWeathCols;
            csv += "\r\n";

            //Merges the two dictionaries
            foreach(var kvp2 in weathDict)
            {
                if(mosqDict.ContainsKey(kvp2.Key))
                {
                    mosqDict[kvp2.Key].AddRange(kvp2.Value);
                    continue;
                }
            }


            foreach (KeyValuePair<string, List<string>> mosq in mosqDict)
            {
                csv += mosq.Key + ",";
                foreach (string v in mosq.Value)
                {
                    csv += v + ",";
                }
                
                csv += "\r\n";
            }
            System.Diagnostics.Debug.WriteLine(csv);

            Response.Clear();
            Response.Buffer = true;

            string year = ddlYear.SelectedValue.ToString();
            string county = Regex.Replace(ddlCounty.SelectedValue.ToString(), @"\s+", "");

            if (chkStatewide.Checked)
            {
                string fileName = year + "MultiChartData-WholeState";
                Response.AddHeader("content-disposition", "attachment;filename=" + fileName + ".csv");
            }
            else
            {
                string fileName = year + "MultiChartData-" + county;
                Response.AddHeader("content-disposition", "attachment;filename=" + fileName + ".csv");
            }
            Response.Charset = "";
            Response.ContentType = "application/text";
            Response.Output.Write(csv);
            Response.Flush();
            Response.End();
        }
    }
}