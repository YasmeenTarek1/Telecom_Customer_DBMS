﻿<%@ Page Language="C#" AutoEventWireup="true" CodeFile="AdminDashboard.aspx.cs" Inherits="Telecom_Customer_Application.AdminDashboard" %>

<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" rel="stylesheet">
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard</title>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <style>
        /* General Body and Layout */
        body {
            margin: 0 25px 30px 0;
            font-family: 'Arial', sans-serif;
            background-color: #f5f5f5;
            color: #333;
            overflow-y: auto;
        }

        /* Entire page scrollbar */
        ::-webkit-scrollbar {
            width: 8px; 
        }

        ::-webkit-scrollbar-track {
            background: #f1f1f1; 
            border-radius: 6px; 
        }

        ::-webkit-scrollbar-thumb {
            background: #888; 
            border-radius: 6px; 
            border: 3px solid #f1f1f1; 
        }

        ::-webkit-scrollbar-thumb:hover {
            background: #555; 
        }

        /* Container with Flexbox Layout */
        .container {
            display: flex;
            flex-direction: row;
            height: 100vh;
        }

        /* Sidebar Styling */
        .sidebar {
            position: fixed; 
            width: 260px;
            height: 100%;
            background-color: #2a3d56;
            color: #f5f5f5;
            display: flex;
            flex-direction: column;
            transition: width 0.3s ease-in-out;
            overflow-y: auto;
            overflow-x: hidden;
            margin-right: 20px;
            top: 0;
            left: 0;
        }

        .sidebar:hover {
            width: 280px;
        }

        /* Sidebar Header */
        .sidebar h4 {
            text-align: center;
            font-size: 28px;
            font-weight: bold;
            margin-top: -52px;
            margin-bottom: 50px;
            margin-left: 63px;
        }

        /* Style for the image inside the header */
        .sidebar-header-img {
            width: 70px;
            height: auto;
            margin-left: 10px;
            margin-top: 35px;
        }

        /* Sidebar Links */
        .sidebar a {
            color: #fff;
            text-decoration: none;
            padding: 13px 15px;
            margin: 7px 4px;
            border-radius: 5px;
            display: flex;
            font-size: 16px;
            font-weight: 500;
            position: relative;
        }

        .sidebar a:hover,
        .sidebar a.active {
            background-color: #f5f5f5;
            border-top-left-radius: 30px;
            border-bottom-left-radius: 30px;
            color: #2a3d56;
        }

        .sidebar a:hover::before,
        .sidebar a.active::before {
            content: "";
            position: absolute;
            right: -4px;
            top: -35px;
            width: 35px;
            height: 35px;
            background-color: transparent;
            border-radius: 50%;
            box-shadow: 25px 25px 0 6px #f5f5f5;
            pointer-events: none;
            z-index: 1;
        }

        .sidebar a:hover::after,
        .sidebar a.active::after {
            content: "";
            position: absolute;
            right: -4px;
            bottom: -35px;
            width: 35px;
            height: 35px;
            background-color: transparent;
            border-radius: 50%;
            box-shadow: 25px -25px 0 6px #f5f5f5;
            pointer-events: none;
            z-index: 1;
        }

        /* Styling the icons (Font Awesome) */
        .sidebar-icon {
            width: 20px;
            height: 20px;
            margin-right: 8px;
        }

        .sidebar-icon2 {
            font-size: 11px;
            width: 20px;
            height: 20px;
            margin-left: auto;
            margin-top: 3px;
        }

        /* Scrollbar Styling */
        .sidebar::-webkit-scrollbar {
            width: 0;
            height: 12px;
        }

        .sidebar::-webkit-scrollbar-thumb {
            background: linear-gradient(45deg, #3b5f77, #2c4d6f);
            border-radius: 6px;
            border: 2px solid #1f3a4d;
        }

        .sidebar::-webkit-scrollbar-thumb:hover {
            background: linear-gradient(45deg, #2a4c65, #1c3b4d);
        }

        .sidebar::-webkit-scrollbar-track {
            background-color: #1f3a4d;
            border-radius: 6px;
            margin: 2px;
        }

        .sidebar {
            scroll-behavior: smooth;
        }

        /* Dropdown */
        .dropdown-content {
            display: none;
            margin-left: 30px;
        }

        .dropdown-content a {
            padding: 10px 15px;
            font-size: 14px;
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

        /* Cards Styling */
        .cardBox {
            position: relative;
            width: 95%;
            padding: 20px;
            display: grid;
            margin-left: 25px;
            margin-top: 20px;
            grid-template-columns: repeat(4, 1fr);
            grid-gap: 30px;
        }

        .cardBox .card {
            position: relative;
            background: #f5f5f5;
            padding: 30px;
            border-radius: 20px;
            display: flex;
            justify-content: space-between;
            cursor: pointer;
            box-shadow: 0 10px 35px rgba(0, 0, 0, 0.1);
        }

        .cardBox .card .numbers {
            position: relative;
            font-weight: 500;
            font-size: 2.5rem;
            color: #2a3d56;
        }

        .cardBox .card .cardName {
            color: #9b9b9b;
            font-size: 1.1rem;
            margin-top: 5px;
        }

        .cardBox .card .iconBx {
            font-size: 3.5rem;
            color: #007bff;
            margin-right: 20px;
        }

        .cardBox .card:hover {
            background: #2a3d56;
        }

        .cardBox .card:hover .numbers,
        .cardBox .card:hover .cardName,
        .cardBox .card:hover .iconBx {
            color: #f5f5f5;
        }
          /*
            #9b9b9b --> grey
            #2a3d56 --> dark blue
            #007bff --> baby blue
            #f5f5f5 --> white
        */

        /* Table Styling */
        table {
            border-collapse: collapse;
            margin: 20px 0 0 15px;
            font-size: 16px;
            text-align: center;
            background-color: #ffffff;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
            border: 1px solid #e0e0e0;
            border-radius: 8px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            padding: 20px;
        }

        table th {
            padding: 12px;
            border: 1px solid #ddd;
            color: #333;
            font-weight: bold;
            background-color: #e9f3ff;
            color: #0056b3;
            border: 1px solid #cce5ff;
        }

        table td {
            padding: 10px;
            border: 1px solid #ddd;
            color: #333;
        }

        .table-responsive {
            max-height: 100%;
            max-width: 100%;
            border: none;
            box-shadow: none;
            position: relative;
            padding: 3px;
        }

        /* Status badges */
        .status-active {
            display: inline-block;
            padding: 4px 10px;
            background-color: #28a745;
            color: white;
            border-radius: 12px;
            font-size: 14px;
            text-align: center;
        }

        .status-onhold {
            display: inline-block;
            padding: 4px 10px;
            background-color: #dc3545;
            color: white;
            border-radius: 12px;
            font-size: 14px;
            text-align: center;
        }

        .status-pending {
            display: inline-block;
            padding: 4px 10px;
            background-color: #f8e061;
            color: black;
            border-radius: 12px;
            font-size: 14px;
            text-align: center;
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
            color: blue;
            text-decoration: underline;
        }

        .clickable-link:hover {
            color: darkblue;
            text-decoration: underline;
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
            font-size: 28px;
            color: #333;
            margin: 40px 0px 0px 20px;
            display: inline-block;
            letter-spacing: 0.05em;
            border-bottom: 2px solid #0056b3;
        }

        .tab-content{
            margin: 0 0 0 280px;
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
            content: "\f2f5";
            font-family: "Font Awesome 5 Free";
            font-weight: 900;
            color: #2a3d56;
            font-size: 35px;
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
     /* General Plan Card Styling */
       #PlanCardsContainer {
            display: flex; 
            flex-wrap: nowrap;
            gap: 20px; 
            padding: 20px;
            margin: 20px 0;
            overflow-x: auto; 
            width: 100%; 
            align-items: flex-start; 
        }

        .PlanCardsContainer {
            display: flex; 
            flex-wrap: nowrap; 
            gap: 20px; 
        }

        .plan-card {
            background-color: #ffffff; /* White background for cards */
            border-radius: 15px;
            padding: 25px;
            width: 280px; /* Fixed width for each card */
            box-shadow: 0 6px 12px rgba(0, 0, 0, 0.1); /* Deeper shadow */
            transition: transform 0.3s ease, box-shadow 0.3s ease;
            cursor: pointer;
            position: relative;
            overflow: hidden;
            flex-shrink: 0; /* Prevent cards from shrinking */
        }

        .plan-card:hover {
            transform: translateY(-10px); /* Stronger lift effect on hover */
            box-shadow: 0 12px 24px rgba(0, 0, 0, 0.2); /* Stronger shadow on hover */
        }

        /* Plan Name Styling */
        .plan-name {
            font-size: 24px;
            font-weight: bold;
            margin-bottom: 10px;
            color: #fff; /* White text for better contrast */
        }

        /* Plan ID Styling */
        .plan-id {
            font-size: 14px;
            color: rgba(255, 255, 255, 0.8); /* Semi-transparent white */
            margin-bottom: 10px;
        }

        /* Plan Details Styling */
        .plan-details {
            font-size: 16px;
            color: rgba(255, 255, 255, 0.9); /* Semi-transparent white */
            margin-bottom: 20px;
        }

        /* Plan Price Styling */
        .plan-price {
            font-size: 22px;
            font-weight: bold;
            color: #fff; /* White text */
            background-color: rgba(0, 0, 0, 0.1); /* Semi-transparent background */
            padding: 10px 15px;
            border-radius: 8px;
            display: inline-block;
        }

        /* Unique Styling for Each Plan */
        .basic-plan {
            background: linear-gradient(135deg, #64b5f6, #1976d2); /* Blue gradient */
        }

        .basic-plan .plan-name {
            color: #fff; /* White text */
        }

        .standard-plan {
            background: linear-gradient(135deg, #81c784, #388e3c); /* Green gradient */
        }

        .standard-plan .plan-name {
            color: #fff; /* White text */
        }

        .premium-plan {
            background: linear-gradient(135deg, #ffb74d, #f57c00); /* Orange gradient */
        }

        .premium-plan .plan-name {
            color: #fff; /* White text */
        }

        .unlimited-plan {
            background: linear-gradient(135deg, #f48fb1, #c2185b); /* Pink gradient */
        }

        .unlimited-plan .plan-name {
            color: #fff; /* White text */
        }

        /* Add Icons for Each Plan */
        .plan-card::before {
            content: "";
            position: absolute;
            top: -50px;
            right: -50px;
            width: 150px;
            height: 150px;
            background-color: rgba(255, 255, 255, 0.1); /* Semi-transparent circle */
            border-radius: 50%;
            z-index: 1;
        }

        .plan-card::after {
            content: "";
            position: absolute;
            bottom: -50px;
            left: -50px;
            width: 150px;
            height: 150px;
            background-color: rgba(255, 255, 255, 0.1); /* Semi-transparent circle */
            border-radius: 50%;
            z-index: 1;
        }

        /* Add Icons for Each Plan */
        .plan-card i {
            font-size: 40px;
            color: rgba(255, 255, 255, 0.8); /* Semi-transparent white */
            margin-bottom: 20px;
            display: block;
            z-index: 2;
            position: relative;
        }

        /* Unique Icons for Each Plan */
        .basic-plan i {
            content: "\f1ec"; /* Font Awesome icon for Basic Plan */
            font-family: "Font Awesome 5 Free";
            font-weight: 900;
        }

        .standard-plan i {
            content: "\f0c0"; /* Font Awesome icon for Standard Plan */
            font-family: "Font Awesome 5 Free";
            font-weight: 900;
        }

        .premium-plan i {
            content: "\f3a5"; /* Font Awesome icon for Premium Plan */
            font-family: "Font Awesome 5 Free";
            font-weight: 900;
        }

        .unlimited-plan i {
            content: "\f0e7"; /* Font Awesome icon for Unlimited Plan */
            font-family: "Font Awesome 5 Free";
            font-weight: 900;
        }

        /* Section Styles */
        .section {
            display: flex;
            justify-content: space-between;
            margin-bottom: 20px;
        }

        .chart-container {
            width: 60%;
            background-color: #fff;
            border-radius: 8px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            padding: 20px;
        }

        /* Section Styling */
        .section {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-top: 30px;
        }

        /* CardBox Override for Two-Column Layout */
        .cardBox2 {
            display: grid;
            grid-template-columns: 1fr 1fr; /* Two equal columns: card and chart */
            gap: 20px; /* Space between the card and chart */
            align-items: center;
            width: 90%;
            margin: auto;
        }

        /* Chart Container Styling */
        .chart-container {
            position: relative;
            width: 300px; /* Set a fixed width for the chart */
            height: 300px; /* Set a fixed height for the chart */
            margin: 0 auto; /* Center the chart */
        }

        /* Optional: Add hover effect to the chart */
        .chart-container:hover {
            transform: scale(1.05); /* Slight zoom-in effect on hover */
            transition: transform 0.3s ease-in-out;
        }


    </style>

    <script>
       // Function to toggle dropdown visibility
       function toggleDropdown(element, hiddenFieldId) {
           // Toggle the clicked dropdown
           const content = element.nextElementSibling;
           if (content.style.display === "block") {
               content.style.display = "none";
               document.getElementById(hiddenFieldId).value = "closed";
           } else {
               content.style.display = "block";
               document.getElementById(hiddenFieldId).value = "open";
           }
       }

       // Restore dropdown states when the page loads
       window.onload = function () {
           // Restore the state of each dropdown individually
            const storesDropdownState = document.getElementById('<%= hdnStoresDropdownState.ClientID %>').value;
            const plansDropdownState = document.getElementById('<%= hdnPlansDropdownState.ClientID %>').value;
            const transactionDropdownState = document.getElementById('<%= hdnTransactionDropdownState.ClientID %>').value;

           if (storesDropdownState === "open") {
               document.querySelector('#storesTabDropDown + .dropdown-content').style.display = "block";
           }
           if (plansDropdownState === "open") {
               document.querySelector('#plansTab + .dropdown-content').style.display = "block";
           }
           if (transactionDropdownState === "open") {
               document.querySelector('#TransactionTabDropdown + .dropdown-content').style.display = "block";
           }
       };

       // Prevent dropdown from closing when clicking inside it
       document.querySelectorAll('.dropdown-content').forEach(dropdown => {
           dropdown.addEventListener('click', function (event) {
               event.stopPropagation(); // Stop the click event from bubbling up to the parent
           });
       });

    </script>

    <script type="text/javascript">
        function triggerPostback(planId) {
            __doPostBack('PlanClicked', planId);
        }
    </script>

    <script type="text/javascript">
        document.addEventListener("DOMContentLoaded", function () {
            if (typeof benefitTypesData !== 'undefined') {
                var ctx = document.getElementById('benefit-types-chart').getContext('2d');

                // Extract labels and data from the JSON
                var labels = benefitTypesData.map(item => item.benefitID); // Use benefitID as labels
                var data = benefitTypesData.map(item => item.Percentage); // Use Percentage as data

                var myPieChart = new Chart(ctx, {
                    type: 'pie',
                    data: {
                        labels: labels,
                        datasets: [{
                            data: data,
                            backgroundColor: [
                                'rgba(255, 99, 132, 0.6)',
                                'rgba(54, 162, 235, 0.6)',
                                'rgba(255, 206, 86, 0.6)',
                                'rgba(75, 192, 192, 0.6)',
                                'rgba(153, 102, 255, 0.6)',
                                'rgba(255, 159, 64, 0.6)'
                            ],
                            borderColor: [
                                'rgba(255, 99, 132, 1)',
                                'rgba(54, 162, 235, 1)',
                                'rgba(255, 206, 86, 1)',
                                'rgba(75, 192, 192, 1)',
                                'rgba(153, 102, 255, 1)',
                                'rgba(255, 159, 64, 1)'
                            ],
                            borderWidth: 1
                        }]
                    },
                    options: {
                        responsive: true,
                        maintainAspectRatio: false,
                        plugins: {
                            legend: {
                                position: 'top',
                            },
                            title: {
                                display: true,
                                text: 'Benefit Type Percentages'
                            },
                            tooltip: {
                                callbacks: {
                                    label: function (context) {
                                        let label = context.label || '';
                                        if (label) {
                                            label += ': ';
                                        }
                                        label += context.raw + '%'; // Display percentage in tooltip
                                        return label;
                                    }
                                }
                            }
                        }
                    }
                });
            }
        });
    </script>

    <script type="text/javascript">
        document.addEventListener("DOMContentLoaded", function () {
            if (typeof benefitsStatusData !== 'undefined') {
                var ctx = document.getElementById('benefits-status-chart').getContext('2d');

                // Extract labels and data from the JSON
                var labels = Object.keys(benefitsStatusData); // ["Active", "Expired"]
                var data = Object.values(benefitsStatusData); // [activeCount, expiredCount]

                var myPieChart = new Chart(ctx, {
                    type: 'pie',
                    data: {
                        labels: labels,
                        datasets: [{
                            data: data,
                            backgroundColor: [
                                'rgba(75, 192, 192, 0.6)', // Green for Active
                                'rgba(255, 99, 132, 0.6)'  // Red for Expired
                            ],
                            borderColor: [
                                'rgba(75, 192, 192, 1)', // Green for Active
                                'rgba(255, 99, 132, 1)'  // Red for Expired
                            ],
                            borderWidth: 1
                        }]
                    },
                    options: {
                        responsive: true,
                        maintainAspectRatio: false,
                        plugins: {
                            legend: {
                                position: 'top',
                            },
                            title: {
                                display: true,
                                text: 'Active vs Expired Benefits'
                            },
                            tooltip: {
                                callbacks: {
                                    label: function (context) {
                                        let label = context.label || '';
                                        if (label) {
                                            label += ': ';
                                        }
                                        label += context.raw; // Display count in tooltip
                                        return label;
                                    }
                                }
                            }
                        }
                    }
                });
            }
        });
    </script>

</head>
<body>
    <form id="form1" runat="server">
        <asp:HiddenField ID="hdnStoresDropdownState" runat="server" />
        <asp:HiddenField ID="hdnPlansDropdownState" runat="server" />
        <asp:HiddenField ID="hdnTransactionDropdownState" runat="server" />

        <div class="container" runat="server">
            <!-- Sidebar -->
            <div class="sidebar">
                <div class="sidebar-header">
                    <img src="TeleSphere.png" alt="Header Image" class="sidebar-header-img">
                    <h4>TeleSphere</h4>
                </div>

                <a href="#" id="customersTab" runat="server" onserverclick="LoadCustomers">
                    <i class="fa-solid fa-user sidebar-icon"></i>Customers
                </a>

                <a href="#" id="subscriptionsTab" runat="server" onserverclick="LoadSubscriptions">
                    <i class="fa-solid fa-sim-card sidebar-icon"></i>Subscriptions
                </a>

                <div>
                    <a href="#" id="storesTabDropDown" onclick="toggleDropdown(this, '<%= hdnStoresDropdownState.ClientID %>')">
                        <i class="fa-solid fa-store sidebar-icon"></i>Shops
                        <i class="fa-solid fa-chevron-down sidebar-icon2"></i>
                    </a>
                    <div class="dropdown-content">
                        <a href="#" id="physicalShopsTab" runat="server" onserverclick="LoadPhysicalShops">Physical Shops</a>
                        <a href="#" id="E_shopsTab" runat="server" onserverclick="LoadE_shops">E-Shops</a>
                    </div>
                </div>

                <a href="#" id="ticketsTab" runat="server" onserverclick="LoadTickets">
                    <i class="fa-solid fa-ticket sidebar-icon"></i>Tickets
                </a>

                <div>
                    <a href="#" id="plansTab" onclick="toggleDropdown(this, '<%= hdnPlansDropdownState.ClientID %>')">
                        <i class="fa-solid fa-globe sidebar-icon"></i>Plans
                        <i class="fa-solid fa-chevron-down sidebar-icon2"></i>
                    </a>
                    <div class="dropdown-content">
                        <a href="#" id="PlanSinceDateTab" runat="server" onserverclick="LoadPlans">Subscribers Since a Date</a>
                        <a href="#" id="PlanInfoTab" runat="server" onserverclick="LoadPlansInfo">Plans Information</a>
                    </div>
                </div>

                <a href="#" id="BenefitsTabDropdown" runat="server" onserverclick="LoadBenefits">
                    <i class="fa-solid fa-gift sidebar-icon"></i>Benefits
                </a>

                <a href="#" id="accountUsageTab" runat="server" onserverclick="LoadAccountUsage">
                    <i class="fa-solid fa-chart-column sidebar-icon"></i>Account Usage
                </a>

                <a href="#" id="walletsTab" runat="server" onserverclick="LoadWallets">
                    <i class="fa-solid fa-wallet sidebar-icon"></i>Wallets
                </a>

                <a href="#" id="PaymentsTab" runat="server" onserverclick="LoadPayments">
                    <i class="fa-solid fa-coins sidebar-icon"></i>Payments
                </a>

                <div>
                    <a href="#" id="TransactionTabDropdown" onclick="toggleDropdown(this, '<%= hdnTransactionDropdownState.ClientID %>')">
                        <i class="fa-solid fa-arrow-right-arrow-left sidebar-icon"></i>Transaction
                        <i class="fa-solid fa-chevron-down sidebar-icon2"></i>
                    </a>
                    <div class="dropdown-content">
                        <a href="#" id="TransactionsTab" runat="server" onserverclick="LoadTransactions">Transaction Details</a>
                        <a href="#" id="AverageTransactionsTab" runat="server" onserverclick="LoadAverageTransactions">Average Transaction Amount</a>
                    </div>
                </div>
            </div>

            <!-- Content Area -->
            <div id="sharedContent" runat="server" class="tab-content active-tab" style="display: block;">
                <h3 id="TabHeading" runat="server" class="tab-heading">Tab Details</h3>
                <div id="cardBox" runat="server" style="display: none;">
                    <div class="cardBox">
                        <div class="card">
                            <div>
                                <div class="numbers" id="customerCount" runat="server">0</div>
                                <div class="cardName">Customers</div>
                            </div>
                            <div class="iconBx">
                                <i class="fa-solid fa-user sidebar-icon"></i>
                            </div>
                        </div>

                        <div class="card">
                            <div>
                                <div class="numbers" id="paymentCount" runat="server">0</div>
                                <div class="cardName">Payments</div>
                            </div>
                            <div class="iconBx">
                                <i class="fa-solid fa-coins sidebar-icon"></i>
                            </div>
                        </div>

                        <div class="card">
                            <div>
                                <div class="numbers" id="transferCount" runat="server">0</div>
                                <div class="cardName">Transactions</div>
                            </div>
                            <div class="iconBx">
                                <i class="fa-solid fa-arrow-right-arrow-left sidebar-icon"></i>
                            </div>
                        </div>

                        <div class="card">
                            <div>
                                <div class="numbers" id="servicePlanCount" runat="server">0</div>
                                <div class="cardName">Plans</div>
                            </div>
                            <div class="iconBx">
                                <i class="fa-solid fa-globe sidebar-icon"></i>
                            </div>
                        </div>
                    </div>
                </div>

                <div id="PlanCardsContainer" runat="server" style="display: none;">
                    <div class="PlanCardsContainer">
                        <!-- Basic Plan Card -->
                        <div class="plan-card basic-plan" onclick="triggerPostback('1')">
                            <i class="fas fa-user"></i>
                            <div class="plan-name">Basic Plan</div>
                            <div class="plan-id">Plan ID: 1</div>
                            <div class="plan-details">Affordable plan for light users</div>
                            <div class="plan-price">Price: $50/month</div>
                        </div>

                        <!-- Standard Plan Card -->
                        <div class="plan-card standard-plan" onclick="triggerPostback('2')">
                            <i class="fas fa-users"></i>
                            <div class="plan-name">Standard Plan</div>
                            <div class="plan-id">Plan ID: 2</div>
                            <div class="plan-details">Ideal for moderate users</div>
                            <div class="plan-price">Price: $100/month</div>
                        </div>

                        <!-- Premium Plan Card -->
                        <div class="plan-card premium-plan" onclick="triggerPostback('3')">
                            <i class="fas fa-star"></i>
                            <div class="plan-name">Premium Plan</div>
                            <div class="plan-id">Plan ID: 3</div>
                            <div class="plan-details">Best for heavy users</div>
                            <div class="plan-price">Price: $200/month</div>
                        </div>

                        <!-- Unlimited Plan Card -->
                        <div class="plan-card unlimited-plan" onclick="triggerPostback('4')">
                            <i class="fas fa-infinity"></i>
                            <div class="plan-name">Unlimited Plan</div>
                            <div class="plan-id">Plan ID: 4</div>
                            <div class="plan-details">Unlimited calls, SMS, and data</div>
                            <div class="plan-price">Price: $300/month</div>
                        </div>
                    </div>
                </div>

                <!-- Section 1: Three Cards for Points, Cashback, and Exclusive Offers -->
                <div id="mainCards" runat="server" style="display: none;">
                    <div class="PlanCardsContainer">
                        <div class="plan-card basic-plan" id="points-card">
                            <div class="plan-name">Points</div>
                            <p>Total Points Earned: <span id="totalPoints" runat="server">0</span></p>
                        </div>
                        <div class="plan-card standard-plan" id="cashback-card">
                            <div class="plan-name">Cashback</div>
                            <p>Total Cashback Earned: <span id="totalCashback" runat="server">0</span></p>
                        </div>
                        <div class="plan-card premium-plan" id="exclusive-offers-card">
                            <div class="plan-name">Exclusive Offers</div>
                            <p>Total Offers Redeemed: <span id="totalOffers" runat="server">0</span></p>
                        </div>
                    </div>
                </div>

                <!-- Section 2: Number of Benefit Types with Pie Chart -->
                <div id="secondCards" runat="server" style="display: none;">
                    <div class="section">
                        <div class="cardBox2">
                            <!-- Card -->
                            <div class="card">
                                <div class="cardName">Number of Benefit Types</div>
                                <div class="numbers" id="benefitsTypeCount" runat="server">6</div>
                            </div>
                            <!-- Pie Chart -->
                            <div class="chart-container">
                                <canvas id="benefit-types-chart" width="400" height="400"></canvas>
                                <script src="script.js"></script>     
                            </div>
                        </div>
                    </div>
                </div>


                <!-- Section 3: Total Benefits Offered with Pie Chart -->
                <div id="thirdCards" runat="server" style="display: none;">
                    <div class="section">
                        <div class="cardBox2">
                            <div class="card">
                                <div class="cardName">Total Benefits Offered</div>
                                <div class="numbers" id="totalBenefits" runat="server">0</div>
                            </div>
                            <div class="chart-container">
                                <canvas id="benefits-status-chart" width="400" height="400"></canvas>
                                <script src="script.js"></script>    
                            </div>
                        </div>
                    </div>
                </div>
 



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
                    <asp:Button ID="DeleteButton" runat="server" CssClass="styled-button delete-button" Text="Delete" OnClick="DeleteBenefitsButton_Click" Style="display: none;" />
                </div>

                <div class="output-container">
                    <asp:Label ID="LabelOut" runat="server" CssClass="output-label" Text=""></asp:Label>
                </div>

                <!-- Data Tables -->
                <div class="table-responsive">
                    <table>
                        <tbody id="TableBody1" runat="server"></tbody>
                    </table>
                </div>
                <div class="table-responsive">
                    <table>
                        <tbody id="TableBody2" runat="server" style="display: none;"></tbody>
                    </table>
                </div>
                <div class="table-responsive">
                    <table>
                        <tbody id="TableBody3" runat="server" style="display: none;"></tbody>
                    </table>
                </div>
            </div>
        </div>
    </form>
</body> 
</html>