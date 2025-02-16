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
        <h3 class="tab-heading" style="margin: 40px auto 170px 940px; font-size: 30px;">Your Subscribed Plans</h3>
        <div id="PlanCardContainer" runat="server"></div>

        <div class="mainContainer">
            <h3 class="tab-heading" style="margin: 0px auto 40px auto; font-size: 26px;">Plan Usage</h3>
            <div class="UsagesContainer" id="PlanContainer" runat="server">
                <!-- Plan Usage Elements will be dynamically inserted here -->
            </div>
        </div>
        
        <div class="mainContainer" id="benefitsContainer2">
            <h3 class="tab-heading" style="margin: 0px auto 40px auto; font-size: 26px;">Benefit Usage</h3>
            <div class="UsagesContainer" id="benefitsContainer" runat="server">
                <!-- Benefit Usage Elements will be dynamically inserted here -->
            </div>
        </div>
    </form>
</body>
</html>