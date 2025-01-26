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
