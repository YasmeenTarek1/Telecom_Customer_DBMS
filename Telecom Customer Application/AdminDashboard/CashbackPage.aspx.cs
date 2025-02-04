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

                        using (SqlCommand cmd = new SqlCommand("CashbackHistory", con))
                        {
                            cmd.CommandType = CommandType.StoredProcedure;
                            PageUtilities.LoadData(cmd, TableBody1);
                        }
                    }
                    cashbackCount.InnerText = CashbackCount.ToString() + " $";
                    paymentCount.InnerText = PaymentCount.ToString() + " $";

                    string query = "SELECT * FROM Num_of_cashback";
                    PageUtilities.ExecuteQueryWithHandling(query, TableBody2, form1);

                    // Fetch data for the pie chart
                    DataTable cashbackPlanData = GetData("calculatePlanCashbackPercentage");
                    string cashbackPlanJson = JsonConvert.SerializeObject(cashbackPlanData);

                    // Pass the JSON data to the front end
                    ScriptManager.RegisterStartupScript(this, GetType(), "cashbackPlanData", $"var cashbackPlanData = {cashbackPlanJson};", true);

                    DataTable dataTable = GetData("TopCustomersByCashback");
                    string jsonData = JsonConvert.SerializeObject(dataTable);

                    ScriptManager.RegisterStartupScript(this, GetType(), "topCustomersData", $"var topCustomersData = {jsonData};", true);
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