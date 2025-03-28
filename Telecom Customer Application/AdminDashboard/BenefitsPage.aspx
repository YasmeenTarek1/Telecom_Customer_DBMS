<%@ Page Language="C#" AutoEventWireup="true" CodeFile="BenefitsPage.aspx.cs" Inherits="Telecom_Customer_Application.AdminDashboard.BenefitsPage" %>
<%@ Register Src="../Controls/AdminSidebar.ascx" TagName="Sidebar" TagPrefix="uc" %>

<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" rel="stylesheet">
    <meta charset="UTF-8">
    <title>Benefits Page</title>
   <script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.2/dist/chart.umd.js"></script>
    <script src="../Scripts/Dashboards.js"></script> 
    <link href="../Styles/Dashboards.css" rel="stylesheet"/>
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

                <!-- Table 1: Active Benefits -->
                <div class="table-responsive">
                    <table>
                        <caption>Active Benefits</caption>
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
                    <div class="chart-navigation">
                        <button id="prevChart" class="nav-arrow left-arrow" type="button" onclick="prevChart(event)">
                            <i class="fas fa-chevron-left"></i>
                        </button>
                        <div class="chart-container" data-index="0">
                            <canvas id="benefit-types-chart" width="400" height="400"></canvas>
                        </div>
                        <div class="chart-container" data-index="1">
                            <canvas id="benefits-status-chart" width="400" height="400"></canvas>
                        </div>
                        <button id="nextChart" class="nav-arrow right-arrow" type="button" onclick="nextChart(event)">
                            <i class="fas fa-chevron-right"></i>
                        </button>
                    </div>
                </div>
            </div>
        </div>
    </form>
</body>
</html>
