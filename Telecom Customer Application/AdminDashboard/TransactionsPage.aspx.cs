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
                string subtab = Request.QueryString["subtab"];

                if (!string.IsNullOrEmpty(subtab))
                {
                    switch (subtab.ToLower())
                    {
                        case "details":
                            LoadTransactionDetails(sender, e);
                            break;

                        case "average":
                            LoadAverageTransactions(sender, e);
                            break;
                    }
                }
            }
        }

        protected void LoadTransactionDetails(object sender, EventArgs e)
        {
            TabHeading.InnerText = "Transaction Details";

            DateContainer1.Style["display"] = "none";
            DateInput1.Text = "";

            DateContainer2.Style["display"] = "none";
            DateInput2.Text = "";

            TextBoxContainer2.Style["display"] = "block";
            MobileEditText.Text = "";

            TextBoxContainer3.Style["display"] = "none";
            WalletEditText.Text = "";

            LabelOut.Style["display"] = "none";
            LabelOut.Text = "";

            TableBody.Style["display"] = "block";
        }

        protected void LoadAverageTransactions(object sender, EventArgs e)
        {
            TabHeading.InnerText = "Average Transaction Amount";

            DateContainer1.Style["display"] = "block";
            DateInput1.Text = "";

            DateContainer2.Style["display"] = "block";
            DateInput2.Text = "";

            TextBoxContainer2.Style["display"] = "none";
            MobileEditText.Text = "";

            TextBoxContainer3.Style["display"] = "block";
            WalletEditText.Text = "";

            LabelOut.Style["display"] = "block";
            LabelOut.Text = "";

            TableBody.Style["display"] = "none";
        }

        protected void SearchButton_Click(object sender, EventArgs e)
        {
            using (SqlConnection con = new SqlConnection(PageUtilities.connectionString))
            {
                SqlCommand cmd = null;

                try
                {
                    string subtab = Request.QueryString["subtab"];

                    if (subtab == "details")
                    {
                        cmd = new SqlCommand("Account_Payment_Points", con);
                        string mobileNo = MobileEditText.Text;
                        PageUtilities.checkValidMobileNum(mobileNo);
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.Parameters.Add(new SqlParameter("@mobile_num", SqlDbType.Char, 11)).Value = mobileNo;
                        con.Open();
                        PageUtilities.LoadData(cmd, TableBody);
                    }
                    else if (subtab == "average")
                    {
                        cmd = new SqlCommand("SELECT dbo.Wallet_Transfer_Amount(@walletID, @start_date, @end_date)", con);
                        string walletId = WalletEditText.Text;
                        PageUtilities.CheckValidWalletID(walletId);
                        cmd.Parameters.Add(new SqlParameter("@walletID", walletId));
                        cmd.Parameters.Add(new SqlParameter("@start_date", SqlDbType.Date) { Value = DateTime.Parse(DateInput1.Text) });
                        cmd.Parameters.Add(new SqlParameter("@end_date", SqlDbType.Date) { Value = DateTime.Parse(DateInput2.Text) });
                        con.Open();
                        LoadLabel(cmd);
                    }
                }
                catch (Exception ex)
                {
                    PageUtilities.DisplayAlert(ex, TableBody);
                }
            }
        }
        protected void LoadLabel(SqlCommand cmd)
        {
            object result = cmd.ExecuteScalar();

            if (result != null && result != DBNull.Value)
            {
                int data = Convert.ToInt32(result);
                LabelOut.Text = $"Average Transactions Amount: {data}";
            }
            else
            {
                throw new Exception("No cashback available for this wallet and plan combination.");
            }
        }
    }
}