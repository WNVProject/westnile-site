using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WNV {
    public partial class logout : System.Web.UI.Page {
        protected void Page_Load(object sender, EventArgs e) {
            
        }
        protected void Timer1_Tick(object sender, EventArgs e) {
            Session.Clear();
            Session.Abandon();
            Response.Redirect("~/Login.aspx");
        }
    }
}