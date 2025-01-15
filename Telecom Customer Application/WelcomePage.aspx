<%@ Page Language="C#" AutoEventWireup="true" CodeFile="WelcomePage.aspx.cs" Inherits="Telecom_Customer_Application.WelcomePage" %>

<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <meta charset="UTF-8">
    <title>Home Page</title>
    <!-- Import Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Quicksand:wght@700&display=swap" rel="stylesheet">
    <style>
        body {
            margin: 0;
            padding: 0;
            font-family: 'Arial', sans-serif;
            background: linear-gradient(to bottom right, rgba(7, 156, 255, 0.2), rgba(7, 156, 255, 0.05)), #F5F7FA;
            color: rgba(0, 0, 0, 0); /* Transparent black */
            height: 100vh;
            overflow: hidden;
            display: flex;
            justify-content: flex-start;
            align-items: center;
        }
        .left-section {
            position: relative;
            width: 750px; 
            height: auto;
            margin-left: 50px; 
        }
        .left-section img {
            width: 100%;
            height: auto;
            transition: transform 0.5s ease, filter 0.5s ease; 
        }
        .left-section img:hover {
            transform: scale(1.05) rotate(2deg); 
            filter: brightness(1.09); 
        }
        .left-section h2 {
            position: absolute;
            bottom: 30px; 
            left: 50%;
            transform: translateX(-50%);
            color: rgba(7, 156, 255, 1); /* Blue */
            font-size: 120px; 
            z-index: 2;
            font-weight: bold;
            text-align: center;
            text-shadow: 2px 2px 5px rgba(7, 156, 255, 0.3); 
            letter-spacing: 2px; 
            font-family: 'Quicksand', sans-serif;
        }
        .button-container {
            position: absolute;
            top: 50%;
            left: 65%;
            transform: translate(-50%, -50%);
            background-color: rgba(255, 255, 255, 0.5); /* Semi-transparent white */
            padding: 60px 40px; /* Taller container */
            border-radius: 15px;
            box-shadow: 0 4px 10px rgba(7, 156, 255, 0.2); /* Blue shadow for subtle depth */
            width: 400px;
            text-align: center;
        }
        .button-container h1 {
            margin-bottom: 10px;
            color: rgba(7, 156, 255, 1); /* Blue */
            font-size: 28px;
        }
        .button-container .sub-heading {
            color: rgba(7, 156, 255, 0.8); /* Lighter blue */
            font-size: 18px; /* Smaller text */
            margin-bottom: 20px;
        }
        .btn {
            display: inline-block;
            margin: 15px;
            padding: 15px 30px;
            border: 2px solid rgba(7, 156, 255, 1); /* Blue border */
            border-radius: 5px;
            background-color: transparent;
            color: rgba(7, 156, 255, 1); /* Blue text */
            font-size: 18px;
            cursor: pointer;
            text-align: center;
            text-decoration: none;
            transition: background-color 0.3s ease, color 0.3s ease;
        }
        .btn:hover {
            background-color: rgba(7, 156, 255, 1); /* Blue background */
            color: #FFFFFF; /* White text */
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="left-section">
            <img src="TeleSphere.png" alt="TeleSphere Logo" />
            <h2>TeleSphere</h2>
        </div>
        <div class="button-container">
            <h1>Welcome To TeleSphere</h1>
            <p class="sub-heading">Fast, Reliable, Unlimited Connections</p>
            <asp:Button ID="btnAdmin" runat="server" Text="Admin" CssClass="btn" OnClick="btnAdmin_Click" />
            <asp:Button ID="btnCustomer" runat="server" Text="Customer" CssClass="btn" OnClick="btnCustomer_Click" />
        </div>
    </form>
</body>
</html>
