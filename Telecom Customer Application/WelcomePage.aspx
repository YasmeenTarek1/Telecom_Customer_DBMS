<%@ Page Language="C#" AutoEventWireup="true" CodeFile="WelcomePage.aspx.cs" Inherits="Telecom_Customer_Application.WelcomePage" %>

<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <meta charset="UTF-8">
    <title>Home Page</title>
    <style>
        body {
            margin: 0;
            padding: 0;
            font-family: 'Arial', sans-serif;
            background-color: #F5F7FA; /* Light background */
            color: #121212;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
        }
        .button-container {
            text-align: center;
            background-color: #FFFFFF;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
        }
        .button-container h1 {
            margin-bottom: 20px;
            color: #4A90E2;
        }
        .btn {
            display: inline-block;
            margin: 10px;
            padding: 10px 20px;
            border: none;
            border-radius: 5px;
            background-color: #4A90E2;
            color: #FFFFFF;
            font-size: 16px;
            cursor: pointer;
            text-align: center;
            text-decoration: none;
        }
        .btn:hover {
            background-color: #357ABD;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="button-container">
            <h1>Welcome</h1>
            <asp:Button ID="btnAdmin" runat="server" Text="Admin" CssClass="btn" OnClick="btnAdmin_Click" />
            <asp:Button ID="btnCustomer" runat="server" Text="Customer" CssClass="btn" OnClick="btnCustomer_Click" />
        </div>
    </form>
</body>
</html>
