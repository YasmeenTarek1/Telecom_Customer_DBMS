using System;
using System.Data.SqlClient;
using System.Data;
using System.Collections.Generic;
using System.Web.Services;
using System.Web.UI.WebControls;

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

            if (!IsPostBack)
            {
                string subtab = Request.QueryString["subtab"];

                if (!string.IsNullOrEmpty(subtab))
                {
                    LoadPlansInfo(sender, e);
                }
            }
        }

        protected void LoadPlansInfo(object sender, EventArgs e)
        {
            TabHeading.InnerText = "Plans Info";

            PlanCardsContainer.Style["display"] = "block";
        }
       

        protected void BasicPlanLink_Click(object sender, EventArgs e)
        {
            Subscribers_for_plan("1");
            SelectedPlan = 1;
        }

        protected void StandardPlanLink_Click(object sender, EventArgs e)
        {
            Subscribers_for_plan("2");
            SelectedPlan = 2;
        }

        protected void PremiumPlanLink_Click(object sender, EventArgs e)
        {
            Subscribers_for_plan("3");
            SelectedPlan = 3;
        }

        protected void UnlimitedPlanLink_Click(object sender, EventArgs e)
        {
            Subscribers_for_plan("4");
            SelectedPlan = 4;
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
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.Add(new SqlParameter("@PlanID", SqlDbType.Int) { Value = int.Parse(planId) });
                    PageUtilities.LoadData(cmd, TableBody);
                }
            }
            catch (Exception ex)
            {
                PageUtilities.DisplayAlert(ex, form1);
            }
        }
        [WebMethod]
        public static Dictionary<string, int> GetSubscriptionStatistics()
        {
            var statistics = new Dictionary<string, int>();
            string procedureName = "GetSubscriptionStatistics";

            using (SqlConnection connection = new SqlConnection(PageUtilities.connectionString))
            {
                using (SqlCommand command = new SqlCommand(procedureName, connection))
                {
                    command.CommandType = System.Data.CommandType.StoredProcedure;
                    connection.Open();
                    using (SqlDataReader reader = command.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            string planName = reader["PlanName"].ToString();
                            int subscriptionCount = Convert.ToInt32(reader["SubscriptionCount"]);
                            statistics[planName] = subscriptionCount;
                        }
                    }
                }
            }

            return statistics;
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

                    // Load the data into the target UI element
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