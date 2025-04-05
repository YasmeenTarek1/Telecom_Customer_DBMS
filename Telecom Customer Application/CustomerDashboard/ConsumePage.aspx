<%@ Page Language="C#" AutoEventWireup="true" CodeFile="ConsumePage.aspx.cs" Inherits="Telecom_Customer_Application.CustomerDashboard.ConsumePage" %>
<%@ Register Src="~/Controls/CustomerSidebar.ascx" TagName="Sidebar" TagPrefix="uc" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" rel="stylesheet" />
    <meta charset="UTF-8" />
    <title>Consume Page</title>
</head>
<body>
    <form id="form1" runat="server">
        <uc:Sidebar runat="server" />
        <div id="sharedContent" class="tab-content">

            <h3 id="TabHeading" class="tab-heading" style="margin: 40px 31% 50px 31%; font-size: 34px;">Consume Resources</h3>

            <div class="grid-container">
                <div class="grid-item">
                    <i class="fas fa-comment"></i>
                    <p>SMS</p>
                    <div class="counter">
                        <button type="button" onclick="updateCounter('sms', -1)">-</button>
                        <input type="number" id="smsCounter" value="0" min="0" oninput="handleManualInput('sms')" />
                        <button type="button" onclick="updateCounter('sms', 1)">+</button>
                    </div>
                    <input type="hidden" id="smsHidden" name="smsCounter" value="0" />
                </div>
                <div class="grid-item">
                    <i class="fas fa-phone"></i>
                    <p>Minutes</p>
                    <div class="counter">
                        <button type="button" onclick="updateCounter('minutes', -1)">-</button>
                        <input type="number" id="minutesCounter" value="0" min="0" oninput="handleManualInput('minutes')" />
                        <button type="button" onclick="updateCounter('minutes', 1)">+</button>
                    </div>
                    <input type="hidden" id="minutesHidden" name="minutesCounter" value="0" />
                </div>
                <div class="grid-item">
                    <i class="fas fa-wifi"></i>
                    <p>Data (GB)</p>
                    <div class="counter">
                        <button type="button" onclick="updateCounter('data', -1)">-</button>
                        <input type="number" id="dataCounter" value="0" min="0" oninput="handleManualInput('data')" />
                        <button type="button" onclick="updateCounter('data', 1)">+</button>
                    </div>
                    <input type="hidden" id="dataHidden" name="dataCounter" value="0" />
                </div>
            </div>
            <asp:Button ID="btnConsume" runat="server" Text="Consume Resources" CssClass="submit-btn" OnClick="btnConsume_Click" />
        </div>
        <script type="text/javascript">
            function updateCounter(type, change) {
                const counter = document.getElementById(type + 'Counter');
                const hiddenInput = document.getElementById(type + 'Hidden');

                let value = parseInt(counter.value) || 0;
                value = Math.max(0, value + change);

                counter.value = value;
                hiddenInput.value = value;
            }

            function handleManualInput(type) {
                const counter = document.getElementById(type + 'Counter');
                const hiddenInput = document.getElementById(type + 'Hidden');

                let value = parseInt(counter.value) || 0;
                value = Math.max(0, value);

                counter.value = value;
                hiddenInput.value = value;
            }
        </script>
    </form>
</body>
</html>