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

namespace WebApplication1
{
    public partial class _Default : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            string cs = ConfigurationManager.ConnectionStrings["CString"].ConnectionString;

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

        }
    }
}