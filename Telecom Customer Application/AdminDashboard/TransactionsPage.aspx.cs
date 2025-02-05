using System;
using System.Data;
using System.Data.SqlClient;

namespace Telecom_Customer_Application.AdminDashboard
{
    public partial class TransactionsPage : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                using (SqlConnection con = new SqlConnection(PageUtilities.connectionString))
                {
                    try
                    {
                        con.Open();
                        SqlCommand cmd = new SqlCommand("SELECT * From TransactionsHistory", con);
                        PageUtilities.LoadData(cmd, TableBody);
                    }
                    catch (Exception ex)
                    {
                        PageUtilities.DisplayAlert(ex, TableBody);
                    }
                }
            }
        }

        protected void ApplyFilterButton_Click(object sender, EventArgs e)
        {

            using (SqlConnection con = new SqlConnection(PageUtilities.connectionString))
            {
                try
                {
                    con.Open();

                    string walletId = WalletEditText.Text;
                    PageUtilities.CheckValidWalletID(walletId);


                    SqlCommand cmd = new SqlCommand("Wallet_Transaction_History", con);
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.Add(new SqlParameter("@walletID", walletId));
                    PageUtilities.LoadData(cmd, TableBody);

                    SqlCommand cmd1 = new SqlCommand("SELECT dbo.Wallet_Average_Sent(@walletID, @start_date, @end_date)", con);
                    cmd1.Parameters.Add(new SqlParameter("@walletID", walletId));
                    cmd1.Parameters.Add(new SqlParameter("@start_date", SqlDbType.Date) { Value = DateTime.Parse(DateInput1.Text) });
                    cmd1.Parameters.Add(new SqlParameter("@end_date", SqlDbType.Date) { Value = DateTime.Parse(DateInput2.Text) });

                    SqlCommand cmd2 = new SqlCommand("SELECT dbo.Wallet_Average_Received(@walletID, @start_date, @end_date)", con);
                    cmd2.Parameters.Add(new SqlParameter("@walletID", walletId));
                    cmd2.Parameters.Add(new SqlParameter("@start_date", SqlDbType.Date) { Value = DateTime.Parse(DateInput1.Text) });
                    cmd2.Parameters.Add(new SqlParameter("@end_date", SqlDbType.Date) { Value = DateTime.Parse(DateInput2.Text) });

                    AverageSentLabel.Style["display"] = "block";
                    AverageReceivedLabel.Style["display"] = "block";

                    LoadLabel(cmd1, cmd2);
                }
                catch (Exception ex)
                {
                    PageUtilities.DisplayAlert(ex, form1);
                }
            }
        }
        protected void LoadLabel(SqlCommand cmd1, SqlCommand cmd2)
        {
            object result = cmd1.ExecuteScalar();
            int data = Convert.ToInt32(result);
            AverageSentLabel.Text = $"Average Sent Transactions: {data}";

            result = cmd2.ExecuteScalar();
            data = Convert.ToInt32(result);
            AverageReceivedLabel.Text = $"Average Received Transactions: {data}";
        }
    }
}