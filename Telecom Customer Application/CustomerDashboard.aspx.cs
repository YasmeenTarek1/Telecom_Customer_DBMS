using System;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web.Configuration;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;

namespace Telecom_Customer_Application
{
    public partial class CustomerDashboard : System.Web.UI.Page
    {
        private string connStr = WebConfigurationManager.ConnectionStrings["TelecomDatabaseConnection"].ToString();
        private static string currentTab = "";
        private static string MobileNo;
        private static string NationalID;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                MobileNo = Session["MobileNo"].ToString();
                NationalID = Session["NationalID"].ToString();
                LoadOfferedServicePlans(null, null);
            }
        }

        protected void LoadOfferedServicePlans(object sender, EventArgs e)
        {
            DisplayContent("loadOfferedServicePlansTab");

            string query = "SELECT * FROM allServicePlans";

            ExecuteQueryWithHandling(query);

            SetActiveTab("loadOfferedServicePlansTab");
        }

        protected void LoadNotSubscribedPlans(object sender, EventArgs e)
        {
            DisplayContent("loadNotSubscribedPlansTab");
            try
            {
                using (SqlConnection con = new SqlConnection(connStr))
                {
                    SqlCommand cmd = new SqlCommand("Unsubscribed_Plans");
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.Add(new SqlParameter("@mobile_num", MobileNo));

                    con.Open();
                    cmd.Connection = con;
                    cmd.ExecuteNonQuery();

                    LoadData(cmd);
                }
            }
            catch (Exception ex)
            {
                DisplayAlert(ex);
            }

            SetActiveTab("loadNotSubscribedPlansTab");
        }

        protected void LoadSubscribedPlansLast5Months(object sender, EventArgs e)
        {
            DisplayContent("loadSubscribedPlansLast5MonthsTab");
            try
            {
                using (SqlConnection con = new SqlConnection(connStr))
                {
                    SqlCommand cmd = new SqlCommand("SELECT * FROM Subscribed_plans_5_Months(@mobile_num)", con);
                    cmd.Parameters.Add(new SqlParameter("@mobile_num", MobileNo));

                    con.Open();
                    LoadData(cmd);
                }
            }
            catch (Exception ex)
            {
                DisplayAlert(ex);
            }
            SetActiveTab("loadSubscribedPlansLast5MonthsTab");
        }

        protected void LoadRenewSubscription(object sender, EventArgs e)
        {
            DisplayContent("loadRenewSubscriptionTab");

            SetActiveTab("loadRenewSubscriptionTab");
        }

        protected void LoadConsumption(object sender, EventArgs e)
        {
            DisplayContent("loadConsumptionTab");

            SetActiveTab("loadConsumptionTab");
        }

        protected void LoadCurrentMonthUsage(object sender, EventArgs e)
        {
            DisplayContent("loadCurrentMonthActiveUsageTab"); 

            try
            {
                using (SqlConnection con = new SqlConnection(connStr))
                {

                    SqlCommand cmd = new SqlCommand("SELECT * FROM dbo.Usage_Plan_CurrentMonth(@mobile_num)", con);
                    cmd.Parameters.Add(new SqlParameter("@mobile_num", MobileNo));

                    con.Open();
                    LoadData(cmd);
                }
            }
            catch (Exception ex)
            {
                DisplayAlert(ex);
            }
            SetActiveTab("loadCurrentMonthActiveUsageTab");
        }

        protected void LoadCashbackTransactions(object sender, EventArgs e)
        {
            DisplayContent("loadCashbackTransactionsTab");

            try
            {
                using (SqlConnection con = new SqlConnection(connStr))
                {

                    SqlCommand cmd = new SqlCommand("SELECT * FROM dbo.Cashback_Wallet_Customer(@NID)", con);
                    cmd.Parameters.Add(new SqlParameter("@NID", NationalID));

                    con.Open();
                    LoadData(cmd);

                }
            }
            catch (Exception ex)
            {
                DisplayAlert(ex);
            }
            SetActiveTab("loadCashbackTransactionsTab");
        }

        protected void LoadCalculateCashback(object sender, EventArgs e)
        {
            DisplayContent("loadCalculateCashbackTab");

            SetActiveTab("loadCalculateCashbackTab");
        }

        protected void LoadTop10SuccessfulPayments(object sender, EventArgs e)
        {
            DisplayContent("loadTop10SuccessfulPaymentsTab");

            try
            {
                using (SqlConnection con = new SqlConnection(connStr))
                {
                    SqlCommand cmd = new SqlCommand("Top_Successful_Payments", con);
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.Add(new SqlParameter("@mobile_num", MobileNo));

                    con.Open();
                    cmd.Connection = con;
                    cmd.ExecuteNonQuery();

                    LoadData(cmd);
                }
            }
            catch (Exception ex)
            {
                DisplayAlert(ex);
            }
            SetActiveTab("loadTop10SuccessfulPaymentsTab");
        }

        protected void LoadRemainingExtraAmount(object sender, EventArgs e)
        {
            DisplayContent("loadRemainingExtraAmountTab");

            SetActiveTab("loadRemainingExtraAmountTab");
        }

        protected void LoadActiveBenefits(object sender, EventArgs e)
        {
            DisplayContent("loadActiveBenefitsTab");
            string query = "select * from allBenefits";
            ExecuteQueryWithHandling(query);
            SetActiveTab("loadActiveBenefitsTab");
        }

        protected void LoadHighestVoucher(object sender, EventArgs e)
        {
            DisplayContent("loadHighestVoucherTab");
            try
            {
                using (SqlConnection con = new SqlConnection(connStr))
                {
                    SqlCommand cmd = new SqlCommand("Account_Highest_Voucher", con);
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.Add(new SqlParameter("@mobile_num", MobileNo));

                    con.Open();
                    cmd.Connection = con;
                    cmd.ExecuteNonQuery();

                    object voucher = cmd.ExecuteScalar();

                    // Ensure voucher is not null
                    if (voucher != null && voucher != DBNull.Value)
                    {
                        Label1.Text = $"Highest Voucher: {voucher.ToString()}";
                    }
                    else
                    {
                        Label1.Text = $"No voucher data found.";
                    }
                }
            }
            catch (Exception ex)
            {
                DisplayAlert(ex);
            }
            SetActiveTab("loadHighestVoucherTab");
        }

        protected void LoadRedeemVoucher(object sender, EventArgs e)
        {
            DisplayContent("loadRedeemVoucherTab");

            SetActiveTab("loadRedeemVoucherTab");
        }

        protected void LoadUnresolvedTickets(object sender, EventArgs e)
        {
            DisplayContent("loadUnresolvedTicketsTab");
            try
            {
                using (SqlConnection con = new SqlConnection(connStr))
                {
                    SqlCommand cmd = new SqlCommand("Ticket_Account_Customer", con);
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.Add(new SqlParameter("@NID", SqlDbType.Int) { Value = NationalID });

                    con.Open();
                    cmd.Connection = con;
                    cmd.ExecuteNonQuery();

                    object result = cmd.ExecuteScalar();

                    // Ensure result is not null or DBNull.Value
                    if (result != null && result != DBNull.Value)
                    {
                        int unresolvedTicketCount = Convert.ToInt32(result);
                        Label1.Text = $"Unresolved Tickets: {unresolvedTicketCount}";
                    }
                    else
                    {
                        Label1.Text = $"No unresolved tickets found.";
                    }

                }
            }
            catch (Exception ex)
            {
                DisplayAlert(ex);
            }
            SetActiveTab("loadUnresolvedTicketsTab");
        }

        protected void LoadShops(object sender, EventArgs e)
        {
            DisplayContent("loadShopsTab");
            string query = "SELECT * FROM allShops";
            ExecuteQueryWithHandling(query);
            SetActiveTab("loadShopsTab");
        }

        protected void LoadRechargeBalance(object sender, EventArgs e)
        {
            DisplayContent("loadRechargeBalanceTab");

            SetActiveTab("loadRechargeBalanceTab");
        }

        protected void SearchButton_Click(object sender, EventArgs e)
        {
            string activeTabId = currentTab;
            try
            {
                switch (activeTabId)
                {
                    case "loadRenewSubscriptionTab":
                        LoadRenewSubscriptionOperations();
                        break;
                    case "loadConsumptionTab":
                        LoadConsumptionOperations();
                        break;
                    case "loadCalculateCashbackTab":
                        LoadCalculateCashbackOperations();
                        break;
                    case "loadRemainingExtraAmountTab":
                        LoadRemainingExtraAmountOperations();
                        break;
                    case "loadRedeemVoucherTab":
                        LoadRedeemVoucherOperations();
                        break;
                    case "loadRechargeBalanceTab":
                        LoadRechargeBalanceOperations();
                        break;
                }
            }
            catch (Exception ex)
            {
                DisplayAlert(ex);
            }
        }
        protected void LoadRenewSubscriptionOperations()
        {
            try
            {
                using (SqlConnection con = new SqlConnection(connStr))
                {
                    SqlCommand cmd = new SqlCommand("Initiate_plan_payment", con);
                    cmd.CommandType = CommandType.StoredProcedure;
                    checkValidPlanID(PlanIDInput.Text);
                    checkValidPaymentAmount(PaymentAmountInput.Text);
                    cmd.Parameters.Add(new SqlParameter("@mobile_num", MobileNo));
                    cmd.Parameters.Add(new SqlParameter("@amount", SqlDbType.Decimal, 10) { Value = Decimal.Parse(PaymentAmountInput.Text) });
                    cmd.Parameters.Add(new SqlParameter("@payment_method", SqlDbType.NVarChar, 50) { Value = PaymentMethodDropDown.Text.Trim() });
                    cmd.Parameters.Add(new SqlParameter("@plan_id", SqlDbType.Int) { Value = int.Parse(PlanIDInput.Text) });

                    con.Open();
                    cmd.Connection = con;
                    cmd.ExecuteNonQuery();

                    Label1.Text = $"Subscription renewed successfully!";
                }
            }
            catch (Exception ex)
            {
                DisplayAlert(ex);
            }
        }

        protected void LoadConsumptionOperations()
        {
            try
            {
                using (SqlConnection con = new SqlConnection(connStr))
                {
                    SqlCommand cmd = new SqlCommand("SELECT * FROM dbo.Consumption(@Plan_name, @start_date, @end_date)", con);
                    CheckValidPlanName(PlanNameInput.Text);
                    cmd.Parameters.Add(new SqlParameter("@Plan_name", SqlDbType.NVarChar, 50) { Value = PlanNameInput.Text });
                    cmd.Parameters.Add(new SqlParameter("@start_date", SqlDbType.Date) { Value = DateTime.Parse(DateInput1.Text) });
                    cmd.Parameters.Add(new SqlParameter("@end_date", SqlDbType.Date) { Value = DateTime.Parse(DateInput2.Text) });

                    con.Open();
                    LoadData(cmd);
                }
            }
            catch (Exception ex)
            {
                DisplayAlert(ex);
            }
        }

        protected void LoadCalculateCashbackOperations()
        {
            try
            {
                using (SqlConnection con = new SqlConnection(connStr))
                {
                    SqlCommand cmd = new SqlCommand("Payment_wallet_cashback", con);
                    cmd.CommandType = CommandType.StoredProcedure;
                    checkValidPaymentID(PaymentIDInput.Text);
                    checkValidBenefitID(BenefitIDInput.Text);
                    cmd.Parameters.Add(new SqlParameter("@mobile_num", MobileNo));
                    cmd.Parameters.Add(new SqlParameter("@payment_id", SqlDbType.Int) { Value = int.Parse(PaymentIDInput.Text) });
                    cmd.Parameters.Add(new SqlParameter("@benefit_id", SqlDbType.Int) { Value = int.Parse(BenefitIDInput.Text) });

                    con.Open();
                    cmd.Connection = con;
                    cmd.ExecuteNonQuery();

                    Label1.Text = $"Cashback successfully applied!";
                }
            }
            catch (Exception ex)
            {
                DisplayAlert(ex);
            }
        }

        protected void LoadRemainingExtraAmountOperations()
        {
            try
            {
                using (SqlConnection con = new SqlConnection(connStr))
                {
                    SqlCommand cmd = new SqlCommand("SELECT dbo.Remaining_plan_amount(@mobile_num, @plan_name)", con);
                    CheckValidPlanName(PlanNameInput.Text);
                    cmd.Parameters.Add(new SqlParameter("@mobile_num", MobileNo));
                    cmd.Parameters.Add(new SqlParameter("@plan_name", SqlDbType.NVarChar, 50) { Value = PlanNameInput.Text.Trim() });

                    con.Open();
                    object result = cmd.ExecuteScalar();
                    int remainingAmount = result != null ? Convert.ToInt32(result) : 0;
                    Label1.Text = $"Remaining Amount: {remainingAmount}";

                    cmd = new SqlCommand("SELECT dbo.Extra_plan_amount(@mobile_num, @plan_name)", con);
                    cmd.Parameters.Add(new SqlParameter("@mobile_num", MobileNo));
                    cmd.Parameters.Add(new SqlParameter("@plan_name", SqlDbType.NVarChar, 50) { Value = PlanNameInput.Text.Trim() });

                    result = cmd.ExecuteScalar();
                    int extraAmount = result != null ? Convert.ToInt32(result) : 0;
                    Label2.Text = $"Extra Amount: {extraAmount}";
                }
            }
            catch (Exception ex)
            {
                DisplayAlert(ex);
            }
        }

        protected void LoadRedeemVoucherOperations()
        {
            try
            {
                using (SqlConnection con = new SqlConnection(connStr))
                {
                    SqlCommand cmd = new SqlCommand("Redeem_voucher_points", con);
                    cmd.CommandType = CommandType.StoredProcedure;

                    checkValidVoucherID(VoucherIDInput.Text);
                    cmd.Parameters.Add(new SqlParameter("@mobile_num", MobileNo));
                    cmd.Parameters.Add(new SqlParameter("@voucher_id", SqlDbType.Int) { Value = int.Parse(VoucherIDInput.Text) });

                    con.Open();
                    cmd.Connection = con;
                    cmd.ExecuteNonQuery();

                    Label1.Text = $"Voucher is redeemed successfully!";
                }
            }
            catch (Exception ex)
            {
                DisplayAlert(ex);
            }
        }

        protected void LoadRechargeBalanceOperations()
        {
            try
            {
                using (SqlConnection con = new SqlConnection(connStr))
                {
                    SqlCommand cmd = new SqlCommand("Initiate_balance_payment", con);
                    cmd.CommandType = CommandType.StoredProcedure;
                    checkValidPaymentAmount(PaymentAmountInput.Text);
                    cmd.Parameters.Add(new SqlParameter("@mobile_num", MobileNo));
                    cmd.Parameters.Add(new SqlParameter("@amount", SqlDbType.Decimal, 10) { Value = decimal.Parse(PaymentAmountInput.Text) });
                    cmd.Parameters.Add(new SqlParameter("@payment_method", SqlDbType.NVarChar, 50) { Value = PaymentMethodDropDown.SelectedValue });

                    con.Open();
                    cmd.Connection = con;
                    cmd.ExecuteNonQuery();

                    Label1.Text = $"Balance recharged successfully!";
                }
            }
            catch (Exception ex)
            {
                DisplayAlert(ex);
            }
        }


        private void SetActiveTab(string activeTabId)
        {
            string[] allTabs = {
                "loadOfferedServicePlansTab","loadNotSubscribedPlansTab",
                "loadPlansSubscribedLast5MonthsTab","loadRenewSubscriptionTab",
                "loadCurrentMonthActiveUsageTab","loadConsumptionTab", "loadCashbackTransactionsTab",
                "loadCalculateCashbackTab","loadTop10SuccessfulPaymentsTab","loadRemainingExtraAmountTab",
                "loadHighestVoucherTab","loadRedeemVoucherTab", "loadActiveBenefitsTab",
                "loadUnresolvedTicketsTab","loadShopsTab","loadRechargeBalanceTab"
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
            switch (currentTab)
            {
                case "loadOfferedServicePlansTab": // 1 All false
                    ConfigureSharedContent("Offered Plans", false, false, false, false, false, false, false, false, false, false, false, false, "Search");
                    break;
                case "loadNotSubscribedPlansTab": // 2 All false
                    ConfigureSharedContent("Not Subscribed Plans", false, false, false, false, false, false, false, false, false, false, false, false, "Search");
                    break;
                case "loadPlansSubscribedLast5MonthsTab": // 3 All false
                    ConfigureSharedContent("Last 5 Months Subscribed Plans", false, false, false, false, false, false, false, false, false, false, false, false, "Search");
                    break;
                case "loadRenewSubscriptionTab": // 4 Dropdown, Payment Amount, Plan ID, search , label1
                    ConfigureSharedContent("Plan Renewal", false, false, false, true, true, true, false, false, false, true, true, false , "Renew");
                    break;
                case "loadCurrentMonthActiveUsageTab": // 5 Start Date, End Date, Plan Name, search
                    ConfigureSharedContent("Current Month Usage", false, false, false, false, false, false, false, false, false, false, false, false, "Search");
                    break;
                case "loadConsumptionTab": // 6 All false
                    ConfigureSharedContent("Plans Consumption", true, true, true, false, false, false, false, false, false, true, false, false, "Search");
                    break;
                case "loadCashbackTransactionsTab": // 7 All false
                    ConfigureSharedContent("Cashback Transactions", false, false, false, false, false, false, false, false, false, false, false, false, "Search");
                    break;
                case "loadCalculateCashbackTab": // 8 Payment ID, Benefit ID,  search , label1
                    ConfigureSharedContent("Payment Cashback", false, false, false, false, false, false, true, true, false, true, true, false, "Search");
                    break;
                case "loadTop10SuccessfulPaymentsTab": // 9 All false
                    ConfigureSharedContent("Top 10 Successful Payments", false, false, false, false, false, false, false, false, false, false, false, false, "Search");
                    break;
                case "loadRemainingExtraAmountTab": // 10 Plan Name,  search , label1, label2
                    ConfigureSharedContent("Remaining and Extra Amounts for a Payment", false, false, true, false, false, false, false, false, false, true, true, true, "Search");
                    break;
                case "loadActiveBenefitsTab": // 11 All false
                    ConfigureSharedContent("Active Benefits", false, false, false, false, false, false, false, false, false, false, false, false, "Search");
                    break;
                case "loadHighestVoucherTab": // 12 label1
                    ConfigureSharedContent("Highest Value Voucher", false, false, false, false, false, false, false, false, false, false, true, false, "Search");
                    break;
                case "loadRedeemVoucherTab": // 13 search , label1
                    ConfigureSharedContent("Redeem Voucher", false, false, false, false, false, false, false, false, true, true, true, false, "Redeem");
                    break;
                case "loadUnresolvedTicketsTab": // 14 label1
                    ConfigureSharedContent("Unresolved Tickets", false, false, false, false, false, false, false, false, false, false, true, false, "Search");
                    break;
                case "loadShopsTab": // 15 All false
                    ConfigureSharedContent("Shop Details", false, false, false, false, false, false, false, false, false, false, false, false, "Search");
                    break;
                case "loadRechargeBalanceTab": // 16 Dropdown, Payment Amount, search , label1
                    ConfigureSharedContent("Recharge Balance", false, false, false, false, true, true, false, false, false, true, true, false, "Recharge");
                    break;
            }
        }

        private void ConfigureSharedContent(
            string headingText, bool showStartDate, bool showEndDate,
            bool showPlanName, bool showPlanID, bool showPaymentAmount,
            bool showPaymentDropdown, bool showPaymentID, bool showBenefitID,
            bool showVoucherID, bool showSearchButton, bool showLabel1, bool showLabel2, string buttonText)
        {
            // Update heading
            TabHeading.InnerText = headingText;

            // Toggle visibility and reset fields
            DateContainer1.Style["display"] = showStartDate ? "block" : "none";
            DateInput1.Text = "";

            DateContainer2.Style["display"] = showEndDate ? "block" : "none";
            DateInput2.Text = "";

            PlanNameContainer.Style["display"] = showPlanName ? "block" : "none";
            PlanNameInput.Text = "";

            PlanIDContainer.Style["display"] = showPlanID ? "block" : "none";
            PlanIDInput.Text = "";

            PaymentAmountContainer.Style["display"] = showPaymentAmount ? "block" : "none";
            PaymentAmountInput.Text = "";

            DropdownContainer.Style["display"] = showPaymentDropdown ? "block" : "none";

            PaymentIDContainer.Style["display"] = showPaymentID ? "block" : "none";
            PaymentIDInput.Text = "";

            BenefitIDContainer.Style["display"] = showBenefitID ? "block" : "none";
            BenefitIDInput.Text = "";

            VoucherIDContainer.Style["display"] = showVoucherID ? "block" : "none";
            VoucherIDInput.Text = "";

            SearchButton.Style["display"] = showSearchButton ? "block" : "none";
            SearchButton.Text = buttonText;

            Label1.Style["display"] = showLabel1 ? "block" : "none";
            Label1.Text = "";

            Label2.Style["display"] = showLabel2 ? "block" : "none";
            Label2.Text = "";
        }

        protected void LoadData(SqlCommand cmd)
        {
            try
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
                            headerCell.InnerText = columnName;
                            row.Cells.Add(headerCell);
                        }
                        TableBody.Controls.Add(row);

                        // Generate rows dynamically
                        while (reader.Read())
                        {
                            row = new HtmlTableRow();
                            for (int i = 0; i < reader.FieldCount; i++)
                            {
                                HtmlTableCell cell = new HtmlTableCell();

                                // Check if the current column is "status"
                                if (reader.GetName(i).Equals("status", StringComparison.OrdinalIgnoreCase))
                                {
                                    string statusValue = reader[i]?.ToString();

                                    if (statusValue.Equals("active", StringComparison.OrdinalIgnoreCase) || statusValue.Equals("successful", StringComparison.OrdinalIgnoreCase) || statusValue.Equals("Resolved", StringComparison.OrdinalIgnoreCase))
                                    {
                                        cell.Attributes.Add("class", "status-active"); // green
                                    }
                                    else if (statusValue.Equals("onhold", StringComparison.OrdinalIgnoreCase) || statusValue.Equals("rejected", StringComparison.OrdinalIgnoreCase) || statusValue.Equals("Open", StringComparison.OrdinalIgnoreCase) || statusValue.Equals("expired", StringComparison.OrdinalIgnoreCase))
                                    {
                                        cell.Attributes.Add("class", "status-onhold"); // red
                                    }
                                    else if (statusValue.Equals("pending", StringComparison.OrdinalIgnoreCase) || statusValue.Equals("In progress", StringComparison.OrdinalIgnoreCase))
                                    {
                                        cell.Attributes.Add("class", "status-pending"); // yellow
                                    }

                                    cell.InnerText = reader[i]?.ToString();
                                    row.Cells.Add(cell);
                                }
                                // Check if the column name is "URL"
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
     
                                else 
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
            catch (Exception ex)
            {
                DisplayAlert(ex);
            }
        }

        protected void checkValidPlanID(string planID)
        {
            if (string.IsNullOrEmpty(planID))
                throw new Exception("Plan ID number cannot be empty.");

            if (!planID.All(char.IsDigit))
                throw new Exception("Invalid Plan ID numbers. Please enter digits only.");

            using (SqlConnection con = new SqlConnection(connStr))
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
        protected void checkValidPaymentID(string paymentId)
        {
            if (string.IsNullOrEmpty(paymentId))
                throw new Exception("Payment ID number cannot be empty.");

            if (!paymentId.All(char.IsDigit))
                throw new Exception("Invalid Payment ID numbers. Please enter digits only.");

            using (SqlConnection con = new SqlConnection(connStr))
            {
                using (SqlCommand cmd = new SqlCommand("SELECT COUNT(*) FROM Payment WHERE paymentID = @paymentID", con))
                {
                    cmd.Parameters.Add(new SqlParameter("@paymentID", SqlDbType.Int)).Value = paymentId;
                    con.Open();

                    int count = (int)cmd.ExecuteScalar();
                    if (count < 1)
                        throw new Exception("Invalid Payment ID. Payment does not exist.");
                }
            }
        }

        protected void checkValidBenefitID(string benefitId)
        {
            if (string.IsNullOrEmpty(benefitId))
                throw new Exception("Benefit ID number cannot be empty.");

            if (!benefitId.All(char.IsDigit))
                throw new Exception("Invalid Benefit ID numbers. Please enter digits only.");

            using (SqlConnection con = new SqlConnection(connStr))
            {
                using (SqlCommand cmd = new SqlCommand("SELECT COUNT(*) FROM Benefits WHERE benefitID = @benefitID", con))
                {
                    cmd.Parameters.Add(new SqlParameter("@benefitID", SqlDbType.Int)).Value = benefitId;
                    con.Open();

                    int count = (int)cmd.ExecuteScalar();
                    if (count < 1)
                        throw new Exception("Invalid Benefit ID. Benefit does not exist.");
                }
            }
        }

        protected void checkValidVoucherID(string voucherId)
        {
            if (string.IsNullOrEmpty(voucherId))
                throw new Exception("Voucher ID number cannot be empty.");

            if (!voucherId.All(char.IsDigit))
                throw new Exception("Invalid Voucher ID numbers. Please enter digits only.");

            using (SqlConnection con = new SqlConnection(connStr))
            {
                using (SqlCommand cmd = new SqlCommand("SELECT COUNT(*) FROM Voucher WHERE voucherID = @voucherID", con))
                {
                    cmd.Parameters.Add(new SqlParameter("@voucherID", SqlDbType.Int)).Value = voucherId;
                    con.Open();

                    int count = (int)cmd.ExecuteScalar();
                    if (count < 1)
                        throw new Exception("Invalid Voucher ID. Voucher does not exist.");
                }
            }
        }

        protected void checkValidPaymentAmount(string paymentAmount)
        {

            if (string.IsNullOrEmpty(paymentAmount))
                throw new Exception("Payment amount cannot be empty.");

            paymentAmount = paymentAmount.Trim();
            if (!decimal.TryParse(paymentAmount, out decimal parsedAmount))
                throw new Exception("Invalid payment amount. Please enter a numeric value.");

            if (parsedAmount < 0 || parsedAmount >= 1000000000)
                throw new Exception("Payment amount must be between 0 and 999999999.9 inclusive.");

            if (Math.Round(parsedAmount, 1) != parsedAmount)
                throw new Exception("Payment amount can only have one decimal place.");

            if (parsedAmount <= 0)
                throw new Exception("Payment amount cannot be zero.");

        }
        protected void CheckValidPlanName(string name)
        {

            if (string.IsNullOrWhiteSpace(name))
                throw new Exception("Plan name cannot be empty or null.");

            if (name.Length > 50)
                throw new Exception("Plan name cannot exceed 50 characters.");

            using (SqlConnection con = new SqlConnection(connStr))
            {
                string query = "SELECT COUNT(*) FROM Service_Plan WHERE name = @name";
                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.Add(new SqlParameter("@name", SqlDbType.VarChar, 50)).Value = name;

                    con.Open();
                    int count = (int)cmd.ExecuteScalar();

                    if (count < 1)
                        throw new Exception("Invalid plan name. The service plan does not exist.");
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
            using (SqlConnection con = new SqlConnection(connStr))
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
            Response.Redirect("CustomerLogin.aspx");

        }
    }
}
