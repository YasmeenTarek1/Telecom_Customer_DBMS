<%@ Page Language="C#" AutoEventWireup="true" CodeFile="VouchersPage.aspx.cs" Inherits="Telecom_Customer_Application.CustomerDashboard.VouchersPage" %>
<%@ Register Src="~/Controls/CustomerSidebar.ascx" TagName="Sidebar" TagPrefix="uc" %>

<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <meta charset="UTF-8">
    <title>Vouchers Page</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Libre+Barcode+128+Text&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Merriweather:400,400i,700">
    <script src="https://cdn.jsdelivr.net/npm/js-sha256@0.9.0/src/sha256.min.js"></script> 
</head>
<body>
    <form id="form1" runat="server">

        <asp:HiddenField ID="HiddenVoucherIdPhysical" runat="server" Value="" />
        <asp:HiddenField ID="HiddenVoucherIdEshop" runat="server" Value="" />
        <asp:HiddenField ID="HiddenVoucherIdRedeemed" runat="server" Value="" />
        <asp:HiddenField ID="HiddenVoucherIdExpired" runat="server" Value="" />

        <div class="container" runat="server">
            <uc:Sidebar runat="server" />
            <div id="sharedContent" class="tab-content">
                <h3 id="TabHeading" class="tab-heading" style="margin: 40px auto 50px auto; font-size: 34px;">Vouchers</h3>

                 <!-- Single Voucher Details Box -->
                 <div class="voucher-details">
                     <div class="voucher-detail-content">
                         <h3>Voucher ID</h3>
                         <p><strong>Value:</strong> <span class="detail-value"></span></p>
                         <p><strong>Points:</strong> <span class="detail-points"></span></p>
                         <p><strong>Expiry:</strong> <span class="detail-expiry"></span></p>
                         <p><strong>Shop:</strong> <span class="detail-shop"></span></p>
                         <p><strong>Address:</strong> <span class="detail-address"></span></p>
                         <p><strong>Rating:</strong> <span class="detail-rating"></span></p>
                         <p><strong>URL:</strong> <span class="detail-url"></span></p>
                         <p><strong>Redeemed:</strong> <span class="detail-redeem-date"></span></p>
                         <asp:Button ID="RedeemButtonPhysical" runat="server" Text="Redeem Voucher" CssClass="redeem-btn" OnClick="RedeemVoucher_Click" />
                         <asp:Button ID="RedeemButtonEshop" runat="server" Text="Redeem Voucher" CssClass="redeem-btn" OnClick="RedeemVoucher_Click" />
                         <asp:Button ID="RedeemButtonRedeemed" runat="server" Text="Redeemed" CssClass="redeem-btn disabled-btn" Enabled="false" onmouseover="showTooltip(this, 'This voucher has already been redeemed')" onmouseout="hideTooltip()" />
                         <asp:Button ID="RedeemButtonExpired" runat="server" Text="Expired" CssClass="redeem-btn disabled-btn" Enabled="false" onmouseover="showTooltip(this, 'This voucher has expired')" onmouseout="hideTooltip()" />
                     </div>
                 </div>

                <!-- Non-Redeemed Physical Vouchers -->
                <div class="caption" style="width: 1550px; margin-left: 30px; margin-top: 20px; margin-bottom: 20px;">Non-Redeemed Physical Vouchers</div>
                <div class="voucher-container">
                    <div class="voucher-list">
                        <div class="section">
                            <asp:Repeater ID="PhysicalVouchers" runat="server">
                                <ItemTemplate>
                                    <div class="coupon" id='coupon-<%# Eval("voucherID") %>' data-voucher-id='<%# Eval("voucherID") %>' data-value='<%# Eval("Cash") %>' data-points='<%# Eval("Required Points") %>' data-expiry='<%# Eval("expiry_date") %>' data-shop='<%# Eval("name") %>' data-address='<%# Eval("address") %>'>
                                        <style>
                                            #coupon-<%# Eval("voucherID") %>::before {
                                                background-image: radial-gradient(circle at 0 50%, transparent 25px, <%# GetVoucherColor(Eval("Cash").ToString()) %> 26px);
                                            }
                                            #coupon-<%# Eval("voucherID") %>::after {
                                                background-image: radial-gradient(circle at 100% 50%, transparent 25px, <%# GetVoucherColor(Eval("Cash").ToString()) %> 26px);
                                            }
                                            #h2-<%# Eval("voucherID") %> {
                                                color: <%# GetVoucherColor(Eval("Cash").ToString()) %>;
                                            }
                                        </style>
                                        <div class="left">
                                            <div>Enjoy Your Gift</div>
                                        </div>
                                        <div class="center">
                                            <h2 id='h2-<%# Eval("voucherID") %>'><%# Eval("Cash") %>$</h2>
                                            <h3>Coupon</h3>
                                            <small>Valid until <%# Eval("expiry_date", "{0:MMM, yyyy}") %></small>
                                        </div>
                                        <div class="right">
                                            <div>VOUCHER#<%# Eval("voucherID") %></div>
                                        </div>
                                    </div>
                                </ItemTemplate>
                            </asp:Repeater>
                        </div>
                    </div>
                </div>

                <!-- Non-Redeemed E-Shop Vouchers -->
                <div class="caption" style="width: 1550px; margin-left: 30px; margin-top: 20px; margin-bottom: 20px;">Non-Redeemed E-Shop Vouchers</div>
                <div class="voucher-container">
                    <div class="voucher-list">
                        <div class="section">
                            <asp:Repeater ID="EshopVouchers" runat="server">
                                <ItemTemplate>
                                    <div class="coupon" id='coupon-<%# Eval("voucherID") %>' data-voucher-id='<%# Eval("voucherID") %>' data-value='<%# Eval("Cash") %>' data-points='<%# Eval("Required Points") %>' data-expiry='<%# Eval("expiry_date") %>' data-shop='<%# Eval("name") %>' data-rating='<%# Eval("rating") %>' data-url='<%# Eval("URL") %>'>
                                        <style>
                                            #coupon-<%# Eval("voucherID") %>::before {
                                                background-image: radial-gradient(circle at 0 50%, transparent 25px, <%# GetVoucherColor(Eval("Cash").ToString()) %> 26px);
                                            }
                                            #coupon-<%# Eval("voucherID") %>::after {
                                                background-image: radial-gradient(circle at 100% 50%, transparent 25px, <%# GetVoucherColor(Eval("Cash").ToString()) %> 26px);
                                            }
                                            #h2-<%# Eval("voucherID") %> {
                                                color: <%# GetVoucherColor(Eval("Cash").ToString()) %>;
                                            }
                                        </style>
                                        <div class="left">
                                            <div>Enjoy Your Gift</div>
                                        </div>
                                        <div class="center">
                                            <h2 id='h2-<%# Eval("voucherID") %>'><%# Eval("Cash") %>$</h2>
                                            <h3>Coupon</h3>
                                            <small>Valid until <%# Eval("expiry_date", "{0:MMM, yyyy}") %></small>
                                        </div>
                                        <div class="right">
                                            <div>VOUCHER#<%# Eval("voucherID") %></div>
                                        </div>
                                    </div>
                                </ItemTemplate>
                            </asp:Repeater>
                        </div>
                    </div>
                </div>

                <!-- Redeemed Vouchers -->
                <div class="caption" style="width: 1550px; margin-left: 30px; margin-top: 20px; margin-bottom: 20px;">Redeemed Vouchers</div>
                <div class="voucher-container">
                    <div class="voucher-list">
                        <div class="section">
                            <asp:Repeater ID="RedeemedVouchers" runat="server">
                                <ItemTemplate>
                                    <div class="coupon" id='coupon-<%# Eval("voucherID") %>' data-voucher-id='<%# Eval("voucherID") %>' data-value='<%# Eval("Cash") %>' data-points='<%# Eval("Required Points") %>' data-redeem-date='<%# Eval("redeem_date") %>' data-shop='<%# Eval("name") %>'>
                                        <style>
                                            #coupon-<%# Eval("voucherID") %>::before {
                                                background-image: radial-gradient(circle at 0 50%, transparent 25px, <%# GetVoucherColor(Eval("Cash").ToString()) %> 26px);
                                            }
                                            #coupon-<%# Eval("voucherID") %>::after {
                                                background-image: radial-gradient(circle at 100% 50%, transparent 25px, <%# GetVoucherColor(Eval("Cash").ToString()) %> 26px);
                                            }
                                            #h2-<%# Eval("voucherID") %> {
                                                color: <%# GetVoucherColor(Eval("Cash").ToString()) %>;
                                            }
                                        </style>
                                        <div class="left">
                                            <div>Enjoy Your Gift</div>
                                        </div>
                                        <div class="center">
                                            <h2 id='h2-<%# Eval("voucherID") %>'><%# Eval("Cash") %>$</h2>
                                            <h3>Coupon</h3>
                                            <small>Redeemed on <%# Eval("redeem_date", "{0:MMM dd, yyyy}") %></small>
                                        </div>
                                        <div class="right">
                                            <div>VOUCHER#<%# Eval("voucherID") %></div>
                                        </div>
                                    </div>
                                </ItemTemplate>
                            </asp:Repeater>
                        </div>
                    </div>
                </div>

                <!-- Expired Vouchers -->
                <div class="caption" style="width: 1550px; margin-left: 30px; margin-top: 20px; margin-bottom: 20px;">Expired Vouchers</div>
                <div class="voucher-container">
                    <div class="voucher-list">
                        <div class="section">
                            <asp:Repeater ID="ExpiredVouchers" runat="server">
                                <ItemTemplate>
                                    <div class="coupon" id='coupon-<%# Eval("voucherID") %>' data-voucher-id='<%# Eval("voucherID") %>' data-value='<%# Eval("Cash") %>' data-points='<%# Eval("Required Points") %>' data-expiry='<%# Eval("expiry_date") %>' data-shop='<%# Eval("name") %>'>
                                        <style>
                                            #coupon-<%# Eval("voucherID") %>::before {
                                                background-image: radial-gradient(circle at 0 50%, transparent 25px, <%# GetVoucherColor(Eval("Cash").ToString()) %> 26px);
                                            }
                                            #coupon-<%# Eval("voucherID") %>::after {
                                                background-image: radial-gradient(circle at 100% 50%, transparent 25px, <%# GetVoucherColor(Eval("Cash").ToString()) %> 26px);
                                            }
                                            #h2-<%# Eval("voucherID") %> {
                                                color: <%# GetVoucherColor(Eval("Cash").ToString()) %>;
                                            }
                                        </style>
                                        <div class="left">
                                            <div>Enjoy Your Gift</div>
                                        </div>
                                        <div class="center">
                                            <h2 id='h2-<%# Eval("voucherID") %>'><%# Eval("Cash") %>$</h2>
                                            <h3>Coupon</h3>
                                            <small>Expired on <%# Eval("expiry_date", "{0:MMM dd, yyyy}") %></small>
                                        </div>
                                        <div class="right">
                                            <div>VOUCHER#<%# Eval("voucherID") %></div>
                                        </div>
                                    </div>
                                </ItemTemplate>
                            </asp:Repeater>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </form>
    <script>
        document.addEventListener('DOMContentLoaded', function () {
            const vouchers = document.querySelectorAll('.coupon');
            const details = document.querySelector('.voucher-details');

            vouchers.forEach(voucher => {
                voucher.addEventListener('click', function () {
                    const voucherId = this.getAttribute('data-voucher-id');
                    const value = this.getAttribute('data-value');
                    const points = this.getAttribute('data-points');
                    const expiry = this.getAttribute('data-expiry');
                    const shop = this.getAttribute('data-shop');
                    const address = this.getAttribute('data-address');
                    const rating = this.getAttribute('data-rating');
                    const url = this.getAttribute('data-url');
                    const redeemDate = this.getAttribute('data-redeem-date');
                    const workingHours = this.getAttribute('data-working-hours');
                    const category = this.getAttribute('data-category');

                    // Clear all fields initially
                    const fields = [
                        '.detail-value', '.detail-points', '.detail-expiry',
                        '.detail-shop', '.detail-address', '.detail-rating', '.detail-url',
                        '.detail-redeem-date', '.detail-working-hours', '.detail-category'
                    ];
                    fields.forEach(selector => {
                        const element = details.querySelector(selector);
                        if (element) {
                            element.textContent = '';
                            element.parentElement.style.display = 'none'; // Hide the parent element
                        }
                    });

                    // Set the title with the voucher ID
                    details.querySelector('h3').textContent = `Voucher #${voucherId}`;

                    // Show & Set common fields
                    details.querySelector('.detail-value').textContent = value + '$';
                    details.querySelector('.detail-points').textContent = points;
                    details.querySelector('.detail-shop').textContent = shop;
                    details.querySelector('.detail-value').parentElement.style.display = 'block';
                    details.querySelector('.detail-points').parentElement.style.display = 'block';
                    details.querySelector('.detail-shop').parentElement.style.display = 'block';

                    // Handle specific fields based on voucher type
                    if (address) { // Non-Redeemed Physical Vouchers
                        details.querySelector('.detail-expiry').textContent = expiry;
                        details.querySelector('.detail-address').textContent = address;
                        if (workingHours) details.querySelector('.detail-working-hours').textContent = workingHours;
                        if (category) details.querySelector('.detail-category').textContent = category;

                        ['.detail-expiry', '.detail-address', '.detail-working-hours', '.detail-category'].forEach(selector => {
                            const element = details.querySelector(selector);
                            if (element && element.textContent) element.parentElement.style.display = 'block';
                        });
                    } else if (rating && url) { // Non-Redeemed E-Shop Vouchers
                        details.querySelector('.detail-expiry').textContent = expiry;
                        details.querySelector('.detail-rating').textContent = rating;
                        details.querySelector('.detail-url').textContent = url;
                        if (category) details.querySelector('.detail-category').textContent = category;

                        ['.detail-expiry', '.detail-rating', '.detail-url', '.detail-category'].forEach(selector => {
                            const element = details.querySelector(selector);
                            if (element && element.textContent) element.parentElement.style.display = 'block';
                        });
                    } else if (redeemDate) { // Redeemed Vouchers
                        details.querySelector('.detail-redeem-date').textContent = redeemDate;
                        details.querySelector('.detail-redeem-date').parentElement.style.display = 'block';
                    } else if (expiry) { // Expired Vouchers
                        details.querySelector('.detail-expiry').textContent = expiry;
                        details.querySelector('.detail-expiry').parentElement.style.display = 'block';
                    }


                    // Set border color to match the voucher's color using SHA256
                    if (value) {
                        const encoder = new TextEncoder();
                        const data = encoder.encode(value);
                        const hash = sha256(data);
                        const color = '#' + hash.substring(0, 6); // Take first 6 characters for a valid hex color
                        details.style.borderColor = color;
                    } else {
                        details.style.borderColor = 'transparent'; // Default if no value
                    }

                    // Show the details box
                    details.classList.add('active');

                    // Set data-voucher-id and hidden field 
                    if (address) { // Non-Redeemed Physical Vouchers
                        document.getElementById('<%= RedeemButtonPhysical.ClientID %>').setAttribute('data-voucher-id', voucherId);
                        document.getElementById('<%= HiddenVoucherIdPhysical.ClientID %>').value = voucherId;

                        document.getElementById('<%= RedeemButtonPhysical.ClientID %>').style.display = 'block';
                        document.getElementById('<%= RedeemButtonEshop.ClientID %>').style.display = 'none';
                        document.getElementById('<%= RedeemButtonRedeemed.ClientID %>').style.display = 'none';
                        document.getElementById('<%= RedeemButtonExpired.ClientID %>').style.display = 'none';
                    } else if (rating && url) { // Non-Redeemed E-Shop Vouchers
                        document.getElementById('<%= RedeemButtonEshop.ClientID %>').setAttribute('data-voucher-id', voucherId);
                        document.getElementById('<%= HiddenVoucherIdEshop.ClientID %>').value = voucherId;

                        document.getElementById('<%= RedeemButtonPhysical.ClientID %>').style.display = 'none';
                        document.getElementById('<%= RedeemButtonEshop.ClientID %>').style.display = 'block';
                        document.getElementById('<%= RedeemButtonRedeemed.ClientID %>').style.display = 'none';
                        document.getElementById('<%= RedeemButtonExpired.ClientID %>').style.display = 'none';
                    } else if (redeemDate) { // Redeemed Vouchers
                        document.getElementById('<%= RedeemButtonRedeemed.ClientID %>').setAttribute('data-voucher-id', voucherId);
                        document.getElementById('<%= HiddenVoucherIdRedeemed.ClientID %>').value = voucherId;

                        document.getElementById('<%= RedeemButtonPhysical.ClientID %>').style.display = 'none';
                        document.getElementById('<%= RedeemButtonEshop.ClientID %>').style.display = 'none';
                        document.getElementById('<%= RedeemButtonRedeemed.ClientID %>').style.display = 'block';
                        document.getElementById('<%= RedeemButtonExpired.ClientID %>').style.display = 'none';
                    } else if (expiry) { // Expired Vouchers
                        document.getElementById('<%= RedeemButtonExpired.ClientID %>').setAttribute('data-voucher-id', voucherId);
                        document.getElementById('<%= HiddenVoucherIdExpired.ClientID %>').value = voucherId;

                        document.getElementById('<%= RedeemButtonPhysical.ClientID %>').style.display = 'none';
                        document.getElementById('<%= RedeemButtonEshop.ClientID %>').style.display = 'none';
                        document.getElementById('<%= RedeemButtonRedeemed.ClientID %>').style.display = 'none';
                        document.getElementById('<%= RedeemButtonExpired.ClientID %>').style.display = 'block';
                    }
                });
            });

            // Close on click outside
            document.addEventListener('click', function (e) {
                if (!details.contains(e.target) && !Array.from(vouchers).some(v => v.contains(e.target))) {
                    details.classList.remove('active');
                }
            });
        });
    </script>
</body>
</html>