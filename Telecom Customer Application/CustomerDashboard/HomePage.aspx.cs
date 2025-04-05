using System;
using System.Data;
using System.Data.SqlClient;

namespace Telecom_Customer_Application.CustomerDashboard
{
    public partial class HomePage : System.Web.UI.Page
    {
        private static string MobileNo;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                MobileNo = Session["MobileNo"].ToString();
                LoadSubscribedPlans();
            }
        }

        private void LoadSubscribedPlans()
        {
            using (SqlConnection conn = new SqlConnection(PageUtilities.connectionString))
            {
                SqlCommand cmd = new SqlCommand("LoadSubscribedPlans", conn);
                PageUtilities.checkValidMobileNum(MobileNo);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@mobileNo", MobileNo);
                conn.Open();

                string fullHtml = ""; // All HTML content

                using (SqlDataReader reader = cmd.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        int planID = reader.GetInt32(0);
                        string planName = reader.GetString(1);
                        int smsOffered = reader.GetInt32(2);
                        int minutesOffered = reader.GetInt32(3);
                        int dataOffered = reader.GetInt32(4);

                        int smsUsed = reader.IsDBNull(5) ? 0 : reader.GetInt32(5);
                        int minutesUsed = reader.IsDBNull(6) ? 0 : reader.GetInt32(6);
                        int dataUsed = reader.IsDBNull(7) ? 0 : reader.GetInt32(7);
                        string planStatus = reader.GetString(8);

                        // Plan Card
                        fullHtml += GeneratePlanCard(planID, planName, planStatus);

                        // Plan Usage
                        fullHtml += $@"
                        <div class='mainContainer' style='{(planStatus == "onhold" ? "opacity: 0.5;" : "")}' >
                            <h3 class='tab-heading' style='margin: 0px auto 40px auto; font-size: 26px;'>Plan Usage</h3>
                            <div class='UsagesContainer'>
                                {GenerateUsageElement(planID, "SMS", smsUsed, smsOffered)}
                                {GenerateUsageElement(planID, "Minutes", minutesUsed, minutesOffered)}
                                {GenerateUsageElement(planID, "Data", dataUsed, dataOffered)}
                            </div>
                        </div>";

                        // Plan Benefits
                        fullHtml += LoadPlanBenefits(planID, planStatus);
                    }
                }

                // Set the full HTML inside the container
                PlansContainer.InnerHtml = fullHtml;
            }
        }


        private string LoadPlanBenefits(int planID, string planStatus)
        {
            using (SqlConnection conn = new SqlConnection(PageUtilities.connectionString))
            {
                PageUtilities.checkValidPlanID(planID.ToString());
                PageUtilities.checkValidMobileNum(MobileNo);

                SqlCommand cmd = new SqlCommand("LoadPlanBenefits", conn);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@mobile_num", MobileNo);
                cmd.Parameters.AddWithValue("@planID", planID);
                conn.Open();

                string benefitsHTML = $@"
                <div class='mainContainer' style='{(planStatus == "onhold" ? "opacity: 0.5;" : "")}'>
                    <h3 class='tab-heading' style='margin: 0px auto 40px auto; font-size: 26px;'>Benefits Usage</h3>
                    <div class='UsagesContainer'>";

                string benefits = "";

                using (SqlDataReader reader = cmd.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        benefits += GenerateUsageElement(planID, "SMS", reader.IsDBNull(4) ? 0 : reader.GetInt32(4), reader.IsDBNull(0) ? 0 : reader.GetInt32(0));
                        benefits += GenerateUsageElement(planID, "Minutes", reader.IsDBNull(6) ? 0 : reader.GetInt32(6), reader.IsDBNull(2) ? 0 : reader.GetInt32(2));
                        benefits += GenerateUsageElement(planID, "Data", reader.IsDBNull(5) ? 0 : reader.GetInt32(5), reader.IsDBNull(1) ? 0 : reader.GetInt32(1));
                        benefits += GenerateUsageElement(planID, "Points", reader.IsDBNull(7) ? 0 : reader.GetInt32(7), reader.IsDBNull(3) ? 0 : reader.GetInt32(3));
                    }
                }

                if (benefits.Length == 0)
                    return "";
                benefitsHTML += benefits + "</div></div>";
                return benefitsHTML;
            }
        }


        private string GenerateUsageElement(int planID, string type, int used, int offered)
        {
            if (offered == 0) return "";
            return $@"
                    <div class='UsageElement'>
                        <div class='{GetPlanColorClass(planID)} progress-circle' style='--progress: {CalculatePercentage(used, offered)}%'>
                            <span>{CalculatePercentage(used, offered)}%</span>
                        </div>
                        <h4 style='color: #03184c;'>{used} / {offered} {type}</h4>
                    </div>";
        }

        protected string CalculatePercentage(object used, object total)
        {
            if (used == DBNull.Value || total == DBNull.Value || Convert.ToInt32(total) == 0) return "0";
            return ((Convert.ToDouble(used) / Convert.ToDouble(total)) * 100).ToString("0.0");
        }

        private string GetPlanColorClass(int planID)
        {
            switch (planID)
            {
                case 1:
                    return "basic-plan";
                case 2:
                    return "standard-plan";
                case 3:
                    return "premium-plan";
                case 4:
                    return "unlimited-plan";
                default:
                    return "";
            }
        }

        private string GeneratePlanCard(int planID, string planName, string planStatus)
        {
            string planClass = GetPlanColorClass(planID);
            string icon = "";
            string details = "";
            string price = "";
            string tooltipAttributes = planStatus == "onhold" ? "data-bs-toggle='tooltip' data-bs-placement='top' title='This plan is on hold. Complete payment to use it.'" : "";

            switch (planID)
            {
                case 1:
                    icon = "fa-user";
                    details = "Affordable plan for light users";
                    price = "$50/month";
                    break;
                case 2:
                    icon = "fa-users";
                    details = "Ideal for moderate users";
                    price = "$100/month";
                    break;
                case 3:
                    icon = "fa-star";
                    details = "Best for heavy users";
                    price = "$200/month";
                    break;
                case 4:
                    icon = "fa-infinity";
                    details = "Unlimited calls, SMS, and data";
                    price = "$300/month";
                    break;
            }

            return $@"
                <div class='plan-card {planClass}' style='width: 500px; margin: 200px 450px 150px 870px; transform: scale(1.4); {(planStatus == "onhold" ? "opacity: 0.5;" : "")}' {tooltipAttributes}>
                    <i class='fas {icon}'></i>
                    <div class='plan-name'>{planName}</div>
                    <div class='plan-id'>Plan ID: {planID}</div>
                    <div class='plan-details'>{details}</div>
                    <div class='plan-price'>Price: {price}</div>
                </div>";
        }
    }
}