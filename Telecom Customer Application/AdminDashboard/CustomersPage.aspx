<%@ Page Language="C#" AutoEventWireup="true" CodeFile="CustomersPage.aspx.cs" Inherits="Telecom_Customer_Application.AdminDashboard.CustomersPage" %>
<%@ Register Src="../Controls/Sidebar.ascx" TagName="Sidebar" TagPrefix="uc" %>

<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" rel="stylesheet">
    <meta charset="UTF-8">
    <title>Admin Dashboard</title>
    <script src="../Scripts/AdminDashboard.js"></script> 
    <link href="../Styles/AdminDashboard.css" rel="stylesheet"/>
</head>
<body>
    <form id="form1" runat="server">
        <div class="container" runat="server">
            <uc:Sidebar runat="server" />

            <div id="sharedContent" class="tab-content active-tab">

                <h3 id="TabHeading" class="tab-heading">Dashboard</h3>

                <div class="cardBox">
                    <div class="card">
                        <div>
                            <div class="numbers" id="customerCount" runat="server">0</div>
                            <div class="cardName">Customers</div>
                        </div>
                        <div class="iconBx">
                            <i class="fa-solid fa-user sidebar-icon"></i>
                        </div>
                    </div>

                    <div class="card">
                        <div>
                            <div class="numbers" id="paymentCount" runat="server">0</div>
                            <div class="cardName">Payments</div>
                        </div>
                        <div class="iconBx">
                            <i class="fa-solid fa-coins sidebar-icon"></i>
                        </div>
                    </div>

                    <div class="card">
                        <div>
                            <div class="numbers" id="transferCount" runat="server">0</div>
                            <div class="cardName">Transactions</div>
                        </div>
                        <div class="iconBx">
                            <i class="fa-solid fa-arrow-right-arrow-left sidebar-icon"></i>
                        </div>
                    </div>

                    <div class="card">
                        <div>
                            <div class="numbers" id="servicePlanCount" runat="server">0</div>
                            <div class="cardName">Plans</div>
                        </div>
                        <div class="iconBx">
                            <i class="fa-solid fa-globe sidebar-icon"></i>
                        </div>
                    </div>
                </div>
            </div>

            <div class="table-responsive">
                <table>
                    <tbody id="TableBody" runat="server"></tbody>
                </table>
            </div>
        </div>
    </form>
</body>
</html>
