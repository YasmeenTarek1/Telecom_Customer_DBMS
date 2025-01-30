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

// Prevent dropdown from closing when clicking inside it
document.querySelectorAll('.dropdown-content').forEach(dropdown => {
    dropdown.addEventListener('click', function (event) {
        event.stopPropagation(); // Stop the click event from bubbling up to the parent
    });
});

// benefits types pie chart
document.addEventListener("DOMContentLoaded", function () {
    if (typeof benefitTypesData !== 'undefined') {
        var ctx = document.getElementById('benefit-types-chart').getContext('2d');

        // Sort the data by benefitID
        benefitTypesData.sort((a, b) => a.benefitID - b.benefitID);

        var data = benefitTypesData.map(item => item.Percentage); 

        var myPieChart = new Chart(ctx, {
            type: 'pie',
            data: {
                labels: [
                    'Extra 1GB data per month',
                    'Free 100 SMS per month',
                    'Extra 100 minutes per month',
                    '10% cashback on plan renewal',
                    '20% cashback on plan renewal',
                    'Earn 50 loyalty points per month'
                ],
                datasets: [{
                    data: data,
                    backgroundColor: [
                        '#D3D3D3', // Bright Grey
                        '#00FFFF', 
                        '#00b3e0', 
                        '#0a6aa9', 
                        '#0a3d8c',
                        '#03184c'  // Darkest blue
                    ],
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: {
                        align: 'start',
                        labels: {
                            color: '#2a3d56', 
                            font: {
                                size: 14,
                            },
                        }
                    },
                    title: {
                        position: 'bottom',
                        display: true,
                        text: 'Customer Benefit Distribution'
                    },
                    tooltip: {
                        callbacks: {
                            label: function (context) {
                                let label = context.label || '';
                                let value = context.raw || 0;
                                return `${label}: ${value}%`;
                            }
                        }
                    }
                }
            }
        });
    }
});

document.addEventListener("DOMContentLoaded", function () {
    if (typeof cashbackPlanData !== 'undefined') {
        var ctx = document.getElementById('cashback-plan-chart').getContext('2d');

        var labels = cashbackPlanData.map(item => item.PlanName); 
        var data = cashbackPlanData.map(item => item.Percentage); 

        var myPieChart = new Chart(ctx, {
            type: 'pie',
            data: {
                labels: labels, 
                datasets: [{
                    data: data, 
                    backgroundColor: [
                        '#00FFFF',
                        '#00b3e0',
                        '#0a6aa9',
                        '#03184c'
                    ],
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: {
                        align: 'start',
                        labels: {
                            color: '#2a3d56',
                            font: {
                                size: 14,
                            },
                        }
                    },
                    title: {
                        position: 'bottom',
                        display: true,
                        text: 'Cashback Distribution by Plan'
                    },
                    tooltip: {
                        callbacks: {
                            label: function (context) {
                                let label = context.label || '';
                                let value = context.raw || 0;
                                return `${label}: ${value}%`;
                            }
                        }
                    }
                }
            }
        });
    }
});

// benefits status pie chart
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
                        '#02194C',
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
                        position: 'bottom',
                        display: true,
                        text: 'Active vs Expired Benefits'
                    },
                    tooltip: {
                        callbacks: {
                            label: function (context) {
                                let label = context.label || '';
                                let value = context.raw || 0;
                                return `${label}: ${value}%`;
                            }
                        }
                    }
                }
            }
        });
    }
}); 


document.addEventListener("DOMContentLoaded", function () {
    if (typeof data !== 'undefined') {
        var ctx = document.getElementById('subscriptionPieChart').getContext('2d');

        var subscriptionPieChart = new Chart(ctx, {
            type: 'pie',
            data: {
                labels: Object.keys(data),
                datasets: [{
                    data: Object.values(data),
                    backgroundColor: [
                        '#00FFFF',
                        '#00b3e0',
                        '#0a6aa9',
                        '#03184c'
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
                        position: 'bottom',
                        display: true,
                        text: 'Subscription Rates for Each Plan'
                    },
                    tooltip: {
                        callbacks: {
                            label: function (context) {
                                let label = context.label || '';
                                let value = context.raw || 0;
                                return `${label}: ${value}%`;
                            }
                        }
                    }
                }
            }
        });
    }
});

document.addEventListener("DOMContentLoaded", function () {
    if (typeof topCustomersData !== 'undefined') {
        var ctx = document.getElementById('top-customers-chart').getContext('2d');

        // Extract labels and data from topCustomersData
        var labels = topCustomersData.map(item => `${item.first_name} ${item.last_name}`); // Combine first and last name
        var data = topCustomersData.map(item => item['Total Cashback Earned']); // Use total cashback earned

        var myBarChart = new Chart(ctx, {
            type: 'bar',
            data: {
                labels: labels, // Customer names as labels
                datasets: [{
                    label: 'Total Cashback Earned',
                    data: data, // Total cashback earned as data
                    backgroundColor: [
                        '#00FFFF',
                        '#00b3e0',
                        '#0a6aa9',
                        '#03184c',
                        '#2a3d56'
                    ],
                    borderColor: [
                        '#00FFFF',
                        '#00b3e0',
                        '#0a6aa9',
                        '#03184c',
                        '#2a3d56'
                    ],
                    borderWidth: 1
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: {
                        display: false // Hide legend for a cleaner look
                    },
                    title: {
                        display: true,
                        text: 'Top 5 Customers by Cashback Earned',
                        font: {
                            size: 16
                        }
                    },
                    tooltip: {
                        callbacks: {
                            label: function (context) {
                                let label = context.dataset.label || '';
                                let value = context.raw || 0;
                                return `${label}: ${value}`;
                            }
                        }
                    }
                },
                scales: {
                    y: {
                        beginAtZero: true,
                        title: {
                            display: true,
                            text: 'Total Cashback Earned'
                        }
                    },
                    x: {
                        title: {
                            display: true,
                            text: 'Customers'
                        }
                    }
                }
            }
        });
    }
});
function togglePanel() {
    const panel = document.getElementById('rightSidePanel');
    panel.classList.toggle('open');
}

function triggerPostback(planId) {
    __doPostBack('PlanClicked', planId);  // Triggers the postback with the correct event args
}

function triggerPostback2(benefitID) {
    __doPostBack('BenefitClicked', benefitID);  
}