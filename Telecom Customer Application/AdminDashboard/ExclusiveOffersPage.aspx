<%@ Page Language="C#" AutoEventWireup="true" CodeFile="ExclusiveOffersPage.aspx.cs" Inherits="Telecom_Customer_Application.AdminDashboard.ExclusiveOffersPage" %>
<%@ Register Src="../Controls/AdminSidebar.ascx" TagName="Sidebar" TagPrefix="uc" %>

<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" rel="stylesheet">
    <meta charset="UTF-8">
    <title>Exclusive Offers Page</title>
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
                    <h3 id="TabHeading" class="tab-heading">Exclusive Offers</h3>
                    <a href="~/AdminDashboard/BenefitsPage.aspx" runat="server" class="backButton">
                        <i class="fa-solid fa-right-from-bracket sidebar-icon"></i>
                    </a>
                </div>

                <div class="cardBox" style="grid-template-columns: repeat(3, 0.3fr); grid-gap: 100px; margin: 30px 60px 20px 60px;">
                    <div class="card">
                        <div>
                            <div class="numbers" id="totalOffersCount" runat="server">0</div>
                            <div class="cardName">Total Offers</div>
                        </div>
                        <div class="iconBx" style="margin-right:10px;">
                            <i class="fa-solid fa-comments"></i>
                        </div>
                    </div>

                    <div class="card">
                        <div>
                            <div class="numbers" id="activeOffersCount" runat="server">0</div>
                            <div class="cardName">Active Offers</div>
                        </div>
                        <div class="iconBx" style="margin-right:10px;">
                            <i class="fa-solid fa-circle-check"></i>
                        </div>
                    </div>

                    <div class="card">
                        <div>
                            <div class="numbers" id="expiredOffersCount" runat="server">0</div>
                            <div class="cardName">Expired Offers</div>
                        </div>
                        <div class="iconBx" style="margin-right:10px;">
                            <i class="fa-solid fa-shop-slash"></i>
                        </div>
                    </div>
                </div>


                <div class="table-responsive">
                    <table>
                        <caption>Exclusive Offers History</caption>
                        <tbody id="TableBody1" runat="server"></tbody>
                    </table>
                </div>
                <div class="table-responsive">
                    <table>
                        <caption>Customers Didn't Use Their Exclusive Offers</caption>
                        <tbody id="TableBody2" runat="server"></tbody>
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
                        <div class="chart-container">
                            <canvas id="offers-plan-chart" width="400" height="400"></canvas>
                        </div>

                        <!-- TOP Customers offered offered SMS Bar Chart -->
                        <div class="chart-container">
                            <canvas id="top-sms-chart" width="400" height="400"></canvas>
                        </div>
                        <!-- TOP Customers offered offered minutes Bar Chart -->
                        <div class="chart-container">
                            <canvas id="top-minutes-chart" width="400" height="400"></canvas>
                        </div>
                        <!-- TOP Customers offered offered data Bar Chart -->
                        <div class="chart-container">
                            <canvas id="top-data-chart" width="400" height="400"></canvas>
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