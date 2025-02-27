using System;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Telecom_Customer_Application.CustomerDashboard
{
    public partial class PlansPage : System.Web.UI.Page
    {
        private static string MobileNo;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                MobileNo = Session["MobileNo"].ToString();
                SetButtonText();     // based on whether the customer is subscribing or renewing
            }
        }

        protected void PlanButton_Click(object sender, EventArgs e)
        {
            // Get the plan ID from the button's CommandArgument
            Button btn = (Button)sender;
            int planID = int.Parse(btn.CommandArgument);

            HandlePlanSubscription(planID);
        }

        private void SetButtonText()
        {
            // Loop through each button and set its text based on the subscription status
            foreach (Control control in ButtonsContainer.Controls)
            {
                if (control is Button btn)
                {
                    int planID = int.Parse(btn.CommandArgument);
                    string action = GetSubscriptionAction(planID);
                    btn.Text = action;
                }
            }
        }

        private string GetSubscriptionAction(int planID)
        {
            using (SqlConnection conn = new SqlConnection(PageUtilities.connectionString))
            {
                conn.Open();
                using (SqlCommand cmd = new SqlCommand("SELECT dbo.subscribe_or_renew_plan(@mobile_num, @plan_id)", conn))
                {
                    cmd.Parameters.AddWithValue("@mobile_num", MobileNo);
                    cmd.Parameters.AddWithValue("@plan_id", planID);
                    return cmd.ExecuteScalar().ToString();
                }
            }
        }

        private void HandlePlanSubscription(int planID)
        {
            using (SqlConnection conn = new SqlConnection(PageUtilities.connectionString))
            { 
                using (SqlCommand cmd = new SqlCommand("renew_or_subscribe_plan", conn))
                {
                    cmd.CommandType = System.Data.CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@mobile_num", MobileNo);
                    cmd.Parameters.AddWithValue("@plan_id", planID);
                    conn.Open();
                    cmd.ExecuteScalar();
                }
            }
        }
    }
}