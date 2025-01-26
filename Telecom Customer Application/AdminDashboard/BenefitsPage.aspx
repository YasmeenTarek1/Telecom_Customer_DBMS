<%@ Page Language="C#" AutoEventWireup="true" CodeFile="BenefitsPage.aspx.cs" Inherits="Telecom_Customer_Application.AdminDashboard.BenefitsPage" %>
<%@ Register Src="~/Controls/Sidebar.ascx" TagName="Sidebar" TagPrefix="uc" %>

<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" rel="stylesheet">
    <meta charset="UTF-8">
    <title>Benefits Page</title>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <script src="../Scripts/AdminDashboard.js"></script> 
    <link href="../Styles/AdminDashboard.css" rel="stylesheet"/>
</head>
<body>
    <form id="form1" runat="server">
        <div class="container" runat="server">
            <uc:Sidebar runat="server" />

            <div id="sharedContent" class="tab-content active-tab">

                <h3 id="TabHeading" class="tab-heading">Benefits</h3>

               <!-- Section 1: Three Cards for Points, Cashback, and Exclusive Offers -->
               <div id="mainCards" runat="server">
                   <div class="PlanCardsContainer">
                       <div class="plan-card basic-plan" id="points-card">
                           <div class="plan-name">Points</div>
                           <p>Total Points Earned: <span id="totalPoints" runat="server">0</span></p>
                       </div>
                       <div class="plan-card standard-plan" id="cashback-card">
                           <div class="plan-name">Cashback</div>
                           <p>Total Cashback Earned: <span id="totalCashback" runat="server">0</span></p>
                       </div>
                       <div class="plan-card premium-plan" id="exclusive-offers-card">
                           <div class="plan-name">Exclusive Offers</div>
                           <p>Total Offers Redeemed: <span id="totalOffers" runat="server">0</span></p>
                       </div>
                   </div>
               </div>

               <!-- Section 2: Number of Benefit Types with Pie Chart -->
               <div id="secondCards" runat="server">
                   <div class="section">
                       <div class="cardBox2">
                           <!-- Card -->
                           <div class="card">
                               <div class="cardName">Number of Benefit Types</div>
                               <div class="numbers" id="benefitsTypeCount" runat="server">6</div>
                           </div>
                           <!-- Pie Chart -->
                           <div class="chart-container">
                               <canvas id="benefit-types-chart" width="400" height="400"></canvas>
                           </div>
                       </div>
                   </div>
               </div>


               <!-- Section 3: Total Benefits Offered with Pie Chart -->
               <div id="thirdCards" runat="server">
                   <div class="section">
                       <div class="cardBox2">
                           <div class="card">
                               <div class="cardName">Total Benefits Offered</div>
                               <div class="numbers" id="totalBenefits" runat="server">0</div>
                           </div>
                           <div class="chart-container">
                               <canvas id="benefits-status-chart" width="400" height="400"></canvas>
                           </div>
                       </div>
                   </div>
               </div>

                <div class="table-responsive">
                    <table>
                        <tbody id="TableBody1" runat="server"></tbody>
                    </table>
                </div>
                <div class="table-responsive">
                    <table>
                        <tbody id="TableBody2" runat="server"></tbody>
                    </table>
                </div>
                <div class="table-responsive">
                    <table>
                        <tbody id="TableBody3" runat="server"></tbody>
                    </table>
                </div>

            </div>
        </div>
    </form>
</body>
</html>
