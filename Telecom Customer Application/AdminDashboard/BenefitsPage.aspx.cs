using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Data;
using System.Web.UI;
using Newtonsoft.Json;
using Microsoft.SqlServer.Server;
using System.Web.UI.HtmlControls;
using System.Collections;

namespace Telecom_Customer_Application.AdminDashboard
{
    public partial class BenefitsPage : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

            string eventTarget = Request.Form["__EVENTTARGET"];
            string eventArgument = Request.Form["__EVENTARGUMENT"];

            if (eventTarget == "DeleteBenefit")
            {
                string[] data = eventArgument.Split('|');
                string mobileNumber = data[0];
                int planId = int.Parse(data[1]);

                DeleteCustomerBenefit(mobileNumber, planId);
            }
            else if (eventTarget == "BenefitClicked")
            {
                // sent from the client
                int benefitID = int.Parse(eventArgument);      
                if (benefitID == 1)
                {
                    Response.Redirect("PointsPage.aspx");
                }
                else if (benefitID == 2)
                {
                    Response.Redirect("CashbackPage.aspx");
                }
                else
                {
                    Response.Redirect("ExclusiveOffersPage.aspx");
                }
            }

            try
            {
                int TotalPoints;
                int TotalCashback;
                int TotalOffers;
                int TotalBenefits;

                using (SqlConnection con = new SqlConnection(PageUtilities.connectionString))
                {
                    con.Open();

                    using (SqlCommand cmd = new SqlCommand("SELECT COUNT(*) FROM Customer_Benefits", con))
                    {
                        TotalBenefits = Convert.ToInt32(cmd.ExecuteScalar());
                    }

                    using (SqlCommand cmd = new SqlCommand("SELECT ISNULL(SUM(COALESCE(points_offered, 0)), 0) FROM Customer_Points", con))
                    {
                        TotalPoints = Convert.ToInt32(cmd.ExecuteScalar());
                    }

                    using (SqlCommand cmd = new SqlCommand("SELECT ISNULL(SUM(COALESCE(amount_earned, 0)), 0) FROM Customer_Cashback", con))
                    {
                        TotalCashback = Convert.ToInt32(cmd.ExecuteScalar());
                    }

                    using (SqlCommand cmd = new SqlCommand("SELECT COUNT(*) FROM Customer_Exclusive_Offers", con))
                    {
                        TotalOffers = Convert.ToInt32(cmd.ExecuteScalar());
                    }
                }

                totalPoints.InnerText = TotalPoints.ToString();
                totalCashback.InnerText = TotalCashback.ToString();
                totalOffers.InnerText = TotalOffers.ToString();
                totalBenefits.InnerText = TotalBenefits.ToString();

                string query1 = "GetActiveBenefits";
                PageUtilities.ExecuteQueryWithHandling(query1, TableBody1, form1, true);

                string query2 = "GetCustomersWithNoActiveBenefits";
                PageUtilities.ExecuteQueryWithHandling(query2, TableBody2, form1);

                string query3 = "GetBenefitsExpiringSoon";
                PageUtilities.ExecuteQueryWithHandling(query3, TableBody3, form1);

                // Fetch data for the pie chart
                DataTable benefitTypesData = PageUtilities.GetData("calculateBenefitsTypePercentages");
                string benefitTypesJson = JsonConvert.SerializeObject(benefitTypesData);

                // Pass the JSON data to the front end
                ScriptManager.RegisterStartupScript(this, GetType(), "benefitTypesData", $"var benefitTypesData = {benefitTypesJson};", true);

                DataTable benefitsStatusData = PageUtilities.GetData("calculateActiveExpiredBenefitsPercentage");
                string benefitsStatusJson = JsonConvert.SerializeObject(benefitsStatusData);

                ScriptManager.RegisterStartupScript(this, GetType(), "benefitsStatusData", $"var benefitsStatusData = {benefitsStatusJson};", true);
            }
            catch (Exception ex)
            {
                PageUtilities.DisplayAlert(ex, form1);
            }
            
        }

        private void DeleteCustomerBenefit(string mobile_num, int plan_id)
        {
            using (SqlConnection con = new SqlConnection(PageUtilities.connectionString))
            {
                try
                {
                    using (SqlCommand cmd = new SqlCommand("Delete_Benefits_Account_Plan", con))
                    {
                        con.Open();
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.Parameters.AddWithValue("@mobile_num", mobile_num);
                        cmd.Parameters.AddWithValue("@plan_id", plan_id);
                        cmd.ExecuteNonQuery();
                    }
                }
                catch (Exception ex)
                {
                    PageUtilities.DisplayAlert(ex, form1);
                }
            }
        }
    }
}