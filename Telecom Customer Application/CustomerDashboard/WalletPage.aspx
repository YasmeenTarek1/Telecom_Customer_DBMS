<%@ Page Language="C#" AutoEventWireup="true" CodeFile="WalletPage.aspx.cs" Inherits="Telecom_Customer_Application.CustomerDashboard.WalletPage" %>
<%@ Register Src="~/Controls/CustomerSidebar.ascx" TagName="Sidebar" TagPrefix="uc" %>

<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <meta charset="UTF-8">
    <title>Wallet Page</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inconsolata&family=Open+Sans&display=swap" rel="stylesheet"> 
    <style>
        .container1 {
            display: flex;
            flex-direction: row;
            align-items: center;
            padding: 20px;
        }

        .credit-card-box {
            width: 500px;
            height: 300px;
            position: relative;
            margin-right: 50px;
        }
        .credit-card-box.hover .flip {
            transform: rotateY(180deg);
        }
        .flip {
            transition: 0.6s;
            transform-style: preserve-3d;
            position: relative;
        }
        .front,
        .back {
            width: 100%;
            height: 300px;
            border-radius: 15px;
            backface-visibility: hidden;
            background: linear-gradient(135deg, #bd6772, #53223f);
            position: absolute;
            color: #fff;
            font-family: 'Inconsolata', monospace;
            top: 0;
            left: 0;
            text-shadow: 0 1px 1px hsla(0, 0, 0, 0.3);
            box-shadow: 0 1px 6px hsla(0, 0, 0, 0.3);
        }
        .front {
            z-index: 2;
            transform: rotateY(0deg);
        }
        .back {
            transform: rotateY(180deg);
        }
        .logo {
            position: absolute;
            top: 30px;
            right: 30px;
            font-size: 68px; 
        }
        .back .logo {
            top: 225px;
            font-size: 52px; 
            right: 35px;
        }
        .chip::before {
            content: '';
            position: absolute;
            top: 0;
            bottom: 0;
            left: 0;
            right: 0;
            margin: auto;
            border: 4px solid hsla(0, 0, 50, .1);
            width: 80%;
            height: 70%;
            border-radius: 5px;
        }
        .chip {
            position: absolute;
            width: 55px;
            height: 42px;
            top: 40px;
            left: 35px;
            border-radius: 8px;
        }
        .chip img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }
        .strip {
            background: linear-gradient(135deg, hsl(200, 10%, 30%), hsl(200, 10%, 15%));
            position: absolute;
            width: 100%;
            height: 50px;
            top: 50px;
            left: 0;
        }
        .number {
            position: absolute;
            margin: 0 auto;
            top: 125px;
            left: 35px;
            font-size: 40px;
        }
        label {
            font-size: 12px;
            letter-spacing: 1px;
            text-shadow: none;
            text-transform: uppercase;
            font-weight: normal;
            opacity: 0.5;
            display: block;
            margin-bottom: 3px;
        }
        .card-holder,
        .card-expiration-date {
            position: absolute;
            margin: 0 auto;
            top: 220px;
            left: 35px;
            font-size: 24px;
            text-transform: capitalize;
        }
        .card-expiration-date {
            text-align: right;
            left: auto;
            right: 35px;
        }
        .ccv {
            height: 19px;
            background: #fff;
            width: 84%;
            border-radius: 5px;
            top: 145px;
            left: 0;
            right: 0;
            position: absolute;
            margin: 0 auto;
            color: #000;
            text-align: right;
            padding: 10px;
        }
        .ccv label {
            margin: -25px 0 14px;
            color: #fff;
        }
        .stats-container {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 20px;
            flex-grow: 1;
        }
        .stat-card {
            background-color: #fff;
            border-radius: 15px;
            padding: 15px;
            width: 150px;
            height: 100px;
            box-shadow: 0 5px 10px rgba(0, 0, 0, 0.1);
            display: flex;
            flex-direction: column;
            justify-content: space-between;
        }
        .stat-card h4 {
            font-size: 14px;
            color: #666;
            margin: 0;
        }
        .stat-card p {
            font-size: 20px;
            font-weight: bold;
            margin: 5px 0;
        }
        .stat-card span {
            font-size: 12px;
            color: #999;
        }
        .stat-card i {
            align-self: flex-end;
            color: #ccc;
            font-size: 14px;
        }
        
        .balance-card { background-color: #ffcccc; } /* Peach */
        .cashback-card { background-color: #ccffcc; } /* Light green */
        .sent-card { background-color: #cce0ff; } /* Light blue */
        .received-card { background-color: #e6ccff; } /* Light purple */

        /* Colored arrows for transfers */
        .transfer-arrow-sent::before, .transfer-arrow-received::before {
            content: "\f061"; 
            font-family: "Font Awesome 6 Free";
            font-weight: 900;
            margin-right: 5px;
            font-size: 30px; 
        }
        .transfer-arrow-sent::before{
            color: red;
        }
        .transfer-arrow-received::before {
            color: green;
            transform: scaleX(-1); 
            display: inline-block; 
        }

        .due-amount-red {
            color: red;
        }

        /* Action Boxes Styles */
        .action-container {
            display: flex;
            gap: 20px;
            margin: 30px 20px;
        }
    
        .action-box {
            display: flex;
            align-items: center;
            padding: 20px;
            border-radius: 15px;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
            cursor: pointer;
            transition: transform 0.3s, box-shadow 0.3s;
            flex: 1;
            max-width: 300px;
        }
    
        .action-box:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 20px rgba(0, 0, 0, 0.15);
        }
    
        .recharge-box {
            background: linear-gradient(135deg, #4CAF50, #2E7D32);
            color: white;
        }
    
        .transfer-box {
            background: linear-gradient(135deg, #2196F3, #1565C0);
            color: white;
        }
    
        .action-icon {
            font-size: 36px;
            margin-right: 20px;
            display: flex;
            align-items: center;
            justify-content: center;
            width: 60px;
            height: 60px;
            background-color: rgba(255, 255, 255, 0.2);
            border-radius: 50%;
        }
    
        .action-text h3 {
            margin: 0 0 5px 0;
            font-size: 18px;
        }
    
        .action-text p {
            margin: 0;
            font-size: 14px;
            opacity: 0.8;
        }
    
        /* Dialog Styles */
        .dialog-overlay {
            position: fixed;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background-color: rgba(0, 0, 0, 0.5);
            display: flex;
            align-items: center;
            justify-content: center;
            z-index: 1000;
            opacity: 0;
            visibility: hidden;
            transition: opacity 0.3s, visibility 0.3s;
        }
    
        .dialog-overlay.active {
            opacity: 1;
            visibility: visible;
        }
    
        .dialog-content {
            background-color: white;
            border-radius: 10px;
            width: 90%;
            max-width: 400px;
            box-shadow: 0 10px 25px rgba(0, 0, 0, 0.2);
            transform: translateY(20px);
            transition: transform 0.3s;
        }
    
        .dialog-overlay.active .dialog-content {
            transform: translateY(0);
        }
    
        .dialog-header {
            padding: 15px 20px;
            border-bottom: 1px solid #eee;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
    
        .dialog-header h3 {
            margin: 0;
            color: #333;
        }
    
        .close-dialog {
            background: none;
            border: none;
            font-size: 18px;
            cursor: pointer;
            color: #666;
        }
    
        .dialog-body {
            padding: 20px;
        }
    
        .form-group {
            margin-bottom: 20px;
        }
    
        .form-group label {
            display: block;
            margin-bottom: 8px;
            color: #333;
            opacity: 1;
            font-size: 14px;
        }
    
        .form-group input, .form-group select {
            width: 100%;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 5px;
            font-size: 16px;
        }
    
        .dialog-footer {
            padding: 15px 20px;
            border-top: 1px solid #eee;
            display: flex;
            justify-content: flex-end;
            gap: 10px;
        }
    
        .action-btn, .cancel-btn {
            padding: 10px 20px;
            border-radius: 5px;
            font-weight: bold;
            cursor: pointer;
            border: none;
            transition: background-color 0.3s;
        }
    
        .action-btn {
            background-color: #4CAF50;
            color: white;
        }
    
        .action-btn:hover {
            background-color: #388E3C;
        }
    
        .cancel-btn {
            background-color: #f2f2f2;
            color: #333;
        }
    
        .cancel-btn:hover {
            background-color: #e0e0e0;
        }
     
    </style>
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
                        <caption>Payments</caption>
                        <tbody id="TableBody2" runat="server"></tbody>
                    </table>
                </div>
                <div class="table-responsive">
                    <table>
                        <caption>Cashbacks</caption>
                        <tbody id="TableBody3" runat="server"></tbody>
                    </table>
                </div>
            </div>
        </div>
        <asp:HiddenField ID="HiddenMobileNo" runat="server" />
    </form>
</body>
</html>