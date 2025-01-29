using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using Newtonsoft.Json;
using System.Web.Services;
using System.Data;
using System.Web.UI;
using System.Collections;


namespace Telecom_Customer_Application.AdminDashboard
{
    public partial class SubscriptionsPage : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                string query = "Account_Plan";

                PageUtilities.ExecuteQueryWithHandling(query, TableBody, form1);

                // Fetch data for the pie chart
                Dictionary<string, int> subscriptionsStatus = GetSubscriptionStatistics();
                string subscriptionsStatusJson = JsonConvert.SerializeObject(subscriptionsStatus);

                // Pass the JSON data to the front end
                ScriptManager.RegisterStartupScript(this, GetType(), "data", $"var data = {subscriptionsStatusJson};", true);
            }
        }

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