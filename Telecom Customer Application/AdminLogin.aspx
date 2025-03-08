<%@ Page Language="C#" AutoEventWireup="true" CodeFile="AdminLogin.aspx.cs" Inherits="Telecom_Customer_Application.Login" %>

<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
     <!-- Import Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@600&display=swap" rel="stylesheet">
    <meta charset="UTF-8">
    <script src="../Scripts/Logins.js"></script> 
    <link href="../Styles/Logins.css" rel="stylesheet"/>
    <title>Admin Login</title>
</head>
<body>
    <form id="form1" runat="server">
    <div class="header">
        <img src="TeleSphere.png" alt="TeleSphere Logo" />
        <h2>TeleSphere</h2>
        <div class="nav">
            <a href="WelcomePage.aspx" runat="server">Home</a>
            <a href="#Footer">About</a>
            <a href="#Footer">Services</a>
            <a href="#Footer">Contact</a>
        </div>
    </div>
    <div class="container">
        <div class="image-section">
            <img src="adminLogin.png" alt="admin Login picture" style="margin-left: 30px;" />
        </div>
        <div class="form-section">
            <h2>Admin Login</h2>
            <div class="form-group">
                <label for="txtAdminID">Admin ID</label>
                <asp:TextBox ID="txtAdminID" runat="server" placeholder="Enter Admin ID"></asp:TextBox>
            </div>
            <div class="form-group">
                <label for="txtPassword">Password</label>
                <div style="position: relative;">
                    <asp:TextBox ID="txtPassword" runat="server" TextMode="Password" placeholder="Enter Password"></asp:TextBox>
                    <i class="fas fa-eye" id="togglePassword" style="position: absolute; right: 10px; top: 50%; transform: translateY(-50%); cursor: pointer; color: #ccc;"></i>
                </div>
            </div>
            <asp:Label ID="lblMessage" runat="server" CssClass="error-message"></asp:Label>
            <asp:Button ID="btnLogin" runat="server" Text="Login" CssClass="btn" OnClick="btnLogin_Click" />
        </div>
    </div>
    <footer id="Footer" class="footer">
        <div class="footer-section">
            <h2>About Us</h2>
            <p>TeleSphere is a leading telecom provider, ensuring seamless connectivity for businesses and individuals worldwide.</p>
            <br />
            <h2>Our Services</h2>
            <p>We offer ultra-fast internet and seamless digital communication to keep you connected anytime, anywhere.</p>
            <br />
            <h2>Contact Us</h2>
            <p>Email: support@telesphere.com</p>
            <p>Phone: +1 (123) 456-7890</p>
            <p>Address: 123 Telecom Street, City, Country</p>
        </div>
    </footer>
</form>

        <script>

            document.addEventListener("DOMContentLoaded", function () {
                const footer = document.getElementById("Footer");
                const contactLink = document.querySelector(".nav a[href='#Footer']");

                // Function to check if the footer is in the viewport
                function isFooterInViewport() {
                    const rect = footer.getBoundingClientRect();
                    return (
                        rect.top <= window.innerHeight && rect.bottom >= 0
                    );
                }

                // Function to show the footer
                function showFooter() {
                    footer.classList.add("visible");
                }

                // Show the footer when it comes into the viewport while scrolling
                document.addEventListener("scroll", function () {
                    if (isFooterInViewport()) {
                        showFooter();
                    }
                });

                // Scroll to the footer and show it when the "Contact" link is clicked
                contactLink.addEventListener("click", function (e) {
                    e.preventDefault(); // Prevent default anchor behavior
                    footer.scrollIntoView({ behavior: "smooth" }); // Smooth scroll to footer
                    showFooter(); // Make the footer visible
                });
            });
        </script>
</body>
</html>
