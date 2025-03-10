using Newtonsoft.Json;
using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.Script.Serialization;
using System.Web.Services;
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
                try
                { 
                    MobileNo = Session["MobileNo"].ToString();
                    BindTickets();
                    HiddenMobileNo.Value = MobileNo?? string.Empty;
                }
                catch (Exception ex)
                {
                    HiddenMobileNo.Value = string.Empty;
                }

            }
        }

        [WebMethod]
        public static string SubmitTicket(string description, int priority)
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(PageUtilities.connectionString))
                {
                    conn.Open();
                    string query = @"
                    INSERT INTO Technical_Support_Ticket (mobileNo, Issue_description, priority_level, status, submissionDate)
                    VALUES (@mobileNo, @description, @priority, 'Open', @submissionDate)";

                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@mobileNo", MobileNo);
                        cmd.Parameters.AddWithValue("@description", description.Length > 50 ? description.Substring(0, 50) : description); // Truncate if > 50 chars
                        cmd.Parameters.AddWithValue("@priority", priority);
                        cmd.Parameters.AddWithValue("@submissionDate", DateTime.Now.Date); // Use current date

                        cmd.ExecuteNonQuery();
                    }
                }
                return new JavaScriptSerializer().Serialize(new { success = true });
            }
            catch (SqlException sqlEx)
            {
                return JsonConvert.SerializeObject(new { success = false, error = $"Database error: {sqlEx.Message}" });
            }
            catch (Exception ex)
            {
                return JsonConvert.SerializeObject(new { success = false, error = $"General error: {ex.Message}" });
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