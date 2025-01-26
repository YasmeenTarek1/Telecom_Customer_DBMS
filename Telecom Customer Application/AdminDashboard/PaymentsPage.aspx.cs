using System;

namespace Telecom_Customer_Application.AdminDashboard
{
    public partial class PaymentsPage : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

            string query = "SELECT * FROM AccountPayments ORDER BY CASE Payment_Status WHEN 'Successful' THEN 1 WHEN 'Pending' THEN 2 ELSE 3 END, date_of_payment DESC;";

            PageUtilities.ExecuteQueryWithHandling(query, TableBody, form1);

        }
    }
}