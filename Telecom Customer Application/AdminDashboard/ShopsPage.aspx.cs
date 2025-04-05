using System;

namespace Telecom_Customer_Application.AdminDashboard
{
    public partial class ShopsPage : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                string subtab = Request.QueryString["subtab"];

                if (!string.IsNullOrEmpty(subtab))
                {
                    switch (subtab.ToLower())
                    {
                        case "physical":
                            LoadPhysicalShops(sender, e);
                            break;

                        case "eshop":
                            LoadE_shops(sender, e);
                            break;
                    }
                }
            }
        }
        protected void LoadPhysicalShops(object sender, EventArgs e)
        {
            DisplayContent("physicalShopsTab");

            string query = "SELECT * FROM PhysicalStoreVouchers";

            PageUtilities.ExecuteQueryWithHandling(query, TableBody, form1);
        }

        protected void LoadE_shops(object sender, EventArgs e)
        {
            DisplayContent("E_shopsTab");

            string query = "SELECT * FROM E_shopVouchers";

            PageUtilities.ExecuteQueryWithHandling(query, TableBody, form1);
        }

        private void DisplayContent(string tab)
        {
            if (tab.Equals("physicalShopsTab"))
            {
                TabHeading.InnerText = "Physical Shops";
            }
            else
            {
                TabHeading.InnerText = "E-Shops";
            }
        }
    }
}