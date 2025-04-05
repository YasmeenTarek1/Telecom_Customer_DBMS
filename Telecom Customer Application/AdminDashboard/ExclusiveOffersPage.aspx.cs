using System;
using System.Data.SqlClient;
using System.Data;
using System.Web.UI;
using Newtonsoft.Json;

namespace Telecom_Customer_Application.AdminDashboard
{
    public partial class ExclusiveOffersPage : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                try
                {
                    int TotalOffersCount;
                    int ActiveOffersCount;
                    int ExpiredOffersCount;

                    using (SqlConnection con = new SqlConnection(PageUtilities.connectionString))
                    {
                        con.Open();

                        using (SqlCommand cmd = new SqlCommand("SELECT * FROM TotalExclusiveOffers", con))
                        {
                            TotalOffersCount = Convert.ToInt32(cmd.ExecuteScalar());
                        }

                        using (SqlCommand cmd = new SqlCommand("SELECT * FROM ActiveExclusiveOffers", con))
                        {
                            ActiveOffersCount = Convert.ToInt32(cmd.ExecuteScalar());
                        }

                        using (SqlCommand cmd = new SqlCommand("SELECT * FROM ExpiredExclusiveOffers", con))
                        {
                            ExpiredOffersCount = Convert.ToInt32(cmd.ExecuteScalar());
                        }
                    }

                    string query1 = "ExclusiveOffersHistory";
                    PageUtilities.ExecuteQueryWithHandling(query1, TableBody1, form1);

                    string query2 = "CustomersOfferNotUsed";
                    PageUtilities.ExecuteQueryWithHandling(query2, TableBody2, form1);

                    totalOffersCount.InnerText = TotalOffersCount.ToString();
                    activeOffersCount.InnerText = ActiveOffersCount.ToString();
                    expiredOffersCount.InnerText = ExpiredOffersCount.ToString();

                    DataTable offersPlanData = PageUtilities.GetData("calculatePlanOffersPercentage");
                    string offersPlanJson = JsonConvert.SerializeObject(offersPlanData);
                    ScriptManager.RegisterStartupScript(this, GetType(), "offersPlanData", $"var offersPlanData = {offersPlanJson};", true);

                    DataTable topSMSData = PageUtilities.GetData("TopCustomersByOfferedSMS");
                    string jsonData1 = JsonConvert.SerializeObject(topSMSData);
                    ScriptManager.RegisterStartupScript(this, GetType(), "topSMSData", $"var topSMSData = {jsonData1};", true);

                    DataTable topMinutesData = PageUtilities.GetData("TopCustomersByOfferedMinutes");
                    string jsonData2 = JsonConvert.SerializeObject(topMinutesData);
                    ScriptManager.RegisterStartupScript(this, GetType(), "topMinutesData", $"var topMinutesData = {jsonData2};", true);
                    
                    DataTable topInternetData = PageUtilities.GetData("TopCustomersByOfferedInternet");
                    string jsonData3 = JsonConvert.SerializeObject(topInternetData);
                    ScriptManager.RegisterStartupScript(this, GetType(), "topInternetData", $"var topInternetData = {jsonData3};", true);
                }
                catch (Exception ex)
                {
                    PageUtilities.DisplayAlert(ex, form1);
                }
            }
        }
    }
}