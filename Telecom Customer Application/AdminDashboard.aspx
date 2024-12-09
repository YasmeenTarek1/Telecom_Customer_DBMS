<%@ Page Language="C#" AutoEventWireup="true" CodeFile="AdminDashboard.aspx.cs" Inherits="Telecom_Customer_Application.AdminDashboard" %>

<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" rel="stylesheet">
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard</title>
     <style>
        /* General Body and Layout */
        body {
            margin: 0;
            font-family: 'Arial', sans-serif;
            background-color: #f5f5f5;
            color: #333;
        }

        /* Container with Flexbox Layout */
        .container {
            display: flex;
            flex-direction:row;
            height: 100vh;
            overflow: hidden;
        }


         /* Sidebar Styling */
        .sidebar {
            width: 300px;  /* Default wider width */
            background-color: #2a3d56;  /* Darker blue shade */
            color: #fff;
            display: flex;
            flex-direction: column;
            height: 100vh;
            transition: width 0.3s ease-in-out;  /* Smooth transition */
            overflow-y: auto;
            overflow-x: hidden;
            position: relative;
            margin-right: 40px;
            top: 0;
            left: 0;
        }

        .sidebar:hover {
            width: 350px;  /* Expanding sidebar further on hover */
        }

        /* Sidebar Header */
        .sidebar h4 {
            text-align: center;
            font-size: 30px;
            font-weight: bold;
            margin-top: -52px;
            margin-bottom: 50px;
            margin-left: 50px;
        }

        /* Style for the image inside the header */
        .sidebar-header-img {
            width: 70px;
            height: auto;
            border-radius: 50%; /* make the image circular */
            margin-left: 10px;
            margin-top: 35px;
        }

        /* Sidebar Links */
        .sidebar a {
            color: #fff;
            text-decoration: none;
            padding: 11px 15px;
            margin: 7px 4px;
            border-radius: 5px;
            display: flex;
            font-size: 16px;
            font-weight: 500;
            transition: background-color 0.3s;
        }

        .sidebar a:hover {
            background-color: #3e4f6e;  /* Darker blue hover effect */
        }

        .sidebar a.active {
            background-color: #1e6fa1;  /* New shade of blue */
        }

        /* Styling the icons (Font Awesome) */
        .sidebar-icon {
            width: 20px;
            height: 20px;
            margin-right: 8px;
        }
        .sidebar-icon2 {
            font-size: 11px;  /* Change the font size to make the icon smaller */
            width: 20px;
            height: 20px;
            margin-left: auto; /* Push this icon to the far right */
            margin-top:3px;
        }


        /* Scrollbar Styling */
        .sidebar::-webkit-scrollbar {
            width: 12px;
            height: 12px;
        }

        .sidebar::-webkit-scrollbar-thumb {
            background: linear-gradient(45deg, #3b5f77, #2c4d6f);  /* Darker blue gradient */
            border-radius: 6px;
            border: 2px solid #1f3a4d;
        }

        .sidebar::-webkit-scrollbar-thumb:hover {
            background: linear-gradient(45deg, #2a4c65, #1c3b4d);  /* Darker blue hover effect */
        }

        .sidebar::-webkit-scrollbar-track {
            background-color: #1f3a4d;  /* Darker blue track */
            border-radius: 6px;
            margin: 2px;
        }

        /* Smooth scrolling behavior */
        .sidebar {
            scroll-behavior: smooth;
        }


        /* Dropdown */
        .dropdown {
            position: relative;
        }

        .dropdown-toggle {
            color: #fff;
            text-decoration: none;
            padding: 15px;
            display: block;
            cursor: pointer;
            background-color: #2a3d56;  /* Darker blue shade */
            transition: background-color 0.3s;
        }

        .dropdown-toggle:hover {
            background-color: #3e4f6e;  /* Darker blue hover effect */
        }

        .dropdown-content {
            display: none;
            flex-direction: column;
            background-color: #2d3e55;  /* Darker blue shade */
            width: 100%;
            padding-left: 15px;
        }

        .dropdown-content a {
            color: #fff;
            text-decoration: none;
            padding: 10px 15px;
            display: block;
            font-size: 14px;
        }

        .dropdown-content a:hover {
            background-color: #3e4f6e;  /* Darker blue hover effect */
        }

        .dropdown.active .dropdown-content {
            display: flex;
        }
        .nested-dropdown {
            left: 100%;
            top: 0;
            position: absolute;
            min-width: 200px;
            z-index: 15;
        }

        .dropdown-content .dropdown:hover > .nested-dropdown {
            display: block;
        }

        /* Content Area */
        .content {
            width: 80%;
            padding: 20px;
            box-sizing: border-box;
            background-color: #ffffff;
            overflow-y: auto;
            overflow-x: auto;
            transition: width 0.3s ease;
        }

        .container:hover .content {
            width: 75%;
        }

        .content h3 {
            margin-bottom: 20px;
            font-size: 24px;
            color: #343a40;
            font-weight: 700;
        }

        .filters button,
        .actions button {
            background-color: #f0f0f0;
            border: 1px solid #ccc;
            padding: 10px 15px;
            font-size: 14px;
            cursor: pointer;
            border-radius: 5px;
            margin-right: 10px;
            transition: background-color 0.3s ease;
        }

        .filters button:hover,
        .actions button:hover {
            background-color: #e0e0e0;
        }

        .filters button:focus,
        .actions button:focus {
            outline: none;
            box-shadow: 0 0 5px rgba(0, 123, 255, 0.5);
        }

         /* Table Styling */
        .table-responsive {
            max-height: 720px;
            max-width: 1340px;
            overflow-y: auto;
            overflow-x: auto;
            border: none; 
            box-shadow: none; 
            position: relative;
            margin: 0;
            padding: 0;
        }

        .table-responsive::-webkit-scrollbar {
            width: 5px;
            height: 5px;
        }

        .table-responsive::-webkit-scrollbar-thumb {   
            background: rgba(200, 200, 200, 0.7);
            border-radius: 4px;
        }

       .table-responsive::-webkit-scrollbar-thumb:hover {
            background: rgba(180, 180, 180, 0.8); 
            border-radius: 4px;
       }
 

        .table-responsive::-webkit-scrollbar-track {
            background: rgba(220, 220, 220, 0.5);
            border-radius: 4px;
        }

        .table-responsive {
            scroll-behavior: smooth;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            font-size: 16px;
            text-align: center;
            background-color: #ffffff;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
            border: none;
            margin: 0;
            padding: 0;
        }

        table th, table td {
            padding: 12px;
            border: 1px solid #ddd;
            color: #333;
        }

        table th {
            font-weight: bold;
            background-color: #e9f3ff;
            color: #0056b3;
            border: 1px solid #cce5ff;
        }


        /* Status badges */
        .status-active {
            color: #00ff00;
            padding: 5px 10px;
            border-radius: 5px;
            font-size: 14px;
        }
        .status-onhold {
            color: #ff0000;
            padding: 5px 10px;
            border-radius: 5px;
            font-size: 14px;
        }

        .status-pending {
            color: #ffd700;
            padding: 5px 10px;
            border-radius: 5px;
            font-size: 14px;
        }

        /* Style for the initials circle */
        .initials-circle {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            background-color: #007bff;
            color: white;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            font-weight: bold;
            font-size: 14px;
            text-transform: uppercase;
            margin-right: 10px;
        }

        /* Container for name cell */
        .name-container {
            display: flex;
            align-items: center;
        }

        /* Style for full name next to initials */
        .full-name {
            font-size: 14px;
            color: #333;
            font-weight: normal;
        }

        /* Style for clickable link */
        .clickable-link {
            color: blue; /* Make the link blue */
            text-decoration: underline; /* Underline the link */
        }

        /* Style for the link when hovered */
        .clickable-link:hover {
            color: darkblue; /* Change color when the link is hovered */
            text-decoration: underline; /* Keep the underline on hover */
        }


        table tr:nth-child(odd) {
            background-color: #f9fbff;
        }

        table tr:hover {
            background-color: #e2edff;
            transition: background-color 0.3s ease;
        }

        /* Responsive Design */
        @media (max-width: 768px) {
            .container {
                flex-direction: column;
            }

            .sidebar {
                width: 100%;
                height: auto;
            }

            .content {
                width: 100%;
            }

            .stats-panel {
                width: 100%;
                border-left: none;
            }
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
        .tab-heading {
        font-family: "Arial", sans-serif;
        font-size: 24px;
        font-weight: 600;
        color: #333;
        margin-bottom: 15px;
        margin-top:40px;
        display: inline-block; /* Ensures the underline is only under the text */
        letter-spacing: 0.05em;
        border-bottom: 2px solid #0056b3; /* Adds a blue underline */
        padding-bottom: 5px;
    }
        .date-container {
            margin-bottom: 20px;
            display: flex;
            flex-direction: column;
            gap: 10px;
            align-items: flex-start;
            font-family: 'Arial', sans-serif;
        }

        .date-label {
            font-size: 16px;
            font-weight: 700;
            color: #2c3e50;
            margin-bottom: 5px;
        }

        .date-input {
            padding: 12px 15px;
            font-size: 16px;
            font-weight: 500;
            border: 2px solid #d9e9ff;
            border-radius: 8px;
            width: 100%;
            max-width: 340px;
            background-color: #f7fbff;
            transition: all 0.3s ease-in-out;
            box-shadow: inset 0 1px 3px rgba(0, 0, 0, 0.1);
        }

        .date-input:focus {
            border-color: #007bff;
            box-shadow: 0 0 8px rgba(0, 123, 255, 0.4);
            background-color: #ffffff;
            outline: none;
        }

        .date-input:hover {
            background-color: #eaf4ff;
            border-color: #007bff;
        }

        .date-container .date-input::placeholder {
            color: #b0c7de;
        }

        @media (max-width: 768px) {
            .date-container {
                align-items: center;
                text-align: center;
            } 
           .date-input {
                max-width: 100%;
            }
        }
        .date-picker-container {
            margin-bottom: 30px; 
            display: block;
            padding: 30px 20px 0px;
            padding-left: 5px;
            margin-bottom: 15px;
            display: flex;
            flex-direction: column;
            gap: 6px;
            align-items: flex-start;
            font-family: 'Segoe UI', Tahoma, Geneva, sans-serif;
        }

        .date-picker-label {
            display: block; 
            font-size: 14px;
            font-weight: bold;
            color: #2d3e50;
            margin-bottom: 10px; 
        }

        .date-picker {
            padding: 8px 10px;
            font-size: 14px;
            font-weight: 500;
            color: #2c3e50;
            border: 1.5px solid #cce5ff;
            border-radius: 6px;
            width: 100%;
            max-width: 280px;
            background-color: #f0faff;
            transition: all 0.3s ease;
            box-shadow: inset 0 1px 2px rgba(0, 0, 0, 0.1);
            appearance: none;
            -webkit-appearance: none;
        }

        .date-picker:hover {
            background-color: #e8f4ff;
            border-color: #0088ff;
            cursor: pointer;
        }

        .date-picker:focus {
            border-color: #006bbf;
            box-shadow: 0 0 8px rgba(0, 107, 191, 0.4);
            background-color: #ffffff;
            outline: none;
        }

        .date-picker::-webkit-calendar-picker-indicator {
            cursor: pointer;
            filter: hue-rotate(200deg) brightness(1.1);
        }

        .date-picker-container .date-picker::placeholder {
            color: #9fbfdc;
        }

        @media (max-width: 768px) {
            .date-picker-container {
                align-items: center;
            }

            .date-picker {
                max-width: 90%;
            }
        }
        /* General Styles */

        .input-container {
            margin-bottom: 30px; 
            display: block;
            padding: 30px 20px 0px;
            padding-left: 5px;
        }

        .input-label {
            font-size: 14px;
            font-weight: bold;
            color: #34495e;
            letter-spacing: 0.3px;
            margin: 0; 
            padding-bottom: 8px; 
        }

        .styled-input {
            padding: 10px 12px;
            font-size: 14px;
            font-weight: 400;
            color: #2c3e50;
            border: 1.5px solid #cce5ff;
            border-radius: 6px;
            background-color: #f8faff;
            box-shadow: inset 0 1px 2px rgba(0, 0, 0, 0.1);
            width: 100%;
            max-width: 300px;
            transition: all 0.3s ease;
            outline: none;
            margin-top: 10px;
        }

        .textbox-style {
            width: 100%;
            padding: 5px;
            font-size: 14px;
            border: 1px solid #ccc;
            border-radius: 4px;
            box-sizing: border-box;
            transition: border-color 0.3s ease;
            margin-top: 5px; 
        }
      
        .textbox-style:focus {
            border-color: #007bff;
            outline: none;
        }

        .styled-input:hover {
            background-color: #eef7ff;
            border-color: #0088ff;
        }

        .styled-input:focus {
            border-color: #006bbf;
            box-shadow: 0 0 8px rgba(0, 107, 191, 0.4);
        }

        /* Buttons */
        .button-container {
            display: flex;
            gap: 10px;
            margin-top: 10px;
        }

        .styled-button {
            padding: 10px 16px;
            font-size: 14px;
            font-weight: bold;
            color: #ffffff;
            background-color: #3498db;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            transition: background-color 0.3s ease;
            margin-left: 5px;
            margin-top: 5px;
            margin-bottom: 50px;
        }

        .styled-button:hover {
            background-color: #2c81ba;
        }

        .styled-button:focus {
            box-shadow: 0 0 6px rgba(44, 129, 186, 0.5);
            outline: none;
        }

        .delete-button {
            background-color: #e74c3c;
        }

        .delete-button:hover {
            background-color: #c0392b;
        }

        /* Output Label */
        .output-container {
            margin-top: 10px;
        }

        .output-label {
            font-size: 14px;
            color: #16a085;
            font-weight: bold;
        }

        .top-right-button {
            position: absolute;
            top: 15px;
            right: 8px;
            background-color: transparent;
            border: none;
            cursor: pointer; 
            padding: 10px;
            font-size: 16px;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .top-right-button::before {
            content: "\f2f5"; /* Unicode icon */
            font-family: "Font Awesome 5 Free";
            font-weight: 900;
            color: #2a3d56;
            font-size: 35px; /* icon size */
            margin-right: 8px;
        }

        .top-right-button:hover::before {
            color: #0056b3;
        }

        /* Responsive Design */
         @media (max-width: 768px) {
             .styled-input {
                 max-width: 90%;
             }

             .button-container {
                 flex-direction: column;
                 gap: 6px;
             }
         }
         /* From Uiverse.io by cuzpq */ 
        .theme-checkbox {
          --toggle-size: 16px;
          -webkit-appearance: none;
          -moz-appearance: none;
          appearance: none;
          width: 6.25em;
          height: 3.125em;
          background: -webkit-gradient(linear, left top, right top, color-stop(50%, #efefef), color-stop(50%, #2a2a2a)) no-repeat;
          background: -o-linear-gradient(left, #efefef 50%, #2a2a2a 50%) no-repeat;
          background: linear-gradient(to right, #efefef 50%, #2a2a2a 50%) no-repeat;
          background-size: 205%;
          background-position: 0;
          -webkit-transition: 0.4s;
          -o-transition: 0.4s;
          transition: 0.4s;
          border-radius: 99em;
          position: relative;
          cursor: pointer;
          font-size: var(--toggle-size);
        }

        .theme-checkbox::before {
          content: "";
          width: 2.25em;
          height: 2.25em;
          position: absolute;
          top: 0.438em;
          left: 0.438em;
          background: -webkit-gradient(linear, left top, right top, color-stop(50%, #efefef), color-stop(50%, #2a2a2a)) no-repeat;
          background: -o-linear-gradient(left, #efefef 50%, #2a2a2a 50%) no-repeat;
          background: linear-gradient(to right, #efefef 50%, #2a2a2a 50%) no-repeat;
          background-size: 205%;
          background-position: 100%;
          border-radius: 50%;
          -webkit-transition: 0.4s;
          -o-transition: 0.4s;
          transition: 0.4s;
        }

        .theme-checkbox:checked::before {
          left: calc(100% - 2.25em - 0.438em);
          background-position: 0;
        }

        .theme-checkbox:checked {
          background-position: 100%;
        }

    </style>

    <script>
        function toggleDropdown(element) {
            const content = element.nextElementSibling;
            if (content.style.display === "block") {
                content.style.display = "none";
            } else {
                content.style.display = "block";
            }
        }

    </script>

</head>
<body>
    <form id="form1" runat="server">
        <div class="container" runat="server">
            <!-- Sidebar -->
            <div class="sidebar">

                <div class="sidebar-header">
                    <img src="TeleSphere.png" alt="Header Image" class="sidebar-header-img">
                    <h4>TeleSphere</h4>
                </div>

                 <div class="dropdown">
                    <a href="#" id="customersTabDropdown" class="dropdown-toggle" onclick="toggleDropdown(this)" ><i class="fa-solid fa-user sidebar-icon"></i>Customer<i class="fa-solid fa-chevron-down sidebar-icon2"></i> </a>
                       <div class="dropdown-content">
                           <a href="#" id="customersTab" runat="server" onserverclick="LoadCustomers" class="active">Customers Details</a>
                           <a href="#" id="customersWalletTab" runat="server" onserverclick="LoadCustomersWallet">Customer linked Wallets</a>
                       </div>
                 </div>

                <a href="#" id="subscriptionsTab" runat="server" onserverclick="LoadSubscriptions">
                    <i class="fa-solid fa-sim-card sidebar-icon"></i>Subscribtions
                </a>
                
                <div class="dropdown">
                    <a href="#" id="storesTabDropDown" class="dropdown-toggle" onclick="toggleDropdown(this)">
                        <i class="fa-solid fa-store sidebar-icon"></i>Shops
                        <i class="fa-solid fa-chevron-down sidebar-icon2"></i>
                    </a>
                       <div class="dropdown-content">
                         <a href="#" id="storesTab" runat="server" onserverclick="LoadStores">All Shops Details</a>
                         <a href="#" id="E_shopsTab" runat="server" onserverclick="LoadE_shops">E-shops Details</a>
                       </div>
                 </div>

                <a href="#" id="ticketsTab" runat="server" onserverclick="LoadTickets">
                    <i class="fa-solid fa-ticket sidebar-icon"></i>Tickets
                </a>

                <a href="#" id="plansTab" runat="server" onserverclick="LoadPlans"><i class="fa-solid fa-globe sidebar-icon"></i>Plans</a>
                
                <div class="dropdown">
                    <a href="#" id="BenefitsTabDropdown" class="dropdown-toggle" onclick="toggleDropdown(this)">
                        <i class="fa-solid fa-gift sidebar-icon"></i>Benefits<i class="fa-solid fa-chevron-down sidebar-icon2"></i></a>
                    <div class="dropdown-content">

                        <div class="dropdown">
                            <a href="#" id="CashbackTabDropdown" class="dropdown-toggle" onclick="toggleDropdown(this)"><i class="fa-solid fa-money-bill-wave sidebar-icon"></i>Cashback&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<i class="fa-solid fa-chevron-down sidebar-icon2"></i></a>
                            <div class="dropdown-content">
                                <a href="#" id="CashbackTab" runat="server" onserverclick="LoadCashback">Cashback Transactions</a>
                                <a href="#" id="CashbackAmountTab" runat="server" onserverclick="LoadCashbackAmount">Cashback Amount</a>
                            </div>
                        </div>

                        <a href="#" id="benefitsTab" runat="server" onserverclick="LoadBenefits" class="active">Delete Benefits</a>
                        <a href="#" id="offersTab" runat="server" onserverclick="LoadOffers">Offers</a>
                        <a href="#" id="PointsTab" runat="server" onserverclick="LoadPoints" class="active">Update Points</a>

                    </div>
                </div>


                <a href="#" id="accountUsageTab" runat="server" onserverclick="LoadAccountUsage"><i class="fa-solid fa-chart-column sidebar-icon"></i>Account Usage</a>
                <a href="#" id="walletsTab" runat="server" onserverclick="LoadWallets"><i class="fa-solid fa-wallet sidebar-icon"></i>Wallets</a>
                <a href="#" id="PaymentsTab" runat="server" onserverclick="LoadPayments"><i class="fa-solid fa-coins sidebar-icon"></i>Payments</a>
                

                 <div class="dropdown">
                    <a href="#" id="TransactionTabDropdown" class="dropdown-toggle" onclick="toggleDropdown(this)"><i class="fa-solid fa-arrow-right-arrow-left sidebar-icon"></i>Transaction <i class="fa-solid fa-chevron-down sidebar-icon2"></i></a>
                       <div class="dropdown-content">
                            <a href="#" id="TransactionsTab" runat="server" onserverclick="LoadTransactions">Transaction Details</a>
                           <a href="#" id="AverageTransactionsTab" runat="server" onserverclick="LoadAverageTransactions">Average Transaction Amount</a>
                       </div>
                 </div>

            </div>

    
            <div id="sharedContent" runat="server" class="tab-content active-tab" style="display:block;">

                <h3 id="TabHeading" runat="server" class="tab-heading">Tab Details</h3>

                <div id="DateContainer1" runat="server" class="date-picker-container" style="display: none;">
                    <label id="DateLabel1" runat="server" for="DateInput1" class="date-picker-label">Start Date:</label>
                    <asp:TextBox ID="DateInput1" runat="server" CssClass="date-picker" TextMode="Date"></asp:TextBox>
                </div>

                <div id="DateContainer2" runat="server" class="date-picker-container" style="display: none;">
                    <label id="DateLabel2" runat="server" for="DateInput2" class="date-picker-label">End Date:</label>
                    <asp:TextBox ID="DateInput2" runat="server" CssClass="date-picker" TextMode="Date"></asp:TextBox>
                </div>


                <div id="TextBoxContainer1" runat="server" class="input-container">
                    <label for="PlanIDEditText" class="input-label">Plan ID:</label>
                    <asp:TextBox ID="PlanIDEditText" runat="server" CssClass="styled-input" placeholder="Enter Plan ID"></asp:TextBox>
                </div>

                <div id="TextBoxContainer2" runat="server" class="input-container">
                    <label for="MobileEditText" class="input-label">Mobile Number:</label>
                    <asp:TextBox ID="MobileEditText" runat="server" CssClass="styled-input" placeholder="Enter Mobile Number"></asp:TextBox>
                </div>

                <div id="TextBoxContainer3" runat="server" class="input-container">
                    <label for="WalletEditText" class="input-label">Wallet ID:</label>
                    <asp:TextBox ID="WalletEditText" runat="server" CssClass="styled-input" placeholder="Enter Wallet ID"></asp:TextBox>
                </div>


                <div class="button-container">
                    <asp:Button ID="SearchButton" runat="server" CssClass="styled-button" Text="Search" OnClick="SearchButton_Click" />
                    <asp:Button ID="DeleteButton" runat="server" CssClass="styled-button delete-button" Text="Delete" OnClick="DeleteBenefitsButton_Click" style="display:none;" />
                </div>


                <div class="output-container">
                    <asp:Label ID="LabelOut" runat="server" CssClass="output-label" Text=""></asp:Label>
                </div>

                 <!-- Data Table -->
                 <div class="table-responsive">
                     <table>
                         <tbody id="TableBody" runat="server"></tbody> <!-- TableBody for rows -->
                     </table>
                 </div>

                <button id="backButton" runat="server" onserverclick="BackButton_Click" class="top-right-button"/>


            </div> 
        </div>       
    </form>
</body>
</html>