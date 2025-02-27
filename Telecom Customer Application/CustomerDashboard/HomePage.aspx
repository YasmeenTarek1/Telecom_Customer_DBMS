<%@ Page Language="C#" AutoEventWireup="true" CodeFile="HomePage.aspx.cs" Inherits="Telecom_Customer_Application.CustomerDashboard.HomePage" %>
<%@ Register Src="~/Controls/CustomerSidebar.ascx" TagName="Sidebar" TagPrefix="uc" %>

<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" rel="stylesheet">
    <meta charset="UTF-8">
    <title>Home</title>
</head>
<body>
    <form id="form1" runat="server">
        <uc:Sidebar runat="server"/>
        <h3 class="tab-heading" style="margin: 40px auto 30px 940px; font-size: 30px;">Your Subscribed Plans</h3>

        <div id="PlansContainer" runat="server"></div>
    </form>
</body>
</html>