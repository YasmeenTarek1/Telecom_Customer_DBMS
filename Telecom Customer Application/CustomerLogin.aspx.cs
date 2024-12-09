using System;
using System.Data.SqlClient;
using System.Web.Configuration;
using System.Web.UI.WebControls;

namespace Telecom_Customer_Application
{
    public partial class CustomerLogin : System.Web.UI.Page
    {
        private string connectionString = WebConfigurationManager.ConnectionStrings["TelecomDatabaseConnection"].ToString();

        protected void login(object sender, EventArgs e)
        {
            using (SqlConnection con = new SqlConnection(connectionString))
            {
                try
                {
                    string MobileNo = TextBox1.Text;
                    string Password = TextBox2.Text;

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

                        Response.Redirect("CustomerDashboard.aspx");
                    }
                    else
                    {
                        // Display error message
                        throw new Exception("Invalid Admin ID or Password.");

                    }

                }
                catch (Exception ex)
                {
                    // Use the DisplayAlert method to show the error message
                    DisplayAlert(ex);
                }
            }

        }
        protected void DisplayAlert(Exception ex)
        {
            string errorMessage = $@"
                <div id='errorAlert' class='alert alert-danger' role='alert'>{ex.Message}</div>
                <script>
                    var alertBox = document.getElementById('errorAlert');
                    if (alertBox) {{
                        alertBox.style.cssText = 'opacity: 1; transition: opacity 0.5s ease-out;';
                        setTimeout(function() {{
                            alertBox.style.opacity = '0';
                            setTimeout(function() {{
                                alertBox.style.visibility = 'hidden';
                            }}, 500);
                        }}, 2500);
                    }}
                </script>
        ";

            form1.Controls.Add(new Literal { Text = errorMessage });

        }

        protected void BackButton_Click(object sender, EventArgs e)
        {
            Response.Redirect("WelcomePage.aspx");

        }
    }
}