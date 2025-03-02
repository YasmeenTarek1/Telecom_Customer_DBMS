<%@ Page Language="C#" AutoEventWireup="true" CodeFile="TicketsPage.aspx.cs" Inherits="Telecom_Customer_Application.CustomerDashboard.TicketsPage" %>
<%@ Register Src="~/Controls/CustomerSidebar.ascx" TagName="Sidebar" TagPrefix="uc" %>

<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" rel="stylesheet">
    <meta charset="UTF-8">
    <title>Tickets Page</title>
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
                    document.querySelector('.ticket-detail-content .description .desc-value').textContent = description;
                    document.querySelector('.ticket-detail-content .priority .priority-value').textContent = priority;
                    document.querySelector('.ticket-detail-content .date .date-value').textContent = dateSubmitted;
                    document.querySelector('.ticket-detail-content .status .status-value').textContent = status.charAt(0).toUpperCase() + status.slice(1);

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

                <h3 id="TabHeading" class="tab-heading" style="margin: 30px auto 30px auto; font-size: 34px;">Tickets</h3>

                <div class="tickets-container">
                    <div class="ticket-list" id="TicketList" runat="server">
                        <!-- Tickets will be dynamically bound here -->
                    </div>
                    <div class="ticket-detail">
                        <div class="ticket-detail-content">
                            <h3>Ticket ID</h3>
                            <p class="description"><strong>Description:</strong> <span class="desc-value">[Description]</span></p>
                            <p class="priority"><strong>Priority:</strong> <span class="priority-value">[Priority]</span></p>
                            <p class="date"><strong>Submitted:</strong> <span class="date-value">[Date]</span></p>
                            <p class="status"><strong>Status:</strong> <span class="status-value">[Status]</span></p>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </form>
</body>
</html>