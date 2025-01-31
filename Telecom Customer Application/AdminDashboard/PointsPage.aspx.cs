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

                        using (SqlCommand cmd = new SqlCommand("PointsHistory", con))
                        {
                            cmd.CommandType = CommandType.StoredProcedure;
                            PageUtilities.LoadData(cmd, TableBody);
                        }
                    }
                    totalPointsCount.InnerText = TotalPointsCount.ToString();
                    usedPointsCount.InnerText = UsedPointsCount.ToString();
                    activePointsCount.InnerText = TotalPointsCount.ToString();
                    expiredPointsCount.InnerText = UsedPointsCount.ToString();

                    // Fetch data for the pie chart
                    DataTable pointsPlanData = GetPointsPlanData();
                    string pointsPlanJson = JsonConvert.SerializeObject(pointsPlanData);

                    // Pass the JSON data to the front end
                    ScriptManager.RegisterStartupScript(this, GetType(), "pointsPlanData", $"var pointsPlanData = {pointsPlanJson};", true);

                    DataTable topCustomersPointsData = GetTopCustomersByPointsData();
                    string jsonData = JsonConvert.SerializeObject(topCustomersPointsData);

                    ScriptManager.RegisterStartupScript(this, GetType(), "topCustomersPointsData", $"var topCustomersPointsData = {jsonData};", true);
                }
                catch (Exception ex)
                {
                    PageUtilities.DisplayAlert(ex, form1);

                }
            }
        }
        protected DataTable GetPointsPlanData()
        {
            DataTable dataTable = new DataTable();
            using (SqlConnection con = new SqlConnection(PageUtilities.connectionString))
            {
                try
                {
                    con.Open();
                    string query = "calculatePlanPointsPercentage";

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
                    PageUtilities.DisplayAlert(ex, form1);
                }
            }
            return dataTable;
        }

        protected DataTable GetTopCustomersByPointsData()
        {
            DataTable dataTable = new DataTable();
            using (SqlConnection con = new SqlConnection(PageUtilities.connectionString))
            {
                try
                {
                    con.Open();
                    string query = "TopCustomersByUsedPoints";

                    using (SqlCommand cmd = new SqlCommand(query, con))
                    {
                        cmd.CommandType = CommandType.StoredProcedure;
                        using (SqlDataAdapter adapter = new SqlDataAdapter(cmd))
                        {
                            adapter.Fill(dataTable);
                        }
                    }
                }
                catch (Exception ex)
                {
                    PageUtilities.DisplayAlert(ex, form1);
                }
            }
            return dataTable;
        }
    }
}