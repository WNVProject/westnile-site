using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.IO;
using System.Data;
using ExcelDataReader;

namespace WNV
{
    public partial class Upload : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }


        protected void ImportCSV(object sender, EventArgs e)
        {
            if (FileUpload1.HasFile)
            {
                var ex = ExcelReaderFactory.CreateCsvReader(FileUpload1.FileContent);
                do
                {
                    while (ex.Read())
                    {
                        System.Diagnostics.Debug.Write(ex.GetString(0) + " | ");
                        System.Diagnostics.Debug.Write(ex.GetString(1) + " | ");
                        System.Diagnostics.Debug.Write(ex.GetString(2) + " | ");
                        System.Diagnostics.Debug.Write(ex.GetString(3) + " | ");
                        System.Diagnostics.Debug.WriteLine("");

                    }
                } while (ex.NextResult());
            }

        }
    }
}