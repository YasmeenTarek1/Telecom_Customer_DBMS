using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Telecom_Customer_Application.CustomerDashboard
{
    public partial class TicketsPage : System.Web.UI.Page
    {
        private static string MobileNo;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                MobileNo = Session["MobileNo"].ToString();
                BindTickets();
            }
        }

        private void BindTickets()
        {
            using (SqlConnection conn = new SqlConnection(PageUtilities.connectionString))
            {
                using (SqlCommand cmd = new SqlCommand("Tickets_Account", conn))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@mobile_num", MobileNo);

                    conn.Open();
                    SqlDataReader reader = cmd.ExecuteReader();

                    string ticketListHtml = "";
                    while (reader.Read())
                    {
                        string ticketId = reader["ticketID"].ToString();
                        string description = reader["Issue_description"].ToString();
                        string priority = reader["priority_level"].ToString();
                        string status = reader["status"].ToString();
                        DateTime dateSubmitted = Convert.ToDateTime(reader["submissionDate"]);

                        if (status.Equals("In Progress"))
                            status = "in-progress";

                        ticketListHtml += $@"
                            <div class='ticket-card {status.ToLower()}' data-status='{status.ToLower()}' data-priority='{priority}' data-date='{dateSubmitted:yyyy-MM-dd}' data-description='{description}'>
                                <div class='ticket-content'>
                                    <span class='ticket-id'>Ticket #{ticketId}</span>
                                    <span class='ticket-status'>{status}</span>
                                </div>
                            </div>";
                    }
                    TicketList.InnerHtml = ticketListHtml;
                }
            }
        }
    }
}