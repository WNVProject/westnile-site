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
            PopulateYearDDL();
            PopulateLocationDDL();
        }

        protected void PopulateYearDDL()
        {
            if (!IsPostBack)
            {
                try
                {
                    using (MySqlConnection conn = new MySqlConnection(cs))
                    {
                        MySqlCommand cmd = new MySqlCommand("SELECT DISTINCT TrapYear from trap_data ORDER BY TrapYear", conn);
                        cmd.CommandType = CommandType.Text;
                        DataSet ds = new DataSet();

                        using (MySqlDataAdapter da = new MySqlDataAdapter(cmd))
                        {
                            da.Fill(ds, "trap_data");
                        }
                        yearDDL.DataSource = ds.Tables["trap_data"];
                        yearDDL.DataValueField = "TrapYear";
                        yearDDL.DataTextField = "TrapYear";
                        yearDDL.DataBind();
                        yearDDL.Items.Insert(0, new ListItem("<Select Year>", "0"));
                    }

                    //System.Diagnostics.Debug.WriteLine(hiddenVals.Value.ToString());

                }
                catch (Exception ex)
                {
                    errMsg.ForeColor = System.Drawing.Color.Red;
                    errMsg.Text = "An error has occurred:" + "<br />" + ex.ToString();
                }
            }
        }

        protected void PopulateLocationDDL()
        {
            if (!IsPostBack)
            {
                try
                {
                    using (MySqlConnection conn = new MySqlConnection(cs))
                    {
                        MySqlCommand cmd = new MySqlCommand("SELECT TrapLocationID, TrapArea from trap_locations ORDER BY TrapArea", conn);
                        cmd.CommandType = CommandType.Text;
                        DataSet ds = new DataSet();

                        using (MySqlDataAdapter da = new MySqlDataAdapter(cmd))
                        {
                            da.Fill(ds, "trap_locations");
                        }
                        locationDDL.DataSource = ds.Tables["trap_locations"];
                        locationDDL.DataValueField = "TrapLocationID";
                        locationDDL.DataTextField = "TrapArea";
                        locationDDL.DataBind();
                        locationDDL.Items.Insert(0, new ListItem("<Select Location>", "0"));
                    }

                    //System.Diagnostics.Debug.WriteLine(hiddenVals.Value.ToString());

                }
                catch (Exception ex)
                {
                    errMsg.ForeColor = System.Drawing.Color.Red;
                    errMsg.Text = "An error has occurred:" + "<br />" + ex.ToString();
                }
            }
        }

        protected void PopulateTreeMap(int year, int locationID)
        {
            string str = "";
            string totalFems = "";
            try
            {
                using (MySqlConnection conn = new MySqlConnection(cs))
                {
                    MySqlCommand cmd = new MySqlCommand("getMosqPercs", conn);
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("yr", year);
                    cmd.Parameters.AddWithValue("loc", locationID);

                    conn.Open();
                    using (MySqlDataReader rd = cmd.ExecuteReader())
                    {

                        int i = 0;
                        while (rd.Read())
                        {
                            while (i < 8)
                            {
                                if (i != 7)
                                {
                                    str += rd[i].ToString() + ",";

                                }
                                else
                                {
                                    str += rd[i].ToString();
                                }
                                i++;
                            }
                            totalFems = rd[8].ToString();
                        }
                    }
                    conn.Close();
                }

                hiddenVals.Value = str;
                totalFemsLbl.Text = "Total Females: " + totalFems;
                //System.Diagnostics.Debug.WriteLine(hiddenVals.Value.ToString());

            }
            catch (Exception ex)
            {
                errMsg.ForeColor = System.Drawing.Color.Red;
                errMsg.Text = "An error has occurred:" + "<br />" + ex.ToString();
            }
        }

        protected void renderBtn_Click(object sender, EventArgs e)
        {
            if(locationDDL.SelectedIndex == 0 || yearDDL.SelectedIndex == 0)
            {
                //Do nothing
            } else
            {
                PopulateTreeMap(Int32.Parse(yearDDL.SelectedValue.ToString()), Int32.Parse(locationDDL.SelectedValue.ToString()));
            }
        }
    }
}