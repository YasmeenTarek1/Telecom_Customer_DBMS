<%@ Page Language="C#" AutoEventWireup="true" CodeFile="WalletPage.aspx.cs" Inherits="Telecom_Customer_Application.CustomerDashboard.WalletPage" %>
<%@ Register Src="~/Controls/CustomerSidebar.ascx" TagName="Sidebar" TagPrefix="uc" %>

<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <meta charset="UTF-8">
    <title>Wallet Page</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inconsolata&family=Open+Sans&display=swap" rel="stylesheet"> 
</head>
<body>
    <form id="form1" runat="server">
        <div class="container" runat="server">
            <uc:Sidebar runat="server" />
            <div id="sharedContent" class="tab-content">
                <h3 id="TabHeading" class="tab-heading" style="margin: 40px auto 50px auto; font-size: 34px;">Wallet</h3>
                <div class="container1" runat="server">

                    <!-- Credit Card -->
                    <div class="credit-card-box">
                        <div class="flip">
                            <div class="front">
                                <div class="chip">
                                    <img src="../chip.png" runat="server" alt="Chip Image" />
                                </div>
                                <div class="logo">
                                    <i class="fa-brands fa-cc-visa"></i>
                                </div>
                                <div class="number"></div>
                                <div class="card-holder">
                                    <label>Card Holder</label>
                                    <div></div>
                                </div>
                                <div class="card-expiration-date">
                                    <label>Expires</label>
                                    <div>12/25</div>
                                </div>
                            </div>
                            <div class="back">
                                <div class="strip"></div>
                                <div class="logo">
                                    <i class="fa-brands fa-cc-visa"></i>
                                </div>
                                <div class="ccv">
                                    <label>CVV</label>
                                    <div>***</div>
                                </div>
                            </div>
                        </div>
                    </div>
                       
                    <!-- Stats Box -->
                    <div class="stats-container">
                        <div class="stat-card balance-card">
                            <h4>Balance</h4>
                            <p id="balance">$0</p>
                            <span>Current balance</span>
                            <i class="fas fa-arrow-right"></i>
                        </div>
                        <div class="stat-card cashback-card">
                            <h4>Cashback</h4>
                            <p id="cashback">$0</p>
                            <span>Total earned</span>
                            <i class="fas fa-arrow-right"></i>
                        </div>
                        <div class="stat-card sent-card">
                            <h4>Sent Transactions</h4>
                            <p id="sent">$0</p>
                            <span>Total sent</span>
                            <i class="fas fa-arrow-right"></i>
                        </div>
                        <div class="stat-card received-card">
                            <h4>Received Transactions</h4>
                            <p id="received">$0</p>
                            <span>Total received</span>
                            <i class="fas fa-arrow-right"></i>
                        </div>
                    </div>

                    <!-- Actions Box -->
                    <div class="action-container">
                        <div class="action-box recharge-box" id="rechargeBox">
                            <div class="action-icon">
                                <i class="fas fa-wallet"></i>
                            </div>
                            <div class="action-text">
                                <h3>Recharge Balance</h3>
                                <p>Add funds to your wallet</p>
                            </div>
                        </div>
    
                        <div class="action-box transfer-box" id="transferBox">
                            <div class="action-icon">
                                <i class="fas fa-exchange-alt"></i>
                            </div>
                            <div class="action-text">
                                <h3>Transfer Money</h3>
                                <p>Send to another wallet</p>
                            </div>
                        </div>
                    </div>

                    <!-- Recharge Dialog -->
                    <div class="dialog-overlay" id="rechargeDialog">
                        <div class="dialog-content">
                            <div class="dialog-header">
                                <h3>Recharge Your Balance</h3>
                                <button class="close-dialog"><i class="fas fa-times"></i></button>
                            </div>
                            <div class="dialog-body">
                                <div class="form-group">
                                    <label for="rechargeAmount">Amount</label>
                                    <input type="number" id="rechargeAmount" min="1" step="0.1" placeholder="Enter amount">
                                </div>
                                <div class="form-group">
                                    <label for="paymentMethod">Payment Method</label>
                                    <select id="paymentMethod">
                                        <option value="cash">Cash</option>
                                        <option value="credit">Credit Card</option>
                                    </select>
                                </div>
                            </div>
                            <div class="dialog-footer">
                                <button class="cancel-btn">Cancel</button>
                                <button class="action-btn" id="confirmRecharge">Confirm Recharge</button>
                            </div>
                        </div>
                    </div>

                    <!-- Transfer Dialog -->
                    <div class="dialog-overlay" id="transferDialog">
                        <div class="dialog-content">
                            <div class="dialog-header">
                                <h3>Transfer Money</h3>
                                <button class="close-dialog"><i class="fas fa-times"></i></button>
                            </div>
                            <div class="dialog-body">
                                <div class="form-group">
                                    <label for="recipientMobile">Recipient Mobile Number</label>
                                    <input type="text" id="recipientMobile" placeholder="Enter mobile number">
                                </div>
                                <div class="form-group">
                                    <label for="transferAmount">Amount</label>
                                    <input type="number" id="transferAmount" min="1" step="0.1" placeholder="Enter amount">
                                </div>
                            </div>
                            <div class="dialog-footer">
                                <button class="cancel-btn">Cancel</button>
                                <button class="action-btn" id="confirmTransfer">Confirm Transfer</button>
                            </div>
                        </div>
                    </div>
                </div>

                 <div class="table-responsive">
                     <table>
                         <caption>Wallet Transactions</caption>
                         <tbody id="TableBody1" runat="server"></tbody>
                     </table>
                 </div>
                <div class="table-responsive">
                    <table>
                        <caption>Plan Renewals/Subscriptions</caption>
                        <tbody id="TableBody2" runat="server"></tbody>
                    </table>
                </div>
                <div class="table-responsive">
                    <table>
                        <caption>Balance Recharges</caption>
                        <tbody id="TableBody3" runat="server"></tbody>
                    </table>
                </div>
                <div class="table-responsive">
                    <table>
                        <caption>Cashbacks</caption>
                        <tbody id="TableBody4" runat="server"></tbody>
                    </table>
                </div>
            </div>
        </div>
        <asp:HiddenField ID="HiddenMobileNo" runat="server" />
    </form>
</body>
</html>