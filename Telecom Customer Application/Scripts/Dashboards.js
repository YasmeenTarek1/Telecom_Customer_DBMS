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

    if (storesDropdownState === "open") {
        document.querySelector('#shopsTab + .dropdown-content').style.display = "block";
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

var benefitTypesChartInstance = null;
var benefitsStatusChartInstance = null;
var subscriptionChartInstance = null;
var cashbackPlanChartInstance = null;
var topCustomersChartInstance = null;
var pointsChartInstance = null;
var topPointsChartInstance = null;
var offersPlanChartInstance = null;
var topSMSChartInstance = null;
var topMinutesChartInstance = null;
var topInternetChartInstance = null;


// benefits types pie chart
document.addEventListener("DOMContentLoaded", function () {
    if (window.location.pathname.includes("BenefitsPage.aspx") && !typeof benefitTypesData !== 'undefined') {
        let ctx = document.getElementById('benefit-types-chart')?.getContext('2d');

        // Destroy existing chart if it exists
        if (benefitTypesChartInstance !== null) {
            benefitTypesChartInstance.destroy();
        }

        // Sort the data by benefitID
        benefitTypesData.sort((a, b) => a.benefitID - b.benefitID);

        var data = benefitTypesData.map(item => item.Percentage); 

        benefitTypesChartInstance = new Chart(ctx, {
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
                responsive: false,
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
    // benefits status pie chart
    if (typeof benefitsStatusData !== 'undefined') {
        let ctx = document.getElementById('benefits-status-chart')?.getContext('2d');

        // Destroy existing chart if it exists
        if (benefitsStatusChartInstance != null) {
            benefitsStatusChartInstance.destroy();
        }

        var labels = benefitsStatusData.map(item => item.status.charAt(0).toUpperCase() + item.status.slice(1));
        var data = benefitsStatusData.map(item => item.Percentage);

        benefitsStatusChartInstance = new Chart(ctx, {
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
                responsive: false,
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
    if (window.location.pathname.includes("PlansPage.aspx")  && typeof data !== 'undefined') {
        let ctx = document.getElementById('subscriptionPieChart')?.getContext('2d');


        // Destroy existing chart if it exists
        if (subscriptionChartInstance != null) {
            subscriptionChartInstance.destroy();
        }

        subscriptionChartInstance = new Chart(ctx, {
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
                responsive: false,
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
    if (window.location.pathname.includes("CashbackPage.aspx") && typeof cashbackPlanData !== 'undefined') {
        let ctx = document.getElementById('cashback-plan-chart')?.getContext('2d');

        // Destroy existing chart if it exists
        if (cashbackPlanChartInstance != null) {
            cashbackPlanChartInstance.destroy();
        }

        var labels = cashbackPlanData.map(item => item.PlanName);
        var data = cashbackPlanData.map(item => item.Percentage);

        cashbackPlanChartInstance = new Chart(ctx, {
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
                responsive: false,
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

    if (typeof topCustomersData !== 'undefined') {
        let ctx = document.getElementById('top-customers-chart')?.getContext('2d');

        // Destroy existing chart if it exists
        if (topCustomersChartInstance != null) {
            topCustomersChartInstance.destroy();
        }

        var labels = topCustomersData.map(item => `${item.first_name} ${item.last_name}`); 
        var data = topCustomersData.map(item => item['Total Cashback Earned']); 

        topCustomersChartInstance = new Chart(ctx, {
            type: 'bar',
            data: {
                labels: labels,
                datasets: [{
                    label: 'Total Cashback Earned',
                    data: data, 
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
                responsive: false,
                maintainAspectRatio: false,
                plugins: {
                    legend: {
                        display: false 
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

document.addEventListener("DOMContentLoaded", function () {
    if (window.location.pathname.includes("PointsPage.aspx") && typeof pointsPlanData !== 'undefined') {
        let ctx = document.getElementById('points-plan-chart')?.getContext('2d');


        // Destroy existing chart if it exists
        if (pointsChartInstance != null) {
            pointsChartInstance.destroy();
        }

        var labels = pointsPlanData.map(item => item.PlanName);
        var data = pointsPlanData.map(item => item.Percentage);

        pointsChartInstance = new Chart(ctx, {
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
                    ]
                }]
            },
            options: {
                responsive: false,
                maintainAspectRatio: false,
                plugins: {
                    legend: {
                        position: 'top',
                    },
                    title: {
                        position: 'bottom',
                        display: true,
                        text: 'Points Distribution by Plan'
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

    if (typeof topCustomersPointsData !== 'undefined') {
        let ctx = document.getElementById('top-points-chart')?.getContext('2d');

        // Destroy existing chart if it exists
        if (topPointsChartInstance != null) {
            topPointsChartInstance.destroy();
        }

        var labels = topCustomersPointsData.map(item => `${item.first_name} ${item.last_name}`);
        var data = topCustomersPointsData.map(item => item['Total Points Earned']);

        topPointsChartInstance = new Chart(ctx, {
            type: 'bar',
            data: {
                labels: labels,
                datasets: [{
                    label: 'Total Points Earned',
                    data: data,
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
                responsive: false,
                maintainAspectRatio: false,
                plugins: {
                    legend: {
                        display: false
                    },
                    title: {
                        display: true,
                        text: 'Top 5 Customers by Points Earned',
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
                            text: 'Total Points Earned'
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



document.addEventListener("DOMContentLoaded", function () {
    if (window.location.pathname.includes("ExclusiveOffersPage.aspx") && typeof offersPlanData !== 'undefined') {
        let ctx = document.getElementById('offers-plan-chart')?.getContext('2d');

        // Destroy existing chart if it exists
        if (offersPlanChartInstance != null) {
            offersPlanChartInstance.destroy();
        }

        var labels = offersPlanData.map(item => item.PlanName);
        var data = offersPlanData.map(item => item.Percentage);

        offersPlanChartInstance = new Chart(ctx, {
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
                    ]
                }]
            },
            options: {
                responsive: false,
                maintainAspectRatio: false,
                plugins: {
                    legend: {
                        position: 'top',
                    },
                    title: {
                        position: 'bottom',
                        display: true,
                        text: 'Offers Distribution by Plan'
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

    if (window.location.pathname.includes("ExclusiveOffersPage.aspx") && typeof topSMSData !== 'undefined') {
        let ctx = document.getElementById('top-sms-chart')?.getContext('2d');

        // Destroy existing chart if it exists
        if (topSMSChartInstance != null) {
            topSMSChartInstance.destroy();
        }

        var labels = topSMSData.map(item => `${item.first_name} ${item.last_name}`);
        var data = topSMSData.map(item => item['Total SMS Earned']);

        topSMSChartInstance = new Chart(ctx, {
            type: 'bar',
            data: {
                labels: labels,
                datasets: [{
                    label: 'Total SMS Earned',
                    data: data,
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
                responsive: false,
                maintainAspectRatio: false,
                plugins: {
                    legend: {
                        display: false
                    },
                    title: {
                        display: true,
                        text: 'Top 5 Customers by SMS Earned',
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
                            text: 'Total SMS Earned'
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

    if (window.location.pathname.includes("ExclusiveOffersPage.aspx") && typeof topMinutesData !== 'undefined') {
        let ctx = document.getElementById('top-minutes-chart')?.getContext('2d');

        // Destroy existing chart if it exists
        if (topMinutesChartInstance != null) {
            topMinutesChartInstance.destroy();
        }

        var labels = topMinutesData.map(item => `${item.first_name} ${item.last_name}`);
        var data = topMinutesData.map(item => item['Total Minutes Earned']);

        topMinutesChartInstance = new Chart(ctx, {
            type: 'bar',
            data: {
                labels: labels,
                datasets: [{
                    label: 'Total Minutes Earned',
                    data: data,
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
                responsive: false,
                maintainAspectRatio: false,
                plugins: {
                    legend: {
                        display: false
                    },
                    title: {
                        display: true,
                        text: 'Top 5 Customers by Minutes Earned',
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
                            text: 'Total Minutes Earned'
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

    if (window.location.pathname.includes("ExclusiveOffersPage.aspx") && typeof topInternetData !== 'undefined') {
        let ctx = document.getElementById('top-data-chart')?.getContext('2d');

        // Destroy existing chart if it exists
        if (topInternetChartInstance != null) {
            topInternetChartInstance.destroy();
        }

        var labels = topInternetData.map(item => `${item.first_name} ${item.last_name}`);
        var data = topInternetData.map(item => item['Total Internet Earned']);

        topInternetChartInstance = new Chart(ctx, {
            type: 'bar',
            data: {
                labels: labels,
                datasets: [{
                    label: 'Total Data Earned',
                    data: data,
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
                responsive: false,
                maintainAspectRatio: false,
                plugins: {
                    legend: {
                        display: false
                    },
                    title: {
                        display: true,
                        text: 'Top 5 Customers by Data Earned',
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
                            text: 'Total Data Earned'
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

function toggleBenefits(planID) {
    var benefitsDiv = document.getElementById("benefits-" + planID);
    if (benefitsDiv.innerHTML.trim() === "") {
        fetch(`GetPlanBenefits.aspx?planID=${planID}`)
            .then(response => response.text())
            .then(data => {
                benefitsDiv.innerHTML = data;
                benefitsDiv.style.display = "block";
            });
    } else {
        benefitsDiv.style.display = (benefitsDiv.style.display === "none") ? "block" : "none";
    }
}

document.addEventListener("DOMContentLoaded", function () {
    // Apply circular progress effect
    document.querySelectorAll(".circle").forEach(circle => {
        let progress = circle.getAttribute("data-progress"); // Get progress from HTML
        circle.style.setProperty("--progress", progress + "%");
        circle.innerHTML = `<span>${progress}%</span>`; // Display percentage
    });
});