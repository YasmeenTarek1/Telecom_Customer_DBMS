<%@ Page Language="C#" AutoEventWireup="true" CodeFile="PointsPage.aspx.cs" Inherits="Telecom_Customer_Application.AdminDashboard.PointsPage" %>
<%@ Register Src="../Controls/AdminSidebar.ascx" TagName="Sidebar" TagPrefix="uc" %>

<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" rel="stylesheet">
    <meta charset="UTF-8">
    <title>Points Page</title>
    <script src="https://cdn.jsdelivr.net/npm/chart.js@3.7.1"></script>
    <script src="../Scripts/Dashboards.js"></script> 
    <link href="../Styles/Dashboards.css" rel="stylesheet"/>
</head>
<body>
    <form id="form1" runat="server">
        <div class="container" runat="server">
            <uc:Sidebar runat="server" />

            <div id="sharedContent" class="tab-content">

              
                <div style="display: flex; align-items: center;">
                    <h3 id="TabHeading" class="tab-heading">Points</h3>
                    <a href="~/AdminDashboard/BenefitsPage.aspx" runat="server" class="backButton">
                        <i class="fa-solid fa-right-from-bracket sidebar-icon"></i>
                    </a>
                </div>

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
                        <div class="iconBx" style="margin-right:20px;">
                            <i class="fa-solid fa-ticket"></i>
                        </div>
                    </div>
                    <div class="card">
                        <div>
                            <div class="numbers" id="activePointsCount" runat="server">0</div>
                            <div class="cardName">Active Points</div>
                        </div>
                        <div class="iconBx" style="margin-right:20px;">
                            <i class="fa-solid fa-circle-check"></i>
                        </div>
                    </div>

                    <div class="card">
                        <div>
                            <div class="numbers" id="expiredPointsCount" runat="server">0</div>
                            <div class="cardName">Expired Points</div>
                        </div>
                        <div class="iconBx" style="margin-right:20px;">
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
                    <div class="chart-navigation">
                        <button id="prevChart" class="nav-arrow left-arrow" type="button" onclick="prevChart(event)">
                            <i class="fas fa-chevron-left"></i>
                        </button>
                        <div class="chart-container" data-index="0">
                            <canvas id="points-plan-chart" width="400" height="400"></canvas>
                        </div>
                        <div class="chart-container" data-index="1">
                            <canvas id="top-points-chart" width="400" height="400"></canvas>
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