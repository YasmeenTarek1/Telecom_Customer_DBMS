using System;
using System.Web.UI.HtmlControls;

namespace Controls
{
    public partial class AdminSidebar : System.Web.UI.UserControl
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // Get the active tab based on the current URL or query string
                string currentPage = Request.Path;
                string activeTabId = GetActiveTabId(currentPage);

                // Set the active tab
                SetActiveTab(activeTabId);
            }
        }
        private string GetActiveTabId(string currentPage)
        {
            if (currentPage.Contains("CustomersPage.aspx")) return "customersTab";
            if (currentPage.Contains("SubscriptionsPage.aspx")) return "subscriptionsTab";
            if (currentPage.Contains("ShopsPage.aspx"))
            {
                string subtab = Request.QueryString["subtab"];
                if (subtab == "physical") return "physicalShopsTab";
                if (subtab == "eshop") return "E_shopsTab";
            }
            if (currentPage.Contains("TicketsPage.aspx")) return "ticketsTab";
            if (currentPage.Contains("PlansPage.aspx")) return "PlanInfoTab";
            if (currentPage.Contains("BenefitsPage.aspx") || currentPage.Contains("PointsPage.aspx") || currentPage.Contains("ExclusiveOffersPage.aspx") || currentPage.Contains("CashbackPage.aspx")) return "benefitsTab";
            if (currentPage.Contains("AccountUsagePage.aspx")) return "accountUsageTab";
            if (currentPage.Contains("WalletsPage.aspx")) return "walletsTab";
            if (currentPage.Contains("PaymentsPage.aspx")) return "PaymentsTab";
            if (currentPage.Contains("TransactionsPage.aspx")) return "transactionsTab";
            return ""; // no active tab
        }

        private void SetActiveTab(string activeTabId)
        {
            string[] allTabs = {
                "customersTab", "subscriptionsTab", "physicalShopsTab", "ticketsTab",
                "PlanInfoTab", "accountUsageTab", "benefitsTab", "walletsTab",
                "E_shopsTab","PaymentsTab","transactionsTab"
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
    }
}