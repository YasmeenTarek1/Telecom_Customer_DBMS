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

                        using (SqlCommand cmd = new SqlCommand("ExclusiveOffersHistory", con))
                        {
                            cmd.CommandType = CommandType.StoredProcedure;
                            PageUtilities.LoadData(cmd, TableBody1);
                        }

                        using (SqlCommand cmd = new SqlCommand("CustomersOfferNotUsed", con))
                        {
                            cmd.CommandType = CommandType.StoredProcedure;
                            PageUtilities.LoadData(cmd, TableBody2);
                        }
                    }
                    totalOffersCount.InnerText = TotalOffersCount.ToString();
                    activeOffersCount.InnerText = ActiveOffersCount.ToString();
                    expiredOffersCount.InnerText = ExpiredOffersCount.ToString();

                    DataTable offersPlanData = GetData("calculatePlanOffersPercentage");
                    string offersPlanJson = JsonConvert.SerializeObject(offersPlanData);
                    ScriptManager.RegisterStartupScript(this, GetType(), "offersPlanData", $"var offersPlanData = {offersPlanJson};", true);

                    DataTable topSMSData = GetData("TopCustomersByOfferedSMS");
                    string jsonData1 = JsonConvert.SerializeObject(topSMSData);
                    ScriptManager.RegisterStartupScript(this, GetType(), "topSMSData", $"var topSMSData = {jsonData1};", true);

                    DataTable topMinutesData = GetData("TopCustomersByOfferedMinutes");
                    string jsonData2 = JsonConvert.SerializeObject(topMinutesData);
                    ScriptManager.RegisterStartupScript(this, GetType(), "topMinutesData", $"var topMinutesData = {jsonData2};", true);
                    
                    DataTable topInternetData = GetData("TopCustomersByOfferedInternet");
                    string jsonData3 = JsonConvert.SerializeObject(topInternetData);
                    ScriptManager.RegisterStartupScript(this, GetType(), "topInternetData", $"var topInternetData = {jsonData3};", true);
                }
                catch (Exception ex)
                {
                    PageUtilities.DisplayAlert(ex, form1);
                }
            }
        }
        protected DataTable GetData(String query)
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