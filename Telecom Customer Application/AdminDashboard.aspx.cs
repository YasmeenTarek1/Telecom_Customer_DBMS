using System;
using System.Data;
using System.Data.SqlClient;
using System.Drawing;
using System.Linq;
using System.Web.Configuration;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;


namespace Telecom_Customer_Application
{
    public partial class AdminDashboard : System.Web.UI.Page
    {

        public int CustomerCount { get; set; }
        public int PaymentCount { get; set; }
        public int TransferCount { get; set; }
        public int ServicePlanCount { get; set; }

        private string connectionString = WebConfigurationManager.ConnectionStrings["TelecomDatabaseConnection"].ToString();

        private static string currentTab = "";

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // Load Customers by default
                LoadCustomers(null, null);
            }
            string eventTarget = Request["__EVENTTARGET"];
            string eventArgument = Request["__EVENTARGUMENT"];

            if (eventTarget == "PlanClicked")
            {
                Subscribers_for_plan(eventArgument);
            }
        }

        protected void BasicPlanLink_Click(object sender, EventArgs e)
        {
            Subscribers_for_plan("1");
        }

        protected void StandardPlanLink_Click(object sender, EventArgs e)
        {
            Subscribers_for_plan("2");
        }

        protected void PremiumPlanLink_Click(object sender, EventArgs e)
        {
            Subscribers_for_plan("3");
        }

        protected void UnlimitedPlanLink_Click(object sender, EventArgs e)
        {
            Subscribers_for_plan("4");
        }


        protected void LoadCustomers(object sender, EventArgs e)
        {
            DisplayContent("customersTab");

            try
            {
                string query = "allCustomerAccounts";
                ExecuteQueryWithHandling(query);

                using (SqlConnection con = new SqlConnection(connectionString))
                {
                    con.Open();

                    using (SqlCommand cmd = new SqlCommand("SELECT COUNT(*) FROM Customer_profile", con))
                    {
                        CustomerCount = Convert.ToInt32(cmd.ExecuteScalar());
                    }

                    using (SqlCommand cmd = new SqlCommand("SELECT COUNT(*) FROM Payment", con))
                    {
                        PaymentCount = Convert.ToInt32(cmd.ExecuteScalar());
                    }

                    using (SqlCommand cmd = new SqlCommand("SELECT COUNT(*) FROM Transfer_money", con))
                    {
                        TransferCount = Convert.ToInt32(cmd.ExecuteScalar());
                    }

                    using (SqlCommand cmd = new SqlCommand("SELECT COUNT(*) FROM Service_Plan", con))
                    {
                        ServicePlanCount = Convert.ToInt32(cmd.ExecuteScalar());
                    }
                }

                customerCount.InnerText = CustomerCount.ToString();
                paymentCount.InnerText = PaymentCount.ToString();
                transferCount.InnerText = TransferCount.ToString();
                servicePlanCount.InnerText = ServicePlanCount.ToString();

                SetActiveTab("customersTab");
            }
            catch (Exception ex)
            {
                DisplayAlert(ex);
            }
        }

        protected void LoadSubscriptions(object sender, EventArgs e)
        {
            DisplayContent("subscriptionsTab");

            string query = "Account_Plan";

            ExecuteQueryWithHandling(query);

            SetActiveTab("subscriptionsTab");

        }
        protected void LoadPhysicalShops(object sender, EventArgs e)
        {
            DisplayContent("physicalShopsTab");

            string query = "SELECT * FROM PhysicalStoreVouchers";

            ExecuteQueryWithHandling(query);

            SetActiveTab("physicalShopsTab");
        }
        protected void LoadE_shops(object sender, EventArgs e)
        {
            DisplayContent("E_shopsTab");

            string query = "SELECT * FROM E_shopVouchers";

            ExecuteQueryWithHandling(query);

            SetActiveTab("E_shopsTab");
        }
        protected void LoadTickets(object sender, EventArgs e)
        {
            DisplayContent("ticketsTab");

            string query = "SELECT * FROM allTickets ORDER BY CASE Ticket_Status WHEN 'Open' THEN 1 WHEN 'In Progress' THEN 2 ELSE 3 END, priority_level DESC;";

            ExecuteQueryWithHandling(query);

            SetActiveTab("ticketsTab");
        }
        protected void LoadPlans(object sender, EventArgs e)
        {
            DisplayContent("PlanSinceDateTab");

            SetActiveTab("PlanSinceDateTab");
        }
        protected void LoadPlansInfo(object sender, EventArgs e)
        {
            DisplayContent("PlanInfoTab"); 

            SetActiveTab("PlanInfoTab");
        }
        protected void LoadBenefits(object sender, EventArgs e)
        {
            DisplayContent("benefitsTab");

            SetActiveTab("benefitsTab");
        }
        protected void LoadCashback(object sender, EventArgs e)
        {
            DisplayContent("CashbackTab");

            string query = "SELECT * FROM Num_of_cashback";

            ExecuteQueryWithHandling(query);

            SetActiveTab("CashbackTab");
        }
        protected void LoadCashbackAmount(object sender, EventArgs e)
        {
            DisplayContent("CashbackAmountTab");

            SetActiveTab("CashbackAmountTab");
        }
        protected void LoadOffers(object sender, EventArgs e)
        {
            DisplayContent("offersTab");

            SetActiveTab("offersTab");
        }
        protected void LoadPoints(object sender, EventArgs e)
        {
            DisplayContent("PointsTab");

            SetActiveTab("PointsTab");
        }
        protected void LoadAccountUsage(object sender, EventArgs e)
        {
            DisplayContent("accountUsageTab");

            SetActiveTab("accountUsageTab");
        }
        protected void LoadWallets(object sender, EventArgs e)
        {
            DisplayContent("walletsTab");

            string query = "SELECT * FROM CustomerWallet";

            ExecuteQueryWithHandling(query);

            SetActiveTab("walletsTab");
        }
        protected void LoadPayments(object sender, EventArgs e)
        {
            DisplayContent("PaymentsTab");

            string query = "SELECT * FROM AccountPayments ORDER BY CASE Payment_Status WHEN 'Successful' THEN 1 WHEN 'Pending' THEN 2 ELSE 3 END, date_of_payment DESC;";

            ExecuteQueryWithHandling(query);

            SetActiveTab("PaymentsTab");
        }
        protected void LoadTransactions(object sender, EventArgs e)
        {
            DisplayContent("TransactionsTab");

            SetActiveTab("TransactionsTab");
        }

        protected void LoadAverageTransactions(object sender, EventArgs e)
        {
            DisplayContent("AverageTransactionsTab");

            SetActiveTab("AverageTransactionsTab");
        }
        private void Subscribers_for_plan(string planId)
        {
            try
            {

                using (SqlConnection connection = new SqlConnection(connectionString))
                {
                    connection.Open();
                    SqlCommand cmd = new SqlCommand("GetSubscribersForPlan", connection);
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.Add(new SqlParameter("@PlanID", SqlDbType.Int) { Value = int.Parse(planId) });
                    LoadData(cmd);

                }
            }
            catch (Exception ex)
            {
                DisplayAlert(ex);
            }
        }



        protected void SearchButton_Click(object sender, EventArgs e)
        {

            using (SqlConnection con = new SqlConnection(connectionString))
            {
                SqlCommand cmd = null;

                try
                {
                    string mobileNo = "";
                    string walletId = "";
                    string planId = "";
                    int updatedPoints = 0;
                    switch (currentTab)
                    {
                        case "PlanSinceDate                     ":
                            cmd = new SqlCommand("SELECT * FROM dbo.Account_Plan_date(@sub_date, @plan_id)", con);
                            planId = PlanIDEditText.Text;
                            checkValidPlanID(planId);
                            cmd.Parameters.Add(new SqlParameter("@plan_id", SqlDbType.Int) { Value = int.Parse(planId) });
                            cmd.Parameters.Add(new SqlParameter("@sub_date", SqlDbType.Date) { Value = DateTime.Parse(DateInput1.Text) });
                            break;

                        case "accountUsageTab":
                            cmd = new SqlCommand("SELECT * FROM dbo.Account_Usage_Plan(@mobile_num, @start_date)", con);
                            mobileNo = MobileEditText.Text;
                            checkValidMobileNum(mobileNo);
                            cmd.Parameters.Add(new SqlParameter("@mobile_num", SqlDbType.Char, 11) { Value = mobileNo });
                            cmd.Parameters.Add(new SqlParameter("@start_date", SqlDbType.Date) { Value = DateTime.Parse(DateInput1.Text) });
                            break;

                        case "benefitsTab": // displaying available benefits
                            cmd = new SqlCommand("select B.* from  Benefits B inner join plan_provides_benefits pb on B.benefitID = pb.benefitid where B.mobileNo = @mobile_num and pb.planID = @plan_id", con);
                            mobileNo = MobileEditText.Text;
                            checkValidMobileNum(mobileNo);
                            planId = PlanIDEditText.Text;
                            checkValidPlanID(planId);
                            cmd.Parameters.Add(new SqlParameter("@mobile_num", SqlDbType.Char, 11) { Value = mobileNo });
                            cmd.Parameters.Add(new SqlParameter("@plan_id", SqlDbType.Int) { Value = int.Parse(planId) });
                            DeleteButton.Style["display"] = "block";
                            break;

                        case "offersTab":
                            cmd = new SqlCommand("SELECT * FROM dbo.Account_SMS_Offers(@mobile_num)", con);
                            mobileNo = MobileEditText.Text;
                            checkValidMobileNum(mobileNo);
                            cmd.Parameters.Add(new SqlParameter("@mobile_num", SqlDbType.Char, 11) { Value = mobileNo });
                            break;

                        case "TransactionsTab":
                            cmd = new SqlCommand("Account_Payment_Points", con);
                            mobileNo = MobileEditText.Text;
                            checkValidMobileNum(mobileNo);
                            cmd.CommandType = CommandType.StoredProcedure;
                            cmd.Parameters.Add(new SqlParameter("@mobile_num", SqlDbType.Char, 11)).Value = mobileNo;
                            break;

                        case "CashbackAmountTab":
                            cmd = new SqlCommand("SELECT dbo.Wallet_Cashback_Amount(@walletID, @planID)", con);
                            walletId = WalletEditText.Text;
                            checkValidWalletID(walletId);
                            planId = PlanIDEditText.Text;
                            checkValidPlanID(planId);
                            cmd.Parameters.Add(new SqlParameter("@walletID", walletId)); ;
                            cmd.Parameters.Add(new SqlParameter("@planID", planId));
                            break;

                        case "AverageTransactionsTab":
                            cmd = new SqlCommand("SELECT dbo.Wallet_Transfer_Amount(@walletID, @start_date, @end_date)", con);
                            walletId = WalletEditText.Text;
                            checkValidWalletID(walletId);
                            cmd.Parameters.Add(new SqlParameter("@walletID", walletId));
                            cmd.Parameters.Add(new SqlParameter("@start_date", SqlDbType.Date) { Value = DateTime.Parse(DateInput1.Text) });
                            cmd.Parameters.Add(new SqlParameter("@end_date", SqlDbType.Date) { Value = DateTime.Parse(DateInput2.Text) });
                            break;

                        case "PointsTab":

                            cmd = new SqlCommand("Total_Points_Account", con);
                            cmd.CommandType = CommandType.StoredProcedure;
                            mobileNo = MobileEditText.Text;
                            checkValidMobileNum(mobileNo);
                            cmd.Parameters.Add(new SqlParameter("@mobile_num", SqlDbType.Char, 11)).Value = mobileNo;

                            // sub command - fetching from database
                            SqlCommand sumCommand = new SqlCommand("SELECT c.points FROM customer_account c WHERE c.mobileNo = @mobileNo", con);
                            sumCommand.Parameters.Add(new SqlParameter("@mobileNo", SqlDbType.Char, 11)).Value = mobileNo;
                            con.Open();
                            object result = sumCommand.ExecuteScalar();
                            updatedPoints = result != DBNull.Value ? Convert.ToInt32(result) : 0;
                            con.Close();

                            break;

                        default:
                            return;
                    }

                    con.Open();

                    if (currentTab == "CashbackAmountTab" || currentTab == "AverageTransactionsTab") // output is label
                        LoadLabel(cmd);
                    else if (currentTab == "PointsTab") // output is label but 2 consecutive commands
                        LoadLabelPointsTab(cmd, updatedPoints);
                    else
                        LoadData(cmd); // output is data

                }
                catch (Exception ex)
                {
                    DisplayAlert(ex);
                    DeleteButton.Style["display"] = "none";
                }
                finally
                {
                    if (con.State == System.Data.ConnectionState.Open)
                    {
                        con.Close();
                    }
                }

            }
        }

        protected void DeleteBenefitsButton_Click(object sender, EventArgs e)
        {

            using (SqlConnection con = new SqlConnection(connectionString))
            {
                try
                {
                    con.Open();

                    DeleteButton.Style["display"] = "none";

                    // Deleting benefits
                    using (SqlCommand deleteCmd = new SqlCommand("Benefits_Account", con))
                    {
                        deleteCmd.CommandType = CommandType.StoredProcedure;
                        deleteCmd.Parameters.Add(new SqlParameter("@mobile_num", SqlDbType.Char, 11) { Value = MobileEditText.Text });
                        deleteCmd.Parameters.Add(new SqlParameter("@plan_id", SqlDbType.Int) { Value = int.Parse(PlanIDEditText.Text) });
                        deleteCmd.ExecuteNonQuery();

                    }

                    // Displaying benefits after deletion
                    using (SqlCommand displayCmd = new SqlCommand("Benefits_Account_Plan", con))
                    {
                        displayCmd.CommandType = CommandType.StoredProcedure;
                        displayCmd.Parameters.Add(new SqlParameter("@mobile_num", SqlDbType.Char, 11) { Value = MobileEditText.Text });
                        displayCmd.Parameters.Add(new SqlParameter("@plan_id", SqlDbType.Int) { Value = int.Parse(PlanIDEditText.Text) });

                        LoadData(displayCmd);
                    }
                }
                catch (Exception ex)
                {
                    DisplayAlert(ex);
                }
                finally
                {
                    if (con.State == System.Data.ConnectionState.Open)
                    {
                        con.Close();
                    }
                }
            }
        }

        private void SetActiveTab(string activeTabId)
        {
            string[] allTabs = {
                "customersTab", "subscriptionsTab", "physicalShopsTab", "ticketsTab",
                "PlanSinceDateTab","PlanInfoTab", "accountUsageTab", "benefitsTab", "offersTab",
                "walletsTab","E_shopsTab","PaymentsTab","CashbackTab","TransactionsTab",
                "CashbackAmountTab","AverageTransactionsTab", "PointsTab"
            };

            // Loop through each tab and toggle the "active" class
            foreach (string tabId in allTabs)
            {
                var tab = FindControl(tabId) as HtmlAnchor;
                if (tab != null)
                {
                    if (tab.ID == activeTabId)
                    {
                        tab.Attributes["class"] = "active";
                    }
                    else
                    {
                        tab.Attributes.Remove("class");
                    }
                }
            }
        }

        protected void DisplayContent(string activeTabId)
        {
            currentTab = activeTabId;

            // Configure shared content based on activeTabId
            //headingText,showDateInput,showPlanIDInput,showMobileInput,showSearchButton,showWalletIDInput,showDate2Input,showLabelOut
            switch (currentTab)
            {
                case "customersTab":
                    ConfigureSharedContent("Dashboard", false, false, false, false, false, false, false);
                    break;
                case "subscriptionsTab":
                    ConfigureSharedContent("Subscriptions", false, false, false, false, false, false, false);
                    break;
                case "physicalShopsTab":
                    ConfigureSharedContent("Physical Shops", false, false, false, false, false, false, false);
                    break;
                case "ticketsTab":
                    ConfigureSharedContent("Tickets", false, false, false, false, false, false, false);
                    break;
                case "PlanSinceDateTab":
                    ConfigureSharedContent("Subscribers Since a Date", true, true, false, true, false, false, false);
                    break;
                case "PlanInfoTab":
                    ConfigureSharedContent("View Plans Information", false, false, false, false, false, false, false);
                    break;
                case "accountUsageTab":
                    ConfigureSharedContent("Account Usage", true, false, true, true, false, false, false);
                    break;
                case "benefitsTab":
                    ConfigureSharedContent("Benefits", false, true, true, true, false, false, false);
                    break;
                case "offersTab":
                    ConfigureSharedContent("SMS Offers", false, false, true, true, false, false, false);
                    break;
                case "walletsTab":
                    ConfigureSharedContent("Wallets", false, false, false, false, false, false, false);
                    break;
                case "E_shopsTab":
                    ConfigureSharedContent("E-Shops", false, false, false, false, false, false, false);
                    break;
                case "PaymentsTab":
                    ConfigureSharedContent("Payments", false, false, false, false, false, false, false);
                    break;
                case "CashbackTab":
                    ConfigureSharedContent("Cashback", false, false, false, false, false, false, false);
                    break;
                case "TransactionsTab":
                    ConfigureSharedContent("Transactions", false, false, true, true, false, false, false);
                    break;
                case "CashbackAmountTab":
                    ConfigureSharedContent("Cashback Amount", false, true, false, true, true, false, true);
                    break;
                case "AverageTransactionsTab":
                    ConfigureSharedContent("Average Transaction", true, false, false, true, true, true, true);
                    break;
                case "PointsTab":
                    ConfigureSharedContent("Points", false, false, true, true, false, false, true);
                    break;
            }
        }

        private void ConfigureSharedContent(string headingText, bool showDateInput, bool showPlanIDInput,
            bool showMobileInput, bool showSearchButton, bool showWalletIDInput, bool showDate2Input, bool showLabelOut)
        {
            TabHeading.InnerText = headingText;

            DateContainer1.Style["display"] = showDateInput ? "block" : "none";
            DateInput1.Text = "";

            DateContainer2.Style["display"] = showDate2Input ? "block" : "none";
            DateInput2.Text = "";

            TextBoxContainer1.Style["display"] = showPlanIDInput ? "block" : "none";
            PlanIDEditText.Text = "";

            TextBoxContainer2.Style["display"] = showMobileInput ? "block" : "none";
            MobileEditText.Text = "";

            TextBoxContainer3.Style["display"] = showWalletIDInput ? "block" : "none";
            MobileEditText.Text = "";

            SearchButton.Style["display"] = showSearchButton ? "block" : "none";

            LabelOut.Style["display"] = showLabelOut ? "block" : "none";
            LabelOut.Text = "";

            if (currentTab == "PointsTab")
                SearchButton.Text = "Update";
            else
                SearchButton.Text = "Search";


            if (currentTab != "benefitsTab")
                DeleteButton.Style["display"] = "none";


            if (currentTab == "customersTab")
                cardBox.Style["display"] = "block";
            else
                cardBox.Style["display"] = "none";

            if (currentTab == "PlanInfoTab")
                PlanCardsContainer.Style["display"] = "block";
            else
                PlanCardsContainer.Style["display"] = "none";
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
                    DeleteButton.Style["display"] = "none";
                }
            }
        }

        protected void LoadLabel(SqlCommand cmd)
        {
            object result = cmd.ExecuteScalar();

            if (result != null && result != DBNull.Value)
            {
                int data = Convert.ToInt32(result);

                switch (currentTab)
                {
                    case "CashbackAmountTab":
                        LabelOut.Text = $"Cashback Amount: {data}";
                        break;

                    case "AverageTransactionsTab":
                        LabelOut.Text = $"Average Transactions Amount: {data}";
                        break;
                }

            }
            //handle other cases
            else
            {
                throw new Exception("No cashback available for this wallet and plan combination.");
            }
        }

        protected void LoadLabelPointsTab(SqlCommand cmd, int updatedPoints)
        {
            cmd.ExecuteNonQuery();
            LabelOut.Text = $"Points have been successfully updated. The total number of points is now: {updatedPoints}.";
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

        protected void checkValidPlanID(string planID)
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

        protected void checkValidWalletID(string walletID)
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
                finally
                {
                    if (con.State == System.Data.ConnectionState.Open)
                    {
                        con.Close();
                    }
                }
            }
        }

        protected void BackButton_Click(object sender, EventArgs e)
        {
            Response.Redirect("AdminLogin.aspx");

        }
    }
}