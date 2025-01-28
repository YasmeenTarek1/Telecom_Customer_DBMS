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
    const dropdownStates = document.getElementById('dropdownStates');

    // Restore the state of each dropdown individually
    const storesDropdownState = document.getElementById(dropdownStates.dataset.storesDropdown).value;
    const plansDropdownState = document.getElementById(dropdownStates.dataset.plansDropdown).value;
    const transactionDropdownState = document.getElementById(dropdownStates.dataset.transactionDropdown).value;

    if (storesDropdownState === "open") {
        document.querySelector('#shopsTab + .dropdown-content').style.display = "block";
    }
    if (plansDropdownState === "open") {
        document.querySelector('#plansTab + .dropdown-content').style.display = "block";
    }
    if (transactionDropdownState === "open") {
        document.querySelector('#transactionsTab + .dropdown-content').style.display = "block";
    }
};

if (typeof __doPostBack === 'undefined') {
    function __doPostBack(eventTarget, eventArgument) {
        const form = document.getElementById('form1');
        if (!form) {
            console.error('Form not found');
            return;
        }

        const targetInput = document.createElement('input');
        targetInput.type = 'hidden';
        targetInput.name = '__EVENTTARGET';
        targetInput.value = eventTarget;

        const argumentInput = document.createElement('input');
        argumentInput.type = 'hidden';
        argumentInput.name = '__EVENTARGUMENT';
        argumentInput.value = eventArgument;

        form.appendChild(targetInput);
        form.appendChild(argumentInput);
        form.submit();
    }
}

function triggerPostback(planId) {
    __doPostBack('PlanClicked', planId);
}

// Prevent dropdown from closing when clicking inside it
document.querySelectorAll('.dropdown-content').forEach(dropdown => {
    dropdown.addEventListener('click', function (event) {
        event.stopPropagation(); // Stop the click event from bubbling up to the parent
    });
});
// Initialize the benefit types chart
document.addEventListener("DOMContentLoaded", function () {
    if (typeof benefitTypesData !== 'undefined') {
        var ctx = document.getElementById('benefit-types-chart').getContext('2d');

        // Extract labels and data from the JSON
        var labels = benefitTypesData.map(item => item.benefitID); // Use benefitID as labels
        var data = benefitTypesData.map(item => item.Percentage); // Use Percentage as data

        // If the chart already exists, update its data
        if (myPieChart) {
            myPieChart.data.labels = labels;
            myPieChart.data.datasets[0].data = data;
            myPieChart.update(); // Update the chart
            return;
        }

        // If the chart doesn't exist, create it
        var myPieChart = new Chart(ctx, {
            type: 'pie',
            data: {
                labels: labels,
                datasets: [{
                    data: data,
                    backgroundColor: ['#36A2EB', '#4BC0C0', '#FFCE56', '#FF6384', '#9966FF', '#FF9F40'], // Same color scheme as second chart 
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
            }
        });
    }
});



// Initialize the benefits status chart
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
                        '#4BC0C0',//Green
                        'rgb(234, 37, 26)'//Red
                    ]
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

let subscriptionPieChart; // Global variable to store the chart instance

function togglePanel() {
    const panel = document.getElementById('rightSidePanel');
    panel.classList.toggle('open');

    // Fetch and update chart data when the panel is opened
    if (panel.classList.contains('open')) {
        fetchSubscriptionData();
    }
}

function initializeChart(data) {
    const ctx = document.getElementById('subscriptionPieChart').getContext('2d');

    // If the chart already exists, update its data
    if (subscriptionPieChart) {
        subscriptionPieChart.data.labels = Object.keys(data);
        subscriptionPieChart.data.datasets[0].data = Object.values(data);
        subscriptionPieChart.update(); // Update the chart
        return;
    }

    // If the chart doesn't exist, create it
    subscriptionPieChart = new Chart(ctx, {
        type: 'pie',
        data: {
            labels: Object.keys(data),
            datasets: [{
                data: Object.values(data),
                backgroundColor: ['#36A2EB', '#4BC0C0', '#FFCE56', '#FF6384'],
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
        }
    });
}

function fetchSubscriptionData() {
    fetch('PlansPage.aspx/GetSubscriptionStatistics', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
        },
    })
        .then(response => {
            if (!response.ok) {
                throw new Error(`HTTP error! Status: ${response.status}`);
            }
            return response.json();
        })
        .then(data => {
            if (data.d) {
                initializeChart(data.d); // Initialize or update the chart with dynamic data
            } else {
                console.error('API response does not contain data.');
            }
        })
        .catch(error => {
            console.error('Error fetching subscription data:', error);
        });
}

document.addEventListener('DOMContentLoaded', function () {
    fetchSubscriptionData(); // Fetch the chart data when the page loads
});
function triggerPostback(planId) {
    __doPostBack('PlanClicked', planId);  // Triggers the postback with the correct event args
}
