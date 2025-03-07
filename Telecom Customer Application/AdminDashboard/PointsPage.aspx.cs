using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Newtonsoft.Json;

namespace Telecom_Customer_Application.AdminDashboard
{
    public partial class PointsPage : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                try
                {
                    int UsedPointsCount;
                    int TotalPointsCount;
                    int ActivePointsCount;
                    int ExpiredPointsCount;

                    using (SqlConnection con = new SqlConnection(PageUtilities.connectionString))
                    {
                        con.Open();

                        using (SqlCommand cmd = new SqlCommand("SELECT * FROM TotalPoints", con))
                        {
                            TotalPointsCount = Convert.ToInt32(cmd.ExecuteScalar());
                        }

                        using (SqlCommand cmd = new SqlCommand("ActivePoints", con))
                        {
                            cmd.CommandType = CommandType.StoredProcedure;
                            ActivePointsCount = Convert.ToInt32(cmd.ExecuteScalar());
                        }

                        using (SqlCommand cmd = new SqlCommand("SELECT * FROM UsedPoints", con))
                        {
                            UsedPointsCount = Convert.ToInt32(cmd.ExecuteScalar());
                        }

                        using (SqlCommand cmd = new SqlCommand("SELECT * FROM ExpiredPoints", con))
                        {
                            ExpiredPointsCount = Convert.ToInt32(cmd.ExecuteScalar());
                        }
                    }

                    string query = "PointsHistory";
                    PageUtilities.ExecuteQueryWithHandling(query, TableBody, form1);

                    totalPointsCount.InnerText = TotalPointsCount.ToString();
                    usedPointsCount.InnerText = UsedPointsCount.ToString();
                    activePointsCount.InnerText = ActivePointsCount.ToString();
                    expiredPointsCount.InnerText = ExpiredPointsCount.ToString();

                    // Fetch data for the pie chart
                    DataTable pointsPlanData = PageUtilities.GetData("calculatePlanPointsPercentage");
                    string pointsPlanJson = JsonConvert.SerializeObject(pointsPlanData);

                    // Pass the JSON data to the front end
                    ScriptManager.RegisterStartupScript(this, GetType(), "pointsPlanData", $"var pointsPlanData = {pointsPlanJson};", true);

                    DataTable topCustomersPointsData = PageUtilities.GetData("TopCustomersByUsedPoints");
                    string jsonData = JsonConvert.SerializeObject(topCustomersPointsData);

                    ScriptManager.RegisterStartupScript(this, GetType(), "topCustomersPointsData", $"var topCustomersPointsData = {jsonData};", true);
                }
                catch (Exception ex)
                {
                    PageUtilities.DisplayAlert(ex, form1);

                }
            }
        }
    }
}