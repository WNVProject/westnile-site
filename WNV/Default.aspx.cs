using System;
using System.Configuration;
using System.Data;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using MySql;
using MySql.Data;
using MySql.Data.MySqlClient;

namespace WNV
{
    public partial class _Default : Page
    {
        private string cs = ConfigurationManager.ConnectionStrings["CString"].ConnectionString; 

        protected void Page_Load(object sender, EventArgs e)
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

        protected void yearDDL_SelectedIndexChanged(object sender, EventArgs e)
        {
            try
            {
                int month;
                Dictionary<int, double> MonthAverages = new Dictionary<int, double>();
                for (int i = 0; i < 5; i++)
                {
                    month = i+5;
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