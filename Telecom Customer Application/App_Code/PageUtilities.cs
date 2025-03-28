using System;
using System.Data.SqlClient;
using System.Data;
using System.Linq;
using System.Web.Configuration;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Web.UI;
using Microsoft.SqlServer.Server;
using System.IdentityModel.Protocols.WSTrust;

public class PageUtilities
{
    public static string connectionString = WebConfigurationManager.ConnectionStrings["TelecomDatabaseConnection"].ToString();
    public static void ExecuteQueryWithHandling(string query, HtmlGenericControl TableBody, Control form1, bool showDeleteButton = false)
    {
        using (SqlConnection con = new SqlConnection(connectionString))
        {
            try
            {
                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    con.Open();
                    LoadData(cmd, TableBody, showDeleteButton);
                }
            }
            catch (Exception ex)
            {
                DisplayAlert(ex, form1);
            }
        }
    }
    public static void LoadData(SqlCommand cmd, HtmlGenericControl tableBody, bool showDeleteButton = false)
    {
        using (SqlDataReader reader = cmd.ExecuteReader())
        {
            // Clear any existing content
            tableBody.Controls.Clear();

            if (reader.HasRows)
            {
                HtmlTableRow headerRow = new HtmlTableRow();

                // Generate headers dynamically
                for (int i = 0; i < reader.FieldCount; i++)
                {
                    string columnName = reader.GetName(i);
                    HtmlTableCell headerCell = new HtmlTableCell("th");

                    if (columnName.Equals("first_name", StringComparison.OrdinalIgnoreCase))
                    {
                        headerCell.InnerText = "Name";
                    }
                    else if (!columnName.Equals("last_name", StringComparison.OrdinalIgnoreCase))
                    {
                        var words = columnName.Split(new[] { '_', ' ' }, StringSplitOptions.RemoveEmptyEntries);
                        columnName = string.Join(" ", words.Select(word => char.ToUpper(word[0]) + word.Substring(1)));

                        headerCell.InnerText = columnName;
                    }
                    else
                    {
                        continue; // Skip last_name column
                    }

                    headerRow.Cells.Add(headerCell);
                }

                // Add Delete Button column header
                if (showDeleteButton)
                {
                    HtmlTableCell deleteHeaderCell = new HtmlTableCell("th") { InnerText = "Delete Benefit" };
                    headerRow.Cells.Add(deleteHeaderCell);
                }

                tableBody.Controls.Add(headerRow);

                // Generate rows dynamically
                while (reader.Read())
                {
                    HtmlTableRow row = new HtmlTableRow();

                    for (int i = 0; i < reader.FieldCount; i++)
                    {
                        HtmlTableCell cell = new HtmlTableCell();

                        // Status Column with Styling
                        if (reader.GetName(i).IndexOf("status", StringComparison.OrdinalIgnoreCase) >= 0)
                        {
                            string statusValue = reader[i]?.ToString();
                            string statusClass = "";
                            switch(statusValue.ToLower()){
                                case "active":
                                case "successful":
                                case "resolved": statusClass = "status-active"; break;
                                case "onhold":
                                case "rejected":
                                case "open":
                                case "expired": statusClass = "status-onhold"; break;
                                case "pending":
                                case "in progress": statusClass = "status -pending"; break;
                            };

                            string formattedStatus = statusValue.Equals("onhold", StringComparison.OrdinalIgnoreCase)
                                ? "On-Hold"
                                : char.ToUpper(statusValue[0]) + statusValue.Substring(1);

                            cell.InnerHtml = $"<span class='{statusClass}'>{formattedStatus}</span>";
                            row.Cells.Add(cell);
                        }
                        // URL Column
                        else if (reader.GetName(i).Equals("URL", StringComparison.OrdinalIgnoreCase))
                        {
                            string url = reader[i]?.ToString();
                            cell.InnerHtml = !string.IsNullOrEmpty(url)
                                ? $"<a href='{url}' class='clickable-link'>{url}</a>"
                                : "No URL";
                            row.Cells.Add(cell);
                        }
                        // Email Column
                        else if (reader.GetName(i).Equals("Email", StringComparison.OrdinalIgnoreCase))
                        {
                            string mail = reader[i]?.ToString();
                            cell.InnerHtml = !string.IsNullOrEmpty(mail)
                                ? $"<a href='mailto:{mail}' class='clickable-link'>{mail}</a>"
                                : "No Email";
                            row.Cells.Add(cell);
                        }
                        // first_name and last_name Combination
                        else if (reader.GetName(i).Equals("first_name", StringComparison.OrdinalIgnoreCase))
                        {
                            string firstName = reader[i]?.ToString();
                            string lastName = (i + 1 < reader.FieldCount && reader.GetName(i + 1).Equals("last_name", StringComparison.OrdinalIgnoreCase))
                                ? reader[++i]?.ToString()
                                : "";

                            string initials = (!string.IsNullOrEmpty(firstName) ? firstName[0].ToString() : "") +
                                              (!string.IsNullOrEmpty(lastName) ? lastName[0].ToString() : "");

                            cell.InnerHtml = $@"
                            <div class='name-container'>
                                <div class='initials-circle'>{initials}</div>
                                <span class='full-name'>{firstName} {lastName}</span>
                            </div>";
                            row.Cells.Add(cell);
                        }
                        else if (!reader.GetName(i).Equals("last_name", StringComparison.OrdinalIgnoreCase)) // Skip last_name
                        {
                            cell.InnerText = reader[i]?.ToString();
                            row.Cells.Add(cell);
                        }
                    }

                    // Add Delete Button if enabled
                    if (showDeleteButton)
                    {
                        HtmlTableCell deleteCell = new HtmlTableCell();
                        deleteCell.InnerHtml = $"<button class='delete-btn' onclick='deleteBenefit(this)'>Delete</button>";
                        row.Cells.Add(deleteCell);
                    }

                    tableBody.Controls.Add(row);
                }
            }
            else
            {
                HtmlTableRow row = new HtmlTableRow();
                HtmlTableCell cell = new HtmlTableCell
                {
                    ColSpan = reader.FieldCount > 0 ? reader.FieldCount : 1,
                    InnerText = "No data available"
                };

                cell.Style.Add("text-align", "center");
                cell.Style.Add("font-size", "16px");
                cell.Style.Add("font-weight", "bold");
                cell.Style.Add("color", "#dc3545");
                cell.Style.Add("background-color", "#f8d7da");
                cell.Style.Add("padding", "15px");
                cell.Style.Add("border", "1px solid #f5c6cb");
                cell.Style.Add("border-radius", "5px");

                row.Cells.Add(cell);
                tableBody.Controls.Add(row);
            }
        }
    }

    public static void DisplayAlert(Exception ex, Control form, string alertType = "alert-danger")
    {
        string message = ex != null ? ex.Message : "Operation completed successfully!";
        string script = $@"
        const alertDiv = document.createElement('div');
        alertDiv.className = 'alert {alertType}';
        alertDiv.innerHTML = '{message}';
        alertDiv.style.position = 'fixed';
        alertDiv.style.top = '20px';
        alertDiv.style.left = '50%';
        alertDiv.style.transform = 'translateX(-50%)';
        alertDiv.style.padding = '15px';
        alertDiv.style.zIndex = '9999';
        document.body.appendChild(alertDiv);
        setTimeout(() => alertDiv.remove(), 3500);
    ";
        ScriptManager.RegisterStartupScript(form, form.GetType(), "DisplayAlert", script, true);
    }
    public static void checkValidPlanID(string planID)
    {
        if (string.IsNullOrEmpty(planID))
            throw new Exception("Plan ID number cannot be empty.");

        if (!planID.All(char.IsDigit))
            throw new Exception("Invalid Plan ID numbers. Please enter digits only.");

        using (SqlConnection con = new SqlConnection(connectionString))
        {
            using (SqlCommand cmd = new SqlCommand("SELECT COUNT(*) FROM Service_plan WHERE planID = @planID", con))
            {
                cmd.Parameters.Add(new SqlParameter("@planID", planID));
                con.Open();

                int count = (int)cmd.ExecuteScalar();
                if (count < 1)
                    throw new Exception("Invalid Plan ID number. Plan does not exist.");
            }
        }
    }

    public static void checkValidMobileNum(string mobileNum)
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

    public static void CheckValidWalletID(string walletID)
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

    public static DataTable GetData(String query)
    {
        DataTable dataTable = new DataTable();
        using (SqlConnection con = new SqlConnection(connectionString))
        {
            con.Open();

            using (SqlCommand cmd = new SqlCommand(query, con))
            {
                using (SqlDataAdapter adapter = new SqlDataAdapter(cmd))
                {
                    adapter.Fill(dataTable);
                }
            }
        }
        return dataTable;
    }
}