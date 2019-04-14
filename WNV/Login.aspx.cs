using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Configuration;
using System.Data.SqlClient;
using System.Web.Security;
using MySql;
using MySql.Data;
using MySql.Data.MySqlClient;
using System.Text;
using System.Security.Cryptography;
using System.Data;

namespace WNV {
    public partial class Login : System.Web.UI.Page {
        private string cs = ConfigurationManager.ConnectionStrings["CString"].ConnectionString;
        protected void Page_Load(object sender, EventArgs e) {
            if (this.Page.User.Identity.IsAuthenticated) {
                Response.Redirect(FormsAuthentication.DefaultUrl);
            }
        }

        protected void userLogin(object sender, EventArgs e) {
            string hash, salt;
            string pass = passwordTxt.Text;
            GenerateSaltedHash(pass, out salt, out hash);

            try {
                using (MySqlConnection conn = new MySqlConnection(cs)) {
                    var procedure = "USP_validateUser";
                    MySqlCommand cmd = new MySqlCommand(procedure, conn);
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("uEmail", emailTxt.Text);
                    cmd.Parameters.AddWithValue("uPassword", hash);
                    cmd.Parameters.AddWithValue("salt", salt);
                    conn.Open();
                    cmd.ExecuteNonQuery();

                    
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