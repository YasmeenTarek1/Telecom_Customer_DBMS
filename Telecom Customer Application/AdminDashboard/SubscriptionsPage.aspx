<%@ Page Language="C#" AutoEventWireup="true" CodeFile="SubscriptionsPage.aspx.cs" Inherits="Telecom_Customer_Application.AdminDashboard.SubscriptionsPage" %>
<%@ Register Src="~/Controls/Sidebar.ascx" TagName="Sidebar" TagPrefix="uc" %>

<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" rel="stylesheet">
    <meta charset="UTF-8">
    <title>Subscriptions Page</title>
    <script src="https://cdn.jsdelivr.net/npm/chart.js@3.7.1"></script>
    <script src="../Scripts/AdminDashboard.js"></script> 
    <link href="../Styles/AdminDashboard.css" rel="stylesheet"/>
</head>
<body>
    <form id="form1" runat="server">
        <div class="container" runat="server">
            <uc:Sidebar runat="server" />

            <div id="sharedContent" class="tab-content">

                <h3 id="TabHeading" class="tab-heading">Subscriptions</h3>

                <div class="table-responsive">
                    <table>
                        <tbody id="TableBody" runat="server"></tbody>
                    </table>
                </div>

            </div>
            <div id="rightSidePanel" class="right-side-panel">
                <button id="togglePanelButton" class="toggle-panel-button" type="button" onclick="togglePanel()">
                    <i class="fas fa-chart-pie"></i>
                </button>
                <div id="panelContent" class="panel-content">
                    <div class="chart-container">
                        <canvas id="subscriptionPieChart" width="400" height="400"></canvas>
                    </div>
                </div>
            </div>
        </div>
    </form>
</body>
</html>
