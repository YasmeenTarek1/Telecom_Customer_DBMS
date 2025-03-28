using System;
using System.Data.SqlClient;

namespace Telecom_Customer_Application.CustomerDashboard
{
    public partial class ConsumePage : System.Web.UI.Page
    {

        protected void Page_Load(object sender, EventArgs e)
        {
            // Post-Redirect-Get Pattern
            if (Session["AlertMessage"] != null && Session["AlertType"] != null)
            {
                PageUtilities.DisplayAlert(new Exception(Session["AlertMessage"].ToString()), this, Session["AlertType"].ToString());
                Session.Remove("AlertMessage");
                Session.Remove("AlertType");
            }
        }
        protected void btnConsume_Click(object sender, EventArgs e)
        {
            try
            {
                string mobileNo = Session["MobileNo"]?.ToString();

                int smsSent = int.Parse(Request.Form["smsCounter"] ?? "0");
                int minutesUsed = int.Parse(Request.Form["minutesCounter"] ?? "0");
                int dataConsumed = int.Parse(Request.Form["dataCounter"] ?? "0");

                if (smsSent < 0 || minutesUsed < 0 || dataConsumed < 0)
                {
                    throw new Exception("Resource consumption values cannot be negative.");
                }

                using (SqlConnection con = new SqlConnection(PageUtilities.connectionString))
                {
                    con.Open();
                    using (SqlCommand cmd = new SqlCommand("Consume_Resources_With_Exclusive_Offers_And_Plans", con))
                    {
                        cmd.CommandType = System.Data.CommandType.StoredProcedure;
                        cmd.Parameters.AddWithValue("@mobile_num", mobileNo);
                        cmd.Parameters.AddWithValue("@data_consumed", dataConsumed);
                        cmd.Parameters.AddWithValue("@minutes_used", minutesUsed);
                        cmd.Parameters.AddWithValue("@SMS_sent", smsSent);

                        cmd.ExecuteNonQuery();
                    }
                }

                Session["AlertMessage"] = "Resources consumed successfully!";
                Session["AlertType"] = "alert-success";                
            }
            catch (Exception ex)
            {
                Session["AlertMessage"] = ex.Message;
                Session["AlertType"] = "alert-danger";
            }

            Response.Redirect(Request.RawUrl, false);
            Context.ApplicationInstance.CompleteRequest();
        }
    }
}