<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<% 
    String user = (String) session.getAttribute("loggedInUser"); 
%>

<style>
    /* --- LIQUID GLASS NAVBAR STYLES (DESKTOP) --- */
    nav {
        position: sticky; 
        top: 0; 
        background: rgba(15, 15, 20, 0.3); 
        backdrop-filter: blur(24px) saturate(180%); 
        -webkit-backdrop-filter: blur(24px) saturate(180%);
        padding: 15px 50px; 
        display: flex; 
        justify-content: space-between;
        align-items: center; 
        z-index: 1000; 
        font-family: 'Inter', sans-serif;
        box-shadow: 0 15px 35px rgba(0, 0, 0, 0.5), 
                    inset 0 1px 0 rgba(255, 255, 255, 0.15),
                    inset 0 -1px 0 rgba(255, 255, 255, 0.05);
        border-bottom: 1px solid rgba(255, 255, 255, 0.05);
        transition: all 0.4s ease;
    }

    .logo { display: block; text-decoration: none; }
    
    .logo img {
        height: 45px; 
        width: auto;
        display: block;
        transform: scale(1.8); 
        transform-origin: left center; 
        margin-left: 10px; 
    }
    
    .nav-links { display: flex; gap: 20px; align-items: center; }
    .nav-links a {
        color: #b3b3b3; text-decoration: none; padding: 8px 12px;
        border-radius: 8px; font-weight: 600; font-size: 15px; transition: all 0.3s ease;
    }
    
    .nav-links a:hover { 
        color: white; 
        background: rgba(255, 255, 255, 0.08); 
        box-shadow: inset 0 1px 0 rgba(255, 255, 255, 0.1);
    }
    .nav-links a.active { 
        color: white; 
        background: rgba(255, 255, 255, 0.12); 
        box-shadow: inset 0 1px 0 rgba(255, 255, 255, 0.15);
    }

    .login-trigger {
        background: rgba(255, 255, 255, 0.05); color: white; border: 1px solid rgba(255,255,255,0.2);
        padding: 8px 24px; border-radius: 30px; font-weight: 600; font-size: 15px;
        cursor: pointer; transition: all 0.3s ease; backdrop-filter: blur(10px);
    }
    .login-trigger:hover { background: white; color: black; transform: translateY(-2px); }

    .user-profile {
        display: flex; align-items: center; gap: 15px;
        background: rgba(0, 0, 0, 0.4); padding: 6px 6px 6px 18px;
        border-radius: 30px; border: 1px solid rgba(255,255,255,0.08);
    }
    .greeting { font-weight: 600; color: #E23744; font-size: 14px; }
    .logout-btn { 
        background: white; color: black !important; padding: 6px 18px !important; 
        border-radius: 20px !important; font-size: 13px; transition: 0.3s; 
    }
    .logout-btn:hover { background: #e6e6e6; transform: scale(1.05); }

    /* --- Hamburger Icon (Hidden on Desktop) --- */
    .menu-icon {
        display: none;
        color: white;
        font-size: 28px;
        cursor: pointer;
        user-select: none;
    }

    /* =========================================================
       MOBILE RESPONSIVE OVERRIDES (WITH DROPDOWN MENU)
       ========================================================= */
    @media (max-width: 768px) {
        nav { padding: 12px 20px !important; }
        
        .logo img { 
            transform: scale(1.3) !important; /* Safe mobile size */
            margin-left: 0 !important; 
            height: 35px !important; 
        }

        /* Show the Hamburger Menu Icon */
        .menu-icon { display: block !important; margin-left: auto; }

        /* Turn nav-links into a hidden dropdown menu */
        .nav-links { 
            display: none !important; /* Hidden by default on mobile */
            position: absolute;
            top: 100%; /* Sits exactly below the navbar */
            left: 0;
            width: 100%;
            background: rgba(15, 15, 20, 0.95); /* Solid dark glass */
            backdrop-filter: blur(24px);
            flex-direction: column;
            padding: 20px 0;
            gap: 15px;
            box-shadow: 0 15px 30px rgba(0,0,0,0.7);
            border-bottom: 1px solid rgba(255,255,255,0.1);
        }

        /* This class is added by Javascript when the button is clicked */
        .nav-links.show-mobile-menu {
            display: flex !important;
        }
        
        /* Center the links inside the dropdown */
        .nav-links a { 
            display: block !important; 
            text-align: center;
            width: 100%;
            padding: 12px 0 !important;
            font-size: 16px !important;
        }
        
        /* Center the login/profile buttons in the dropdown */
        .login-trigger, .user-profile { 
            margin: 10px auto !important; 
            justify-content: center;
        }
    }
</style>

<nav>
    <a href="index.jsp" class="logo">
        <img src="images/Logo (2).png" alt="Vishakkunnu Logo" />
    </a>
    
    <div class="menu-icon" onclick="toggleMobileMenu()">☰</div>
    
    <div class="nav-links" id="navLinksContainer">
        <a href="index.jsp">Home</a>
        <a href="order.jsp">Book Now</a>

        <% if (user != null) { %>
            <a href="your_booking.jsp">Your Bookings</a>
        <% } %>

        <a href="index.jsp#about">About Us</a>
        <a href="index.jsp#contact">Contact</a>

        <% if (user != null) { %>
            <div class="user-profile">
                <span class="greeting">Hi, <%= user %>!</span>
                <a href="logoutServlet" class="logout-btn">Logout</a>
            </div>
        <% } else { %>
            <button class="login-trigger" onclick="openAuth()">Log in</button>
        <% } %>
    </div>
</nav>

<script>
    // 1. Mobile Menu Toggle Logic
    function toggleMobileMenu() {
        const navMenu = document.getElementById("navLinksContainer");
        navMenu.classList.toggle("show-mobile-menu");
    }

    // 2. Smarter Active Link Logic
    document.addEventListener("DOMContentLoaded", function() {
        let currentPath = window.location.pathname.split('/').pop() || 'index.jsp';
        let currentHash = window.location.hash; 
        let navLinks = document.querySelectorAll("#navLinksContainer a");
        
        navLinks.forEach(link => {
            let linkHref = link.getAttribute("href");
            link.classList.remove("active");

            // Don't apply 'active' to the logout button
            if(link.classList.contains('logout-btn')) return;

            if (currentHash) {
                if (linkHref.includes(currentHash)) {
                    link.classList.add("active");
                }
            } else if (linkHref === currentPath) {
                link.classList.add("active");
            }
        });
    });
</script>