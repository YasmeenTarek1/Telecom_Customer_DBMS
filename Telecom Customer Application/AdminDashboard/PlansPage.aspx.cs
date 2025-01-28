using System;
using System.Data.SqlClient;
using System.Data;
using System.Collections.Generic;
using System.Web.Services;

namespace Telecom_Customer_Application.AdminDashboard
{
    public partial class PlansPage : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            string eventTarget = Request.Form["__EVENTTARGET"];
            string eventArgument = Request.Form["__EVENTARGUMENT"];

            if (eventTarget == "PlanClicked")
            {
                Subscribers_for_plan(eventArgument);
            }

            if (!IsPostBack)
            {
                string subtab = Request.QueryString["subtab"];

                if (!string.IsNullOrEmpty(subtab))
                {
                    switch (subtab.ToLower())
                    {
                        case "info":
                            LoadPlansInfo(sender, e);
                            break;

                        case "sinceDate":
                            LoadPlansSinceDate(sender, e);
                            break;
                    }
                }
            }
        }
        protected void LoadPlansInfo(object sender, EventArgs e)
        {
            TabHeading.InnerText = "Plans Info";

            DateContainer1.Style["display"] = "none";
            DateInput1.Text = "";

            TextBoxContainer1.Style["display"] = "none";
            PlanIDEditText.Text = "";

            SearchButton.Style["display"] = "none";

            PlanCardsContainer.Style["display"] = "block";
        }
        protected void LoadPlansSinceDate(object sender, EventArgs e)
        {
            TabHeading.InnerText = "Plans Since Date";

            DateContainer1.Style["display"] = "block";
            DateInput1.Text = "";

            TextBoxContainer1.Style["display"] = "block";
            PlanIDEditText.Text = "";

            SearchButton.Style["display"] = "block";

            PlanCardsContainer.Style["display"] = "none";
        }
        protected void SearchButton_Click(object sender, EventArgs e)
        {

            using (SqlConnection con = new SqlConnection(PageUtilities.connectionString))
            {
                SqlCommand cmd = null;

                try
                {
                    string planId = "";

                    cmd = new SqlCommand("SELECT * FROM dbo.Account_Plan_date(@sub_date, @plan_id)", con);
                    planId = PlanIDEditText.Text;
                    PageUtilities.checkValidPlanID(planId);
                    cmd.Parameters.Add(new SqlParameter("@plan_id", SqlDbType.Int) { Value = int.Parse(planId) });
                    cmd.Parameters.Add(new SqlParameter("@sub_date", SqlDbType.Date) { Value = DateTime.Parse(DateInput1.Text) });

                    con.Open();

                    PageUtilities.LoadData(cmd, TableBody);

                }
                catch (Exception ex)
                {
                    PageUtilities.DisplayAlert(ex, form1);
                    SearchButton.Style["display"] = "none";
                }
            }
        }

        protected void BasicPlanLink_Click(object sender, EventArgs e)
        {
            Subscribers_for_plan("1");
        }

        protected void StandardPlanLink_Click(object sender, EventArgs e)
        {
            Subscribers_for_plan("2");
        }

        protected void PremiumPlanLink_Click(object sender, EventArgs e)
        {
            Subscribers_for_plan("3");
        }

        protected void UnlimitedPlanLink_Click(object sender, EventArgs e)
        {
            Subscribers_for_plan("4");
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
    }
}