<%@ Page Language="C#" AutoEventWireup="true" CodeFile="PlansPage.aspx.cs" Inherits="Telecom_Customer_Application.AdminDashboard.PlansPage" %>
<%@ Register Src="../Controls/Sidebar.ascx" TagName="Sidebar" TagPrefix="uc" %>

<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" rel="stylesheet">
    <meta charset="UTF-8">
    <title>Plan Page</title>
    <script src="https://cdn.jsdelivr.net/npm/chart.js@3.7.1"></script>
    <script src="../Scripts/AdminDashboard.js"></script> 
    <link href="../Styles/AdminDashboard.css" rel="stylesheet"/>
</head>
<body>
    <form id="form1" runat="server">
        <div class="container" runat="server">
            <uc:Sidebar runat="server" />

            <div id="sharedContent" class="tab-content active-tab">

                <h3 id="TabHeading" runat="server" class="tab-heading">Plans Information</h3>


                <div id="PlanCardsContainer" runat="server" style="display: block;">
                    <div class="PlanCardsContainer">
                        <!-- Basic Plan Card -->
                        <div class="plan-card basic-plan" runat="server" onclick="triggerPostback('1')">
                            <i class="fas fa-user"></i>
                            <div class="plan-name">Basic Plan</div>
                            <div class="plan-id">Plan ID: 1</div>
                            <div class="plan-details">Affordable plan for light users</div>
                            <div class="plan-price">Price: $50/month</div>
                        </div>

                        <!-- Standard Plan Card -->
                        <div class="plan-card standard-plan" runat="server" onclick="triggerPostback('2')">
                            <i class="fas fa-users"></i>
                            <div class="plan-name">Standard Plan</div>
                            <div class="plan-id">Plan ID: 2</div>
                            <div class="plan-details">Ideal for moderate users</div>
                            <div class="plan-price">Price: $100/month</div>
                        </div>

                        <!-- Premium Plan Card -->
                        <div class="plan-card premium-plan" runat="server" onclick="triggerPostback('3')">
                            <i class="fas fa-star"></i>
                            <div class="plan-name">Premium Plan</div>
                            <div class="plan-id">Plan ID: 3</div>
                            <div class="plan-details">Best for heavy users</div>
                            <div class="plan-price">Price: $200/month</div>
                        </div>

                        <!-- Unlimited Plan Card -->
                        <div class="plan-card unlimited-plan" runat="server" onclick="triggerPostback('4')">
                            <i class="fas fa-infinity"></i>
                            <div class="plan-name">Unlimited Plan</div>
                            <div class="plan-id">Plan ID: 4</div>
                            <div class="plan-details">Unlimited calls, SMS, and data</div>
                            <div class="plan-price">Price: $300/month</div>
                        </div>
                    </div>
                </div>

                <div id="FilterContainer" runat="server" class="filter-container">
                    <div class="filter-option">
                        <label for="SubscriptionDateFilter" class="filter-label">Subscription Since:</label>
                        <asp:TextBox ID="SubscriptionDateFilter" runat="server" CssClass="filter-input" TextMode="Date"></asp:TextBox>
                    </div>
                    <div class="filter-option">
                        <label for="SubscriptionStatusFilter" class="filter-label">Subscription Status:</label>
                        <asp:DropDownList ID="SubscriptionStatusFilter" runat="server" CssClass="filter-dropdown">
                            <asp:ListItem Text="All" Value="All" Selected="True"></asp:ListItem>
                            <asp:ListItem Text="active" Value="active"></asp:ListItem>
                            <asp:ListItem Text="onhold" Value="onhold"></asp:ListItem>
                        </asp:DropDownList>
                    </div>
                    <div class="filter-option">
                        <asp:Button ID="ApplyFilterButton" runat="server" CssClass="filter-button" Text="Apply Filters" OnClick="ApplyFilterButton_Click" />
                    </div>
                </div>

                <div class="table-responsive">
                    <table>
                        <tbody id="TableBody" runat="server"></tbody>
                    </table>
                </div>
            </div>
            <div id="rightSidePanel" class="right-side-panel" style="right: -300px;">
                <!-- Hidden by default -->
                <button id="togglePanelButton" class="toggle-panel-button" type="button" onclick="togglePanel()">
                    <i class="fas fa-chart-pie"></i>
                </button>
                <div id="panelContent" class="panel-content">
                    <h3>Subscription Statistics</h3>
                    <div class="chart-container">
                        <canvas id="subscriptionPieChart"></canvas>
                    </div>
                </div>
            </div>

        </div>
    </form>
</body>
</html>