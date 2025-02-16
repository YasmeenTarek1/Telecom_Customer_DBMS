<%@ Control Language="C#" AutoEventWireup="true" CodeFile="AdminSidebar.ascx.cs" Inherits="Controls.AdminSidebar" %>
 <script src="../Scripts/Dashboards.js"></script> 
 <link href="../Styles/Dashboards.css" rel="stylesheet"/>

 <!-- Sidebar -->
<div class="sidebar">
    <div class="sidebar-header">
        <img src="<%= ResolveUrl("~/TeleSphere.png") %>" alt="Header Image" class="sidebar-header-img">
        <h4>TeleSphere</h4>
    </div>

    <!-- Navigation Links -->
    <a href="~/AdminDashboard/CustomersPage.aspx" id="customersTab" runat="server">
        <i class="fa-solid fa-user sidebar-icon"></i>Customers
    </a>
    
    <a href="~/AdminDashboard/PlansPage.aspx" id="PlanInfoTab" runat="server">
       <i class="fa-solid fa-globe sidebar-icon"></i>Plans
    </a>

    <a href="~/AdminDashboard/BenefitsPage.aspx" id="benefitsTab" runat="server">
        <i class="fa-solid fa-gift sidebar-icon"></i>Benefits
    </a>

    <a href="~/AdminDashboard/SubscriptionsPage.aspx" id="subscriptionsTab" runat="server">
        <i class="fa-solid fa-sim-card sidebar-icon"></i>Subscriptions
    </a>

    <a href="~/AdminDashboard/PaymentsPage.aspx" id="paymentsTab" runat="server">
        <i class="fa-solid fa-coins sidebar-icon"></i>Payments
    </a>

    <a href="~/AdminDashboard/WalletsPage.aspx" id="walletsTab" runat="server">
        <i class="fa-solid fa-wallet sidebar-icon"></i>Wallets
    </a>

    <a href="~/AdminDashboard/TransactionsPage.aspx" id="transactionsTab" runat="server">
        <i class="fa-solid fa-arrow-right-arrow-left sidebar-icon"></i>Transactions
    </a>

    <a href="~/AdminDashboard/AccountUsagePage.aspx" id="accountUsageTab" runat="server">
        <i class="fa-solid fa-chart-column sidebar-icon"></i>Account Usage
    </a>

    <asp:HiddenField ID="hdnStoresDropdownState" runat="server" />
    <div>
        <a href="javascript:void(0);" id="shopsTab" runat="server" onclick="toggleDropdown(this, '<%= hdnStoresDropdownState.ClientID %>')">
            <i class="fa-solid fa-store sidebar-icon"></i>Shops<i class="fa-solid fa-chevron-down sidebar-icon2"></i>
        </a>
        <div class="dropdown-content">
            <a href="~/AdminDashboard/ShopsPage.aspx?subtab=physical" id="physicalShopsTab" runat="server">Physical Shops</a>
            <a href="~/AdminDashboard/ShopsPage.aspx?subtab=eshop" id="E_shopsTab" runat="server">E-Shops</a>
        </div>
    </div>

    <a href="~/AdminDashboard/TicketsPage.aspx" id="ticketsTab" runat="server">
        <i class="fa-solid fa-ticket sidebar-icon"></i>Tickets
    </a>

</div>
