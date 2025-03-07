using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Newtonsoft.Json;

namespace Telecom_Customer_Application.AdminDashboard
{
    public partial class CashbackPage : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                try
                {
                    int PaymentCount;
                    int CashbackCount;

                    using (SqlConnection con = new SqlConnection(PageUtilities.connectionString))
                    {
                        con.Open();

                        using (SqlCommand cmd = new SqlCommand("SELECT * FROM TotalPayments", con))
                        {
                            PaymentCount = Convert.ToInt32(cmd.ExecuteScalar());
                        }

                        using (SqlCommand cmd = new SqlCommand("SELECT * FROM TotalCashback", con))
                        {
                            CashbackCount = Convert.ToInt32(cmd.ExecuteScalar());
                        }
                    }

                    cashbackCount.InnerText = CashbackCount.ToString() + " $";
                    paymentCount.InnerText = PaymentCount.ToString() + " $";

                    string query1 = "CashbackHistory";
                    PageUtilities.ExecuteQueryWithHandling(query1, TableBody1, form1);

                    string query2 = "SELECT * FROM Num_of_cashback";
                    PageUtilities.ExecuteQueryWithHandling(query2, TableBody2, form1);

                    // Fetch data for the pie chart
                    DataTable cashbackPlanData = PageUtilities.GetData("calculatePlanCashbackPercentage");
                    string cashbackPlanJson = JsonConvert.SerializeObject(cashbackPlanData);

                    // Pass the JSON data to the front end
                    ScriptManager.RegisterStartupScript(this, GetType(), "cashbackPlanData", $"var cashbackPlanData = {cashbackPlanJson};", true);

                    DataTable dataTable = PageUtilities.GetData("TopCustomersByCashback");
                    string jsonData = JsonConvert.SerializeObject(dataTable);

                    ScriptManager.RegisterStartupScript(this, GetType(), "topCustomersData", $"var topCustomersData = {jsonData};", true);
                }
                catch (Exception ex)
                {
                    PageUtilities.DisplayAlert(ex, form1);
                }
            }
        }
    }
}