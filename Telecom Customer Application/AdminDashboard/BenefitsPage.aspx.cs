using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Data;
using System.Web.UI;
using Newtonsoft.Json;

namespace Telecom_Customer_Application.AdminDashboard
{
    public partial class BenefitsPage : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
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

                    using (SqlCommand cmd = new SqlCommand("SELECT SUM(points_earned) FROM Customer_Points", con))
                    {
                        TotalPoints = Convert.ToInt32(cmd.ExecuteScalar());
                    }

                    using (SqlCommand cmd = new SqlCommand("SELECT SUM(amount_earned) FROM Customer_Cashback", con))
                    {
                        TotalCashback = Convert.ToInt32(cmd.ExecuteScalar());
                    }

                    using (SqlCommand cmd = new SqlCommand("SELECT COUNT(*) FROM Customer_Exclusive_Offers", con))
                    {
                        TotalOffers = Convert.ToInt32(cmd.ExecuteScalar());
                    }
                }

                string query1 = "GetCustomersWithBenefits";
                PageUtilities.ExecuteQueryWithHandling(query1, TableBody1, form1);

                string query2 = "GetCustomersWithNoBenefits";
                PageUtilities.ExecuteQueryWithHandling(query2, TableBody2, form1);

                string query3 = "GetBenefitsExpiringSoon";
                PageUtilities.ExecuteQueryWithHandling(query3, TableBody3, form1);

                // Fetch data for the pie chart
                DataTable benefitTypesData = GetBenefitTypesData();
                string benefitTypesJson = JsonConvert.SerializeObject(benefitTypesData);

                // Pass the JSON data to the front end
                ScriptManager.RegisterStartupScript(this, GetType(), "benefitTypesData", $"var benefitTypesData = {benefitTypesJson};", true);

                // Fetch data for the pie chart (active and expired benefits)
                Dictionary<string, int> benefitsStatus = GetActiveAndExpiredBenefits();
                string benefitsStatusJson = JsonConvert.SerializeObject(benefitsStatus);

                // Pass the JSON data to the front end
                ScriptManager.RegisterStartupScript(this, GetType(), "benefitsStatusData", $"var benefitsStatusData = {benefitsStatusJson};", true);

                totalPoints.InnerText = TotalPoints.ToString();
                totalCashback.InnerText = TotalCashback.ToString();
                totalOffers.InnerText = TotalOffers.ToString();
                totalBenefits.InnerText = TotalBenefits.ToString();

            }
            catch (Exception ex)
            {
                PageUtilities.DisplayAlert(ex, form1);
            }
        }

        protected DataTable GetBenefitTypesData()
        {
            DataTable dataTable = new DataTable();
            using (SqlConnection con = new SqlConnection(PageUtilities.connectionString))
            {
                try
                {
                    con.Open();
                    string query = "calculateBenefitsTypePercentages";

                    using (SqlCommand cmd = new SqlCommand(query, con))
                    {
                        using (SqlDataAdapter adapter = new SqlDataAdapter(cmd))
                        {
                            adapter.Fill(dataTable);
                        }
                    }
                }
                catch (Exception ex)
                {
                    PageUtilities.DisplayAlert(ex, form1);
                }
            }
            return dataTable;
        }
        protected Dictionary<string, int> GetActiveAndExpiredBenefits()
        {
            Dictionary<string, int> benefitsStatus = new Dictionary<string, int>();

            using (SqlConnection con = new SqlConnection(PageUtilities.connectionString))
            {
                try
                {
                    con.Open();
                    using (SqlCommand cmd = new SqlCommand("SELECT COUNT(*) FROM Customer_Benefits WHERE status = 'active'", con))
                    {
                        int activeCount = Convert.ToInt32(cmd.ExecuteScalar());
                        benefitsStatus.Add("Active", activeCount);
                    }
                    using (SqlCommand cmd = new SqlCommand("SELECT COUNT(*) FROM Customer_Benefits WHERE status = 'expired'", con))
                    {
                        int expiredCount = Convert.ToInt32(cmd.ExecuteScalar());
                        benefitsStatus.Add("Expired", expiredCount);
                    }
                }
                catch (Exception ex)
                {
                    PageUtilities.DisplayAlert(ex, form1);
                }
            }
            return benefitsStatus;
        }


        //protected void LoadCashback(object sender, EventArgs e)
        //{
        //    DisplayContent("CashbackTab");

        //    string query = "SELECT * FROM Num_of_cashback";

        //    ExecuteQueryWithHandling(query);

        //    SetActiveTab("CashbackTab");
        //}
        //protected void LoadCashbackAmount(object sender, EventArgs e)
        //{
        //    DisplayContent("CashbackAmountTab");

        //    SetActiveTab("CashbackAmountTab");
        //}
        //protected void LoadOffers(object sender, EventArgs e)
        //{
        //    DisplayContent("offersTab");

        //    SetActiveTab("offersTab");
        //}
        //protected void LoadPoints(object sender, EventArgs e)
        //{
        //    DisplayContent("PointsTab");

        //    SetActiveTab("PointsTab");
        //}


        //protected void DeleteBenefitsButton_Click(object sender, EventArgs e)
        //{

        //    using (SqlConnection con = new SqlConnection(connectionString))
        //    {
        //        try
        //        {
        //            con.Open();

        //            DeleteButton.Style["display"] = "none";

        //            Deleting benefits
        //            using (SqlCommand deleteCmd = new SqlCommand("Benefits_Account", con))
        //            {
        //                deleteCmd.CommandType = CommandType.StoredProcedure;
        //                deleteCmd.Parameters.Add(new SqlParameter("@mobile_num", SqlDbType.Char, 11) { Value = MobileEditText.Text });
        //                deleteCmd.Parameters.Add(new SqlParameter("@plan_id", SqlDbType.Int) { Value = int.Parse(PlanIDEditText.Text) });
        //                deleteCmd.ExecuteNonQuery();

        //            }

        //            Displaying benefits after deletion
        //            using (SqlCommand displayCmd = new SqlCommand("Benefits_Account_Plan", con))
        //            {
        //                displayCmd.CommandType = CommandType.StoredProcedure;
        //                displayCmd.Parameters.Add(new SqlParameter("@mobile_num", SqlDbType.Char, 11) { Value = MobileEditText.Text });
        //                displayCmd.Parameters.Add(new SqlParameter("@plan_id", SqlDbType.Int) { Value = int.Parse(PlanIDEditText.Text) });

        //                LoadData(displayCmd, TableBody1);
        //            }
        //        }
        //        catch (Exception ex)
        //        {
        //            DisplayAlert(ex);
        //        }
        //        finally
        //        {
        //            if (con.State == System.Data.ConnectionState.Open)
        //            {
        //                con.Close();
        //            }
        //        }
        //    }
        //}
        
    }
}