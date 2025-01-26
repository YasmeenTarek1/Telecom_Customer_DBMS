using System;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web.Configuration;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;

namespace Telecom_Customer_Application.AdminDashboard
{
    public partial class TransactionsPage : System.Web.UI.Page
    {
        private string connectionString = WebConfigurationManager.ConnectionStrings["TelecomDatabaseConnection"].ToString();

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
            using (SqlConnection con = new SqlConnection(connectionString))
            {
                SqlCommand cmd = null;

                try
                {
                    string subtab = Request.QueryString["subtab"];

                    if (subtab == "details")
                    {
                        cmd = new SqlCommand("Account_Payment_Points", con);
                        string mobileNo = MobileEditText.Text;
                        checkValidMobileNum(mobileNo);
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.Parameters.Add(new SqlParameter("@mobile_num", SqlDbType.Char, 11)).Value = mobileNo;
                        con.Open();
                        LoadData(cmd);
                    }
                    else if (subtab == "average")
                    {
                        cmd = new SqlCommand("SELECT dbo.Wallet_Transfer_Amount(@walletID, @start_date, @end_date)", con);
                        string walletId = WalletEditText.Text;
                        CheckValidWalletID(walletId);
                        cmd.Parameters.Add(new SqlParameter("@walletID", walletId));
                        cmd.Parameters.Add(new SqlParameter("@start_date", SqlDbType.Date) { Value = DateTime.Parse(DateInput1.Text) });
                        cmd.Parameters.Add(new SqlParameter("@end_date", SqlDbType.Date) { Value = DateTime.Parse(DateInput2.Text) });
                        con.Open();
                        LoadLabel(cmd);
                    }
                }
                catch (Exception ex)
                {
                    DisplayAlert(ex);
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
        protected void checkValidMobileNum(string mobileNum)
        {
            if (string.IsNullOrEmpty(mobileNum))
                throw new Exception("Mobile number cannot be empty.");

            if (mobileNum.Length != 11 || !mobileNum.All(char.IsDigit))
                throw new Exception("Invalid mobile number. It must be exactly 11 digits and contain digits only.");

            using (SqlConnection con = new SqlConnection(connectionString))
            {
                using (SqlCommand cmd = new SqlCommand("SELECT COUNT(*) FROM customer_account WHERE mobileNo = @mobileNo", con))
                {
                    cmd.Parameters.Add(new SqlParameter("@mobileNo", SqlDbType.Char, 11)).Value = mobileNum;
                    con.Open();

                    int count = (int)cmd.ExecuteScalar();
                    if (count < 1)
                        throw new Exception("Invalid mobile number. Mobile number does not exist.");
                }
            }
        }

        protected void CheckValidWalletID(string walletID)
        {
            if (string.IsNullOrEmpty(walletID))
                throw new Exception("Wallet ID number cannot be empty.");

            if (!walletID.All(char.IsDigit))
                throw new Exception("Wallet ID numbers. Please enter digits only.");

            using (SqlConnection con = new SqlConnection(connectionString))
            {
                using (SqlCommand cmd = new SqlCommand("SELECT COUNT(*) FROM Wallet WHERE walletID = @walletID", con))
                {
                    cmd.Parameters.Add(new SqlParameter("@walletID", walletID));
                    con.Open();

                    int count = (int)cmd.ExecuteScalar();
                    if (count < 1)
                        throw new Exception("Invalid Wallet ID number. Wallet does not exist.");
                }
            }
        }
        protected void LoadData(SqlCommand cmd)
        {
            using (SqlDataReader reader = cmd.ExecuteReader())
            {
                // Clear any existing content
                TableBody.Controls.Clear();

                if (reader.HasRows)
                {
                    HtmlTableRow row = new HtmlTableRow();

                    // Generate headers dynamically
                    for (int i = 0; i < reader.FieldCount; i++)
                    {
                        string columnName = reader.GetName(i); // Get column name
                        HtmlTableCell headerCell = new HtmlTableCell("th");

                        // Replace "first_name" columns with "Name" in the header
                        if (columnName.Equals("first_name", StringComparison.OrdinalIgnoreCase))
                        {
                            headerCell.InnerText = "Name";
                            row.Cells.Add(headerCell);
                        }
                        else if (!columnName.Equals("last_name", StringComparison.OrdinalIgnoreCase)) // Skip last_name column header
                        {
                            // Split column name by both underscore and space
                            var words = columnName.Split(new[] { '_', ' ' }, StringSplitOptions.RemoveEmptyEntries);

                            // Capitalize first character of each word
                            columnName = string.Join(" ", words.Select(word => char.ToUpper(word[0]) + word.Substring(1)));

                            headerCell.InnerText = columnName;
                            row.Cells.Add(headerCell);
                        }
                    }
                    TableBody.Controls.Add(row);

                    // Generate rows dynamically
                    while (reader.Read())
                    {
                        row = new HtmlTableRow();
                        for (int i = 0; i < reader.FieldCount; i++)
                        {
                            HtmlTableCell cell = new HtmlTableCell();

                            // Status Column
                            if (reader.GetName(i).IndexOf("status", StringComparison.OrdinalIgnoreCase) >= 0)
                            {
                                string statusValue = reader[i]?.ToString();
                                string statusClass = "";

                                if (statusValue.Equals("active", StringComparison.OrdinalIgnoreCase) || statusValue.Equals("successful", StringComparison.OrdinalIgnoreCase) || statusValue.Equals("Resolved", StringComparison.OrdinalIgnoreCase))
                                {
                                    statusClass = "status-active"; // green
                                }
                                else if (statusValue.Equals("onhold", StringComparison.OrdinalIgnoreCase) || statusValue.Equals("rejected", StringComparison.OrdinalIgnoreCase) || statusValue.Equals("Open", StringComparison.OrdinalIgnoreCase) || statusValue.Equals("expired", StringComparison.OrdinalIgnoreCase))
                                {
                                    statusClass = "status-onhold"; // red
                                }
                                else if (statusValue.Equals("pending", StringComparison.OrdinalIgnoreCase) || statusValue.Equals("In progress", StringComparison.OrdinalIgnoreCase))
                                {
                                    statusClass = "status-pending"; // yellow
                                }

                                // Build a <span> element for the status label
                                if (reader[i].ToString().Equals("onhold"))
                                    cell.InnerHtml = $"<span class='{statusClass}'>{"On-Hold"}</span>";
                                else
                                    cell.InnerHtml = $"<span class='{statusClass}'>{char.ToUpper(statusValue[0]) + statusValue.Substring(1)}</span>";
                                row.Cells.Add(cell);
                            }
                            // URL Column 
                            else if (reader.GetName(i).Equals("URL", StringComparison.OrdinalIgnoreCase))
                            {
                                string url = reader[i]?.ToString();

                                // If URL is not empty, create a clickable link
                                if (!string.IsNullOrEmpty(url))
                                {
                                    // Apply the clickable-link class to make it blue and clickable
                                    cell.InnerHtml = $"<a href='{url}' class='clickable-link'>{url}</a>";
                                }
                                else
                                {
                                    cell.InnerText = "No URL"; // Display a placeholder if URL is empty
                                }
                                row.Cells.Add(cell);
                            }
                            // Email Column
                            else if (reader.GetName(i).Equals("Email", StringComparison.OrdinalIgnoreCase))
                            {
                                string mail = reader[i]?.ToString();

                                if (!string.IsNullOrEmpty(mail))
                                {
                                    // Apply the clickable-link class to make it blue and clickable
                                    cell.InnerHtml = $"<a href='mailto:{mail}' class='clickable-link'>{mail}</a>";
                                }
                                else
                                {
                                    cell.InnerText = "No URL"; // Display a placeholder if Mail is empty
                                }
                                row.Cells.Add(cell);
                            }
                            // first_name Column 
                            else if (reader.GetName(i).Equals("first_name", StringComparison.OrdinalIgnoreCase))
                            {
                                string firstName = reader[i]?.ToString();
                                string lastName = string.Empty;

                                // Check if the next column is "last_name" and retrieve its value
                                if (i + 1 < reader.FieldCount && reader.GetName(i + 1).Equals("last_name", StringComparison.OrdinalIgnoreCase))
                                {
                                    lastName = reader[i + 1]?.ToString(); // Get the last name
                                    i++; // Skip the last name column since we've already handled it
                                }

                                HtmlTableCell nameCell = new HtmlTableCell();

                                // Generate initials and combine with full name
                                string initials = string.Empty;

                                if (!string.IsNullOrEmpty(firstName)) initials += firstName[0];
                                if (!string.IsNullOrEmpty(lastName)) initials += lastName[0];

                                // Add initials and full name in a single cell
                                nameCell.InnerHtml = $@"
                                <div class='name-container'>
                                    <div class='initials-circle'>{initials}</div>
                                    <span class='full-name'>{firstName} {lastName}</span>
                                </div>";

                                row.Cells.Add(nameCell);
                            }
                            else if (!reader.GetName(i).Equals("last_name", StringComparison.OrdinalIgnoreCase)) // Skip last_name column
                            {
                                cell.InnerText = reader[i]?.ToString();
                                row.Cells.Add(cell);
                            }
                        }
                        TableBody.Controls.Add(row);
                    }
                }
                // Displaying no data available label instead of an empty table
                else
                {
                    HtmlTableRow row = new HtmlTableRow();
                    HtmlTableCell cell = new HtmlTableCell();
                    cell.ColSpan = reader.FieldCount > 0 ? reader.FieldCount : 1;
                    cell.InnerText = "No data available";
                    cell.Style.Add("text-align", "center");
                    cell.Style.Add("font-size", "16px");
                    cell.Style.Add("font-weight", "bold");
                    cell.Style.Add("color", "#dc3545");
                    cell.Style.Add("background-color", "#f8d7da");
                    cell.Style.Add("padding", "15px");
                    cell.Style.Add("border", "1px solid #f5c6cb");
                    cell.Style.Add("border-radius", "5px");
                    row.Cells.Add(cell);
                    TableBody.Controls.Add(row);
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
                </script>";

            form1.Controls.Add(new Literal { Text = errorMessage });

        }
    }
}