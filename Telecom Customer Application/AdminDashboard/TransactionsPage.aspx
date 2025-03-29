<%@ Page Language="C#" AutoEventWireup="true" CodeFile="TransactionsPage.aspx.cs" Inherits="Telecom_Customer_Application.AdminDashboard.TransactionsPage" %>
<%@ Register Src="~/Controls/AdminSidebar.ascx" TagName="Sidebar" TagPrefix="uc" %>

<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" rel="stylesheet">
    <meta charset="UTF-8">
    <title>Transactions Page</title>
</head>
<body>
    <form id="form1" runat="server">
        <div class="container" runat="server">
            <uc:Sidebar runat="server" />

            <div id="sharedContent" class="tab-content">

                <h3 id="TabHeading" class="tab-heading" runat="server">Transactions</h3>

                <div id="FilterContainer" runat="server" class="filter-container">
                    <div id="filterOption1" class="filter-group" runat="server">
                        <label for="WalletEditText" class="filter-label">Wallet ID:</label>
                        <asp:TextBox ID="WalletEditText" runat="server" CssClass="filter-input" placeholder="Enter Wallet ID"></asp:TextBox>
                    </div>
                    <div id="filterOption2" class="filter-group" runat="server">
                        <label for="DateInput1" class="filter-label">Start Date:</label>
                        <asp:TextBox ID="DateInput1" runat="server" CssClass="filter-input" TextMode="Date"></asp:TextBox>
                    </div>
                    <div id="filterOption3" class="filter-group" runat="server">
                        <label for="DateInput2" class="filter-label">End Date:</label>
                        <asp:TextBox ID="DateInput2" runat="server" CssClass="filter-input" TextMode="Date"></asp:TextBox>
                    </div>
                    <div id="filterOption4" runat="server">
                        <asp:Button ID="ApplyFilterButton" runat="server" CssClass="styled-button" Text="Apply" OnClick="ApplyFilterButton_Click" Style="margin-left: 659px; margin-right: 0px;"/>
                    </div>
                </div>
   
                <div class="stat-banner" id="OutputBanner" runat="server">
                    <asp:Label ID="AverageSentLabel" runat="server" Style="display: none;"></asp:Label>
                    <asp:Label ID="AverageReceivedLabel" runat="server" Style="display: none;"></asp:Label>
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
