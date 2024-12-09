using System;

namespace Telecom_Customer_Application
{
    public partial class WelcomePage : System.Web.UI.Page
    {
        protected void btnAdmin_Click(object sender, EventArgs e)
        {
            Response.Redirect("AdminLogin.aspx");
        }

        protected void btnCustomer_Click(object sender, EventArgs e)
        {
            Response.Redirect("CustomerLogin.aspx");
        }
    }
}