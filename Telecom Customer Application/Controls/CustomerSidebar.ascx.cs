using System;
using System.Web.UI.HtmlControls;

namespace Controls
{
    public partial class CustomerSidebar : System.Web.UI.UserControl
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
            if (currentPage.Contains("HomePage.aspx")) return "homeTab";
            if (currentPage.Contains("TicketsPage.aspx")) return "ticketsTab";
            if (currentPage.Contains("PlansPage.aspx")) return "plansTab";
            if (currentPage.Contains("WalletPage.aspx")) return "walletTab";
            if (currentPage.Contains("PaymentsPage.aspx")) return "paymentsTab";
            if (currentPage.Contains("VouchersPage.aspx")) return "vouchersTab";
            return ""; // no active tab
        }

        private void SetActiveTab(string activeTabId)
        {
            string[] allTabs = {
                "homeTab", "ticketsTab", "plansTab", "walletTab", "paymentsTab", "vouchersTab"
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