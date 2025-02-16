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