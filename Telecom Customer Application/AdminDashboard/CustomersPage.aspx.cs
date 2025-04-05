using System;
using System.Data.SqlClient;

namespace Telecom_Customer_Application.AdminDashboard
{
    public partial class CustomersPage : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                try
                {
                    string query = "allCustomerAccounts";
                    PageUtilities.ExecuteQueryWithHandling(query, TableBody, form1);

                    int CustomerCount;
                    int PaymentCount;
                    int TransferCount;
                    int ServicePlanCount;

                    using (SqlConnection con = new SqlConnection(PageUtilities.connectionString))
                    {
                        con.Open();

                        using (SqlCommand cmd = new SqlCommand("SELECT COUNT(*) FROM Customer_profile", con))
                        {
                            CustomerCount = Convert.ToInt32(cmd.ExecuteScalar());
                        }

                        using (SqlCommand cmd = new SqlCommand("SELECT COUNT(*) FROM Payment", con))
                        {
                            PaymentCount = Convert.ToInt32(cmd.ExecuteScalar());
                        }

                        using (SqlCommand cmd = new SqlCommand("SELECT COUNT(*) FROM Transfer_money", con))
                        {
                            TransferCount = Convert.ToInt32(cmd.ExecuteScalar());
                        }

                        using (SqlCommand cmd = new SqlCommand("SELECT COUNT(*) FROM Service_Plan", con))
                        {
                            ServicePlanCount = Convert.ToInt32(cmd.ExecuteScalar());
                        }
                    }

                    customerCount.InnerText = CustomerCount.ToString();
                    paymentCount.InnerText = PaymentCount.ToString();
                    transferCount.InnerText = TransferCount.ToString();
                    servicePlanCount.InnerText = ServicePlanCount.ToString();

                }
                catch (Exception ex)
                {
                    PageUtilities.DisplayAlert(ex, form1);
                }
            }
        }
    }
}