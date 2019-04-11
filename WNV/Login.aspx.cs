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

        protected void ValidateUser(object sender, EventArgs e) {
            string email = emailTxt.Text.Trim();
            string password = passwordTxt.Text.Trim();
            int userId = 0;
            try {
                using (MySqlConnection conn = new MySqlConnection(cs)) {
                    var procedure = "Validate_User";
                    MySqlCommand cmd = new MySqlCommand(procedure, conn);
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("email", email);
                    cmd.Parameters.AddWithValue("password", password);
                    cmd.Connection = conn;
                    conn.Open();
                    userId = Convert.ToInt32(cmd.ExecuteScalar());
                    conn.Close();
                }
                switch (userId) {
                    case -1:
                        dvMessage.Visible = true;
                        lblMessage.Text = "Email and/or password is incorrect";
                        break;
                    case -2:
                        dvMessage.Visible = true;
                        lblMessage.Text = "Account has not been activated";
                        break;
                    default:
                        Response.Redirect(Request.QueryString["ReturnUrl"]);
                        break;
                }
            } catch (MySqlException ex) {
                dbError.Visible = true;
                lblDBError.Text = "Could not connect to Database at this time. Try again later." + ex.ToString();

            }
        }
    }
}