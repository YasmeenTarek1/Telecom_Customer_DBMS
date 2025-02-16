using System;
using System.Data.SqlClient;

namespace Telecom_Customer_Application
{
    public partial class CustomerLogin : System.Web.UI.Page
    {
        protected void login(object sender, EventArgs e)
        {
            using (SqlConnection con = new SqlConnection(PageUtilities.connectionString))
            {
                try
                {
                    string MobileNo = TextBox1.Text;
                    string Password = txtPassword.Text;

                    SqlCommand cmd = new SqlCommand("SELECT dbo.AccountLoginValidation(@mobile_num, @pass)", con);
                    cmd.Parameters.Add(new SqlParameter("@mobile_num", MobileNo));
                    cmd.Parameters.Add(new SqlParameter("@pass", Password));

                    con.Open();
                    object result = cmd.ExecuteScalar();

                    if (result != null && Convert.ToBoolean(result) == true)
                    {
                        SqlCommand nationalIDCmd = new SqlCommand("SELECT nationalID  FROM customer_account WHERE mobileNo = @mobileNo", con);
                        nationalIDCmd.Parameters.Add(new SqlParameter("@mobileNo", MobileNo));
                        object nationalIDObj = nationalIDCmd.ExecuteScalar();
                        int nationalID = Convert.ToInt32(nationalIDObj);

                        Session["MobileNo"] = MobileNo;
                        Session["NationalID"] = nationalID;

                        Response.Redirect("CustomerDashboard/HomePage.aspx");
                    }
                    else
                    {
                        throw new Exception("Invalid Admin ID or Password.");

                    }
                }
                catch (Exception ex)
                {
                    PageUtilities.DisplayAlert(ex, form1);
                }
            }

        }
    }
}