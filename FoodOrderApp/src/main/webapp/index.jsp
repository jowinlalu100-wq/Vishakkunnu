<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Vishakkunnu - Home</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&family=Playfair+Display:ital,wght@0,400;0,600;1,400&display=swap" rel="stylesheet">

    <style>
        /* --- Global & Single Page Styles --- */
        html { scroll-behavior: smooth; }

        body {
            margin: 0; font-family: 'Inter', sans-serif;
            background: radial-gradient(circle at top left, #1f0b0b, #0d0d0d 40%);
            background-attachment: fixed; color: white; overflow-x: hidden;
            min-height: 100vh;
        }

        section {
            min-height: 100vh; display: flex; flex-direction: column;
            justify-content: center; padding: 80px 20px; box-sizing: border-box;
        }

        /* --- 1. Hero / Home Section --- */
        #home { 
            position: relative; /* Crucial: traps the video inside this section */
            align-items: center; 
            text-align: center; 
            overflow: hidden; /* Ensures the video doesn't bleed out */
        }

        .home-bg-video {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            object-fit: cover;
            z-index: 0; /* Pushes video to the back */
        }

        .home-video-overlay {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0, 0, 0, 0.5); /* Darkens the video slightly */
            z-index: 1;
        }

        .hero-container {
            position: relative;
            z-index: 2; /* Keeps the card above the video and overlay */
            width: 100%; max-width: 450px; padding: 50px 40px;
            background: rgba(26, 26, 26, 0.1); backdrop-filter: blur(2px);
            border: 1px solid rgba(255, 255, 255, 0.08); border-radius: 24px;
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.5);
        }

        #home h1 { margin-top: 0; letter-spacing: -0.5px; font-size: 36px; font-weight: 700; }
        #home p { color: #a0a0a0; line-height: 1.6; margin-bottom: 35px; font-size: 16px; }

        .btn {
            display: inline-block; width: 85%; padding: 16px; background: white; color: black; 
            text-decoration: none; font-weight: 700; font-size: 16px; border-radius: 12px; 
            transition: all 0.3s ease; box-shadow: 0 4px 15px rgba(255, 255, 255, 0.1);
        }
        .btn:hover { background: #f0f0f0; transform: translateY(-2px); box-shadow: 0 6px 20px rgba(255, 255, 255, 0.2); }

       /* --- 1.5 CRED-STYLE STORY SECTION --- */
        #story {
            background: #000000; 
            height: 350vh; 
            width: 100%; 
            padding: 0;
            margin: 0;
            display: block; 
        }

        .story-sticky-container {
            position: sticky;
            top: 0;
            width: 100%;
            height: 100vh; 
            background: #000000; 
            display: flex;
            flex-direction: column; 
            justify-content: center; /* This safely centers everything vertically! */
            align-items: flex-start; 
            padding-left: 15%; 
            padding-right: 15%;
            box-sizing: border-box;
            overflow: hidden; 
        }

        /* THE NEW CRED-STYLE KICKER TEXT */
        .story-kicker {
            font-family: 'Inter', sans-serif;
            font-size: 22px;
            font-weight: 700;
            letter-spacing: 4px; /* Wide tracking for that premium look */
            text-transform: uppercase;
            color: #ffffff; /* Solid white so it stays visible */
            margin-bottom: 40px; /* Pushes the main paragraph down */
        }

        .story-text {
            font-family: 'Playfair Display', serif; 
            font-size: 3vw; 
            line-height: 1.5; 
            margin: 0;
            max-width: 900px; 
            width: 100%;
        }

        /* Responsive font size for phones */
        @media (max-width: 768px) { 
            .story-text { font-size: 22px; } 
            .story-kicker { font-size: 11px; margin-bottom: 25px; }
            .story-sticky-container { padding-top: 25vh; }
        }

        .story-text span {
            color: rgba(255, 255, 255, 0.15);
            transition: color 0.1s ease-out; 
        }
        /* --- 2. About Us Section --- */
        /* --- ABOUT SECTION: SCROLL PINNED EXPERIENCE --- */
#about {
    height: 300vh;
    padding: 0;
    display: block;
    min-height: unset;
}

.about-sticky {
    position: sticky;
    top: 0;
    width: 100%;
    height: 100vh;
    overflow: hidden;
}

/* PANEL 1: Restaurant video background */
.about-panel-restaurant {
    position: absolute;
    top: 0; left: 0;
    width: 100%; height: 100%;
    display: flex;
    align-items: center;
    justify-content: center;
    z-index: 1;
    transform: translateX(0%);
    transition: transform 0.9s cubic-bezier(0.16, 1, 0.3, 1);
}

.about-panel-restaurant.slide-out {
    transform: translateX(-100%);
}

.about-video-bg {
    position: absolute;
    top: 0; left: 0;
    width: 100%; height: 100%;
    object-fit: cover;
    z-index: 0;
    clip-path: inset(0% 10% 0% 10%);
}

.about-video-overlay {
    position: absolute;
    top: 0; left: 0;
    width: 100%; height: 100%;
    background: linear-gradient(135deg, rgba(0,0,0,0.6) 0%, rgba(20,5,5,0.75) 100%);
    z-index: 1;
}

.about-restaurant-content {
    position: relative;
    z-index: 2;
    text-align: center;
    max-width: 700px;
    padding: 40px 30px;
    opacity: 0;
    transform: translateY(30px);
    transition: opacity 0.8s ease, transform 0.8s ease;
}

.about-restaurant-content.visible {
    opacity: 1;
    transform: translateY(0);
}

.about-restaurant-content .kicker {
    font-size: 11px;
    font-weight: 700;
    letter-spacing: 4px;
    text-transform: uppercase;
    color: #e63946;
    margin-bottom: 20px;
}

.about-restaurant-content h1 {
    font-family: 'Playfair Display', serif;
    font-size: clamp(32px, 5vw, 58px);
    font-weight: 600;
    line-height: 1.2;
    margin-bottom: 20px;
}

.about-restaurant-content p {
    color: rgba(255,255,255,0.7);
    font-size: 17px;
    line-height: 1.7;
    margin-bottom: 30px;
}

.about-scroll-hint {
    display: flex;
    flex-direction: column;
    align-items: center;
    gap: 8px;
    color: rgba(255,255,255,0.4);
    font-size: 12px;
    letter-spacing: 2px;
    text-transform: uppercase;
    animation: bounceDown 2s infinite;
}

.about-scroll-hint::after {
    content: '';
    display: block;
    width: 1px;
    height: 40px;
    background: linear-gradient(to bottom, rgba(255,255,255,0.4), transparent);
}

@keyframes bounceDown {
    0%, 100% { transform: translateY(0); }
    50% { transform: translateY(8px); }
}

/* PANEL 2: Team cards */
.about-panel-team {
    position: absolute;
    top: 0; left: 0;
    width: 100%; height: 100%;
    background: #0d0d0d;
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    padding: 60px 20px;
    box-sizing: border-box;
    z-index: 0;
    opacity: 0;
    transform: translateX(100%);
    transition: opacity 0.6s ease 0.3s, transform 0.9s cubic-bezier(0.16, 1, 0.3, 1);
}

.about-panel-team.visible {
    opacity: 1;
    z-index: 2;
    transform: translateX(0%);
}

.about-panel-team .about-header h1 {
    font-size: clamp(24px, 4vw, 40px);
    letter-spacing: -0.5px;
    margin-bottom: 12px;
    text-align: center;
}

.about-panel-team .subtitle {
    color: #b3b3b3;
    max-width: 600px;
    margin: 0 auto 50px auto;
    line-height: 1.6;
    font-size: 16px;
    text-align: center;
}

.team-container {
    display: flex;
    justify-content: center;
    gap: 30px;
    flex-wrap: wrap;
    max-width: 1000px;
}

.dev-card {
            width: 300px; 
            min-height: 410px; /* Gives the card height so the background photo looks good */
            padding: 35px 28px; 
            border-radius: 20px;
            border: 1px solid rgba(255,255,255,0.05); 
            box-shadow: 0 10px 25px rgba(0, 0, 0, 0.4);
            text-align: center; 
            opacity: 0; 
            transform: translateY(40px);
            transition: opacity 0.6s ease, transform 0.6s ease, box-shadow 0.3s ease;
            /* --- NEW BACKGROUND IMAGE SETTINGS --- */
            position: relative;
            overflow: hidden;
            background-size: cover;
            background-position: center;
            display: flex;
            flex-direction: column;
            justify-content: flex-end; /* Pushes the text to the bottom so faces are visible */
        }

        /* Adds a dark gradient over the bottom of the photo so the text is readable */
		.dev-card::before {
		    content: '';
		    position: absolute;
		    top: 0; 
		    left: 0; 
		    right: 0; 
		    bottom: -2px; /* Pulls the overlay slightly past the bottom edge to fix gaps */
		    
		    /* Changed the final color to 1 (100% opacity) to completely hide the white shirt */
		    background: linear-gradient(to bottom, rgba(0,0,0,0) 0%, rgba(0,0,0,0.8) 100%, rgba(0,0,0,1) 85%, rgba(0,0,0,1) 100%);
		    z-index: 1;
		    border-radius: inherit; /* Ensures the overlay perfectly matches the card's curved corners */
		}

        /* Ensures the text floats above the background image and gradient */
        .dev-card > div {
            position: relative;
            z-index: 2;
        }

        .dev-card.card-visible { opacity: 1; transform: translateY(0); }
        .dev-card.card-visible:hover { transform: translateY(-10px); box-shadow: 0 15px 35px rgba(230, 57, 70, 0.4); border-color: rgba(230, 57, 70, 0.5); }
        .dev-card:nth-child(2) { transition-delay: 0.15s; }

        /* The .profile-pic CSS is completely removed */
        .dev-name { font-size: 22px; font-weight: 700; margin-bottom: 5px; color: white; text-shadow: 0 2px 5px rgba(0,0,0,0.8); }
        .dev-role { color: #e63946; font-weight: 700; font-size: 12px; text-transform: uppercase; letter-spacing: 1px; margin-bottom: 16px; }
        .dev-bio { color: #d0d0d0; line-height: 1.6; font-size: 14px; }
		/* --- INDIVIDUAL PHOTO ADJUSTMENTS --- */
        
        /* Adjustments for Jowin's Card */
        #devCard1 {
            /* Change 'cover' to a percentage to zoom in or out (e.g., 100%, 120%, 150%) */
            background-size: cover; 
            
            /* Move the image around. First value is left/right, second is up/down. */
            /* Try: top center, bottom center, or exact percentages like 50% 20% */
            background-position: top center ; 
        }

        /* Adjustments for Athira's Card */
        #devCard2 {
            /* Example: Setting it to 120% zooms the photo in by 20% */
            background-size: 135%; 
            
            /* Example: Setting it to 'top center' anchors the top of the photo so heads aren't cut off */
            background-position: bottom center ; 
        }
@media (max-width: 768px) {
    #about { height: 350vh; }
    
}

        /* --- 3. Contact Us Section --- */
        #contact { align-items: center; }
        .contact-wrapper { display: flex; justify-content: center; gap: 40px; flex-wrap: wrap; max-width: 900px; width: 100%; }
        
        .contact-info, .contact-form {
            background: #1a1a1a; padding: 40px; border-radius: 20px; width: 380px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.3); border: 1px solid rgba(255, 255, 255, 0.05); box-sizing: border-box;
        }
        .contact-info h2, .contact-form h2 { margin-top: 0; color: #e63946; font-size: 28px; margin-bottom: 15px; }
        .contact-info p { color: #a0a0a0; line-height: 1.6; margin-bottom: 30px; font-size: 15px;}
        .info-item { display: flex; align-items: center; gap: 12px; margin-bottom: 20px; font-weight: 600; font-size: 15px;}

        .contact-form input, .contact-form textarea {
            width: 100%; padding: 15px; margin-bottom: 15px; border: 1px solid rgba(255,255,255,0.1); 
            border-radius: 10px; background: rgba(255,255,255,0.03); color: white; outline: none; box-sizing: border-box; font-family: 'Inter', sans-serif; transition: 0.3s;
        }
        .contact-form input:focus, .contact-form textarea:focus { background: rgba(255,255,255,0.08); border-color: #ff4d5a; box-shadow: 0 0 0 4px rgba(230, 57, 70, 0.1); }
        .contact-form button { width: 100%; padding: 16px; border: none; border-radius: 10px; background: white; color: black; font-weight: 700; font-size: 16px; cursor: pointer; transition: 0.3s; }
        .contact-form button:hover { background: #e63946; color: white; transform: translateY(-2px); box-shadow: 0 6px 20px rgba(230, 57, 70, 0.3); }

        /* --- Overlays & Modals --- */
        .overlay { position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(0, 0, 0, 0.7); backdrop-filter: blur(10px); z-index: 99; opacity: 0; visibility: hidden; transition: all 0.4s ease; }
        .overlay.active { opacity: 1; visibility: visible; }
        .model-container { position: fixed; top: 0; left: -50vw; width: 50vw; height: 100%; z-index: 100; transition: left 0.5s cubic-bezier(0.16, 1, 0.3, 1); pointer-events: none; background-color: transparent; }
        .model-container img, .model-container video { width: 100%; height: 100%; object-fit: cover; opacity: 0; transition: opacity 0.8s ease; }
        .model-container.active { left: 0; }
        .model-container.active img, .model-container.active video { opacity: 1; }
        @media (max-width: 850px) { .model-container { display: none; } }

        .auth-sidebar {
            position: fixed; top: 0; right: -450px; width: 400px; height: 100%; background: #121212; z-index: 100; box-shadow: -10px 0 30px rgba(0,0,0,0.8);
            border-left: 1px solid rgba(255,255,255,0.05); transition: right 0.5s cubic-bezier(0.16, 1, 0.3, 1); padding: 50px 40px; box-sizing: border-box; display: flex; flex-direction: column;
        }
        .auth-sidebar.active { right: 0; }
        .close-btn { align-self: flex-end; background: none; border: none; color: #888; font-size: 28px; cursor: pointer; margin-bottom: 30px; transition: 0.3s; }
        .close-btn:hover { color: white; }
        .auth-title { font-size: 28px; margin-bottom: 25px; font-weight: 700; letter-spacing: -0.5px; }

        .auth-form { display: none; }
        .auth-form.active { display: block; animation: slideUp 0.4s ease forwards; }
        @keyframes slideUp { from { opacity: 0; transform: translateY(20px); } to { opacity: 1; transform: translateY(0); } }

        .auth-form input { width: 100%; padding: 15px; margin: 10px 0; border: 1px solid rgba(255,255,255,0.1); border-radius: 10px; background: rgba(255,255,255,0.03); color: white; outline: none; box-sizing: border-box; font-family: 'Inter', sans-serif; transition: 0.3s; }
        .auth-form input:focus { background: rgba(255,255,255,0.08); border-color: #ff4d5a; box-shadow: 0 0 0 4px rgba(230, 57, 70, 0.1); }
        .auth-form button { width: 100%; padding: 15px; margin-top: 20px; border: none; border-radius: 10px; background: #e63946; color: white; font-weight: 600; font-size: 16px; cursor: pointer; transition: 0.3s; }
        .auth-form button:hover { background: #ff4d5a; transform: translateY(-2px); box-shadow: 0 4px 15px rgba(230, 57, 70, 0.4); }

        .toggle-text { margin-top: 25px; font-size: 14px; color: #888; text-align: center; }
        .toggle-text span { color: white; cursor: pointer; font-weight: 600; transition: 0.3s; }
        .toggle-text span:hover { color: #ff4d5a; }

        #loginErrorMsg { display: none; background: rgba(230, 57, 70, 0.1); color: #ff4d5a; padding: 12px; border-radius: 8px; margin-bottom: 20px; font-size: 14px; text-align: center; border: 1px solid rgba(230, 57, 70, 0.3); font-weight: 500; }
    	
    </style>
</head>

<body>

<jsp:include page="navbar.jsp" />
<jsp:include page="loader.jsp" />
<section id="home">

    <video autoplay muted loop playsinline class="home-bg-video">
        <source src="images/Landing_video.mp4" type="video/mp4">
    </video>
    
    <div class="home-video-overlay"></div>

    <div class="hero-container">
        <h1>Ready to Order?!</h1>
        <p>Pre-book your table and experience the taste of home.</p>
        <a href="order.jsp" class="btn" >Book Your Table</a>
    </div>
</section>

<section id="story">
    <div class="story-sticky-container">
        
        <div class="story-kicker">there is a moment.</div>
        
        <p class="story-text" id="scrollText">
            usually around 4 pm. when the kerala sky turns grey. 
            and the mind wanders to one thing. a strong kattan chaya. 
            a crispy pazhampori. or maybe the irresistible aroma of a spicy pothu roast. 
            at Vishakkunnu, we don't just serve meals. we serve that exact emotion. 
            because we know a true malayali doesn't just eat to live. 
            we live to celebrate our cravings.
        </p>
        
    </div>
</section>

<section id="about">
    <div class="about-sticky">

        <!-- PANEL 1: Restaurant Background Video -->
        <div class="about-panel-restaurant" id="aboutPanelRestaurant">
            <!-- Replace the src with your own video file, e.g. videos/restaurant.mp4 -->
            <video class="about-video-bg" autoplay muted loop playsinline>
                <source src="images/Video.mp4" type="video/mp4">
                <!-- Fallback image if video fails -->
                <img src="images/restaurant-bg.jpg" alt="Restaurant atmosphere" style="width:100%;height:100%;object-fit:cover;">
            </video>
            <div class="about-video-overlay"></div>
            <div class="about-restaurant-content" id="aboutRestaurantContent">
                <div class="kicker">Est. 2024 · Ernakulam, Kerala</div>
                <h1>Food is not just fuel. It is memory.</h1>
                <p>
                    Vishakkunnu was born from a simple belief — that every meal should feel like coming home.
                    From sizzling pothu roast to crispy pazhampori, every dish tells a story of Kerala's
                    rich culinary soul.
                </p>
                <div class="about-scroll-hint">Scroll to meet the team</div>
            </div>
        </div>

        <!-- PANEL 2: Team Cards (slides in from left) -->
        <div class="about-panel-team" id="aboutPanelTeam">
            <div class="about-header">
                <h1>Meet the Minds Behind the Menu</h1>
                <p class="subtitle">
                    Vishakkunnu was built from the ground up to revolutionize the way you order food.
                    Combining sleek user interfaces with robust server-side architecture, our team is
                    passionate about coding the perfect dining experience.
                </p>
            </div>

            <div class="team-container">
                <div class="dev-card" id="devCard1" style="background-image: url('images/Jowin.png');">
                    <div class="dev-name">Jowin Lalu</div>
                    <div class="dev-role">FrontEnd Engineer</div>
                    <div class="dev-bio">A first-year MCA student with a B.Sc. in Computer Science. Passionate about crafting seamless, modern user experiences and exploring the world of DevOps.</div>
                </div>

                <div class="dev-card" id="devCard2" style="background-image: url('images/Athira.png');">
                    <div class="dev-name">Athira P S</div>
                    <div class="dev-role">Backend Engineer</div>
                    <div class="dev-bio">Holding a BCA Degree, Athira tackles the complex database architecture and server-side logic required to keep Vishakkunnu's orders running smoothly.</div>
                </div>
            </div>
        </div>

    </div>
</section>

<section id="contact" style="padding: 100px 20px; background-color: #0a0a0c; display: flex; justify-content: center; align-items: center;">
        <div style="background: rgba(15, 15, 20, 0.4); backdrop-filter: blur(20px); -webkit-backdrop-filter: blur(20px); border: 1px solid rgba(255, 255, 255, 0.05); padding: 50px; border-radius: 24px; width: 100%; max-width: 600px; box-shadow: 0 20px 40px rgba(0,0,0,0.5);">
            
            <h1 style="font-family: 'Amatic SC', cursive; font-size: 50px; color: white; text-align: center; margin-top: 0; margin-bottom: 10px;">Get in Touch</h1>
            <p style="color: #a0a0a0; text-align: center; margin-bottom: 30px; font-size: 15px;">Have a question or feedback? Drop us a message!</p>
            
            <% if ("success".equals(request.getParameter("msg"))) { %>
                <div style="background: rgba(42, 157, 143, 0.2); color: #2a9d8f; padding: 15px; border-radius: 8px; text-align: center; margin-bottom: 20px; font-weight: 600;">
                    Message sent successfully! We will get back to you soon.
                </div>
            <% } %>

            <form action="ContactServlet" method="POST" style="display: flex; flex-direction: column; gap: 20px;">
                <input type="text" name="userName" placeholder="Your Name" required 
                       style="padding: 15px; border-radius: 10px; border: 1px solid rgba(255,255,255,0.1); background: rgba(0,0,0,0.3); color: white; font-family: 'Inter', sans-serif; font-size: 15px; outline: none;">
                
                <input type="email" name="userEmail" placeholder="Your Email Address" required 
                       style="padding: 15px; border-radius: 10px; border: 1px solid rgba(255,255,255,0.1); background: rgba(0,0,0,0.3); color: white; font-family: 'Inter', sans-serif; font-size: 15px; outline: none;">
                
                <textarea name="userMessage" placeholder="How can we help you?" rows="5" required 
                          style="padding: 15px; border-radius: 10px; border: 1px solid rgba(255,255,255,0.1); background: rgba(0,0,0,0.3); color: white; font-family: 'Inter', sans-serif; font-size: 15px; outline: none; resize: vertical;"></textarea>
                
                <button type="submit" 
                        style="background: #E23744; color: white; border: none; padding: 16px; border-radius: 10px; font-size: 16px; font-weight: 700; cursor: pointer; transition: 0.3s; font-family: 'Inter', sans-serif;">
                    Send Message
                </button>
            </form>
        </div>
    </section>

<div class="overlay" id="overlay" onclick="closeAuth()"></div>

<div class="model-container" id="modelContainer">
    <img src="images/hungry-character.gif" alt="Hungry Character">
</div>

<div class="auth-sidebar" id="authSidebar">
    <button class="close-btn" onclick="closeAuth()">&times;</button>

    <div class="auth-form active" id="loginForm">
        <div class="auth-title">Welcome Back</div>
        <div id="loginErrorMsg">Incorrect email or password. Please try again.</div>
        <form action="login" method="post">
            <input type="email" name="email" placeholder="Email Address" required>
            <input type="password" name="password" placeholder="Password" required>
            <button type="submit">Log In</button>
        </form>
        <div class="toggle-text">New to Vishakkunnu? <span onclick="switchForm('register')">Create an account</span></div>
        <div class="toggle-text" style="margin-top: 15px; font-size: 12px;">
            <span onclick="switchForm('admin')">🔒 Admin Portal</span>
        </div>
    </div>

    <div class="auth-form" id="registerForm">
        <div class="auth-title">Create Account</div>
        <form action="register" method="post">
            <input type="text" name="fullname" placeholder="Full Name" required>
            <input type="email" name="email" placeholder="Email Address" required>
            <input type="password" name="password" placeholder="Password" required>
            <button type="submit">Sign Up</button>
        </form>
        <div class="toggle-text">Already have an account? <span onclick="switchForm('login')">Log in</span></div>
    </div>

    <div class="auth-form" id="adminLoginForm">
        <div class="auth-title" style="color: #E23744;">Admin Access</div>
        <p style="color: #888; font-size: 14px; margin-top: -15px; margin-bottom: 25px;">Authorized personnel only.</p>
        <form action="adminLogin" method="post">
            <input type="text" name="username" placeholder="Admin ID" required>
            <input type="password" name="password" placeholder="Admin Password" required>
            <button type="submit" style="background: #E23744;">Access Dashboard</button>
        </form>
        <div class="toggle-text">Not an admin? <span onclick="switchForm('login')">Return to User Login</span></div>
    </div>
</div>

<script>
    // --- AUTH LOGIC ---
    const overlay = document.getElementById('overlay');
    const sidebar = document.getElementById('authSidebar');
    const modelContainer = document.getElementById('modelContainer');
    const loginForm = document.getElementById('loginForm');
    const registerForm = document.getElementById('registerForm');
    const adminLoginForm = document.getElementById('adminLoginForm');
    const loginErrorMsg = document.getElementById('loginErrorMsg');

    window.onload = function() {
        const urlParams = new URLSearchParams(window.location.search);
        if (urlParams.get('error') === 'invalid_login') {
            openAuth(); 
            loginErrorMsg.style.display = 'block'; 
            window.history.replaceState(null, null, window.location.pathname);
        }
    };

    function openAuth() { overlay.classList.add('active'); sidebar.classList.add('active'); modelContainer.classList.add('active'); switchForm('login'); }
    function closeAuth() { overlay.classList.remove('active'); sidebar.classList.remove('active'); modelContainer.classList.remove('active'); }
    
    function switchForm(formType) {
        // Hide all forms first
        loginForm.classList.remove('active');
        registerForm.classList.remove('active');
        adminLoginForm.classList.remove('active');

        // Show the requested form
        if (formType === 'register') { 
            registerForm.classList.add('active'); 
        } else if (formType === 'admin') {
            adminLoginForm.classList.add('active');
        } else { 
            loginForm.classList.add('active'); 
        }
    }
    
    // -- (Keep your existing CRED-Style scroll script here below this) --

    // --- CRED-STYLE SCROLL LIGHTING LOGIC ---
    document.addEventListener('DOMContentLoaded', () => {
        const storyText = document.getElementById('scrollText');
        if(!storyText) return;

        // 1. Break the paragraph into individual words wrapped in <span> tags
        const words = storyText.innerText.split(' ');
        storyText.innerHTML = '';
        words.forEach(word => {
            const span = document.createElement('span');
            span.innerText = word + ' ';
            storyText.appendChild(span);
        });

        const spans = storyText.querySelectorAll('span');
        const storySection = document.getElementById('story');

        
     // 2. Listen to the scroll event
        window.addEventListener('scroll', () => {
            const rect = storySection.getBoundingClientRect();
            const windowHeight = window.innerHeight;
            
            // Calculate how far the user has scrolled INTO the #story section
            const scrolled = -rect.top; 
            // Calculate the total scrollable distance
            const scrollableDistance = rect.height - windowHeight;

            // MULTIPLIER TRICK: We multiply scrollableDistance by 0.8. 
            // This forces the lighting animation to hit 100% when you are only 80% of the way down the section!
            let progress = scrolled / (scrollableDistance * 0.8);
            
            if (progress < 0) progress = 0;
            if (progress > 1) progress = 1;

            const highlightCount = Math.floor(progress * spans.length);

            // Light up the words sequentially
            spans.forEach((span, index) => {
                if (index < highlightCount) {
                    span.style.color = 'rgba(255, 255, 255, 1)'; 
                } else {
                    span.style.color = 'rgba(255, 255, 255, 0.15)'; 
                }
            });
        });
    });
 // --- ABOUT SECTION SCROLL LOGIC ---
    (function() {
        const aboutSection = document.getElementById('about');
        const panelRestaurant = document.getElementById('aboutPanelRestaurant');
        const restaurantContent = document.getElementById('aboutRestaurantContent');
        const panelTeam = document.getElementById('aboutPanelTeam');
        const card1 = document.getElementById('devCard1');
        const card2 = document.getElementById('devCard2');

        if (!aboutSection) return;

        window.addEventListener('scroll', () => {
            const rect = aboutSection.getBoundingClientRect();
            const scrolled = -rect.top;
            const total = rect.height - window.innerHeight;
            const progress = Math.min(Math.max(scrolled / total, 0), 1);

            // Phase 1: 0–30% → fade in restaurant content
            if (progress > 0.05) {
                restaurantContent.classList.add('visible');
            } else {
                restaurantContent.classList.remove('visible');
            }

            // Phase 2: 50%+ → slide restaurant panel out, reveal team panel
            if (progress > 0.5) {
                panelRestaurant.classList.add('slide-out');
                panelTeam.classList.add('visible');
                // Stagger card reveal
                setTimeout(() => card1.classList.add('card-visible'), 100);
                setTimeout(() => card2.classList.add('card-visible'), 250);
            } else {
                panelRestaurant.classList.remove('slide-out');
                panelTeam.classList.remove('visible');
                card1.classList.remove('card-visible');
                card2.classList.remove('card-visible');
            }
        });
    })();
</script>
<jsp:include page="footer.jsp" />
</body>
</html>