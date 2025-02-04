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
            string eventTarget = Request.Form["__EVENTTARGET"];
            string eventArgument = Request.Form["__EVENTARGUMENT"];

            if (eventTarget == "BenefitClicked")
            {
                int benefitID = int.Parse(eventArgument);      // eventArgument will contain the benefit ID sent from the client
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

            if (!IsPostBack)
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

                        using (SqlCommand cmd = new SqlCommand("SELECT ISNULL(SUM(COALESCE(points_earned, 0)), 0) FROM Customer_Points", con))
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

                    string query1 = "GetCustomersWithBenefits";
                    PageUtilities.ExecuteQueryWithHandling(query1, TableBody1, form1);

                    string query2 = "GetCustomersWithNoActiveBenefits";
                    PageUtilities.ExecuteQueryWithHandling(query2, TableBody2, form1);

                    string query3 = "GetBenefitsExpiringSoon";
                    PageUtilities.ExecuteQueryWithHandling(query3, TableBody3, form1);

                    // Fetch data for the pie chart
                    DataTable benefitTypesData = GetData("calculateBenefitsTypePercentages");
                    string benefitTypesJson = JsonConvert.SerializeObject(benefitTypesData);

                    // Pass the JSON data to the front end
                    ScriptManager.RegisterStartupScript(this, GetType(), "benefitTypesData", $"var benefitTypesData = {benefitTypesJson};", true);

                    DataTable benefitsStatusData = GetData("calculateActiveExpiredBenefitsPercentage");
                    string benefitsStatusJson = JsonConvert.SerializeObject(benefitsStatusData);

                    ScriptManager.RegisterStartupScript(this, GetType(), "benefitsStatusData", $"var benefitsStatusData = {benefitsStatusJson};", true);
                }
                catch (Exception ex)
                {
                    PageUtilities.DisplayAlert(ex, form1);
                }
            }
        }

        protected DataTable GetData(string query)
        {
            DataTable dataTable = new DataTable();
            using (SqlConnection con = new SqlConnection(PageUtilities.connectionString))
            {
                try
                {
                    con.Open();

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
    }
}