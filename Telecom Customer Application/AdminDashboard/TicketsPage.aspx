<%@ Page Language="C#" AutoEventWireup="true" CodeFile="TicketsPage.aspx.cs" Inherits="Telecom_Customer_Application.AdminDashboard.TicketsPage" %>
<%@ Register Src="~/Controls/Sidebar.ascx" TagName="Sidebar" TagPrefix="uc" %>

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
            <div id="sharedContent" class="tab-content">
                <h3 id="TabHeading" class="tab-heading">Tickets</h3>

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
