<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<style>
    /* --- Liquid Glass Footer Styles --- */
    .glass-footer {
        /* Liquid Glass Base */
        background: rgba(15, 15, 20, 0.3); 
        backdrop-filter: blur(24px) saturate(180%); 
        -webkit-backdrop-filter: blur(24px) saturate(180%);
        border-top: 1px solid rgba(255, 255, 255, 0.05);
        box-shadow: inset 0 1px 0 rgba(255, 255, 255, 0.05);
        
        padding: 60px 50px 20px 50px;
        font-family: 'Inter', sans-serif;
        color: #a0a0a0;
        margin-top: auto; 
    }

    .footer-container {
        display: flex;
        justify-content: space-between;
        flex-wrap: wrap;
        gap: 40px;
        max-width: 1200px;
        margin: 0 auto;
    }

    /* Brand Section (DESKTOP STYLES) */
    .footer-logo {
        height: 70px; 
        width: auto;
        margin-bottom: 40px; /* Replaced the <br><br> with clean CSS margin */
        display: block;
        margin-left: -170px;
        transform: scale(3.0); 
        transform-origin: left center; 
    }
    
    .footer-brand p {
        font-size: 14px;
        line-height: 1.6;
        max-width: 320px;
        margin: 0;
        margin-left: -120px;
    }

    /* Link Columns */
    .footer-section h3 {
        color: white;
        font-size: 16px;
        font-weight: 600;
        margin: 0 0 20px 0;
        letter-spacing: 0.5px;
    }
    .footer-links {
        list-style: none;
        padding: 0;
        margin: 0;
    }
    .footer-links li {
        margin-bottom: 12px;
    }
    .footer-links a {
        color: #a0a0a0;
        text-decoration: none;
        font-size: 14px;
        transition: all 0.3s ease;
        display: inline-block;
    }
    
    /* The Red Slide Hover Effect */
    .footer-links a:hover {
        color: #E23744;
        transform: translateX(5px); 
    }

    /* Bottom Copyright Bar */
    .footer-bottom {
        border-top: 1px solid rgba(255, 255, 255, 0.05);
        display: flex;
        justify-content: space-between;
        align-items: center;
        max-width: 1200px;
        margin: 40px auto 0 auto;
        padding-top: 20px;
        font-size: 13px;
    }
    .creators {
        color: white;
    }
    .creators span {
        color: #E23744;
        font-weight: 700;
    }

    /* =========================================================
       MOBILE RESPONSIVE OVERRIDES 
       This section activates only on screens smaller than 768px
       ========================================================= */
    @media (max-width: 768px) {
        .glass-footer { 
            padding: 40px 20px 20px 20px; 
        }
        
        .footer-container { 
            flex-direction: column; 
            gap: 40px; 
            text-align: center; /* Center everything! */
        }
        
        .footer-logo { 
            transform: scale(1.8); /* Scale it down for mobile */
            transform-origin: center; /* Scale from the middle, not the left */
            margin: 20px auto 30px auto; /* RESET the -170px margin and center it */
        }
        
        .footer-brand p { 
            text-align: center; 
            margin: 0 auto; /* RESET the -120px margin and center it */
        }

        .footer-section {
            display: flex;
            flex-direction: column;
            align-items: center; /* Centers the quick links perfectly */
        }

        .footer-bottom { 
            flex-direction: column; 
            gap: 15px; 
            text-align: center; 
        }
    }
</style>

<footer class="glass-footer">
    <div class="footer-container">
        <div class="footer-brand">
            <img src="images/Logo (2).png" alt="Vishakkunnu Logo" class="footer-logo">
            <br>
            <p>Revolutionizing the way you order food. Skip the line, book your table, and satisfy your cravings with seamless technology.</p>
        </div>

        <div class="footer-section">
            <h3>Quick Links</h3>
            <ul class="footer-links">
                <li><a href="index.jsp">Home</a></li>
                <li><a href="order.jsp">Menu & Order</a></li>
                <li><a href="index.jsp#about">About the Devs</a></li>
            </ul>
        </div>

        <div class="footer-section">
            <h3>Support</h3>
            <ul class="footer-links">
                <li><a href="index.jsp#contact">Contact Us</a></li>
            </ul>
        </div>
    </div>

    <div class="footer-bottom">
        <div>&copy; 2026 Vishakkunnu. All rights reserved.</div>
        
    </div>
</footer>