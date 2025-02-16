<%@ Control Language="C#" AutoEventWireup="true" CodeFile="CustomerSidebar.ascx.cs" Inherits="Controls.CustomerSidebar" %>
<script src="../Scripts/Dashboards.js"></script> 
<link href="../Styles/Dashboards.css" rel="stylesheet"/>

 <!-- Sidebar -->
<div class="sidebar">
    <div class="sidebar-header">
        <img src="<%= ResolveUrl("~/TeleSphere.png") %>" alt="Header Image" class="sidebar-header-img">
        <h4>TeleSphere</h4>
    </div>

    <!-- Navigation Links -->
    <a href="~/CustomerDashboard/HomePage.aspx" id="homeTab" runat="server">
       <i class="fa-solid fa-house"></i>&nbsp;&nbsp;Home
    </a>

    <a href="~/CustomerDashboard/PlansPage.aspx" id="plansTab" runat="server">
       <i class="fa-solid fa-globe sidebar-icon"></i>Plans
    </a>

    <a href="~/CustomerDashboard/PaymentsPage.aspx" id="paymentsTab" runat="server">
        <i class="fa-solid fa-coins sidebar-icon"></i>Payments
    </a>

    <a href="~/CustomerDashboard/WalletPage.aspx" id="walletTab" runat="server">
        <i class="fa-solid fa-wallet sidebar-icon"></i>Wallet
    </a>

    <a href="~/CustomerDashboard/TicketsPage.aspx" id="ticketsTab" runat="server">
        <i class="fa-solid fa-ticket sidebar-icon"></i>Tickets
    </a>

    <a href="~/CustomerDashboard/VouchersPage.aspx" id="vouchersTab" runat="server">
        <i class="fa-solid fa-ticket-simple sidebar-icon"></i>Vouchers
    </a>

</div>