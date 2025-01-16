<%@ Page Language="C#" AutoEventWireup="true" CodeFile="AdminLogin.aspx.cs" Inherits="Telecom_Customer_Application.Login" %>

<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
     <!-- Import Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@600&display=swap" rel="stylesheet">
    <meta charset="UTF-8">
    <title>Admin Login</title>
    <style>
       body {
             margin: 0;
             padding: 0;
             font-family: 'Arial', sans-serif;
             height: 100vh;
             overflow: hidden;
             display: flex;
             justify-content: center;
             align-items: center;
             background: linear-gradient(
                     135deg,
                     rgba(229, 232, 239, 1), /* Light Gray */
                     rgba(92, 190, 255, 0.5) /* Light Blue */
                 ),
                 radial-gradient(
                     circle at 20% 80%,
                     rgba(255, 190, 0, 0.7), /* Yellow */
                     transparent 60%
                 ),
                 radial-gradient(
                     circle at 70% 20%,
                     rgba(76, 198, 110, 0.6), /* Green */
                     transparent 70%
                 ),
                 radial-gradient(
                     circle at 50% 50%,
                     rgba(255, 216, 12, 0.6), /* Bright Yellow */
                     transparent 80%
                 ),
                 radial-gradient(
                     circle at 90% 90%,
                     rgba(178, 68, 241, 0.5), /* Purple */
                     transparent 80%
                 );
             background-blend-mode: screen, overlay, multiply;
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
          .header {
              position: fixed;
              left:0;
              top: 0;
              width: 100%;
              background-color: rgba(0, 123, 255, 0.9); /* New Header Color */
              display: flex;
              align-items: center;
              padding: 10px 20px;
              box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
              z-index: 1000;
          }

          .header img {
              height: 50px;
              margin-right: 10px;
          }

          .header h2 {
              font-size: 24px;
              color: #ffffff; /* White */
              margin: 0;
              font-family: 'Poppins', sans-serif;
          }

          .nav {
              margin-left: 1150px; /* Push navigation to the left */
              display: flex;
              gap: 20px;
          }

          .nav a {
              text-decoration: none;
              color: #ffffff; /* White */
              font-size: 18px;
              font-family: 'Arial', sans-serif;
              transition: color 0.3s;
          }

          .nav a:hover {
              color: rgba(255, 255, 0, 0.8); /* Yellow hover effect */
          }
        .container {
            display: flex;
            background-color:  rgba(255, 255, 255, 0.3);
            border-radius: 15px;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.4);
            overflow: hidden;
            width: 1300px;
            height: 650px;
            margin-top:20px;
        }
       .image-section {
              margin-top: 0px;
              width: 975px;
              height: 650px;
              align-content:center;
              background: 
                  linear-gradient(
                      rgba(7, 156, 255, 0.8), /* Semi-transparent blue overlay */
                      rgba(0, 123, 255, 0.3)
                  );
              background-size: cover;
              background-blend-mode: overlay; /* Blends the overlay with the image */
              filter: brightness(0,9) saturate(1); /* Adjust brightness and saturation for a closer match */
       }

        .form-section {
            flex: 1;
            padding: 50px;
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
            font-family: 'Poppins', sans-serif; /* Professional and Rounded Font */
        }
        .form-section h2 {
            margin-bottom: 30px;
            color: rgba(7, 156, 255, 1);
            font-size: 32px;
            margin-right:30px;
        }
        .form-group {
            width: 350px;
            margin-bottom: 20px;
            margin-right:30px;
        }
        .form-group label {
            display: block;
            margin-bottom: 5px;
            font-size: 16px;
            color: #333;
        }
        .form-group input {
            width: 350px;
            padding: 12px;
            border: 1px solid #ccc;
            border-radius: 5px;
            font-size: 16px;
            box-sizing: border-box;
        }
        .form-group input:focus {
            outline: none;
            border-color: #4A90E2;
            box-shadow: 0 0 5px #4A90E2;

        }
        .error-message {
            color: #FF6B6B;
            font-size: 14px;
            text-align: center;
            margin-bottom: 10px;
        }
        .btn {
            margin-right:30px;
            display: block;
            width: 350px;
            padding: 12px;
            border: none;
            border-radius: 5px;
            background-color: rgba(7, 156, 255, 1);
            color: #FFFFFF;
            font-size: 18px;
            cursor: pointer;
            text-align: center;
        }
        .btn:hover {
            background-color: #357ABD;
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
            color: rgba(7, 156, 255, 1);
            font-size: 20px; /* icon size */
            margin-right: 8px;
        }

        .top-left-button:hover::before {
            color: #0056b3;
        }

    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="header">
            <img src="TeleSphere.png" alt="TeleSphere Logo" />
            <h2>TeleSphere</h2>
            <div class="nav">
                <a href="#">Home</a>
                <a href="#">About</a>
                <a href="#">Services</a>
                <a href="#">Contact</a>
            </div>
        </div>
        <div class="container">
            <div class="image-section">
                 <img src="adminLogin.png" alt="admin Login picture" style="margin-left:30px;" />
            </div>
            <div class="form-section">
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

                <button id="backButton" runat="server" onserverclick="BackButton_Click" class="top-left-button" />
            </div>
        </div>
    </form>
</body>
</html>
