<%@ Page Language="C#" AutoEventWireup="true" CodeFile="WelcomePage.aspx.cs" Inherits="Telecom_Customer_Application.WelcomePage" %>

<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <meta charset="UTF-8">
    <title>Home Page</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@600&display=swap" rel="stylesheet">
    <style>
        body {
            margin: 0; /* Remove default margin */
            padding: 0; /* Remove default padding */
            width: 100%; /* Full width */
            overflow-x: hidden; 
            font-family: 'Arial', sans-serif;
            min-height: 100vh; /* Full viewport height */
            display: flex;
            flex-direction: column; /* Stack content vertically */
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

        .header {
            position: fixed;
            left: 0;
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

        .hero-section {
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
            text-align: center;
            width: 100%;
            min-height: 100vh; /* Full viewport height */
            color: rgba(7, 156, 255, 1); /* Blue */
            padding: 40px;
            box-sizing: border-box;
        }

        .hero-section h1,
        .hero-section p,
        .hero-section h2 {
            margin: 0;
        }

        .hero-section h1 {
            font-size: 50px;
            margin-bottom: 20px;
            font-family: 'Poppins', sans-serif;
            font-weight: bold;
            text-shadow: 2px 2px 6px rgba(7, 156, 255, 0.3);
        }

        .hero-section p {
            font-size: 22px;
            margin-bottom: 10px;
            color: rgba(7, 156, 255, 0.8);
        }

        .hero-section h2 {
            font-size: 24px;
            margin-bottom: 40px;
            color: rgba(7, 156, 255, 0.6);
            font-family: 'Poppins', sans-serif;
        }

        .icon-container {
            display: flex;
            justify-content: center;
            align-items: center;
            gap: 160px;
            margin-top: 20px;
        }

        .icon-item {
            text-align: center;
        }

        .icon-item img {
            width: 175px;
            height: 175px;
            margin-bottom: 10px;
        }

        .btn {
            display: inline-block;
            padding: 10px 20px;
            border: 2px solid rgba(7, 156, 255, 1);
            border-radius: 10px;
            background-color: rgba(7, 156, 255, 1);
            color: #FFFFFF;
            font-size: 16px;
            font-weight: bold;
            cursor: pointer;
            text-align: center;
            text-decoration: none;
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }

        .btn:hover {
            transform: translateY(-5px);
            box-shadow: 0 6px 15px rgba(7, 156, 255, 0.5);
        }

       
        html {
            scroll-behavior: smooth;
        }

        footer {
            position: relative; 
            width: 100%;
            max-width: 100%; 
            background-color:rgb(9, 83, 132,1); 
            color: #f5f5f5; 
            padding: 40px 20px;
            text-align: left;
            z-index: 1000; 
            opacity: 0; 
            transform: translateY(20px); 
            transition: opacity 0.5s ease, transform 0.5s ease; 
        }

        footer.visible {
            opacity: 1; /* Fully visible */
            transform: translateY(0); /* Move to its original position */
        }
        form {
         width: 100%; /* Full width */
         overflow-x: hidden; 
         overflow-y:hidden;

         }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="header">
            <img src="TeleSphere.png" alt="TeleSphere Logo" />
            <h2>TeleSphere</h2>
            <div class="nav">
                <a href="#">About</a>
                <a href="#">Services</a>
                <a href="#contactFooter">Contact</a> <!-- Scroll to footer -->
            </div>
        </div>
        <div class="hero-section">
            <h1 style="margin-bottom: 50px;">Welcome to TeleSphere</h1>
            <p style="margin-bottom: 120px;">Fast, Reliable, Unlimited Connections</p>
            <h2>Who Are You?</h2>
            <div class="icon-container">
                <div class="icon-item">
                    <img src="admin.png" alt="Admin Icon">
                    <p></p>
                    <asp:Button ID="btnAdmin" runat="server" Text="Admin" CssClass="btn" OnClick="btnAdmin_Click" />
                </div>
                <div class="icon-item">
                    <img src="customer.png" alt="Customer Icon">
                    <p></p>
                    <asp:Button ID="btnCustomer" runat="server" Text="Customer" CssClass="btn" OnClick="btnCustomer_Click" />
                </div>
            </div>
        </div>
        <!-- Footer Section -->
        <footer id="contactFooter">
            <h2>Contact Us</h2>
            <p>Email: support@telesphere.com</p>
            <p>Phone: +1 (123) 456-7890</p>
            <p>Address: 123 Telecom Street, City, Country</p>
        </footer>
    </form>
    <script>
        document.addEventListener("DOMContentLoaded", function () {
            const footer = document.getElementById("contactFooter");
            const contactLink = document.querySelector(".nav a[href='#contactFooter']");

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