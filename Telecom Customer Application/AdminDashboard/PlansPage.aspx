<%@ Page Language="C#" AutoEventWireup="true" CodeFile="PlansPage.aspx.cs" Inherits="Telecom_Customer_Application.AdminDashboard.PlansPage" %>
<%@ Register Src="../Controls/Sidebar.ascx" TagName="Sidebar" TagPrefix="uc" %>

<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" rel="stylesheet">
    <meta charset="UTF-8">
    <title>Plan Page</title>
    <script src="../Scripts/AdminDashboard.js"></script> 
    <link href="../Styles/AdminDashboard.css" rel="stylesheet"/>
</head>
<body>
    <form id="form1" runat="server">
        <div class="container" runat="server">
            <uc:Sidebar runat="server" />

            <div id="sharedContent" class="tab-content active-tab">

                <h3 id="TabHeading" runat="server" class="tab-heading">Plans Since Date</h3>

                <div id="PlanCardsContainer" runat="server" style="display: none;">
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

                <div id="DateContainer1" runat="server" class="date-picker-container">
                     <label id="DateLabel1" runat="server" for="DateInput1" class="date-picker-label">Start Date:</label>
                     <asp:TextBox ID="DateInput1" runat="server" CssClass="date-picker" TextMode="Date"></asp:TextBox>
                 </div>
                <div id="TextBoxContainer1" runat="server" class="input-container">
                    <label for="PlanIDEditText" class="input-label">Plan ID:</label>
                    <asp:TextBox ID="PlanIDEditText" runat="server" CssClass="styled-input" placeholder="Enter Plan ID"></asp:TextBox>
                </div>

                <div class="button-container">
                    <asp:Button ID="SearchButton" runat="server" CssClass="styled-button" Text="Search" OnClick="SearchButton_Click" />
                </div>

                <div class="table-responsive">
                    <table>
                        <tbody id="TableBody" runat="server"></tbody>
                    </table>
                </div>
            </div>
        </div>
    </form>
</body>
</html>