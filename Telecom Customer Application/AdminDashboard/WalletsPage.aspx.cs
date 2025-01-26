using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.Configuration;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;

namespace Telecom_Customer_Application.AdminDashboard
{
    public partial class WalletsPage : System.Web.UI.Page
    {
        private string connectionString = WebConfigurationManager.ConnectionStrings["TelecomDatabaseConnection"].ToString();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                try
                {
                    string query = "SELECT * FROM CustomerWallet";

                    ExecuteQueryWithHandling(query);
                }
                catch (Exception ex)
                {
                    DisplayAlert(ex);
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

        protected void ExecuteQueryWithHandling(string query)
        {
            using (SqlConnection con = new SqlConnection(connectionString))
            {
                try
                {
                    using (SqlCommand cmd = new SqlCommand(query, con))
                    {
                        con.Open();
                        LoadData(cmd);
                    }
                }
                catch (Exception ex)
                {
                    DisplayAlert(ex);
                }
            }
        }
    }
}