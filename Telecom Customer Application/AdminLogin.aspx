<%@ Page Language="C#" AutoEventWireup="true" CodeFile="AdminLogin.aspx.cs" Inherits="Telecom_Customer_Application.Login" %>

<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <meta charset="UTF-8">
    <title>Admin Login</title>
    <style>
        body {
            margin: 0;
            padding: 0;
            font-family: 'Arial', sans-serif;
            background-color: #e0ecf7;
            color: #FFFFFF;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
        }
        .login-container {
            background-color: #1C2333;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.3);
            width: 100%;
            max-width: 400px;
        }
        .login-container h2 {
            text-align: center;
            margin-bottom: 20px;
        }
        .form-group {
            margin-bottom: 15px;
        }
        .form-group label {
            display: block;
            margin-bottom: 5px;
            font-size: 14px;
        }
        .form-group input {
            width: 100%;
            padding: 10px;
            border: none;
            border-radius: 5px;
            font-size: 14px;
            box-sizing: border-box;
        }
        .form-group input:focus {
            outline: none;
            box-shadow: 0 0 5px #4A90E2;
        }
        .error-message {
            color: #FF6B6B;
            font-size: 12px;
            text-align: center;
            margin-bottom: 10px;
        }
        .btn {
            display: block;
            width: 100%;
            padding: 10px;
            border: none;
            border-radius: 5px;
            background-color: #4A90E2;
            color: #FFFFFF;
            font-size: 16px;
            cursor: pointer;
            text-align: center;
        }
        .btn:hover {
            background-color: #357ABD;
        }
        .alert {
            padding: 15px;
            margin: 10px 0;
            border-radius: 5px;
            font-size: 14px;
            color: white;
            background-color: #dc3545;
            border: 1px solid #dc3545;
            position: fixed;
            top: 0;
            left: 50%;
            transform: translateX(-50%);
            z-index: 9999;
            width: 70%;
            max-width: 600px;
            text-align: center;
        }
       
        .top-left-button {
            position: absolute;
            top: 20px;
            left: 20px;
            background-color: transparent;
            border: none;
            cursor: pointer; 
            padding: 10px;
            font-size: 16px;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .top-left-button::before {
            content: "\f0a8"; /* Unicode for Font Awesome's arrow-left icon */
            font-family: "Font Awesome 5 Free";
            font-weight: 900;
            color: #1C2333;
            font-size: 45px; /* icon size */
            margin-right: 8px;
        }

        .top-left-button:hover::before {
            color: #0056b3;
        }

    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="login-container">
            <h2>Admin Login</h2>

            <div class="form-group">
                <label for="txtAdminID">Admin ID</label>
                <asp:TextBox ID="txtAdminID" runat="server" placeholder="Enter Admin ID"></asp:TextBox>
            </div>

            <div class="form-group">
                <label for="txtPassword">Password</label>
                <asp:TextBox ID="txtPassword" runat="server" TextMode="Password" placeholder="Enter Password"></asp:TextBox>
            </div>

            <asp:Label ID="lblMessage" runat="server" CssClass="error-message"></asp:Label>

            <asp:Button ID="btnLogin" runat="server" Text="Login" CssClass="btn" OnClick="btnLogin_Click" />

            <button id="backButton" runat="server" onserverclick="BackButton_Click" class="top-left-button"/>

        </div>
    </form>
</body>
</html>