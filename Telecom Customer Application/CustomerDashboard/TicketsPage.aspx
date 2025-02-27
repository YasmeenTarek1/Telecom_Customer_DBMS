<%@ Page Language="C#" AutoEventWireup="true" CodeFile="TicketsPage.aspx.cs" Inherits="Telecom_Customer_Application.CustomerDashboard.TicketsPage" %>
<%@ Register Src="~/Controls/CustomerSidebar.ascx" TagName="Sidebar" TagPrefix="uc" %>

<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" rel="stylesheet">
    <meta charset="UTF-8">
    <title>Tickets Page</title>
    <script src="../Scripts/Dashboards.js"></script>
    <link href="../Styles/Dashboards.css" rel="stylesheet"/>
    <style>
        .tickets-container {
            display: flex;
            width: 100%;
            flex-direction: row;
            gap:30px;
        }

        .ticket-list {
            display: flex;
            width: 500px;
            flex-direction: column;
            gap: 50px;
            padding: 20px;
            background: #f5f5f5;
            margin-left: 50px;
            margin-bottom: 50px;
        }

        .ticket-card {
            position: relative;
            padding: 15px;
            cursor: pointer;
            overflow: hidden;
            transition: transform 0.3s ease;
            background-size: cover;
            background-position: center;
            background-repeat: no-repeat;
            width: 100%;
            display: flex;
            flex-direction: column;
            aspect-ratio: 500 / 230;
            justify-content: center;
            align-items: center; 
        }

        .ticket-card::before,
        .ticket-card::after {
            content: "";
            position: absolute;
            width: 5px;
            height: 100%;
            background: rgba(0, 0, 0, 0.1);
            top: 0;
            z-index: -1;
        }

        .ticket-card::before {
            left: -5px;
            border-radius: 5px 0 0 5px;
        }
        .ticket-card::after {
            right: -5px;
            border-radius: 0 5px 5px 0;
        }
        .ticket-card:hover {
            transform: translateY(-5px) scale(1.02);
        }

        /* Ticket backgrounds */
        .ticket-card.resolved {
            background-image: url('../Images/greenTicket.png'); 
        }
        .ticket-card.in-progress {
            background-image: url('../Images/yellowTicket.png'); 
        }
        .ticket-card.open {
            background-image: url('../Images/redTicket.png'); 
        }

        /* Overlay to ensure text readability */
        .ticket-detail {
            width: 550px;
            height: min-content;
            padding: 30px;
            padding-left: 60px;
            background: #fff;
            border-radius: 15px;
            box-shadow: 0 8px 16px rgba(0, 0, 0, 0.2);
            position: fixed; 
            align-self: flex-start; 
            display: none;
            margin: 170px auto auto 820px;
            background: linear-gradient(135deg, #fff, #f8f9fa);
            transition: transform 0.3s ease, opacity 0.3s ease; 
        }

        .ticket-id {
            font-weight: bold;
            font-size: 34px; 
            color: #fff;
            display: block; 
            margin-bottom: 10px;
        }

        .ticket-status {
            font-size: 22px;
            margin-top: 15px;
            color: #fff;
            display: block;
        }

        .ticket-content {
            position: relative;
            z-index: 1;
            padding: 10px;
            border-radius: 5px;
            text-align: center;
        }

        .ticket-detail.active {
            display: inline-block;
            transform: translateY(0); 
        }
        .ticket-detail.resolved {
            border: 3px solid #28a745;
        }
        .ticket-detail.in-progress {
            border: 3px solid #ffc107;
        }
        .ticket-detail.open {
            border: 3px solid #dc3545;
        }

        .ticket-detail-content .ticket-info {
            margin: 15px 0;
            line-height: 1.6;
            font-weight: 500;
            text-align: left; 
            display: block; 
            margin-left: 50px; 
        }

        .ticket-detail-content h3 {
            margin-top: 0;
            color: #000;
            font-size: 32px; 
            text-align: center;
            font-weight: bold;
            text-transform: uppercase; 
            letter-spacing: 1px; 
        }

        .ticket-detail-content p {
            margin: 15px 0; 
            line-height: 1.6; 
            font-weight: 500; 
            text-align: left
        }
    </style>
    <script>
        document.addEventListener('DOMContentLoaded', function () {
            const tickets = document.querySelectorAll('.ticket-card');
            const detail = document.querySelector('.ticket-detail');

            tickets.forEach(ticket => {
                ticket.addEventListener('click', function () {
                    const status = this.getAttribute('data-status');
                    const ticketId = this.querySelector('.ticket-id').textContent;
                    const description = this.getAttribute('data-description');
                    const priority = this.getAttribute('data-priority');
                    const dateSubmitted = this.getAttribute('data-date');

                    // Update detail content
                    document.querySelector('.ticket-detail-content h3').textContent = ticketId;
                    document.querySelector('.ticket-detail-content .description').textContent = `Description: ${description}`;
                    document.querySelector('.ticket-detail-content .priority').textContent = `Priority: ${priority}`;
                    document.querySelector('.ticket-detail-content .date').textContent = `Submitted: ${dateSubmitted}`;
                    document.querySelector('.ticket-detail-content .status').textContent = `Status: ${status.charAt(0).toUpperCase() + status.slice(1)}`;

                    // Apply status class to detail
                    detail.className = `ticket-detail ${status}`;
                    detail.classList.add('active');
                });
            });

            // Close on click outside 
            document.addEventListener('click', function (e) {
                if (!detail.contains(e.target) && !Array.from(tickets).some(t => t.contains(e.target))) {
                    detail.classList.remove('active');
                }
            });
        });
    </script>
</head>
<body>
    <form id="form1" runat="server">
        <div class="container" runat="server">
            <uc:Sidebar runat="server" />
            <div id="sharedContent" class="tab-content">

                <h3 id="TabHeading" class="tab-heading" style="margin: 40px auto 50px auto; font-size: 34px;">Tickets</h3>

                <div class="tickets-container">
                    <div class="ticket-list" id="TicketList" runat="server">
                        <!-- Tickets will be dynamically bound here -->
                    </div>
                    <div class="ticket-detail">
                        <div class="ticket-detail-content">
                            <h3>Ticket ID</h3>
                            <p class="description">Description: [Description]</p>
                            <p class="priority">Priority: [Priority]</p>
                            <p class="date">Submitted: [Date]</p>
                            <p class="status">Status: [Status]</p>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </form>
</body>
</html>