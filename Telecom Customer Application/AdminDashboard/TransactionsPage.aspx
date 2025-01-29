<%@ Page Language="C#" AutoEventWireup="true" CodeFile="TransactionsPage.aspx.cs" Inherits="Telecom_Customer_Application.AdminDashboard.TransactionsPage" %>
<%@ Register Src="~/Controls/Sidebar.ascx" TagName="Sidebar" TagPrefix="uc" %>

<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" rel="stylesheet">
    <meta charset="UTF-8">
    <title>Transactions Page</title>
    <script src="../Scripts/AdminDashboard.js"></script> 
    <link href="../Styles/AdminDashboard.css" rel="stylesheet"/>
</head>
<body>
    <form id="form1" runat="server">
        <div class="container" runat="server">
            <uc:Sidebar runat="server" />

            <div id="sharedContent" class="tab-content">

                <h3 id="TabHeading" class="tab-heading" runat="server">Average Transaction Amount</h3>

                   <div id="DateContainer1" runat="server" class="date-picker-container" style="display: none;">
                        <label id="DateLabel1" runat="server" for="DateInput1" class="date-picker-label">Start Date:</label>
                        <asp:TextBox ID="DateInput1" runat="server" CssClass="date-picker" TextMode="Date"></asp:TextBox>
                    </div>
                   <div id="DateContainer2" runat="server" class="date-picker-container" style="display: none;">
                       <label id="DateLabel2" runat="server" for="DateInput2" class="date-picker-label">End Date:</label>
                       <asp:TextBox ID="DateInput2" runat="server" CssClass="date-picker" TextMode="Date"></asp:TextBox>
                   </div>

                   <div id="TextBoxContainer2" runat="server" class="input-container" style="display: none;">
                       <label for="MobileEditText" class="input-label">Mobile Number:</label>
                       <asp:TextBox ID="MobileEditText" runat="server" CssClass="styled-input" placeholder="Enter Mobile Number"></asp:TextBox>
                   </div>

                   <div id="TextBoxContainer3" runat="server" class="input-container" style="display: none;">
                       <label for="WalletEditText" class="input-label">Wallet ID:</label>
                       <asp:TextBox ID="WalletEditText" runat="server" CssClass="styled-input" placeholder="Enter Wallet ID"></asp:TextBox>
                   </div>

                   <div class="button-container">
                       <asp:Button ID="SearchButton" runat="server" CssClass="styled-button" Text="Search" OnClick="SearchButton_Click" />
                   </div>
                 
                <div class="output-container">
                     <asp:Label ID="LabelOut" runat="server" CssClass="output-label" Text="" style="display: none;"></asp:Label>
                 </div>

                <div class="table-responsive" >
                    <table>
                        <tbody id="TableBody" runat="server" style="display: none;"></tbody>
                    </table>
                </div>
            </div>
        </div>
    </form>
</body>
</html>
