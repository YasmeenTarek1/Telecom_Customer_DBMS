using System;
using System.Data.SqlClient;
using System.Data;

namespace Telecom_Customer_Application.AdminDashboard
{
    public partial class AccountUsagePage : System.Web.UI.Page
    {
        protected void SearchButton_Click(object sender, EventArgs e)
        {
            using (SqlConnection con = new SqlConnection(PageUtilities.connectionString))
            {
                SqlCommand cmd = new SqlCommand("SELECT * FROM dbo.Account_Usage_Plan(@mobile_num, @start_date)", con);

                try
                {
                    string mobileNo = MobileEditText.Text;
                    PageUtilities.checkValidMobileNum(mobileNo);
                    cmd.Parameters.Add(new SqlParameter("@mobile_num", SqlDbType.Char, 11) { Value = mobileNo });
                    cmd.Parameters.Add(new SqlParameter("@start_date", SqlDbType.Date) { Value = DateTime.Parse(DateInput.Text) });
                    con.Open();
                    PageUtilities.LoadData(cmd, TableBody);
                }
                catch (Exception ex)
                {
                    PageUtilities.DisplayAlert(ex, form1);
                }
            }
        }
    }
}
