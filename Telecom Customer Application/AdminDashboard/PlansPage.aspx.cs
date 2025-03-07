using System;
using System.Data.SqlClient;
using System.Data;
using Newtonsoft.Json;
using System.Collections.Generic;
using System.Web.UI;

namespace Telecom_Customer_Application.AdminDashboard
{
    public partial class PlansPage : System.Web.UI.Page
    {
        private  int SelectedPlan
        {
            get
            {
                return ViewState["SelectedPlan"] != null ? (int)ViewState["SelectedPlan"] : 0;
            }
            set
            {
                ViewState["SelectedPlan"] = value;
            }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            string eventTarget = Request.Form["__EVENTTARGET"];
            string eventArgument = Request.Form["__EVENTARGUMENT"];

            if (eventTarget == "PlanClicked")
            {
                // eventArgument will contain the plan ID sent from the client
                int planId = int.Parse(eventArgument);
                SelectedPlan = planId;  // Update SelectedPlan based on clicked plan ID
                Subscribers_for_plan(eventArgument);  // Fetch subscribers for the selected plan
            }

            DataTable subscriptionsStatus = PageUtilities.GetData("GetSubscriptionStatistics");
            string subscriptionsStatusJson = JsonConvert.SerializeObject(subscriptionsStatus);

            // Pass the JSON data to the front end
            ScriptManager.RegisterStartupScript(this, GetType(), "subscriptionsData", $"var subscriptionsData = {subscriptionsStatusJson};", true);
            
        }

        private void Subscribers_for_plan(string planId)
        {
            try
            {

                using (SqlConnection connection = new SqlConnection(PageUtilities.connectionString))
                {
                    connection.Open();
                    SqlCommand cmd = new SqlCommand("GetSubscribersForPlan", connection);
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.Add(new SqlParameter("@PlanID", SqlDbType.Int) { Value = int.Parse(planId) });
                    PageUtilities.LoadData(cmd, TableBody);
                    filterOption1.Style["display"] = "block";
                    filterOption2.Style["display"] = "block";
                    filterOption3.Style["display"] = "block";
                }
            }
            catch (Exception ex)
            {
                PageUtilities.DisplayAlert(ex, form1);
            }
        }

        protected void ApplyFilterButton_Click(object sender, EventArgs e)
        {
            DateTime subscriptionDate;
            DateTime.TryParse(SubscriptionDateFilter.Text, out subscriptionDate);

            string subscriptionStatus = SubscriptionStatusFilter.SelectedValue;

            using (SqlConnection connection = new SqlConnection(PageUtilities.connectionString))
            {
                try
                {
                    connection.Open();
                    SqlCommand cmd = new SqlCommand("GetSubscriptions", connection);
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.Add(new SqlParameter("@FilterDate", SqlDbType.Date) { Value = subscriptionDate });
                    cmd.Parameters.AddWithValue("@SubscriptionStatus", subscriptionStatus);
                    cmd.Parameters.AddWithValue("@SelectedPlan", SelectedPlan+1);

                    PageUtilities.LoadData(cmd, TableBody);
                }
                catch (Exception ex)
                {
                    PageUtilities.DisplayAlert(ex, form1);
                }
            }
        }
    }
}