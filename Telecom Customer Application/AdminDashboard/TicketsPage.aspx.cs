using System;

namespace Telecom_Customer_Application.AdminDashboard
{
    public partial class TicketsPage : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                string query = "SELECT * FROM allTickets ORDER BY CASE Ticket_Status WHEN 'Open' THEN 1 WHEN 'In Progress' THEN 2 ELSE 3 END, priority_level DESC;";

                PageUtilities.ExecuteQueryWithHandling(query, TableBody, form1);
            }
        }
    }
}