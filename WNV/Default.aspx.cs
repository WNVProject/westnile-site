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

namespace WNV
{
    public partial class _Default : Page
    {
        private string cs = ConfigurationManager.ConnectionStrings["CString"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            yearDDLFill();
            caseChartFill();
            gfChartFill();
        }

        //Populates WNV case chart
        protected void caseChartFill()
        {
            try
            {
                int year = 2007;
                ArrayList HumanCases = new ArrayList();
                ArrayList BirdCases = new ArrayList();
                for (int i = 0; i < 10; i++)
                {
                    string sql = "SELECT SUM(HumanCases), SUM(BirdCases) FROM wnv_cases WHERE CaseYear = " + year;

                    MySqlConnection conn = new MySqlConnection(cs);
                    MySqlCommand cmd = new MySqlCommand(sql, conn);
                    MySqlDataReader reader = null;
                    conn.Open();
                    reader = cmd.ExecuteReader();

                    while (reader.Read())
                    {
                        HumanCases.Add(reader.GetInt32(0));
                        BirdCases.Add(reader.GetInt32(1));
                    }
                    reader.Close();
                    reader.Dispose();
                    conn.Close();
                    conn.Dispose();
                    cmd.Dispose();
                    year++;
                }

                Chart3.ChartAreas[0].AxisX.Minimum = 2006;
                Chart3.ChartAreas[0].AxisY.Maximum = 250;
                Chart3.ChartAreas[0].AxisX.Title = "Year";
                Chart3.ChartAreas[0].AxisY.Title = "# of Cases";
                Chart3.Legends.Add(new Legend("Legend") { Docking = Docking.Right });
                year = 2007;
                for (int i = 0; i < HumanCases.Count; i++)
                {
                    Chart3.Series[0].Points.AddXY(year, HumanCases[i]);
                    Chart3.Series[1].Points.AddXY(year, BirdCases[i]);
                    year++;
                }

                Chart3.Series[0].MarkerStyle = System.Web.UI.DataVisualization.Charting.MarkerStyle.Circle;
                Chart3.Series[0].MarkerSize = 15;
                Chart3.Series[0].LegendText = "Humans";
                Chart3.Series[0].IsValueShownAsLabel = false;
                Chart3.Series[0].IsVisibleInLegend = true;
                //Chart3.Series[0].Color = System.Drawing.Color.Magenta;
                Chart3.Series[1].MarkerStyle = System.Web.UI.DataVisualization.Charting.MarkerStyle.Square;
                Chart3.Series[1].MarkerSize = 15;
                Chart3.Series[1].LegendText = "Birds";
                Chart3.Series[1].IsValueShownAsLabel = false;
                Chart3.Series[1].IsVisibleInLegend = true;
                //Chart3.Series[1].Color = System.Drawing.Color.LightCoral;
                Chart3.Width = 500;
                Chart3.DataBind();
            }
            catch (MySqlException ex)
            {
                caseErrMsg.ForeColor = System.Drawing.Color.Red;
                caseErrMsg.Text = "An error has occurred:" + "<br />" + ex.ToString();
            }
        }

        //Populates grand forks chart
        protected void gfChartFill()
        {
            try
            {
                ArrayList WNVCases = new ArrayList();
                ArrayList years = new ArrayList();
                ArrayList TotalMosquitoes = new ArrayList();
                ArrayList CulexTarsalis = new ArrayList();
                string sql = "SELECT DISTINCT CaseYear, WNVCasesSum FROM wnv_cases WHERE CaseLocationID = 23";
                string sql2 = "SELECT DISTINCT TrapYear, YearTotalMosquitoes, YearSumCulexTarsalis FROM trap_data WHERE TrapLocationID = 23 AND TrapYear > 2006";
                MySqlConnection conn = new MySqlConnection(cs);
                MySqlCommand cmd = new MySqlCommand(sql, conn);
                MySqlDataReader reader = null;
                conn.Open();
                reader = cmd.ExecuteReader();

                while (reader.Read())
                {
                    years.Add(reader.GetInt32(0));
                    WNVCases.Add(reader.GetInt32(1));
                }

                conn = new MySqlConnection(cs);
                cmd = new MySqlCommand(sql2, conn);
                reader = null;
                conn.Open();
                reader = cmd.ExecuteReader();

                while (reader.Read())
                {
                   TotalMosquitoes.Add(reader.GetInt32(1));
                   CulexTarsalis.Add(reader.GetInt32(2));
                }

                reader.Close();
                reader.Dispose();
                cmd.Dispose();
                conn.Close();
                conn.Dispose();

                for (int i = 0; i < WNVCases.Count; i++)
                {
                    Chart2.Series[0].Points.AddXY(years[i], WNVCases[i]);
                    Chart2.Series[1].Points.AddXY(years[i], TotalMosquitoes[i]);
                    Chart2.Series[2].Points.AddXY(years[i], CulexTarsalis[i]);

                }
                Chart2.Legends.Add(new Legend("Legend") { Docking = Docking.Right });
                Chart2.Series[0].MarkerStyle = System.Web.UI.DataVisualization.Charting.MarkerStyle.Circle;
                Chart2.Series[0].IsVisibleInLegend = true;
                Chart2.Series[0].LegendText = "WNV Cases";
                Chart2.Series[1].IsVisibleInLegend = true;
                Chart2.Series[1].LegendText = "Total Mosquitoes";
                Chart2.Series[2].IsVisibleInLegend = true;
                Chart2.Series[2].LegendText = "Total Culex Tarsalis";

                Chart2.Series[1]["PointWidth"] = ".75";
                Chart2.Series[2]["PointWidth"] = ".5";

                Chart2.ChartAreas[0].AxisX.Title = "Year";
                Chart2.ChartAreas[0].AxisY.Title = "Total Number";
                Chart2.Width = 700;
                Chart2.DataBind();
            }

            catch (MySqlException ex)
            {
                gfErrMsg.ForeColor = System.Drawing.Color.Red;
                gfErrMsg.Text = "An error has occurred:" + "<br />" + ex.ToString();
            }

        }

        //Populates year dropdown list
        protected void yearDDLFill()
        {
            try
            {
                if (!IsPostBack)
                {

                    MySqlConnection conn = new MySqlConnection(cs);
                    DataSet ds = new DataSet();
                    var sql = "SELECT DISTINCT WeatherYear FROM weather_info ORDER BY WeatherYear";
                    MySqlCommand cmd = new MySqlCommand(sql, conn);
                    using (MySqlDataAdapter da = new MySqlDataAdapter(cmd))
                        da.Fill(ds, "weather_info");
                    yearDDL.DataSource = ds.Tables["weather_info"];
                    yearDDL.DataValueField = "WeatherYear";
                    yearDDL.DataTextField = "WeatherYear";
                    yearDDL.DataBind();
                    conn.Close();
                    yearDDL.Items.Insert(0, new ListItem("<Select Year>", "0"));
                }
            }
            catch (MySqlException ex)
            {
                weatherErrMsg.ForeColor = System.Drawing.Color.Red;
                weatherErrMsg.Text = "An error has occurred:" + "<br />" + ex.ToString();
            }
        }

        //Populates chart from the selected year
        protected void yearDDL_SelectedIndexChanged(object sender, EventArgs e)
        {
            if(yearDDL.SelectedItem.ToString() == "<Select Year>")
            {
                //Do nothing
            } else
            {
                try
                {
                    int month;
                    Dictionary<int, double> MonthAverages = new Dictionary<int, double>();
                    for (int i = 0; i < 5; i++)
                    {
                        month = i + 5;
                        string sql = "SELECT w.WeatherYear, w.WeatherMonth, AVG(w.AvgTemp) `avg` FROM " +
                                    "weather_info w join station_info s on w.StationID = s.StationID " +
                                    "WHERE w.WeatherYear = " + Convert.ToInt32(yearDDL.SelectedItem.ToString()) + " AND w.WeatherMonth = " + month;

                        MySqlConnection conn = new MySqlConnection(cs);
                        MySqlCommand cmd = new MySqlCommand(sql, conn);
                        MySqlDataReader reader = null;
                        conn.Open();
                        reader = cmd.ExecuteReader();

                        while (reader.Read())
                        {
                            MonthAverages.Add(month, Math.Round(reader.GetDouble(2), 2));
                        }
                        reader.Close();
                        reader.Dispose();
                        conn.Close();
                        conn.Dispose();
                        cmd.Dispose();
                    }
                    Chart1.DataSource = MonthAverages;
                    Chart1.ChartAreas[0].AxisX.Minimum = 4;
                    Chart1.ChartAreas[0].AxisY.Minimum = 40;
                    Chart1.ChartAreas[0].AxisY.Maximum = 80;
                    Chart1.ChartAreas[0].AxisX.Title = "Month";
                    Chart1.ChartAreas[0].AxisY.Title = "Temperature (Deg F)  ";

                    Chart1.Series[0].XValueMember = "Key";
                    Chart1.Series[0].YValueMembers = "Value";
                    Chart1.Series[0].MarkerStyle = System.Web.UI.DataVisualization.Charting.MarkerStyle.Circle;
                    Chart1.Series[0].MarkerSize = 15;
                    Chart1.Series[0].IsValueShownAsLabel = true;
                    Chart1.DataBind();
                }
                catch (MySqlException ex)
                {
                    weatherErrMsg.ForeColor = System.Drawing.Color.Red;
                    weatherErrMsg.Text = "An error has occurred:" + "<br />" + ex.ToString();
                }
            }

        }

    }
}