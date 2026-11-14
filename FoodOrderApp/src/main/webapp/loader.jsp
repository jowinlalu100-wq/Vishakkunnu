<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<style>
    @import url('https://fonts.googleapis.com/css?family=Amatic+SC:700');

    /* --- Tech Cafe Dark Background (FLEXBOX ADDED FOR CENTERING) --- */
    #global-loader {
        position: fixed;
        top: 0; left: 0;
        width: 100vw; height: 100vh;
        background-color: #0f0f13; /* EXACT match to your page background */
        z-index: 99999;
        overflow: hidden;
        transition: opacity 0.4s ease-in-out, visibility 0.4s ease-in-out;
        
        /* Flexbox guarantees perfect centering on all screen sizes */
        display: flex;
        flex-direction: column;
        justify-content: center;
        align-items: center;
        gap: 5vh; /* Responsive space between text and pan */
    }

    #global-loader.hidden {
        opacity: 0;
        visibility: hidden;
    }

    /* --- Themed Typography --- */
    #global-loader h1 {
        margin: 0;
        text-align: center;
        font-family: 'Amatic SC', cursive;
        /* clamp() makes the font scale smoothly between mobile and desktop */
        font-size: clamp(32px, 6vw, 6vh); 
        color: #ffffff; 
        font-weight: 700;
        letter-spacing: 2px;
        opacity: .85;
        animation: pulse 2.5s linear infinite;
        text-shadow: 0 0 15px rgba(226, 55, 68, 0.4); 
    }

    /* --- The Cooking Pan --- */
    #cooking {
        position: relative;
        /* Changed from vh to vmin! This makes it responsive on portrait screens */
        width: 65vmin; 
        height: 65vmin;
        max-width: 500px; /* Caps the size on massive desktop screens */
        max-height: 500px;
        overflow: hidden;
    }

    #cooking .bubble {
        position: absolute;
        border-radius: 100%;
        box-shadow: 0 0 .25vh rgba(255, 107, 119, 0.8);
        opacity: 0;
    }

    /* Recalculated Bubble Colors & Sizes (vh -> vmin) */
    #cooking .bubble:nth-child(1) {
        margin-top: 2.5vmin; left: 58%; width: 2.5vmin; height: 2.5vmin;
        background-color: #ff6b77; 
        animation: bubble 2s cubic-bezier(.53, .16, .39, .96) infinite;
    }
    #cooking .bubble:nth-child(2) {
        margin-top: 3vmin; left: 52%; width: 2vmin; height: 2vmin;
        background-color: #ff4f5e; 
        animation: bubble 2s ease-in-out .35s infinite;
    }
    #cooking .bubble:nth-child(3) {
        margin-top: 1.8vmin; left: 50%; width: 1.5vmin; height: 1.5vmin;
        background-color: #E23744; 
        animation: bubble 1.5s cubic-bezier(.53, .16, .39, .96) .55s infinite;
    }
    #cooking .bubble:nth-child(4) {
        margin-top: 2.7vmin; left: 56%; width: 1.2vmin; height: 1.2vmin;
        background-color: #c42835; 
        animation: bubble 1.8s cubic-bezier(.53, .16, .39, .96) .9s infinite;
    }
    #cooking .bubble:nth-child(5) {
        margin-top: 2.7vmin; left: 63%; width: 1.1vmin; height: 1.1vmin;
        background-color: #a61e28; 
        animation: bubble 1.6s ease-in-out 1s infinite;
    }

    #cooking #area {
        position: absolute; bottom: 0; right: 0; width: 50%; height: 50%;
        background-color: transparent;
        transform-origin: 15% 60%;
        animation: flip 2.1s ease-in-out infinite;
    }

    #cooking #area #sides {
        position: absolute; width: 100%; height: 100%;
        transform-origin: 15% 60%;
        animation: switchSide 2.1s ease-in-out infinite;
    }

    #cooking #area #sides #handle {
        position: absolute; bottom: 18%; right: 80%; width: 35%; height: 20%;
        background-color: transparent;
        border-top: 1vmin solid #E23744; /* Changed to vmin */
        border-left: 1vmin solid transparent; /* Changed to vmin */
        border-radius: 100%;
        transform: rotate(20deg) rotateX(0deg) scale(1.3, .9);
    }

    #cooking #area #sides #pan {
        position: absolute; bottom: 20%; right: 30%; width: 50%; height: 8%;
        background-color: #E23744; 
        border-radius: 0 0 1.4em 1.4em;
        transform-origin: -15% 0;
    }

    #cooking #area #pancake {
        position: absolute; top: 24%; width: 100%; height: 100%;
        transform: rotateX(85deg);
        animation: jump 2.1s ease-in-out infinite;
    }

    #cooking #area #pancake #pastry {
        position: absolute; bottom: 26%; right: 37%; width: 40%; height: 45%;
        background-color: #ffffff; 
        box-shadow: 0 0 5px 0 rgba(255,255,255,0.5);
        border-radius: 100%;
        transform-origin: -20% 0;
        animation: fly 2.1s ease-in-out infinite;
    }

    /* --- Keyframes --- */
    @keyframes jump {
        0% { top: 24%; transform: rotateX(85deg); }
        25% { top: 10%; transform: rotateX(0deg); }
        50% { top: 30%; transform: rotateX(85deg); }
        75% { transform: rotateX(0deg); }
        100% { transform: rotateX(85deg); }
    }

    @keyframes flip {
        0% { transform: rotate(0deg); }
        5% { transform: rotate(-27deg); }
        30%, 50% { transform: rotate(0deg); }
        55% { transform: rotate(27deg); }
        83.3% { transform: rotate(0deg); }
        100% { transform: rotate(0deg); }
    }

    @keyframes switchSide {
        0% { transform: rotateY(0deg); }
        50% { transform: rotateY(180deg); }
        100% { transform: rotateY(0deg); }
    }

    @keyframes fly {
        0% { bottom: 26%; transform: rotate(0deg); }
        10% { bottom: 40%; }
        50% { bottom: 26%; transform: rotate(-190deg); }
        80% { bottom: 40%; }
        100% { bottom: 26%; transform: rotate(0deg); }
    }

    @keyframes bubble {
        0% { transform: scale(.15, .15); top: 80%; opacity: 0; }
        50% { transform: scale(1.1, 1.1); opacity: 1; }
        100% { transform: scale(.33, .33); top: 60%; opacity: 0; }
    }

    @keyframes pulse {
        0% { transform: scale(1, 1); opacity: .4; }
        50% { transform: scale(1.05, 1); opacity: 1; }
        100% { transform: scale(1, 1); opacity: .4; }
    }
</style>

<div id="global-loader">
    <h1>Cooking in progress..</h1>
    <div id="cooking">
        <div class="bubble"></div>
        <div class="bubble"></div>
        <div class="bubble"></div>
        <div class="bubble"></div>
        <div class="bubble"></div>
        
        <div id="area">
            <div id="sides">
                <div id="pan"></div>
                <div id="handle"></div>
            </div>
            <div id="pancake">
                <div id="pastry"></div>
            </div>
        </div>
    </div>
</div>

<script>
    // 1. SILKY FADE OUT ON LOAD
    window.addEventListener('load', function() {
        const loader = document.getElementById('global-loader');
        setTimeout(() => {
            loader.classList.add('hidden');
        }, 150); 
    });

    // 2. BACK BUTTON FIX
    window.addEventListener('pageshow', function(event) {
        if (event.persisted) {
            document.getElementById('global-loader').classList.add('hidden');
        }
    });

    // 3. SMART FADE IN ON CLICK
    document.addEventListener("DOMContentLoaded", function() {
        const links = document.querySelectorAll('a');
        
        links.forEach(link => {
            link.addEventListener('click', function(e) {
                const hrefAttr = this.getAttribute('href');
                const targetAttr = this.getAttribute('target');
                
                if (!hrefAttr || hrefAttr.startsWith('javascript') || targetAttr === '_blank') {
                    return;
                }

                const linkUrl = new URL(this.href, window.location.href);
                const currentUrl = new URL(window.location.href);

                if (linkUrl.pathname === currentUrl.pathname && linkUrl.hash) {
                    return;
                }

                e.preventDefault(); 
                document.getElementById('global-loader').classList.remove('hidden'); 
                
                setTimeout(() => {
                    window.location.href = this.href;
                }, 400); 
            });
        });
    });
</script>