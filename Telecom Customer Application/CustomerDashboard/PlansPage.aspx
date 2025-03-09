<%@ Page Language="C#" AutoEventWireup="true" CodeFile="PlansPage.aspx.cs" Inherits="Telecom_Customer_Application.CustomerDashboard.PlansPage" %>
<%@ Register Src="~/Controls/CustomerSidebar.ascx" TagName="Sidebar" TagPrefix="uc" %>

<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <meta charset="UTF-8">
    <title>Plans Page</title>
</head>
<body>
    <form id="form1" runat="server">
        <div class="container" runat="server">
            <uc:Sidebar runat="server" />

            <div id="sharedContent" class="tab-content">

                <h3 id="TabHeading" class="tab-heading" style="margin: 40px auto 50px auto; font-size: 34px;">Available Plans</h3>

                <div class="PlanCardsContainer" id="PlanCardsContainer" runat="server" style="margin-top: 55px;">
                    <!-- Basic Plan Card -->
                    <div class="plan-card basic-plan" runat="server" >
                        <i class="fas fa-user"></i>
                        <div class="plan-name">Basic Plan</div>
                        <div class="plan-id">Plan ID: 1</div>
                        <div class="plan-details">Affordable plan for light users</div>
                        <div class="plan-price">Price: $50/month</div>

                        <!-- Plan Offerings -->
                        <div class="plan-offerings">
                            <h4>Plan Includes:</h4>
                            <ul>
                                <li><strong>SMS:</strong> 100/month</li>
                                <li><strong>Minutes:</strong> 200/month</li>
                                <li><strong>Data:</strong> 1GB/month</li>
                            </ul>
                        </div>

                        <!-- Additional Benefits -->
                        <div class="plan-benefits">
                            <h4>Additional Benefits:</h4>
                            <ul>
                                <li>Free 100 SMS per month</li>
                                <li>Earn 50 loyalty points per month</li>
                                <li>10% cashback on plan renewal</li>
                            </ul>
                        </div>

                    </div>
             
                    <!-- Standard Plan Card -->
                    <div class="plan-card standard-plan" runat="server">
                        <i class="fas fa-users"></i>
                        <div class="plan-name">Standard Plan</div>
                        <div class="plan-id">Plan ID: 2</div>
                        <div class="plan-details">Ideal for moderate users</div>
                        <div class="plan-price">Price: $100/month</div>

                        <!-- Plan Offerings -->
                        <div class="plan-offerings">
                            <h4>Plan Includes:</h4>
                            <ul>
                                <li><strong>SMS:</strong> 500/month</li>
                                <li><strong>Minutes:</strong> 1000/month</li>
                                <li><strong>Data:</strong> 5GB/month</li>
                            </ul>
                        </div>

                        <!-- Additional Benefits -->
                        <div class="plan-benefits">
                            <h4>Additional Benefits:</h4>
                            <ul>
                                <li>Extra 1GB data per month</li>
                                <li>Bonus 100 minutes per month</li>
                                <li>Earn 50 loyalty points per month</li>
                                <li>10% cashback on plan renewal</li>
                            </ul>
                        </div>
                    </div>

         
                    <!-- Premium Plan Card -->
                    <div class="plan-card premium-plan" runat="server">
                        <i class="fas fa-star"></i>
                        <div class="plan-name">Premium Plan</div>
                        <div class="plan-id">Plan ID: 3</div>
                        <div class="plan-details">Best for heavy users</div>
                        <div class="plan-price">Price: $200/month</div>

                        <!-- Plan Offerings -->
                        <div class="plan-offerings">
                            <h4>Plan Includes:</h4>
                            <ul>
                                <li><strong>SMS:</strong> 1000/month</li>
                                <li><strong>Minutes:</strong> 2000/month</li>
                                <li><strong>Data:</strong> 10GB/month</li>
                            </ul>
                        </div>

                        <!-- Additional Benefits -->
                        <div class="plan-benefits">
                            <h4>Additional Benefits:</h4>
                            <ul>
                                <li>Extra 1GB data per month</li>
                                <li>Bonus 100 minutes per month</li>
                                <li>Earn 50 loyalty points per month</li>
                                <li>20% cashback on plan renewal</li>
                            </ul>
                        </div>
                    </div>

                
                    <!-- Unlimited Plan Card -->
                    <div class="plan-card unlimited-plan" runat="server">
                        <i class="fas fa-infinity"></i>
                        <div class="plan-name">Unlimited Plan</div>
                        <div class="plan-id">Plan ID: 4</div>
                        <div class="plan-details">Unlimited calls, SMS, and data</div>
                        <div class="plan-price">Price: $300/month</div>

                        <!-- Plan Offerings -->
                        <div class="plan-offerings">
                            <h4>Plan Includes:</h4>
                            <ul>
                                <li><strong>SMS:</strong> Unlimited</li>
                                <li><strong>Minutes:</strong> Unlimited</li>
                                <li><strong>Data:</strong> Unlimited</li>
                            </ul>
                        </div>

                        <!-- Additional Benefits -->
                        <div class="plan-benefits">
                            <h4>Additional Benefits:</h4>
                            <ul>
                                <li>Extra 1GB data per month</li>
                                <li>Free 100 SMS per month</li>
                                <li>Bonus 100 minutes per month</li>
                                <li>20% cashback on plan renewal</li>
                                <li>Earn 50 loyalty points per month</li>
                            </ul>
                        </div>
                    </div>
                </div>
                    
                <div class="PlanCardsContainer" id="ButtonsContainer" runat="server" style="margin-top: -20px;">
                     <!-- Basic Plan Button -->
                     <asp:Button ID="btnPlan1" runat="server" Text="Subscribe" CommandArgument="1" OnClick="PlanButton_Click" style="background: linear-gradient(135deg, #64b5f6, #1976d2);" />

                     <!-- Standard Plan Button -->
                     <asp:Button ID="btnPlan2" runat="server" Text="Subscribe" CommandArgument="2" OnClick="PlanButton_Click" style="background: linear-gradient(135deg, #fbd977, #e9ab22);" />

                     <!-- Premium Plan Button -->
                     <asp:Button ID="btnPlan3" runat="server" Text="Subscribe" CommandArgument="3" OnClick="PlanButton_Click" style="background: linear-gradient(135deg, #81c784, #388e3c);" />

                     <!-- Unlimited Plan Button -->
                     <asp:Button ID="btnPlan4" runat="server" Text="Subscribe" CommandArgument="4" OnClick="PlanButton_Click" style="background: linear-gradient(135deg, #ce85f7, #b345f0);" />
              </div>
            </div>
        </div>
    </form>
</body>
</html>
