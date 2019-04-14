using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Security.Cryptography;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using MySql;
using MySql.Data;
using MySql.Data.MySqlClient;
using System.Data;
using System.Diagnostics;


namespace WNV {
    public partial class Register : System.Web.UI.Page {

        private string cs = ConfigurationManager.ConnectionStrings["Cstring"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e) {
            //TODO: write the fizzbuzz logic of the page
            //probably just make sure that the text in the fields are clear
        }
        protected void userRegister(object sender, EventArgs e) {
            //TODO: grab the email and password (hashed) and send them to the database to be inserted
            string hash, salt;
            string pass = passwordTxt.Text;
            GenerateSaltedHash(pass, out salt, out hash);
            
            try {
                using (MySqlConnection conn = new MySqlConnection(cs)) {
                    var procedure = "USP_registerUser";
                    MySqlCommand cmd = new MySqlCommand(procedure, conn);
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("uEmail", emailTxt.Text);
                    cmd.Parameters.AddWithValue("uPassword", hash);
                    cmd.Parameters.AddWithValue("salt", salt);
                    conn.Open();
                    cmd.ExecuteNonQuery();

                    Response.Redirect("Default.aspx");
                }
            } catch (MySqlException ex) {
                lblDBError.Text = "Could not connect to database: " + ex.ToString();
                lblDBError.Visible = true;
            }
            
            
                       

        }

        public static void GenerateSaltedHash(string password, out string salt, out string hash) {
            var saltBytes = new byte[64];
            var provider = new RNGCryptoServiceProvider();
            provider.GetNonZeroBytes(saltBytes);
            salt = Convert.ToBase64String(saltBytes);

            var rfc2898DeriveBytes = new Rfc2898DeriveBytes(password, saltBytes, 10000);
            hash = Convert.ToBase64String(rfc2898DeriveBytes.GetBytes(256));

           
        }
    }
}