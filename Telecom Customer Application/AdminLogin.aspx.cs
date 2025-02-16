using System;

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
                    Response.Redirect("AdminDashboard/CustomersPage.aspx");
                }
                else
                {
                    // Display error message
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
