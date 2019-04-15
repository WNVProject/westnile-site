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
            string enteredPassword = passwordTxt.Text;
            //GenerateSaltedHash(pass, salt, hash);

            //rework this to get session crap working.

            //TODO:
                //create a stored procedure that grabs the salt and hash of the user first
                //then compare the two
                //then establish the sessions.
            try {
                using (MySqlConnection conn = new MySqlConnection(cs)) {
                    var procedure = "USP_validateUser";
                    MySqlCommand cmd = new MySqlCommand(procedure, conn);
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("uEmail", emailTxt.Text);
                    
                    using (MySqlDataAdapter da = new MySqlDataAdapter(cmd)) {
                        DataTable dt = new DataTable();

                        da.Fill(dt);
                        if(dt.Rows.Count > 0) {
                            int ID = 0;
                            string email = "";
                            string storedHash = "";
                            string storedSalt = "";
                            string isAdmin = "false";
                            string Admin = "";

                            foreach (DataRow row in dt.Rows) {
                                ID = Int32.Parse(row["userId"].ToString());
                                email = row["userEmail"].ToString();
                                storedHash = row["userPassword"].ToString();
                                storedSalt = row["userSalt"].ToString();
                                Admin = row["isAdmin"].ToString();

                                bool passwordMatch = verifyPassword(enteredPassword, storedSalt, storedHash);
                                if (passwordMatch) {
                                    if (Admin.Equals("True")) {
                                        isAdmin = "true";
                                    } else {
                                        isAdmin = "false";
                                    }
                                }
                            }
                            
                            Session["Logged"] = "Yes";
                            Session["userID"] = ID;
                            Session["userEmail"] = email;
                            Session["isAdmin"] = isAdmin;
                            Response.Redirect("~/Default.aspx");
                        } else {
                            lblMessage.Text = "Invalid Email/Password";
                            lblMessage.Visible = true;
                            dvMessage.Visible = true;
                        }
                    }
                }
                
            } catch (MySqlException ex) {
                lblDBError.Text = "Could not connect to database: " + ex.ToString();
                lblDBError.Visible = true;
            }
        }

        public static bool verifyPassword(string password, string storedSalt, string storedHash) {
            
            var saltBytes = Convert.FromBase64String(storedSalt);

            var rfc2898DeriveBytes = new Rfc2898DeriveBytes(password, saltBytes, 10000);
            return Convert.ToBase64String(rfc2898DeriveBytes.GetBytes(256)) == storedHash;


        }
        
    }
}