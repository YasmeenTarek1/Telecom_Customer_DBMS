<%@ Control Language="C#" AutoEventWireup="true" CodeFile="Sidebar.ascx.cs" Inherits="Controls.Sidebar" %>
 <script src="../Scripts/AdminDashboard.js"></script> 
 <link href="../Styles/AdminDashboard.css" rel="stylesheet"/>

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

    <a href="~/AdminDashboard/SubscriptionsPage.aspx" id="subscriptionsTab" runat="server">
        <i class="fa-solid fa-sim-card sidebar-icon"></i>Subscriptions
    </a>


    <asp:HiddenField ID="hdnStoresDropdownState" runat="server" />
    <asp:HiddenField ID="hdnPlansDropdownState" runat="server" />
    <asp:HiddenField ID="hdnTransactionDropdownState" runat="server" />

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

    <div>
        <a href="javascript:void(0);" id="plansTab" runat="server" onclick="toggleDropdown(this, '<%= hdnPlansDropdownState.ClientID %>')">
            <i class="fa-solid fa-globe sidebar-icon"></i>Plans<i class="fa-solid fa-chevron-down sidebar-icon2"></i>
        </a>
        <div class="dropdown-content">
            <a href="~/AdminDashboard/PlansPage.aspx?subtab=info" id="PlanInfoTab" runat="server">Plans Information</a>
            <a href="~/AdminDashboard/PlansPage.aspx?subtab=sinceDate" id="PlanSinceDateTab" runat="server">Subscribers Since a Date</a>
        </div>
    </div>

    <a href="~/AdminDashboard/BenefitsPage.aspx" id="benefitsTab" runat="server">
        <i class="fa-solid fa-gift sidebar-icon"></i>Benefits
    </a>

    <a href="~/AdminDashboard/AccountUsagePage.aspx" id="accountUsageTab" runat="server">
        <i class="fa-solid fa-chart-column sidebar-icon"></i>Account Usage
    </a>

    <a href="~/AdminDashboard/WalletsPage.aspx" id="walletsTab" runat="server">
        <i class="fa-solid fa-wallet sidebar-icon"></i>Wallets
    </a>

    <a href="~/AdminDashboard/PaymentsPage.aspx" id="paymentsTab" runat="server">
        <i class="fa-solid fa-coins sidebar-icon"></i>Payments
    </a>

    <div>
        <a href="javascript:void(0);" id="transactionsTab" runat="server" onclick="toggleDropdown(this, '<%= hdnTransactionDropdownState.ClientID %>')">
            <i class="fa-solid fa-arrow-right-arrow-left sidebar-icon"></i>Transaction<i class="fa-solid fa-chevron-down sidebar-icon2"></i>
        </a>
        <div class="dropdown-content">
            <a href="~/AdminDashboard/TransactionsPage.aspx?subtab=details" id="A1" runat="server">Transaction Details</a>
            <a href="~/AdminDashboard/TransactionsPage.aspx?subtab=average" id="AverageTransactionsTab" runat="server">Average Transaction Amount</a>
        </div>
    </div>

</div>
