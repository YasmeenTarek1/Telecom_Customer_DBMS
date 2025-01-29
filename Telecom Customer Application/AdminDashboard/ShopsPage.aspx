<%@ Page Language="C#" AutoEventWireup="true" CodeFile="ShopsPage.aspx.cs" Inherits="Telecom_Customer_Application.AdminDashboard.ShopsPage" %>
<%@ Register Src="~/Controls/Sidebar.ascx" TagName="Sidebar" TagPrefix="uc" %>

<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" rel="stylesheet">
    <meta charset="UTF-8">
    <title>Shops Page</title>
    <link href="../Styles/AdminDashboard.css" rel="stylesheet"/>
    <script src="../Scripts/AdminDashboard.js"></script> 
</head>
<body>
    <form id="form1" runat="server">
        <div class="container" runat="server">
            <uc:Sidebar runat="server" />
            <div id="sharedContent" class="tab-content">
                <h3 id="TabHeading" class="tab-heading" runat="server"></h3>

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
