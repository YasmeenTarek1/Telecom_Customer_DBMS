<%@ Page Language="C#" AutoEventWireup="true" CodeFile="WelcomePage.aspx.cs" Inherits="Telecom_Customer_Application.WelcomePage" %>

<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <meta charset="UTF-8">
    <title>Home Page</title>
    <script src="../Scripts/Logins.js"></script> 
    <link href="../Styles/Logins.css" rel="stylesheet"/>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@600&display=swap" rel="stylesheet">
   <style>
    body {
        margin: 0;
        padding: 0;
        width: 100%;
        overflow-x: hidden;
        font-family: 'Arial', sans-serif;
        min-height: 100vh;
        display: flex;
        flex-direction: column;
        justify-content: center;
        align-items: center;
        background: linear-gradient(
                135deg,
                rgba(229, 232, 239, 1), /* Light Gray */
                rgba(3, 24, 76, 0.5) /* New Blue */
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

    .button {
        display: inline-block;
        padding: 10px 20px;
        border-radius: 10px;
        background-color: #03184c;
        color: #FFFFFF;
        font-size: 16px;
        font-weight: bold;
        cursor: pointer;
        text-align: center;
        text-decoration: none;
        transition: transform 0.3s ease, box-shadow 0.3s ease;
    }

    .button:hover {
        background-color: #002366; 
        transform: translateY(-5px);
        box-shadow: 0 6px 15px rgba(7, 156, 255, 0.5);
    }

</style>

</head>
<body>
    <form id="form1" runat="server">
        <div class="header">
            <img src="TeleSphere.png" alt="TeleSphere Logo" />
            <h2>TeleSphere</h2>
            <div class="nav">
                <a href="#Footer">About</a>
                <a href="#Footer">Services</a>
                <a href="#Footer">Contact</a> 
            </div>
        </div>
        <div class="hero-section">
            <h1 style="margin-bottom: 50px;">Welcome to TeleSphere</h1>
            <p style="margin-bottom: 120px;">Fast, Reliable, Unlimited Connections</p>
            <h2>Who Are You?</h2>
            <div class="icon-container">
                <div class="icon-item">
                    <img src="adminNew.png" alt="Admin Icon">
                    <p></p>
                    <asp:Button ID="btnAdmin" runat="server" Text="Admin" CssClass="button" OnClick="btnAdmin_Click" />
                </div>
                <div class="icon-item">
                    <img src="customer.png" alt="Customer Icon">
                    <p></p>
                    <asp:Button ID="btnCustomer" runat="server" Text="Customer" CssClass="button" OnClick="btnCustomer_Click" />
                </div>
            </div>
        </div>

        <!-- Contact Section -->
        <footer id="Footer" class="footer">
            <div class="footer-section">
                <h2>About Us</h2>
                <p>TeleSphere is a leading telecom provider, ensuring seamless connectivity for businesses and individuals worldwide.</p>
                <br />
                <h2>Our Services</h2>
                <p>We offer ultra-fast internet and seamless digital communication to and keep you connected anytime, anywhere.</p>
                <br />
                <h2>Contact Us</h2>
                <p>Email: support@telesphere.com</p>
                <p>Phone: +1 (123) 456-7890</p>
                <p>Address: 123 Telecom Street, City, Country</p>
            </div>
        </footer>

    </form>
</body>
</html>