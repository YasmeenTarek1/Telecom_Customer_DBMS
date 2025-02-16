using System;
using System.Data;
using System.Data.SqlClient;

namespace Telecom_Customer_Application.CustomerDashboard
{
    public partial class HomePage : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                string mobileNo = Session["MobileNo"] as string;
                if (!string.IsNullOrEmpty(mobileNo))
                {
                    LoadSubscribedPlans(mobileNo);
                }
            }
        }

        private void LoadSubscribedPlans(string mobileNo)
        {
            using (SqlConnection conn = new SqlConnection(PageUtilities.connectionString))
            {
                SqlCommand cmd = null;
                cmd = new SqlCommand("LoadSubscribedPlans", conn);
                PageUtilities.checkValidMobileNum(mobileNo);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add(new SqlParameter("@mobileNo", SqlDbType.Char, 11)).Value = mobileNo;
                conn.Open();

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

                        // Plan Card
                        string planCard = GeneratePlanCard(planID, planName);
                        PlanCardContainer.InnerHtml = planCard;

                        // Plan Usage Cards
                        string planSMSCard = $@"
                            <div class='UsageElement' id='plan-{planID}'>
                                <div class='{GetPlanColorClass(planID)} progress-circle' style='--progress: {CalculatePercentage(smsUsed, smsOffered)}%'><span>{CalculatePercentage(smsUsed, smsOffered)}%</span></div>
                                <h4 style='color: #03184c;'>{smsUsed} / {smsOffered} SMS</h4>
                            </div>";
                        PlanContainer.InnerHtml += planSMSCard;

                        string planMinutesCard = $@"
                            <div class='UsageElement' id='plan-{planID}'>
                                <div class='{GetPlanColorClass(planID)} progress-circle' style='--progress: {CalculatePercentage(minutesUsed, minutesOffered)}%'><span>{CalculatePercentage(minutesUsed, minutesOffered)}%</span></div>
                                <h4 style='color: #03184c;'>{minutesUsed} / {minutesOffered} minutes</h4>
                            </div>";
                        PlanContainer.InnerHtml += planMinutesCard;

                        string planDataCard = $@"
                            <div class='UsageElement' id='plan-{planID}'>
                                <div class='{GetPlanColorClass(planID)} progress-circle' style='--progress:{CalculatePercentage(dataUsed, dataOffered)}%'><span>{CalculatePercentage(dataUsed, dataOffered)}%</span></div>
                                <h4 style='color: #03184c;'>{dataUsed} / {dataOffered} MB</h4>
                            </div>";
                        PlanContainer.InnerHtml += planDataCard;

                        // Load benefits for this plan
                        LoadPlanBenefits(planID);
                    }
                }
                
            }
        }

        private void LoadPlanBenefits(int planID)
        {
            using (SqlConnection conn = new SqlConnection(PageUtilities.connectionString))
            {

                SqlCommand cmd = null;
                cmd = new SqlCommand("LoadPlanBenefits", conn);
                PageUtilities.checkValidPlanID(planID.ToString());
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add(new SqlParameter("@planID", SqlDbType.Int) { Value = planID });
                conn.Open();
        
                using (SqlDataReader reader = cmd.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        int SMSOffered = reader.IsDBNull(0) ? 0 : reader.GetInt32(0);
                        int dataOffered = reader.IsDBNull(1) ? 0 : reader.GetInt32(1);
                        int minutesOffered = reader.IsDBNull(2) ? 0 : reader.GetInt32(2);
                        int pointsOffered = reader.IsDBNull(3) ? 0 : reader.GetInt32(3);

                        int SMSUsed = reader.IsDBNull(4) ? 0 : reader.GetInt32(4);
                        int dataUsed = reader.IsDBNull(5) ? 0 : reader.GetInt32(5);
                        int minutesUsed = reader.IsDBNull(6) ? 0 : reader.GetInt32(6);
                        int pointsUsed = reader.IsDBNull(7) ? 0 : reader.GetInt32(7);

                        if (SMSOffered > 0)
                        {
                            string benefitSMSCard = $@"
                            <div class='UsageElement'>
                                <div class='progress-circle {GetPlanColorClass(planID)}' style='--progress: {CalculatePercentage(SMSUsed, SMSOffered)}%'><span>{CalculatePercentage(SMSUsed, SMSOffered)}%</span></div>
                                <h4 style='color: #03184c;'>{SMSUsed} / {SMSOffered} SMS</h4>
                            </div>";
                            benefitsContainer.InnerHtml += benefitSMSCard;
                        }

                        if (minutesOffered > 0)
                        {
                            string benefitMinutesCard = $@"
                            <div class='UsageElement'>
                                <div class='progress-circle {GetPlanColorClass(planID)}' style='--progress: {CalculatePercentage(minutesUsed, minutesOffered)}%'><span>{CalculatePercentage(minutesUsed, minutesOffered)}%</span></div>
                                <h4 style='color: #03184c;'>{minutesUsed} / {minutesOffered} Minutes</h4>
                            </div>";
                            benefitsContainer.InnerHtml += benefitMinutesCard;
                        }

                        if (dataOffered > 0)
                        {
                            string benefitDataCard = $@"
                            <div class='UsageElement'>
                                <div class='progress-circle {GetPlanColorClass(planID)}' style='--progress: {CalculatePercentage(dataUsed, dataOffered)}%'><span>{CalculatePercentage(dataUsed, dataOffered)}%</span></div>
                                <h4 style='color: #03184c;'>{dataUsed} / {dataOffered} MB</h4>
                            </div>";
                            benefitsContainer.InnerHtml += benefitDataCard;
                        }

                        if (pointsOffered > 0)
                        {
                            string benefitPointsCard = $@"
                            <div class='UsageElement'>
                                <div class='progress-circle {GetPlanColorClass(planID)}' style='--progress: {CalculatePercentage(pointsUsed, pointsOffered)}%'><span>{CalculatePercentage(pointsUsed, pointsOffered)}%</span></div>
                                <h4 style='color: #03184c;'>{pointsUsed} / {pointsOffered} Points</h4>
                            </div>";
                            benefitsContainer.InnerHtml += benefitPointsCard;
                        }
                    }
                }
            }
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
        private string GeneratePlanCard(int planID, string planName)
        {
            string planClass = GetPlanColorClass(planID);
            string icon = "";
            string details = "";
            string price = "";

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
                <div class='plan-card {planClass}' style='width: 500px; margin: 100px 450px 150px 870px; transform: scale(1.4);'>
                    <i class='fas {icon}'></i>
                    <div class='plan-name'>{planName}</div>
                    <div class='plan-id'>Plan ID: {planID}</div>
                    <div class='plan-details'>{details}</div>
                    <div class='plan-price'>Price: {price}</div>
                </div>";
        }

    }
}