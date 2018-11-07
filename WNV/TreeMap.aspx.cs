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
    public partial class TreeMap : Page
    {
        private string cs = ConfigurationManager.ConnectionStrings["CString"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if(!IsPostBack)
            {
                var json = "";
                string str = "";
                string totalFems = "";
                var procedure = "getMosqPercs";
                try
                {
                    using (MySqlConnection conn = new MySqlConnection(cs))
                    {
                        MySqlCommand cmd = new MySqlCommand(procedure, conn);
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.Parameters.AddWithValue("yr", 2005);
                        cmd.Parameters.AddWithValue("loc", 23);

                        using (MySqlDataAdapter da = new MySqlDataAdapter(cmd))
                        {
                            DataTable dt = new DataTable();
                            da.Fill(dt);

                            //json = JsonConvert.SerializeObject(dt);
                            foreach (DataRow row in dt.Rows)
                            {
                                str = row["Aedes"].ToString() + "," + row["AedesVexans"].ToString() + "," + row["Anopheles"].ToString() + "," + row["Culex"].ToString()
                                    + "," + row["CulexSalinarius"].ToString() + "," + row["CulexTarsalis"].ToString() + "," + row["Culiseta"].ToString() + "," + row["Other"].ToString();

                                totalFems = row["TotalFemales"].ToString();

                            }

                        }
                    }
                    hiddenVals.Value = str;

                    System.Diagnostics.Debug.WriteLine(hiddenVals.Value.ToString());


                }
                catch (Exception ex)
                {
                    errMsg.ForeColor = System.Drawing.Color.Red;
                    errMsg.Text = "An error has occurred:" + "<br />" + ex.ToString();
                }
            }

        }
    }
}