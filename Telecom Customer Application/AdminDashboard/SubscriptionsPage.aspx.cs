using System;

namespace Telecom_Customer_Application.AdminDashboard
{
    public partial class SubscriptionsPage : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                string query = "Account_Plan";

                PageUtilities.ExecuteQueryWithHandling(query, TableBody, form1);
            }
        }
    }
}