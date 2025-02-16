<%@ Page Language="C#" AutoEventWireup="true" CodeFile="TransactionsPage.aspx.cs" Inherits="Telecom_Customer_Application.AdminDashboard.TransactionsPage" %>
<%@ Register Src="~/Controls/AdminSidebar.ascx" TagName="Sidebar" TagPrefix="uc" %>

<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" rel="stylesheet">
    <meta charset="UTF-8">
    <title>Transactions Page</title>
    <script src="../Scripts/Dashboards.js"></script> 
    <link href="../Styles/Dashboards.css" rel="stylesheet"/>
</head>
<body>
    <form id="form1" runat="server">
        <div class="container" runat="server">
            <uc:Sidebar runat="server" />

            <div id="sharedContent" class="tab-content">

                <h3 id="TabHeading" class="tab-heading" runat="server">Transactions</h3>

                <div id="FilterContainer" runat="server" class="filter-container">
                    <div id="filterOption1" runat="server">
                        <label for="WalletEditText" class="filter-label">Wallet ID:</label>
                        <asp:TextBox ID="WalletEditText" runat="server" CssClass="filter-input" placeholder="Enter Wallet ID"></asp:TextBox>
                    </div>
                    <div id="filterOption2" runat="server">
                        <label for="DateInput1" class="filter-label">Start Date:</label>
                        <asp:TextBox ID="DateInput1" runat="server" CssClass="filter-input" TextMode="Date"></asp:TextBox>
                    </div>
                    <div id="filterOption3" runat="server">
                        <label for="DateInput2" class="filter-label">End Date:</label>
                        <asp:TextBox ID="DateInput2" runat="server" CssClass="filter-input" TextMode="Date"></asp:TextBox>
                    </div>
                    <div id="filterOption4" runat="server">
                        <asp:Button ID="ApplyFilterButton" runat="server" CssClass="styled-button" Text="Apply" OnClick="ApplyFilterButton_Click" Style="font-size: 12px;" />
                    </div>
                </div>

                <div class="output-container">
                     <asp:Label ID="AverageSentLabel" runat="server" CssClass="output-label" Text="" style="display: none;"></asp:Label>
                </div>
                <div class="output-container">
                     <asp:Label ID="AverageReceivedLabel" runat="server" CssClass="output-label" Text="" style="display: none;"></asp:Label>
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
