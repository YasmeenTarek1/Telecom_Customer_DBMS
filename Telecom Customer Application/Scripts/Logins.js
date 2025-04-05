document.addEventListener("DOMContentLoaded", function () {
    const togglePassword = document.querySelector("#togglePassword");
    const passwordField = document.querySelector("#txtPassword");

    togglePassword.addEventListener("click", function () {
        // Toggle the type attribute
        const type = passwordField.getAttribute("type") === "password" ? "text" : "password";
        passwordField.setAttribute("type", type);

        // Toggle the eye icon
        this.classList.toggle("fa-eye");
        this.classList.toggle("fa-eye-slash");
    });
});
document.addEventListener("DOMContentLoaded", function () {
    const footer = document.getElementById("Footer");
    const contactLink = document.querySelector(".nav a[href='#Footer']");

    // Function to check if the footer is in the viewport
    function isFooterInViewport() {
        const rect = footer.getBoundingClientRect();
        return (
            rect.top <= window.innerHeight && rect.bottom >= 0
        );
    }

    // Function to show the footer
    function showFooter() {
        footer.classList.add("visible");
    }

    // Show the footer when it comes into the viewport while scrolling
    document.addEventListener("scroll", function () {
        if (isFooterInViewport()) {
            showFooter();
        }
    });

    // Scroll to the footer and show it when the "Contact" link is clicked
    contactLink.addEventListener("click", function (e) {
        e.preventDefault(); // Prevent default anchor behavior
        footer.scrollIntoView({ behavior: "smooth" }); // Smooth scroll to footer
        showFooter(); // Make the footer visible
    });
});

document.addEventListener("DOMContentLoaded", function () {
    const footer = document.getElementById("Footer");
    const contactLink = document.querySelector(".nav a[href='#Footer']");
    function isFooterInViewport() {
        const rect = footer.getBoundingClientRect();
        return (
            rect.top <= window.innerHeight && rect.bottom >= 0
        );
    }

    function showFooter() {
        footer.classList.add("visible");
    }

    // Show the footer when it comes into the viewport while scrolling
    document.addEventListener("scroll", function () {
        if (isFooterInViewport()) {
            showFooter();
        }
    });

    // Scroll to the footer and show it when the "Contact" link is clicked
    contactLink.addEventListener("click", function (e) {
        e.preventDefault(); // Prevent default anchor behavior
        footer.scrollIntoView({ behavior: "smooth" }); 
        showFooter(); 
    });
});