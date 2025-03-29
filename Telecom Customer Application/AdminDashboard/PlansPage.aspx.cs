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
        private static readonly Dictionary<int, string> PlanNames = new Dictionary<int, string>
        {
            { 1, "Basic Plan" },
            { 2, "Standard Plan" },
            { 3, "Premium Plan" },
            { 4, "Unlimited Plan" }
        };

        private int SelectedPlan
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
            if (!IsPostBack)
            {
                string query = "GetAllSubscribers";
                PageUtilities.ExecuteQueryWithHandling(query, TableBody, form1);
            }

            string eventTarget = Request.Form["__EVENTTARGET"];
            string eventArgument = Request.Form["__EVENTARGUMENT"];

            if (eventTarget == "PlanClicked")
            {
                int planId = int.Parse(eventArgument); // eventArgument -> plan ID sent from the client
                SelectedPlan = planId;  
                Subscribers_for_plan(eventArgument);  
            }

            DataTable subscriptionsStatus = PageUtilities.GetData("GetSubscriptionStatistics");
            string subscriptionsStatusJson = JsonConvert.SerializeObject(subscriptionsStatus);

            // Pass the JSON data to the front end
            ScriptManager.RegisterStartupScript(this, GetType(), "subscriptionsData",$"var subscriptionsData = {subscriptionsStatusJson};", true);

            if (SelectedPlan > 0)
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "updatePlanSelection",$"updatePlanSelection({SelectedPlan});", true);
            }
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

                    string planName = PlanNames.ContainsKey(int.Parse(planId)) ? PlanNames[int.Parse(planId)]: "Selected Plan";

                    PageUtilities.LoadData(cmd, TableBody);

                    // update table caption
                    ScriptManager.RegisterStartupScript(this, GetType(), "updateTableCaption",$"document.getElementById('TableCaption').innerText = 'Subscribers for {planName}';", true);

                    filterOption1.Style["display"] = "flex";
                    filterOption2.Style["display"] = "flex";
                    filterOption3.Style["display"] = "flex";
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
                    cmd.Parameters.AddWithValue("@SelectedPlan", SelectedPlan);

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