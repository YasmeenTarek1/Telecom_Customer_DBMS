<%@ Page Language="C#" AutoEventWireup="true" CodeFile="WalletsPage.aspx.cs" Inherits="Telecom_Customer_Application.AdminDashboard.WalletsPage" %>
<%@ Register Src="~/Controls/AdminSidebar.ascx" TagName="Sidebar" TagPrefix="uc" %>

<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" rel="stylesheet">
    <meta charset="UTF-8">
    <title>Admin Dashboard</title>
    <script src="../Scripts/Dashboards.js"></script> 
    <link href="../Styles/Dashboards.css" rel="stylesheet"/>
</head>
<body>
    <form id="form1" runat="server">
        <div class="container" runat="server">
            <uc:Sidebar runat="server" />

            <div id="sharedContent" class="tab-content active-tab">
                <h3 id="TabHeading" class="tab-heading">Wallets</h3>

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
