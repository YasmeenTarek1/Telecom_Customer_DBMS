using System;
using System.Data;
using System.Data.SqlClient;
using System.Security.Cryptography;
using System.Text;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Telecom_Customer_Application.CustomerDashboard
{
    public partial class VouchersPage : System.Web.UI.Page
    {
        private static string mobileNum;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                mobileNum = Session["MobileNo"].ToString();
                LoadVouchers();
            }

            // Post-Redirect-Get Pattern
            if (Session["AlertMessage"] != null && Session["AlertType"] != null)
            {
                PageUtilities.DisplayAlert(new Exception(Session["AlertMessage"].ToString()), this, Session["AlertType"].ToString());
                Session.Remove("AlertMessage");
                Session.Remove("AlertType");
            }
        }

        private void LoadVouchers()
        {
            using (SqlConnection conn = new SqlConnection(PageUtilities.connectionString))
            {
                conn.Open();
                // Physical Vouchers
                SqlCommand cmdPhysical = new SqlCommand("Account_Active_Physical_Voucher", conn);
                cmdPhysical.CommandType = CommandType.StoredProcedure;
                cmdPhysical.Parameters.AddWithValue("@mobile_num", mobileNum);
                SqlDataAdapter adapterPhysical = new SqlDataAdapter(cmdPhysical);
                DataTable dtPhysical = new DataTable();
                adapterPhysical.Fill(dtPhysical);
                PhysicalVouchers.DataSource = dtPhysical;
                PhysicalVouchers.DataBind();

                // E-Shop Vouchers
                SqlCommand cmdEshop = new SqlCommand("Account_Active_Eshop_Voucher", conn);
                cmdEshop.CommandType = CommandType.StoredProcedure;
                cmdEshop.Parameters.AddWithValue("@mobile_num", mobileNum);
                SqlDataAdapter adapterEshop = new SqlDataAdapter(cmdEshop);
                DataTable dtEshop = new DataTable();
                adapterEshop.Fill(dtEshop);
                EshopVouchers.DataSource = dtEshop;
                EshopVouchers.DataBind();

                // Redeemed Vouchers
                SqlCommand cmdRedeemed = new SqlCommand("Account_Redeemed_Voucher", conn);
                cmdRedeemed.CommandType = CommandType.StoredProcedure;
                cmdRedeemed.Parameters.AddWithValue("@mobile_num", mobileNum);
                SqlDataAdapter adapterRedeemed = new SqlDataAdapter(cmdRedeemed);
                DataTable dtRedeemed = new DataTable();
                adapterRedeemed.Fill(dtRedeemed);
                RedeemedVouchers.DataSource = dtRedeemed;
                RedeemedVouchers.DataBind();

                // Expired Vouchers
                SqlCommand cmdExpired = new SqlCommand("Account_Expired_Voucher", conn);
                cmdExpired.CommandType = CommandType.StoredProcedure;
                cmdExpired.Parameters.AddWithValue("@mobile_num", mobileNum);
                SqlDataAdapter adapterExpired = new SqlDataAdapter(cmdExpired);
                DataTable dtExpired = new DataTable();
                adapterExpired.Fill(dtExpired);
                ExpiredVouchers.DataSource = dtExpired;
                ExpiredVouchers.DataBind();
            }
        }

        protected string GetVoucherColor(string value)
        {
            using (SHA256 sha256 = SHA256.Create())
            {
                byte[] hash = sha256.ComputeHash(Encoding.UTF8.GetBytes(value));
                string color = "#" + BitConverter.ToString(hash).Replace("-", "").Substring(0, 6);
                return color;
            }
        }

        protected void RedeemVoucher_Click(object sender, EventArgs e)
        {
            Button clickedButton = sender as Button;
            if (clickedButton == null) return;

            string voucherId = null;
            if (clickedButton == RedeemButtonPhysical)
            {
                voucherId = HiddenVoucherIdPhysical.Value;
            }
            else if (clickedButton == RedeemButtonEshop)
            {
                voucherId = HiddenVoucherIdEshop.Value;
            }
            else if (clickedButton == RedeemButtonRedeemed)
            {
                voucherId = HiddenVoucherIdRedeemed.Value;
            }
            else
            {
                voucherId = HiddenVoucherIdExpired.Value;
            }

            if (string.IsNullOrEmpty(voucherId))
            {
                System.Diagnostics.Debug.WriteLine("Voucher ID is null or empty for button: " + clickedButton.ID);
                PageUtilities.DisplayAlert(new Exception("No voucher ID provided."), this, "alert-danger");
                return;
            }

            using (SqlConnection conn = new SqlConnection(PageUtilities.connectionString))
            {
                try
                {
                    SqlCommand cmd = new SqlCommand("Redeem_voucher_points", conn);
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@mobile_num", mobileNum);
                    cmd.Parameters.AddWithValue("@voucher_id", int.Parse(voucherId));
                    SqlParameter messageParam = cmd.Parameters.Add("@message", System.Data.SqlDbType.NVarChar, 100);
                    messageParam.Direction = System.Data.ParameterDirection.Output;

                    conn.Open();
                    cmd.ExecuteNonQuery();

                    string message = messageParam.Value.ToString();
                    if (message.Contains("Insufficient") || message.Contains("expired"))
                    {
                        Session["AlertMessage"] = message;
                        Session["AlertType"] = "alert-danger";
                    }
                    else
                    {
                        Session["AlertMessage"] = message;
                        Session["AlertType"] = "alert-success";
                    }
                }
                catch (Exception ex)
                {
                    Session["AlertMessage"] = ex.Message;
                    Session["AlertType"] = "alert-danger";
                }
                Response.Redirect(Request.RawUrl, false);
                Context.ApplicationInstance.CompleteRequest();
            }
        }
    }
}