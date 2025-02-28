<%@ Page Language="C#" AutoEventWireup="true" CodeFile="VouchersPage.aspx.cs" Inherits="Telecom_Customer_Application.CustomerDashboard.VouchersPage" %>
<%@ Register Src="~/Controls/CustomerSidebar.ascx" TagName="Sidebar" TagPrefix="uc" %>

<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" rel="stylesheet">
    <meta charset="UTF-8">
    <title>Vouchers Page</title>
</head>
<body>
    <form id="form1" runat="server">
        <div class="container" runat="server">
            <uc:Sidebar runat="server" />

        </div>
    </form>
</body>
</html>
