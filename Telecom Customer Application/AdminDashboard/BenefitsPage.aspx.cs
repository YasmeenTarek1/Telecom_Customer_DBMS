using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Newtonsoft.Json;
using System.Web.Configuration;
using System.Web.UI.HtmlControls;

namespace Telecom_Customer_Application.AdminDashboard
{
    public partial class BenefitsPage : System.Web.UI.Page
    {
        private string connectionString = WebConfigurationManager.ConnectionStrings["TelecomDatabaseConnection"].ToString();
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                int TotalPoints;
                int TotalCashback;
                int TotalOffers;
                int TotalBenefits;

                using (SqlConnection con = new SqlConnection(connectionString))
                {
                    con.Open();

                    using (SqlCommand cmd = new SqlCommand("SELECT COUNT(*) FROM Customer_Benefits", con))
                    {
                        TotalBenefits = Convert.ToInt32(cmd.ExecuteScalar());
                    }

                    using (SqlCommand cmd = new SqlCommand("SELECT SUM(points_earned) FROM Customer_Points", con))
                    {
                        TotalPoints = Convert.ToInt32(cmd.ExecuteScalar());
                    }

                    using (SqlCommand cmd = new SqlCommand("SELECT SUM(amount_earned) FROM Customer_Cashback", con))
                    {
                        TotalCashback = Convert.ToInt32(cmd.ExecuteScalar());
                    }

                    using (SqlCommand cmd = new SqlCommand("SELECT COUNT(*) FROM Customer_Exclusive_Offers", con))
                    {
                        TotalOffers = Convert.ToInt32(cmd.ExecuteScalar());
                    }
                }

                string query1 = "GetCustomersWithBenefits";
                ExecuteQueryWithHandling(query1, TableBody1);

                string query2 = "GetCustomersWithNoBenefits";
                ExecuteQueryWithHandling(query2, TableBody2);

                string query3 = "GetBenefitsExpiringSoon";
                ExecuteQueryWithHandling(query3, TableBody3);

                // Fetch data for the pie chart
                DataTable benefitTypesData = GetBenefitTypesData();
                string benefitTypesJson = JsonConvert.SerializeObject(benefitTypesData);

                // Pass the JSON data to the front end
                ScriptManager.RegisterStartupScript(this, GetType(), "benefitTypesData", $"var benefitTypesData = {benefitTypesJson};", true);

                // Fetch data for the pie chart (active and expired benefits)
                Dictionary<string, int> benefitsStatus = GetActiveAndExpiredBenefits();
                string benefitsStatusJson = JsonConvert.SerializeObject(benefitsStatus);

                // Pass the JSON data to the front end
                ScriptManager.RegisterStartupScript(this, GetType(), "benefitsStatusData", $"var benefitsStatusData = {benefitsStatusJson};", true);

                totalPoints.InnerText = TotalPoints.ToString();
                totalCashback.InnerText = TotalCashback.ToString();
                totalOffers.InnerText = TotalOffers.ToString();
                totalBenefits.InnerText = TotalBenefits.ToString();

            }
            catch (Exception ex)
            {
                DisplayAlert(ex);
            }
        }

        protected DataTable GetBenefitTypesData()
        {
            DataTable dataTable = new DataTable();
            using (SqlConnection con = new SqlConnection(connectionString))
            {
                try
                {
                    con.Open();
                    string query = "calculateBenefitsTypePercentages";

                    using (SqlCommand cmd = new SqlCommand(query, con))
                    {
                        using (SqlDataAdapter adapter = new SqlDataAdapter(cmd))
                        {
                            adapter.Fill(dataTable);
                        }
                    }
                }
                catch (Exception ex)
                {
                    DisplayAlert(ex);
                }
            }
            return dataTable;
        }
        protected Dictionary<string, int> GetActiveAndExpiredBenefits()
        {
            Dictionary<string, int> benefitsStatus = new Dictionary<string, int>();

            using (SqlConnection con = new SqlConnection(connectionString))
            {
                try
                {
                    con.Open();
                    using (SqlCommand cmd = new SqlCommand("SELECT COUNT(*) FROM Customer_Benefits WHERE status = 'active'", con))
                    {
                        int activeCount = Convert.ToInt32(cmd.ExecuteScalar());
                        benefitsStatus.Add("Active", activeCount);
                    }
                    using (SqlCommand cmd = new SqlCommand("SELECT COUNT(*) FROM Customer_Benefits WHERE status = 'expired'", con))
                    {
                        int expiredCount = Convert.ToInt32(cmd.ExecuteScalar());
                        benefitsStatus.Add("Expired", expiredCount);
                    }
                }
                catch (Exception ex)
                {
                    DisplayAlert(ex);
                }
            }
            return benefitsStatus;
        }


        //protected void LoadCashback(object sender, EventArgs e)
        //{
        //    DisplayContent("CashbackTab");

        //    string query = "SELECT * FROM Num_of_cashback";

        //    ExecuteQueryWithHandling(query);

        //    SetActiveTab("CashbackTab");
        //}
        //protected void LoadCashbackAmount(object sender, EventArgs e)
        //{
        //    DisplayContent("CashbackAmountTab");

        //    SetActiveTab("CashbackAmountTab");
        //}
        //protected void LoadOffers(object sender, EventArgs e)
        //{
        //    DisplayContent("offersTab");

        //    SetActiveTab("offersTab");
        //}
        //protected void LoadPoints(object sender, EventArgs e)
        //{
        //    DisplayContent("PointsTab");

        //    SetActiveTab("PointsTab");
        //}


        //protected void DeleteBenefitsButton_Click(object sender, EventArgs e)
        //{

        //    using (SqlConnection con = new SqlConnection(connectionString))
        //    {
        //        try
        //        {
        //            con.Open();

        //            DeleteButton.Style["display"] = "none";

        //            Deleting benefits
        //            using (SqlCommand deleteCmd = new SqlCommand("Benefits_Account", con))
        //            {
        //                deleteCmd.CommandType = CommandType.StoredProcedure;
        //                deleteCmd.Parameters.Add(new SqlParameter("@mobile_num", SqlDbType.Char, 11) { Value = MobileEditText.Text });
        //                deleteCmd.Parameters.Add(new SqlParameter("@plan_id", SqlDbType.Int) { Value = int.Parse(PlanIDEditText.Text) });
        //                deleteCmd.ExecuteNonQuery();

        //            }

        //            Displaying benefits after deletion
        //            using (SqlCommand displayCmd = new SqlCommand("Benefits_Account_Plan", con))
        //            {
        //                displayCmd.CommandType = CommandType.StoredProcedure;
        //                displayCmd.Parameters.Add(new SqlParameter("@mobile_num", SqlDbType.Char, 11) { Value = MobileEditText.Text });
        //                displayCmd.Parameters.Add(new SqlParameter("@plan_id", SqlDbType.Int) { Value = int.Parse(PlanIDEditText.Text) });

        //                LoadData(displayCmd, TableBody1);
        //            }
        //        }
        //        catch (Exception ex)
        //        {
        //            DisplayAlert(ex);
        //        }
        //        finally
        //        {
        //            if (con.State == System.Data.ConnectionState.Open)
        //            {
        //                con.Close();
        //            }
        //        }
        //    }
        //}
        protected void LoadData(SqlCommand cmd, HtmlGenericControl TableBody)
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

        protected void ExecuteQueryWithHandling(string query, HtmlGenericControl TableBody)
        {
            using (SqlConnection con = new SqlConnection(connectionString))
            {
                try
                {
                    using (SqlCommand cmd = new SqlCommand(query, con))
                    {
                        con.Open();
                        LoadData(cmd, TableBody);
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