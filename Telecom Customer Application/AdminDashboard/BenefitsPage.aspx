<%@ Page Language="C#" AutoEventWireup="true" CodeFile="BenefitsPage.aspx.cs" Inherits="Telecom_Customer_Application.AdminDashboard.BenefitsPage" %>
<%@ Register Src="../Controls/Sidebar.ascx" TagName="Sidebar" TagPrefix="uc" %>

<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" rel="stylesheet">
    <meta charset="UTF-8">
    <title>Benefits Page</title>
    <script src="https://cdn.jsdelivr.net/npm/chart.js@3.7.1"></script>
    <script src="../Scripts/AdminDashboard.js"></script> 
    <link href="../Styles/AdminDashboard.css" rel="stylesheet"/>
</head>
<body>
    <form id="form1" runat="server">
        <div class="container" runat="server">
            <uc:Sidebar runat="server" />

            <div id="sharedContent" class="tab-content">

                <h3 id="TabHeading" class="tab-heading">Benefits</h3>

                <!-- Four Cards for Total Benefits, Points, Cashback, and Exclusive Offers -->
                <div class="PlanCardsContainer" runat="server">
                    <!-- Total Benefits Card -->
                    <div class="plan-card basic-plan" id="total_benefits_card" style="padding: 35px 25px; height: 170px;">
                        <i class="fas fa-gift"></i>
                        <div class="plan-name">Benefits</div>
                        <div class="plan-details" style="margin-bottom: 0px;">Earned through plan renewals</div>
                        <p style="font-size: 20px;" class="plan-price">Total Benefits awarded: <span id="totalBenefits" runat="server">0</span></p>
                    </div>
                    <!-- Points Card -->
                    <div class="plan-card  standard-plan" id="points_card" style="padding: 35px 25px; height: 170px;" runat="server" onclick="triggerPostback2('1')">
                        <i class="fas fa-trophy"></i>
                        <div class="plan-name">Points</div>
                        <div class="plan-details" style="margin-bottom: 0px;">Redeemable for vouchers and rewards</div>
                        <p style="font-size: 20px;" class="plan-price">Total Points Earned: <span id="totalPoints" runat="server">0</span></p>
                    </div>

                    <!-- Cashback Card -->
                    <div class="plan-card premium-plan" id="cashback_card" style="padding: 35px 25px; height: 170px;" runat="server" onclick="triggerPostback2('2')">
                        <i class="fas fa-wallet"></i>
                        <div class="plan-name">Cashback</div>
                        <div class="plan-details" style="margin-bottom: 0px;">Credited to customers' wallet</div>
                        <p style="font-size: 20px;" class="plan-price">Total Cashback Earned: <span id="totalCashback" runat="server">0</span></p>
                    </div>

                    <!-- Exclusive Offers Card -->
                    <div class="plan-card unlimited-plan" id="exclusive_offers_card" style="padding: 35px 25px; height: 170px;" runat="server" onclick="triggerPostback2('3')">
                        <i class="fas fa-gift"></i>
                        <div class="plan-name">Exclusive Offers</div>
                        <div class="plan-details" style="margin-bottom: 0px;">SMS, minutes, and internet bundles</div>
                        <p style="font-size: 20px;" class="plan-price">Total Offers Redeemed: <span id="totalOffers" runat="server">0</span></p>
                    </div>
                </div>

                <!-- Table 1: Customers With Active Benefits -->
                <div class="table-responsive">
                    <table>
                        <caption>Customers With Active Benefits</caption>
                        <tbody id="TableBody1" runat="server"></tbody>
                    </table>
                </div>
                <!-- Table 2: Customers With No Active Benefits -->
                <div class="table-responsive">
                    <table>
                        <caption>Customers With No Active Benefits</caption>
                        <tbody id="TableBody2" runat="server"></tbody>
                    </table>
                </div>
                <!-- Table 3: Benefits Expiring Soon -->
                <div class="table-responsive">
                    <table>
                        <caption>Benefits Expiring Soon</caption>
                        <tbody id="TableBody3" runat="server"></tbody>
                    </table>
                </div>
            </div>

            <div id="rightSidePanel" class="right-side-panel">
                <button id="togglePanelButton" class="toggle-panel-button" type="button" onclick="togglePanel()">
                    <i class="fas fa-chart-pie"></i>
                </button>

                <div id="panelContent" class="panel-content">
                    <!-- Benefit Types Pie Chart -->
                    <div class="chart-container">
                        <canvas id="benefit-types-chart" width="400" height="400"></canvas>
                    </div>
                    <!-- Active vs Expired Pie Chart -->
                    <div class="chart-container">
                        <canvas id="benefits-status-chart" width="400" height="400"></canvas>
                    </div>
                </div>
            </div>
        </div>
    </form>
</body>
</html>
