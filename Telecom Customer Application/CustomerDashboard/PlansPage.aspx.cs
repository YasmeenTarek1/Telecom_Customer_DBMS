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
                SetButtonTextAndState();
            }

            // Post-Redirect-Get Pattern
            if (Session["AlertMessage"] != null && Session["AlertType"] != null)
            {
                PageUtilities.DisplayAlert(new Exception(Session["AlertMessage"].ToString()), this, Session["AlertType"].ToString());
                Session.Remove("AlertMessage");
                Session.Remove("AlertType");
            }
        }

        protected void PlanButton_Click(object sender, EventArgs e)
        {
            Button btn = (Button)sender;
            int planID = int.Parse(btn.CommandArgument);
            HandlePlanSubscription(planID);
        }

        private void SetButtonTextAndState()
        {
            foreach (Control control in ButtonsContainer.Controls)
            {
                if (control is Button btn && btn.ID.StartsWith("btnPlan"))
                {
                    int planID = int.Parse(btn.CommandArgument);
                    string action = GetSubscriptionAction(planID);
                    btn.Text = action;

                    bool isActive = IsPlanActive(planID);
                    btn.Enabled = !isActive;
                    btn.CssClass = isActive ? "disabled-btn" : "";
                    btn.Attributes["data-bs-toggle"] = isActive ? "tooltip" : "";
                    btn.Attributes["data-bs-placement"] = "top";
                    btn.ToolTip = isActive ? "You are already subscribing to this plan" : "";
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

        private bool IsPlanActive(int planID)
        {
            using (SqlConnection conn = new SqlConnection(PageUtilities.connectionString))
            {
                conn.Open();
                using (SqlCommand cmd = new SqlCommand("SELECT COUNT(*) FROM Subscription WHERE mobileNo = @mobile_num AND planID = @plan_id", conn))
                {
                    cmd.Parameters.AddWithValue("@mobile_num", MobileNo);
                    cmd.Parameters.AddWithValue("@plan_id", planID);
                    return (int)cmd.ExecuteScalar() > 0;
                }
            }
        }

        private void HandlePlanSubscription(int planID)
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(PageUtilities.connectionString))
                {
                    using (SqlCommand cmd = new SqlCommand("renew_or_subscribe_plan", conn))
                    {
                        cmd.CommandType = System.Data.CommandType.StoredProcedure;
                        cmd.Parameters.AddWithValue("@mobile_num", MobileNo);
                        cmd.Parameters.AddWithValue("@plan_id", planID);
                        SqlParameter messageParam = cmd.Parameters.Add("@message", System.Data.SqlDbType.NVarChar, 100);
                        messageParam.Direction = System.Data.ParameterDirection.Output;

                        conn.Open();
                        cmd.ExecuteNonQuery();

                        string message = messageParam.Value.ToString();
                        if (message.Contains("successful!"))
                        {
                            Session["AlertMessage"] = message;
                            Session["AlertType"] = "alert-success";
                        }
                        else if (message.Contains("on hold"))
                        {
                            Session["AlertMessage"] = message;
                            Session["AlertType"] = "alert-warning";
                        }
                        else
                        {
                            Session["AlertMessage"] = message;
                            Session["AlertType"] = "alert-danger";
                        }
                    }
                }
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