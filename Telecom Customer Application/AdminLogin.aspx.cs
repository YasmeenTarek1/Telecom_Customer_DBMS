using Microsoft.SqlServer.Server;
using System;
using System.Web.UI.WebControls;

namespace Telecom_Customer_Application
{
    public partial class Login : System.Web.UI.Page
    {
        // Hardcoded Admin ID and Password
        private const string AdminID = "admin1";
        private const string AdminPassword = "123456";

        protected void Page_Load(object sender, EventArgs e)
        {
            lblMessage.Text = string.Empty;
        }

        protected void btnLogin_Click(object sender, EventArgs e)
        {
            string enteredID = txtAdminID.Text.Trim();
            string enteredPassword = txtPassword.Text.Trim();
            try
            {


                // Check if entered credentials match the hardcoded ones
                if (enteredID == AdminID && enteredPassword == AdminPassword)
                {
                    // Go to the Dashboard
                    Response.Redirect("AdminDashboard.aspx");
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
        protected void BackToHome(object sender, EventArgs e)
        {
            Response.Redirect("WelcomePage.aspx");

        }

    }
}
