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

namespace WNV
{
    public partial class _InteractiveMap : Page
    {
        private string cs = ConfigurationManager.ConnectionStrings["CString"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
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
                {"StartWeek","2013-01-01"},
                {"EndWeek","2013-12-31"}
            };
            fileName = "mosquitoQuery1.json";

            generateGeoJsonFromDataTable(procedure, parameters, geometryType, fileName);
            ScriptManager.RegisterStartupScript(this, GetType(), "render", "render('" + fileName + "');", true);
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

        protected void chkShowTraps_CheckChanged(object sender, EventArgs e)
        {
            string procedure = "";
            string geometryType = "";
            string fileName = "";
            
            procedure = "USP_Select_TrapLocations";
            fileName = "trapLocations.json";
            geometryType = "Point";
            generateGeoJsonFromDataTable(procedure, new Hashtable(), geometryType, fileName);
            ScriptManager.RegisterStartupScript(this, GetType(), "showTraps", "showTraps('" + fileName + "');", true);
        }
    }
}