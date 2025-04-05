using System;
using System.Data.SqlClient;
using System.Text.RegularExpressions;

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
                    string MobileNo = TextBox1.Text.Trim();
                    string Password = txtPassword.Text.Trim();

                    // Validate MobileNo
                    if (string.IsNullOrEmpty(MobileNo))
                    {
                        throw new Exception("Mobile number cannot be empty.");
                    }
                    if (MobileNo.Length < 11)
                    {
                        throw new Exception("Please enter a valid mobile number.");
                    }

                    // Validate Password
                    if (string.IsNullOrEmpty(Password))
                    {
                        throw new Exception("Password cannot be empty.");
                    }

                    // Database call for login validation
                    SqlCommand cmd = new SqlCommand("SELECT dbo.AccountLoginValidation(@mobile_num, @pass)", con);
                    cmd.Parameters.Add(new SqlParameter("@mobile_num", MobileNo));
                    cmd.Parameters.Add(new SqlParameter("@pass", Password));

                    con.Open();
                    object result = cmd.ExecuteScalar();

                    // Check login result
                    if (result == null || !Convert.ToBoolean(result))
                    {
                        throw new Exception("Invalid Mobile Number or Password.");
                    }

                    // Fetch National ID
                    SqlCommand nationalIDCmd = new SqlCommand("SELECT nationalID FROM customer_account WHERE mobileNo = @mobileNo", con);
                    nationalIDCmd.Parameters.Add(new SqlParameter("@mobileNo", MobileNo));
                    object nationalIDObj = nationalIDCmd.ExecuteScalar();

                    // Validate National ID result
                    if (nationalIDObj == null)
                    {
                        throw new Exception("Account not found for the provided mobile number.");
                    }

                    int nationalID;
                    try
                    {
                        nationalID = Convert.ToInt32(nationalIDObj);
                    }
                    catch (FormatException)
                    {
                        throw new Exception("Invalid National ID format in the database.");
                    }

                    Session["MobileNo"] = MobileNo;
                    Session["NationalID"] = nationalID;
                    Response.Redirect("CustomerDashboard/HomePage.aspx");
                }
                catch (Exception ex)
                {
                    PageUtilities.DisplayAlert(ex, form1);
                }
            }
        }
    }
}