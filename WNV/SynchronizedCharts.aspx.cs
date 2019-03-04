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

namespace WNV
{
    public partial class SynchronizedCharts1 : System.Web.UI.Page
    {
        private string cs = ConfigurationManager.ConnectionStrings["CString"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            ddlYearFill();
            ddlTrapCountyFill();
            //ddlCasesFill();
        }

        protected void ddlTrapCountyFill()
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
                            ddlTrapCounty.DataSource = dt;
                            ddlTrapCounty.DataValueField = "TrapCounty";
                            ddlTrapCounty.DataTextField = "TrapCounty";
                            ddlTrapCounty.DataBind();
                            ddlTrapCounty.SelectedIndex = 0;
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

        protected void ddlTrapCounty_SelectedIndexChanged(object sender, EventArgs e)
        {
            ddlTrapCountyFill();
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
            //TODO: 
                //get data from dropdowns and do the following queries:
                    //total mosquitoes for trap county selected
                    //the weather variable that is selected
                    //cases
        }

    }


}