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
    // Add null check for dropdownStates
    if (dropdownStates && dropdownStates.dataset && dropdownStates.dataset.storesDropdown) {
        // Restore the state of each dropdown individually
        const storesDropdownState = document.getElementById(dropdownStates.dataset.storesDropdown).value;

        if (storesDropdownState === "open") {
            document.querySelector('#shopsTab + .dropdown-content').style.display = "block";
        }
    } else {
        console.warn('dropdownStates element or its dataset is not available');
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
                maintainAspectRatio: true,
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
                maintainAspectRatio: true,
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
    if (window.location.pathname.includes("PlansPage.aspx") && typeof subscriptionsData !== 'undefined') {
        let ctx = document.getElementById('subscriptionPieChart')?.getContext('2d');

        // Destroy existing chart if it exists
        if (subscriptionChartInstance != null) {
            subscriptionChartInstance.destroy();
        }

        var labels = subscriptionsData.map(item => item.PlanName);
        var data = subscriptionsData.map(item => item.Percentage);

        subscriptionChartInstance = new Chart(ctx, {
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
                maintainAspectRatio: true,
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
                maintainAspectRatio: true,
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
                maintainAspectRatio: true,
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
                maintainAspectRatio: true,
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
                maintainAspectRatio: true,
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
                maintainAspectRatio: true,
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
                maintainAspectRatio: true,
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
                maintainAspectRatio: true,
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
                maintainAspectRatio: true,
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


document.addEventListener("DOMContentLoaded", function () {
    if (window.location.pathname.includes("BenefitsPage.aspx") && typeof benefitsStatusData !== 'undefined') {
        let ctx = document.getElementById('benefits-status-chart')?.getContext('2d');
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
                    backgroundColor: ['#02194C', 'rgb(234, 37, 26)']
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: true,
                plugins: {
                    legend: { position: 'top' },
                    title: { position: 'bottom', display: true, text: 'Active vs Expired Benefits' },
                    tooltip: { callbacks: { label: function (context) { let label = context.label || ''; let value = context.raw || 0; return `${label}: ${value}%`; } } }
                }
            }
        });
    }
});

function triggerPostback(planId, clickedElement) {
    const planCards = document.querySelectorAll('.plan-card');
    planCards.forEach(card => card.classList.remove('plan-card-selected'));
    clickedElement.classList.add('plan-card-selected');

    __doPostBack('PlanClicked', planId);
}
function updatePlanSelection(planId) {
    const planCards = document.querySelectorAll('.plan-card');
    planCards.forEach(card => card.classList.remove('plan-card-selected'));

    const selectedCard = document.querySelector(`.plan-card:nth-child(${planId})`);
    if (selectedCard) {
        selectedCard.classList.add('plan-card-selected');
    }
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


var benefitTypesChartInstance = null;
var benefitsStatusChartInstance = null;

let currentChartIndex = 0;
let charts;

function updateChartDisplay() {
    charts.forEach((chart, index) => {
        const shouldBeVisible = index === currentChartIndex;
        chart.style.display = shouldBeVisible ? 'block' : 'none';
        chart.classList.toggle('active', shouldBeVisible);
    });
    const prevButton = document.getElementById('prevChart');
    const nextButton = document.getElementById('nextChart');
    if (prevButton) prevButton.disabled = currentChartIndex === 0;
    if (nextButton) nextButton.disabled = currentChartIndex === charts.length - 1;
}

function prevChart(event) {
    event.preventDefault();
    if (currentChartIndex > 0) {
        currentChartIndex--;
        updateChartDisplay();
    }
}

function nextChart(event) {
    event.preventDefault();
    if (currentChartIndex < charts.length - 1) {
        currentChartIndex++;
        updateChartDisplay();
    }
}

function togglePanel() {
    const panel = document.getElementById('rightSidePanel');
    panel.classList.toggle('open');
    if (panel.classList.contains('open')) {
        setTimeout(() => {
            updateChartDisplay();
            if (benefitTypesChartInstance) benefitTypesChartInstance.resize();
            if (benefitsStatusChartInstance) benefitsStatusChartInstance.resize();
        }, 300);
    }
}

function initializeCharts() {
    if (window.location.pathname.includes("BenefitsPage.aspx")) {
        const benefitCtx = document.getElementById('benefit-types-chart');
        if (benefitCtx && typeof benefitTypesData !== 'undefined') {
            if (benefitTypesChartInstance) benefitTypesChartInstance.destroy();
            benefitTypesData.sort((a, b) => a.benefitID - b.benefitID);
            benefitTypesChartInstance = new Chart(benefitCtx.getContext('2d'), {
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
                        data: benefitTypesData.map(item => item.Percentage),
                        backgroundColor: ['#D3D3D3', '#00FFFF', '#00b3e0', '#0a6aa9', '#0a3d8c', '#03184c']
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: true,
                    plugins: {
                        legend: { align: 'start', labels: { color: '#2a3d56', font: { size: 14 } } },
                        title: { position: 'bottom', display: true, text: 'Customer Benefit Distribution' },
                        tooltip: { callbacks: { label: context => `${context.label}: ${context.raw}%` } }
                    }
                }
            });
        }
    }
}

document.addEventListener('DOMContentLoaded', () => {
    charts = document.querySelectorAll('.chart-container');
    initializeCharts();
    updateChartDisplay();

    const prevButton = document.getElementById('prevChart');
    const nextButton = document.getElementById('nextChart');
    if (prevButton) {
        prevButton.addEventListener('click', prevChart);
    }
    if (nextButton) {
        nextButton.addEventListener('click', nextChart);
    }
});

// Wallet page functionality
function initializeWalletPage() {
    const mobileNo = document.getElementById('HiddenMobileNo').value;

    if (mobileNo) {
        fetchCustomerData(mobileNo);
    } else {
        console.error('Mobile number not found in session');
        updateCreditCard('Unknown', 'User', 'N/A');
        updateStats(0, 0, 0, 0);
    }

    checkForStoredAlerts();

    // Transfer arrows
    const transferCells = document.querySelectorAll('#TableBody1 tr td:first-child');
    transferCells.forEach(cell => {
        if (cell.textContent.trim() === 'Sent') {
            cell.innerHTML = '';
            cell.classList.add('transfer-arrow-sent');
        } else if (cell.textContent.trim() === 'Received') {
            cell.innerHTML = '';
            cell.classList.add('transfer-arrow-received');
        }
    });

    // Styling Due Amount
    const dueAmountCells = document.querySelectorAll('#TableBody2 tr td:nth-child(3)');
    dueAmountCells.forEach(cell => {
        const dueAmountText = cell.textContent.trim();
        const amountValue = parseFloat(dueAmountText.replace(' egp', ''));
        if (!isNaN(amountValue) && amountValue > 0) {
            cell.classList.add('due-amount-red');
        }
    });

    // Credit card hover effect
    const creditCardBox = document.querySelector('.credit-card-box');
    creditCardBox.addEventListener('mouseenter', () => creditCardBox.classList.add('hover'));
    creditCardBox.addEventListener('mouseleave', () => creditCardBox.classList.remove('hover'));

    // Event listeners for action boxes
    document.getElementById('rechargeBox').addEventListener('click', function () {
        document.getElementById('rechargeDialog').classList.add('active');
    });

    document.getElementById('transferBox').addEventListener('click', function () {
        document.getElementById('transferDialog').classList.add('active');
    });

    // Close dialog buttons
    document.querySelectorAll('.close-dialog, .cancel-btn').forEach(function (element) {
        element.addEventListener('click', function () {
            document.querySelectorAll('.dialog-overlay').forEach(function (dialog) {
                dialog.classList.remove('active');
            });
        });
    });

    // Recharge confirmation
    document.getElementById('confirmRecharge').addEventListener('click', function () {
        const amount = document.getElementById('rechargeAmount').value;
        const paymentMethod = document.getElementById('paymentMethod').value;
        const mobileNo = document.getElementById('HiddenMobileNo').value;

        if (!amount || amount <= 0) {
            displayClientAlert("Please enter a valid amount", "alert-danger");
            return;
        }

        rechargeBalance(mobileNo, amount, paymentMethod);
    });

    // Transfer confirmation
    document.getElementById('confirmTransfer').addEventListener('click', function () {
        const recipientMobile = document.getElementById('recipientMobile').value;
        const amount = document.getElementById('transferAmount').value;
        const mobileNo = document.getElementById('HiddenMobileNo').value;

        if (!recipientMobile || recipientMobile.length < 10) {
            displayClientAlert("Please enter a valid recipient mobile number", "alert-danger");
            return;
        }

        if (!amount || amount <= 0) {
            displayClientAlert("Please enter a valid amount", "alert-danger");
            return;
        }

        transferMoney(mobileNo, recipientMobile, amount);
    });
}

// Fetching Wallet Info
function fetchCustomerData(mobileNo) {
    fetch('WalletPage.aspx/GetCustomerInfo', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
            'Cache-Control': 'no-cache'
        },
        body: JSON.stringify({ mobileNo: mobileNo })
    })
    .then(response => {
        if (!response.ok) {
            throw new Error(`HTTP error! status: ${response.status}`);
        }
        return response.json();
    })
    .then(data => {
        if (data.d) {
            const customerData = JSON.parse(data.d);
            if (!customerData.error) {
                updateCreditCard(customerData.first_name, customerData.last_name, customerData.mobileNo);
                updateStats(
                    customerData.balance || 0,
                    customerData.cashback || 0,
                    customerData.sentTransactions || 0,
                    customerData.receivedTransactions || 0
                );
            } else {
                throw new Error(customerData.error);
            }
        } else {
            throw new Error('Invalid response format');
        }
    })
    .catch(error => {
        updateCreditCard('Unknown', 'User', mobileNo);
        updateStats(0, 0, 0, 0);
        console.error('Fetch error:', error);
        storeAlertMessage(error.message, "alert-danger");
    });
}

function updateCreditCard(firstName, lastName, mobileNo) {
    const formattedMobileNo = mobileNo.match(/.{1,4}/g)?.join(' ') || mobileNo;
    document.querySelector('.card-holder div').textContent = `${firstName} ${lastName}`;
    document.querySelector('.number').textContent = formattedMobileNo;
    document.querySelector('.ccv div').textContent = '***';
    document.querySelector('.card-expiration-date div').textContent = '12/25';
}

function updateStats(balance, cashback, sent, received) {
    document.getElementById('balance').textContent = `$${balance.toLocaleString()}`;
    document.getElementById('cashback').textContent = `$${cashback.toLocaleString()}`;
    document.getElementById('sent').textContent = `$${sent.toLocaleString()}`;
    document.getElementById('received').textContent = `$${received.toLocaleString()}`;
}

// Function to recharge balance
function rechargeBalance(mobileNo, amount, paymentMethod) {
    fetch('WalletPage.aspx/RechargeBalance', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
            'Cache-Control': 'no-cache'
        },
        body: JSON.stringify({
            mobileNo: mobileNo,
            amount: amount,
            paymentMethod: paymentMethod
        })
    })
    .then(response => {
        if (!response.ok) {
            throw new Error(`HTTP error! status: ${response.status}`);
        }
        return response.json();
    })
    .then(data => {
        if (data.d && JSON.parse(data.d).success) {
            document.getElementById('rechargeDialog').classList.remove('active');

            // Store alert before refresh
            storeAlertMessage("Balance recharged successfully", "alert-success");

            // Update the balance in UI
            const currentBalance = parseFloat(document.getElementById('balance').textContent.replace('$', '').replace(',', ''));
            document.getElementById('balance').textContent = `$${(currentBalance + parseFloat(amount)).toLocaleString()}`;
        } else {
            throw new Error(data.d ? JSON.parse(data.d).error : 'Unknown error occurred');
        }
    })
    .catch(error => {
        console.error('Error recharging balance:', error);
        storeAlertMessage(error.message, "alert-danger");
    });
}

// Function to transfer money
function transferMoney(senderMobile, recipientMobile, amount) {
    fetch('WalletPage.aspx/TransferMoney', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
            'Cache-Control': 'no-cache'
        },
        body: JSON.stringify({
            senderMobile: senderMobile,
            recipientMobile: recipientMobile,
            amount: amount
        })
    })
    .then(response => {
        if (!response.ok) {
            throw new Error(`HTTP error! status: ${response.status}`);
        }
        return response.json();
    })
    .then(data => {
        if (data.d && JSON.parse(data.d).success) {
            document.getElementById('transferDialog').classList.remove('active');

            // Store alert before refresh
            storeAlertMessage("Money transferred successfully!", "alert-success");

            // Update the balance and sent transactions in UI
            const currentBalance = parseFloat(document.getElementById('balance').textContent.replace('$', '').replace(',', ''));
            const currentSent = parseFloat(document.getElementById('sent').textContent.replace('$', '').replace(',', ''));
            document.getElementById('balance').textContent = `$${(currentBalance - parseFloat(amount)).toLocaleString()}`;
            document.getElementById('sent').textContent = `$${(currentSent + parseFloat(amount)).toLocaleString()}`;
        } else {
            throw new Error(data.d ? JSON.parse(data.d).error : 'Unknown error occurred');
        }
    })
    .catch(error => {
        console.error('Error transferring money:', error);
        storeAlertMessage(error.message, "alert-danger");
    });
}

// Store alert message before refresh
function storeAlertMessage(message, alertType) {
    localStorage.setItem('walletAlertMessage', message);
    localStorage.setItem('walletAlertType', alertType);
}

// Display client alert that persists through refresh
function displayClientAlert(message, alertType, shouldStore = false) {
    const alertDiv = document.createElement('div');
    alertDiv.className = `alert ${alertType}`;
    alertDiv.innerHTML = message;
    alertDiv.style.position = 'fixed';
    alertDiv.style.top = '20px';
    alertDiv.style.left = '50%';
    alertDiv.style.transform = 'translateX(-50%)';
    alertDiv.style.padding = '15px';
    alertDiv.style.zIndex = '9999';
    document.body.appendChild(alertDiv);
    setTimeout(() => alertDiv.remove(), 3500);

    // Store before page refresh
    if (shouldStore) {
        storeAlertMessage(message, alertType);
    }
}

// Check for stored alert messages when page loads
function checkForStoredAlerts() {
    const message = localStorage.getItem('walletAlertMessage');
    const alertType = localStorage.getItem('walletAlertType');

    if (message && alertType) {
        // Display the stored alert
        displayClientAlert(message, alertType);

        // Clear the stored alert
        localStorage.removeItem('walletAlertMessage');
        localStorage.removeItem('walletAlertType');
    }
}

// Initialize wallet page when the DOM is fully loaded
document.addEventListener('DOMContentLoaded', function () {
    initializeWalletPage();
});

// Toggle tooltip in Plans Page
document.addEventListener('DOMContentLoaded', function () {
    var tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'));
    tooltipTriggerList.map(function (tooltipTriggerEl) {
        return new bootstrap.Tooltip(tooltipTriggerEl);
    });
});

// Toggle ticket detail on click in Tickets Page
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

function initializeTicketsPage() {
    const IssueTicketButton = document.getElementById('IssueTicketButton');
    if (IssueTicketButton) {
        IssueTicketButton.addEventListener('click', function () {
            document.getElementById('IssueTicketDialog').classList.add('active');
        });
    } else {
        console.error('IssueTicketButton not found');
    }

    document.querySelectorAll('.close-dialog, .cancel-btn').forEach(function (element) {
        element.addEventListener('click', function () {
            document.getElementById('IssueTicketDialog').classList.remove('active');
        });
    });

    const confirmTicket = document.getElementById('confirmTicket');
    if (confirmTicket) {
        confirmTicket.addEventListener('click', function () {
            const description = document.getElementById('ticketDescription').value;
            const priority = document.getElementById('ticketPriority').value;
            const mobileNo = document.getElementById('HiddenMobileNo')?.value;
            submitTicket(mobileNo, description, priority);
        });
    } else {
        console.error('confirmTicket not found');
    }
}

document.addEventListener('DOMContentLoaded', initializeTicketsPage);
function submitTicket(mobileNo, description, priority) {
    if (!description) {
        storeAlertMessage('Please enter a ticket description', "alert-danger");
        return;
    }

    // Prepare ticket data
    const ticketData = {
        mobileNo: mobileNo,
        description: description,
        priority: parseInt(priority)
        // submissionDate will be set server-side
    };

    fetch('TicketsPage.aspx/SubmitTicket', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
            'Cache-Control': 'no-cache'
        },
        body: JSON.stringify(ticketData)
    })
    .then(response => {
        if (!response.ok) {
            throw new Error(`HTTP error! status: ${response.status}`);
        }
        return response.json();
    })
    .then(data => {
        if (data.d && JSON.parse(data.d).success) {
            document.getElementById('IssueTicketDialog').classList.remove('active');

            // Store alert before any potential refresh
            storeAlertMessage("Ticket issued successfully!", "alert-success");

        } else {
            throw new Error(data.d ? JSON.parse(data.d).error : 'Unknown error occurred');
        }
    })
    .catch(error => {
        console.error('Error submitting ticket:', error);
        storeAlertMessage(error.message, "alert-danger");
    });
}

function deleteBenefit(button) {
    try {
        if (confirm('Are you sure you want to delete this benefit?')) {
            var row = button.closest('tr');

            console.log('Delete button clicked');

            var mobileNumberCell = row.querySelector('td:nth-child(3)'); 
            var planCell = row.querySelector('td:nth-child(5)'); 

            var mobileNumber = mobileNumberCell.innerText.trim();
            var planName = planCell.innerText.trim();

            var planId = 0;
            switch (planName.toLowerCase()) {
                case "basic plan": planId = 1; break;
                case "standard plan": planId = 2; break;
                case "premium plan": planId = 3; break;
                case "unlimited plan": planId = 4; break;
                default:
                    console.error('Unknown plan name:', planName);
                    alert('Error: Unknown plan type');
                    return;
            }

            var argument = mobileNumber + "|" + planId;

            console.log('Argument:', argument);

            __doPostBack('DeleteBenefit', argument);
        }
    } catch (error) {
        console.error('Error in deleteBenefit function:', error);
        alert('An error occurred while trying to delete the benefit');
    }
}