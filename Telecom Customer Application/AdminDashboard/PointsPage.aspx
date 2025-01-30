<%@ Page Language="C#" AutoEventWireup="true" CodeFile="PointsPage.aspx.cs" Inherits="Telecom_Customer_Application.AdminDashboard.PointsPage" %>
<%@ Register Src="../Controls/Sidebar.ascx" TagName="Sidebar" TagPrefix="uc" %>

<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" rel="stylesheet">
    <meta charset="UTF-8">
    <title>Points Page</title>
    <script src="https://cdn.jsdelivr.net/npm/chart.js@3.7.1"></script>
    <script src="../Scripts/AdminDashboard.js"></script> 
    <link href="../Styles/AdminDashboard.css" rel="stylesheet"/>
</head>
<body>
    <form id="form1" runat="server">
        <div class="container" runat="server">
            <uc:Sidebar runat="server" />

            <div id="sharedContent" class="tab-content">

                <h3 id="TabHeading" class="tab-heading">Points</h3>

                <div class="cardBox">
                    <div class="card">
                        <div>
                            <div class="numbers" id="totalPointsCount" runat="server">0</div>
                            <div class="cardName">Total Points</div>
                        </div>
                        <div class="iconBx">
                            <i class="fa-solid fa-coins sidebar-icon"></i>
                        </div>
                    </div>

                    <div class="card">
                        <div>
                            <div class="numbers" id="usedPointsCount" runat="server">0</div>
                            <div class="cardName">Used Points</div>
                        </div>
                        <div class="iconBx">
                            <i class="fa-solid fa-ticket"></i>
                        </div>
                    </div>
                    <div class="card">
                        <div>
                            <div class="numbers" id="activePointsCount" runat="server">0</div>
                            <div class="cardName">Active Points</div>
                        </div>
                        <div class="iconBx">
                            <i class="fa-solid fa-circle-check"></i>
                        </div>
                    </div>

                    <div class="card">
                        <div>
                            <div class="numbers" id="expiredPointsCount" runat="server">0</div>
                            <div class="cardName">Expired Points</div>
                        </div>
                        <div class="iconBx">
                            <i class="fa-solid fa-shop-slash"></i>
                        </div>
                    </div>
                </div>

                <div class="table-responsive">
                    <table>
                        <caption>Points History</caption>
                        <tbody id="TableBody" runat="server"></tbody>
                    </table>
                </div>
            </div>

            <div id="rightSidePanel" class="right-side-panel">
                <button id="togglePanelButton" class="toggle-panel-button" type="button" onclick="togglePanel()">
                    <i class="fas fa-chart-pie"></i>
                </button>

                <div id="panelContent" class="panel-content">
                    <!-- Points given by each Plan Pie Chart -->
                    <div class="chart-container">
                        <canvas id="points-plan-chart" width="400" height="400"></canvas>
                    </div>
                </div>
            </div>
        </div>
    </form>
</body>
</html>
