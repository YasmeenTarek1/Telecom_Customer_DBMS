﻿<%@ Page Language="C#" AutoEventWireup="true" CodeFile="TicketsPage.aspx.cs" Inherits="Telecom_Customer_Application.CustomerDashboard.TicketsPage" %>
<%@ Register Src="~/Controls/CustomerSidebar.ascx" TagName="Sidebar" TagPrefix="uc" %>

<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" rel="stylesheet">
    <meta charset="UTF-8">
    <title>Tickets Page</title>
</head>
<body>
    <form id="form1" runat="server">
        <div class="container" runat="server">
            <uc:Sidebar runat="server" />
            <div id="sharedContent" class="tab-content">

                <h3 id="TabHeading" class="tab-heading" style="margin: 40px auto 30px auto; font-size: 34px;">Tickets</h3>

                <!-- Issue a ticket Button -->
                <div id="IssueTicketButton" class="issue-ticket-button">
                    <i class="fa-solid fa-circle-plus"></i>
                </div>


                <div class="dialog-overlay" id="IssueTicketDialog">
                    <div class="dialog-content">
                        <div class="dialog-header">
                            <h3>Issue a New Ticket</h3>
                            <button class="close-dialog"><i class="fas fa-times"></i></button>
                        </div>
                        <div class="dialog-body">
                            <div class="form-group">
                                <label for="ticketDescription">Description</label>
                                <input type="text" id="ticketDescription" placeholder="Enter ticket description">
                            </div>
                            <div class="form-group">
                                <label for="ticketPriority">Priority</label>
                                <select id="ticketPriority">
                                    <option value="1">L1</option>
                                    <option value="2">L2</option>
                                    <option value="3">L3</option>
                                </select>
                            </div>
                        </div>
                        <div class="dialog-footer">
                            <button class="cancel-btn">Cancel</button>
                            <button class="action-btn" id="confirmTicket">Submit Ticket</button>
                        </div>
                    </div>
                </div>

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
        <asp:HiddenField ID="HiddenMobileNo" runat="server" />
    </form>
</body>
</html>