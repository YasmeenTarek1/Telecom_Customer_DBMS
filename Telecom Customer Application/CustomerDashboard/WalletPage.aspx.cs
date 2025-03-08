using System;
using System.Web.Services;
using System.Data;
using System.Data.SqlClient;
using Newtonsoft.Json;

namespace Telecom_Customer_Application.CustomerDashboard
{
    public partial class WalletPage : System.Web.UI.Page
    {
        private static string mobileNum;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                try
                {
                    mobileNum = Session["MobileNo"].ToString();
                    HiddenMobileNo.Value = mobileNum ?? string.Empty;
                }
                catch (Exception ex)
                {
                    HiddenMobileNo.Value = string.Empty;
                }

            }

            using (SqlConnection con = new SqlConnection(PageUtilities.connectionString))
            {
                con.Open();
                SqlCommand cmd1 = new SqlCommand("LoadWalletTransfers", con);
                cmd1.CommandType = CommandType.StoredProcedure;
                cmd1.Parameters.Add(new SqlParameter("@mobile_num", SqlDbType.Char, 11) { Value = mobileNum });
                PageUtilities.LoadData(cmd1, TableBody1);

                SqlCommand cmd2 = new SqlCommand("LoadAccountPlanPayments", con);
                cmd2.CommandType = CommandType.StoredProcedure;
                cmd2.Parameters.Add(new SqlParameter("@mobile_num", SqlDbType.Char, 11) { Value = mobileNum });
                PageUtilities.LoadData(cmd2, TableBody2);

                SqlCommand cmd3 = new SqlCommand("LoadAccountBalanceRechargingPayments", con);
                cmd3.CommandType = CommandType.StoredProcedure;
                cmd3.Parameters.Add(new SqlParameter("@mobile_num", SqlDbType.Char, 11) { Value = mobileNum });
                PageUtilities.LoadData(cmd3, TableBody3);

                SqlCommand cmd4 = new SqlCommand("LoadAccountCashbacks", con);
                cmd4.CommandType = CommandType.StoredProcedure;
                cmd4.Parameters.Add(new SqlParameter("@mobile_num", SqlDbType.Char, 11) { Value = mobileNum });
                PageUtilities.LoadData(cmd4, TableBody4);
            }

        }

        [WebMethod]
        public static string GetCustomerInfo(string mobileNo)
        {
            try
            {
                if (string.IsNullOrEmpty(PageUtilities.connectionString))
                {
                    return JsonConvert.SerializeObject(new { error = "Database connection string is not configured" });
                }

                using (SqlConnection conn = new SqlConnection(PageUtilities.connectionString))
                {
                    conn.Open();

                    // Fetch customer info
                    string firstName = "Unknown", lastName = "User";
                    using (SqlCommand cmd = new SqlCommand("GetCustomerWalletInfo", conn))
                    {
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.Parameters.AddWithValue("@mobileNo", mobileNo ?? (object)DBNull.Value);

                        using (SqlDataReader reader = cmd.ExecuteReader())
                        {
                            if (reader.Read())
                            {
                                firstName = reader["first_name"]?.ToString() ?? "Unknown";
                                lastName = reader["last_name"]?.ToString() ?? "User";
                            }
                            else
                            {
                                return JsonConvert.SerializeObject(new { error = "No customer data found for this mobile number" });
                            }
                        }
                    }

                    // Fetch balance
                    decimal balance = 0;
                    using (SqlCommand cmd = new SqlCommand("SELECT current_balance FROM Wallet WHERE mobileNo = @mobileNo", conn))
                    {
                        cmd.Parameters.AddWithValue("@mobileNo", mobileNo);
                        object balanceResult = cmd.ExecuteScalar();
                        if (balanceResult != null && balanceResult != DBNull.Value)
                        {
                            balance = Convert.ToDecimal(balanceResult);
                        }
                    }

                    // Fetch cashback
                    decimal cashback = 0;
                    using (SqlCommand cmd = new SqlCommand(
                        @"SELECT SUM(cc.amount_earned) as total_cashback 
                          FROM Customer_Cashback cc 
                          JOIN Customer_Benefits cb ON cc.benefitID = cb.benefitID 
                          WHERE cb.mobileNo = @mobileNo", conn))
                    {
                        cmd.Parameters.AddWithValue("@mobileNo", mobileNo);
                        object cashbackResult = cmd.ExecuteScalar();
                        if (cashbackResult != null && cashbackResult != DBNull.Value)
                        {
                            cashback = Convert.ToDecimal(cashbackResult);
                        }
                    }

                    // Fetch sent transactions
                    decimal sentTransactions = 0;
                    using (SqlCommand cmd = new SqlCommand(
                        @"SELECT SUM(tm.amount) as total_sent 
                          FROM Transfer_money tm 
                          JOIN Wallet w ON tm.walletID1 = w.walletID 
                          WHERE w.mobileNo = @mobileNo", conn))
                    {
                        cmd.Parameters.AddWithValue("@mobileNo", mobileNo);
                        object sentResult = cmd.ExecuteScalar();
                        if (sentResult != null && sentResult != DBNull.Value)
                        {
                            sentTransactions = Convert.ToDecimal(sentResult);
                        }
                    }

                    // Fetch received transactions
                    decimal receivedTransactions = 0;
                    using (SqlCommand cmd = new SqlCommand(
                        @"SELECT SUM(tm.amount) as total_received 
                          FROM Transfer_money tm 
                          JOIN Wallet w ON tm.walletID2 = w.walletID 
                          WHERE w.mobileNo = @mobileNo", conn))
                    {
                        cmd.Parameters.AddWithValue("@mobileNo", mobileNo);
                        object receivedResult = cmd.ExecuteScalar();
                        if (receivedResult != null && receivedResult != DBNull.Value)
                        {
                            receivedTransactions = Convert.ToDecimal(receivedResult);
                        }
                    }

                    var result = new
                    {
                        first_name = firstName,
                        last_name = lastName,
                        mobileNo = mobileNo,
                        balance = balance,
                        cashback = cashback,
                        sentTransactions = sentTransactions,
                        receivedTransactions = receivedTransactions
                    };
                    return JsonConvert.SerializeObject(result);
                }
            }
            catch (SqlException sqlEx)
            {
                return JsonConvert.SerializeObject(new { error = $"Database error: {sqlEx.Message}" });
            }
            catch (Exception ex)
            {
                return JsonConvert.SerializeObject(new { error = $"General error: {ex.Message}" });
            }
        }


        [WebMethod]
        public static string RechargeBalance(string mobileNo, decimal amount, string paymentMethod)
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(PageUtilities.connectionString))
                {
                    conn.Open();

                    using (SqlCommand cmd = new SqlCommand("Recharge_Balance", conn))
                    {
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.Parameters.AddWithValue("@mobile_num", mobileNo);
                        cmd.Parameters.AddWithValue("@amount", amount);
                        cmd.Parameters.AddWithValue("@payment_method", paymentMethod);

                        cmd.ExecuteNonQuery();
                    }

                    return JsonConvert.SerializeObject(new { success = true });
                }
            }
            catch (SqlException sqlEx)
            {
                return JsonConvert.SerializeObject(new { success = false, error = $"Database error: {sqlEx.Message}" });
            }
            catch (Exception ex)
            {
                return JsonConvert.SerializeObject(new { success = false, error = $"General error: {ex.Message}" });
            }
        }

        [WebMethod]
        public static string TransferMoney(string senderMobile, string recipientMobile, decimal amount)
        {
            try
            {
                // Validate sender has enough balance
                using (SqlConnection conn = new SqlConnection(PageUtilities.connectionString))
                {
                    conn.Open();

                    decimal currentBalance = 0;
                    using (SqlCommand cmd = new SqlCommand("SELECT current_balance FROM Wallet WHERE mobileNo = @mobileNo", conn))
                    {
                        cmd.Parameters.AddWithValue("@mobileNo", senderMobile);
                        object result = cmd.ExecuteScalar();
                        if (result != null && result != DBNull.Value)
                        {
                            currentBalance = Convert.ToDecimal(result);
                        }
                    }

                    if (currentBalance < amount)
                    {
                        return JsonConvert.SerializeObject(new { success = false, error = "Insufficient balance for this transfer" });
                    }

                    // Verify recipient exists
                    bool recipientExists = false;
                    using (SqlCommand cmd = new SqlCommand("SELECT COUNT(*) FROM Wallet WHERE mobileNo = @mobileNo", conn))
                    {
                        cmd.Parameters.AddWithValue("@mobileNo", recipientMobile);
                        int count = (int)cmd.ExecuteScalar();
                        recipientExists = count > 0;
                    }

                    if (!recipientExists)
                    {
                        return JsonConvert.SerializeObject(new { success = false, error = "Recipient wallet not found" });
                    }

                    // Process transfer
                    using (SqlCommand cmd = new SqlCommand("Wallet_transfer", conn))
                    {
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.Parameters.AddWithValue("@mobile_num1", senderMobile);
                        cmd.Parameters.AddWithValue("@mobile_num2", recipientMobile);
                        cmd.Parameters.AddWithValue("@amount", amount);

                        cmd.ExecuteNonQuery();
                    }

                    return JsonConvert.SerializeObject(new { success = true });
                }
            }
            catch (SqlException sqlEx)
            {
                return JsonConvert.SerializeObject(new { success = false, error = $"Database error: {sqlEx.Message}" });
            }
            catch (Exception ex)
            {
                return JsonConvert.SerializeObject(new { success = false, error = $"General error: {ex.Message}" });
            }
        }
    }
}