using System;

namespace Telecom_Customer_Application.AdminDashboard
{
    public partial class WalletsPage : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                string query = "SELECT * FROM CustomerWallet";

                PageUtilities.ExecuteQueryWithHandling(query, TableBody, form1);
            }
        }
    }
}