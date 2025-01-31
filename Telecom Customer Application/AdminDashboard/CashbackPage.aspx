<%@ Page Language="C#" AutoEventWireup="true" CodeFile="CashbackPage.aspx.cs" Inherits="Telecom_Customer_Application.AdminDashboard.CashbackPage" %>
<%@ Register Src="../Controls/Sidebar.ascx" TagName="Sidebar" TagPrefix="uc" %>

<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" rel="stylesheet">
    <meta charset="UTF-8">
    <title>Cashback Page</title>
    <script src="https://cdn.jsdelivr.net/npm/chart.js@3.7.1"></script>
    <script src="../Scripts/AdminDashboard.js"></script> 
    <link href="../Styles/AdminDashboard.css" rel="stylesheet"/>
</head>
<body>
    <form id="form1" runat="server">
        <div class="container" runat="server">
            <uc:Sidebar runat="server" />

            <div id="sharedContent" class="tab-content">

                <h3 id="TabHeading" class="tab-heading">Cashback</h3>

                <div class="cardBox" style="margin: 20px 170px;">
                    <div class="card">
                        <div>
                            <div class="numbers" id="paymentCount" runat="server">0</div>
                            <div class="cardName">Payments</div>
                        </div>
                        <div class="iconBx">
                            <i class="fa-solid fa-coins sidebar-icon"></i>
                        </div>
                    </div>

                    <div class="vs">VS</div>

                    <div class="card" ">
                        <div>
                            <div class="numbers" id="cashbackCount" runat="server">0</div>
                            <div class="cardName">Cashback</div>
                        </div>
                        <div class="iconBx" style="margin-right:10px;">
                            <i class="fa-solid fa-money-bill-wave"></i>
                        </div>
                    </div>
                </div>

                <div class="table-responsive">
                    <table>
                        <caption>Cashback History</caption>
                        <tbody id="TableBody1" runat="server"></tbody>
                    </table>
                </div>
                <div class="table-responsive">
                    <table>
                        <caption>Cashback Transactions per Wallet</caption>
                        <tbody id="TableBody2" runat="server"></tbody>
                    </table>
                </div>

            </div>

            <div id="rightSidePanel" class="right-side-panel">
                <button id="togglePanelButton" class="toggle-panel-button" type="button" onclick="togglePanel()">
                    <i class="fas fa-chart-pie"></i>
                </button>

                <div id="panelContent" class="panel-content">
                    <!-- Cashback given by each Plan Pie Chart -->
                    <div class="chart-container">
                        <canvas id="cashback-plan-chart" width="400" height="400"></canvas>
                    </div>
                    <!-- TOP Customers awarded Cashback Bar Chart -->
                    <div class="chart-container">
                        <canvas id="top-customers-chart" width="400" height="400"></canvas>
                    </div>
                </div>
            </div>
        </div>
    </form>
</body>
</html>
