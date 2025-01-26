<%@ Page Language="C#" AutoEventWireup="true" CodeFile="AccountUsagePage.aspx.cs" Inherits="Telecom_Customer_Application.AdminDashboard.AccountUsagePage" %>
<%@ Register Src="~/Controls/Sidebar.ascx" TagName="Sidebar" TagPrefix="uc" %>

<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" rel="stylesheet">
    <meta charset="UTF-8">
    <title>Account Usage Page</title>
    <script src="../Scripts/AdminDashboard.js"></script> 
    <link href="../Styles/AdminDashboard.css" rel="stylesheet"/>
</head>
<body>
    <form id="form1" runat="server">
        <div class="container" runat="server">
            <uc:Sidebar runat="server" />

            <div id="sharedContent" class="tab-content active-tab">

                 <h3 id="TabHeading" class="tab-heading">Account Usage</h3>
                 <div id="DateContainer" runat="server" class="date-picker-container">
                      <label id="DateLabel" runat="server" for="DateInput" class="date-picker-label">Start Date:</label>
                      <asp:TextBox ID="DateInput" runat="server" CssClass="date-picker" TextMode="Date"></asp:TextBox>
                  </div>

                 <div id="TextBoxContainer" runat="server" class="input-container">
                    <label for="MobileEditText" class="input-label">Mobile Number:</label>
                    <asp:TextBox ID="MobileEditText" runat="server" CssClass="styled-input" placeholder="Enter Mobile Number"></asp:TextBox>
                </div>

                 <div class="button-container">
                     <asp:Button ID="SearchButton" runat="server" CssClass="styled-button" Text="Search" OnClick="SearchButton_Click" />
                 </div>
                 <!-- Data Tables -->
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
