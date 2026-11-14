<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>

<%
    // JAVA CHECK: Ask Tomcat if the user is currently logged in
    boolean isLoggedIn = session.getAttribute("loggedInUser") != null;

    // 2. ADDED: Database connection setup
    String dbURL = "jdbc:mysql://localhost:3306/fooddb"; // Change if needed
    String dbUser = "root";
    String dbPass = "root"; 
    
    Connection con = null;
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        con = DriverManager.getConnection(dbURL, dbUser, dbPass);
    } catch(Exception e) {
        System.out.println("Database connection failed: " + e.getMessage());
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Order & Book - Vishakkunnu</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/flatpickr/dist/flatpickr.min.css">
    <link rel="stylesheet" type="text/css" href="https://npmcdn.com/flatpickr/dist/themes/dark.css">
    <script src="https://cdn.jsdelivr.net/npm/flatpickr"></script>

    <style>
        /* --- ALL YOUR EXISTING CSS STYLES GO HERE (UNTOUCHED) --- */
        body { margin: 0; font-family: 'Inter', sans-serif; background: #0f0f13; color: #ffffff; overflow-x: hidden; }
        .page-wrapper { max-width: 1200px; margin: 40px auto; padding: 0 20px; display: grid; grid-template-columns: 1fr 380px; gap: 40px; align-items: start; }
        @media (max-width: 900px) { .page-wrapper { grid-template-columns: 1fr; } .cart-panel { position: relative; top: 0; margin-top: 20px; } }
        .section-header { margin-bottom: 25px; border-left: 4px solid #E23744; padding-left: 15px; }
        .section-header h2 { font-size: 24px; margin: 0; }
        .section-header p { color: #888; font-size: 14px; margin: 5px 0 0 0; }
        .menu-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(220px, 1fr)); gap: 20px; margin-bottom: 50px; }
        .food-card { background: #1c1c24; border-radius: 16px; overflow: hidden; transition: 0.3s; border: 1px solid rgba(255,255,255,0.05); }
        .food-card:hover { transform: translateY(-5px); background: #25252e; border-color: rgba(226, 55, 68, 0.5); }
        .food-img { width: 100%; height: 140px; object-fit: cover; border-bottom: 1px solid rgba(255,255,255,0.05); }
        .food-info { padding: 15px; }
        .food-title { font-weight: 600; font-size: 16px; margin-bottom: 5px; }
        .food-price { color: #E23744; font-weight: 700; margin-bottom: 15px; display: block; }
        .add-btn { width: 100%; padding: 10px; border: 1px solid #E23744; border-radius: 8px; background: transparent; color: #E23744; font-weight: 600; cursor: pointer; transition: 0.2s; }
        .add-btn:hover { background: #E23744; color: white; }
        .floor-plan { background: #1c1c24; padding: 25px; border-radius: 20px; display: grid; grid-template-columns: repeat(auto-fit, minmax(90px, 1fr)); gap: 20px; margin-bottom: 40px; border: 1px solid rgba(255,255,255,0.05); }
        .table-unit { display: flex; flex-direction: column; align-items: center; gap: 8px; cursor: pointer; transition: 0.3s; }
        .table-icon { width: 60px; height: 60px; background: rgba(255,255,255,0.05); border: 2px solid rgba(255,255,255,0.2); border-radius: 12px; display: flex; align-items: center; justify-content: center; font-size: 14px; font-weight: bold; transition: 0.3s; }
        .table-unit:hover .table-icon { border-color: white; }
        .table-unit.selected .table-icon { background: #E23744; border-color: #ff4757; color: white; box-shadow: 0 0 15px rgba(226, 55, 68, 0.4); }
        .table-unit.booked { opacity: 0.3; cursor: not-allowed; }
        .table-unit.booked:hover .table-icon { border-color: rgba(255,255,255,0.2); }
        .cart-panel { background: #1c1c24; padding: 30px; border-radius: 20px; position: sticky; top: 100px; border: 1px solid rgba(255,255,255,0.05); box-shadow: 0 10px 30px rgba(0,0,0,0.5); display: flex; flex-direction: column; max-height: calc(100vh - 120px); }
        .cart-scroll-area { flex-grow: 1; overflow-y: auto; margin-bottom: 15px; padding-right: 5px; }
        .cart-scroll-area::-webkit-scrollbar { width: 6px; }
        .cart-scroll-area::-webkit-scrollbar-track { background: transparent; }
        .cart-scroll-area::-webkit-scrollbar-thumb { background: #444; border-radius: 10px; }
        .bill-details { margin: 15px 0; padding-top: 15px; border-top: 1px solid rgba(255,255,255,0.1); }
        .bill-row { display: flex; justify-content: space-between; margin-bottom: 8px; font-size: 14px; color: #aaa; }
        .bill-total { border-top: 1px solid #444; padding-top: 12px; margin-top: 12px; color: white; font-weight: 700; font-size: 18px; }
        .submit-btn { width: 100%; padding: 18px; border: none; border-radius: 12px; background: linear-gradient(135deg, #E23744 0%, #ff4757 100%); color: white; font-weight: 700; font-size: 16px; letter-spacing: 0.5px; cursor: pointer; transition: all 0.3s ease; margin-top: 10px; box-shadow: 0 4px 15px rgba(226, 55, 68, 0.3); text-transform: uppercase; }
        .submit-btn:hover:not(:disabled) { transform: translateY(-3px); box-shadow: 0 8px 25px rgba(226, 55, 68, 0.5); }
        .submit-btn:disabled { background: #2a2a35; color: #666; cursor: not-allowed; box-shadow: none; transform: none; border: 1px solid #333; }

        /* --- Premium Date/Time Inputs --- */
        .datetime-wrapper { display: grid; grid-template-columns: 1fr 1fr; gap: 20px; margin-bottom: 30px; }
        .input-box { position: relative; background: #1c1c24; border: 1px solid rgba(255,255,255,0.1); border-radius: 12px; display: flex; align-items: center; transition: 0.3s; }
        .input-box:hover, .input-box:focus-within { border-color: #E23744; box-shadow: 0 0 0 3px rgba(226, 55, 68, 0.1); }
        .input-icon { padding: 0 15px; font-size: 18px; color: #E23744; }
        .input-box input { width: 100%; background: transparent; border: none; color: white; padding: 16px 15px 16px 0; font-family: 'Inter', sans-serif; font-size: 15px; outline: none; cursor: pointer; }
        .input-box input::placeholder { color: #888; }

        /* --- Sliding Auth Styles --- */
        .overlay { position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(0, 0, 0, 0.8); backdrop-filter: blur(8px); z-index: 2000; opacity: 0; visibility: hidden; transition: 0.4s; }
        .overlay.active { opacity: 1; visibility: visible; }
        .auth-sidebar { position: fixed; top: 0; right: -450px; width: 400px; height: 100%; background: #121212; z-index: 2001; transition: 0.5s cubic-bezier(0.16, 1, 0.3, 1); padding: 50px 40px; display: flex; flex-direction: column; border-left: 1px solid rgba(255,255,255,0.05); }
        .auth-sidebar.active { right: 0; }
        .close-btn { align-self: flex-end; background: none; border: none; color: #888; font-size: 32px; cursor: pointer; margin-bottom: 20px; transition: 0.3s; }
        .close-btn:hover { color: white; }
        .auth-form { display: none; }
        .auth-form.active { display: block; animation: fadeUp 0.4s; }
        @keyframes fadeUp { from { opacity: 0; transform: translateY(15px); } to { opacity: 1; transform: translateY(0); } }
        .auth-form input { width: 100%; padding: 15px; margin: 10px 0; border: 1px solid rgba(255,255,255,0.1); border-radius: 10px; background: rgba(255,255,255,0.03); color: white; outline: none; box-sizing: border-box; font-family: 'Inter', sans-serif; transition: 0.3s; }
        .auth-form input:focus { border-color: #E23744; background: rgba(255,255,255,0.08); box-shadow: 0 0 0 4px rgba(230, 57, 70, 0.1); }
        .toggle-text { margin-top: 25px; font-size: 14px; color: #888; text-align: center; }
        .toggle-text span { color: white; cursor: pointer; font-weight: 600; transition: 0.3s; }
        .toggle-text span:hover { color: #E23744; }
    </style>
</head>
<body>

<jsp:include page="navbar.jsp" />
<jsp:include page="loader.jsp" />

<div class="page-wrapper">
    
    <div class="main-content">
        
        <div class="section-header">
            <h2>Select Your Meals</h2>
            <p>Add items to your cart for pre-ordering.</p>
        </div>
        
        <div class="menu-grid">
            <% 
            if (con != null) {
                try {
                    Statement stmt = con.createStatement();
                    ResultSet rs = stmt.executeQuery("SELECT * FROM menu ORDER BY id DESC");
                    
                    while(rs.next()) {
                        String name = rs.getString("name");
                        double price = rs.getDouble("price");
                        String imgPath = rs.getString("image_path");
                        
                        if (imgPath == null || imgPath.trim().isEmpty()) {
                            imgPath = "images/default-food.jpg"; 
                        }
            %>
            <div class="food-card">
                <img src="<%= imgPath %>" alt="<%= name %>" class="food-img" onerror="this.src='https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?w=400'">
                <div class="food-info">
                    <div class="food-title"><%= name %></div>
                    <span class="food-price">$<%= String.format("%.2f", price) %></span>
                    <button type="button" class="add-btn" onclick="addToCart('<%= name.replace("'", "\\'") %>', <%= price %>)">Add to Cart</button>
                </div>
            </div>
            <% 
                    }
                    rs.close(); 
                    stmt.close();
                    con.close();
                } catch(Exception e) {
                    out.println("<p style='color:#E23744;'>Error loading menu: " + e.getMessage() + "</p>");
                }
            } else {
                out.println("<p style='color:#E23744;'>Database connection failed. Please check your settings.</p>");
            }
            %>
        </div>

        <div class="section-header">
            <h2>Booking Details & Table</h2>
            <p>Select a date and time to see available tables. Reservation fee: $5.00</p>
        </div>
        
        <div class="datetime-wrapper">
            <div class="input-box">
                <span class="input-icon">📅</span>
                <input type="text" id="bookingDate" placeholder="Select Dining Date" required readonly>
            </div>
            <div class="input-box">
                <span class="input-icon">⏰</span>
                <input type="text" id="bookingTime" placeholder="Select Arrival Time" required readonly>
            </div>
        </div>

        <div class="floor-plan">
            <div class="table-unit" id="table-T1" onclick="selectTable('T1', 2, this)">
                <div class="table-icon">T1</div>
                <span style="font-size:11px; color:#888;">2 Seats</span>
            </div>
            <div class="table-unit" id="table-T2" onclick="selectTable('T2', 2, this)">
                <div class="table-icon">T2</div>
                <span style="font-size:11px; color:#888;">2 Seats</span>
            </div>
            <div class="table-unit" id="table-T3" onclick="selectTable('T3', 4, this)">
                <div class="table-icon">T3</div>
                <span style="font-size:11px; color:#888;">4 Seats</span>
            </div>
            <div class="table-unit" id="table-T4" onclick="selectTable('T4', 6, this)">
                <div class="table-icon">T4</div>
                <span style="font-size:11px; color:#888;">6 Seats</span>
            </div>
        </div>
    </div>

    <div class="cart-panel">
        <h3 style="margin:0 0 20px 0; font-size:20px;">Order Summary</h3>
        
        <div id="cartItemsContainer" class="cart-scroll-area">
            <p style="color:#666; text-align:center; padding:20px 0; font-size:14px;">Your cart is empty.</p>
        </div>

        <div id="selectedTableDisplay" style="display:none; padding:12px; background:rgba(226, 55, 68, 0.1); border:1px solid rgba(226,55,68,0.2); border-radius:8px; margin-bottom:15px;">
            <span style="font-size:13px; color:#ccc;">Reserved Table:</span>
            <span id="tableLabel" style="float:right; font-weight:700; color:#E23744;"></span>
        </div>

        <div class="bill-details">
            <div class="bill-row"><span>Food Subtotal</span><span id="foodSubtotal">$0.00</span></div>
            <div class="bill-row"><span>Booking Fee</span><span id="bookingFee">$0.00</span></div>
            <div class="bill-row"><span>Tax (5%)</span><span id="taxAmount">$0.00</span></div>
            <div class="bill-total"><span>Total Bill</span><span id="grandTotal">$0.00</span></div>
        </div>

        <form action="payment.jsp" method="post" id="checkoutForm">
            <input type="hidden" name="cartData" id="hiddenCartData">
            <input type="hidden" name="tableId" id="hiddenTableId">
            <input type="hidden" name="totalBill" id="hiddenTotal">
            <input type="hidden" name="bookingDate" id="hiddenDate">
            <input type="hidden" name="bookingTime" id="hiddenTime">
            
            <button type="submit" id="mainSubmitBtn" class="submit-btn" disabled>
                Select items or table
            </button>
        </form>
    </div>
</div>

<div class="overlay" id="overlay" onclick="closeAuth()"></div>
<div class="auth-sidebar" id="authSidebar">
    <button class="close-btn" onclick="closeAuth()">&times;</button>

    <div class="auth-form active" id="loginForm">
        <div style="font-size: 28px; margin-bottom: 10px; font-weight: 700;">Welcome Back</div>
        <p style="color: #888; font-size: 14px; margin-bottom: 25px;">Enter your credentials to continue ordering.</p>
        <form action="login" method="post">
            <input type="email" name="email" placeholder="Email Address" required>
            <input type="password" name="password" placeholder="Password" required>
            <input type="hidden" name="redirect" value="order.jsp">
            <button type="submit" class="submit-btn">Log In</button>
        </form>
        <div class="toggle-text">New to Vishakkunnu ? <span onclick="switchForm('register')">Create an account</span></div>
    </div>

    <div class="auth-form" id="registerForm">
        <div style="font-size: 28px; margin-bottom: 10px; font-weight: 700;">Sign Up</div>
        <p style="color: #888; font-size: 14px; margin-bottom: 25px;">Create an account to manage your reservations.</p>
        <form action="register" method="post">
            <input type="text" name="fullname" placeholder="Full Name" required>
            <input type="email" name="email" placeholder="Email Address" required>
            <input type="password" name="password" placeholder="Password" required>
            <input type="hidden" name="redirect" value="order.jsp">
            <button type="submit" class="submit-btn">Create Account</button>
        </form>
        <div class="toggle-text">Already have an account? <span onclick="switchForm('login')">Log in</span></div>
    </div>
</div>

<script>
    // PASS JAVA CHECK TO JAVASCRIPT
    const userIsLoggedIn = <%= isLoggedIn %>;

    let cart = [];
    let selectedTable = null;
    const BOOKING_FEE = 5.00;

    // Initialize Premium Calendars
    document.addEventListener('DOMContentLoaded', function() {
        flatpickr("#bookingDate", {
            minDate: "today",
            dateFormat: "Y-m-d",
            onChange: function() { checkAvailability(); }
        });
        flatpickr("#bookingTime", {
            enableTime: true,
            noCalendar: true,
            dateFormat: "H:i",
            minTime: "11:00",
            maxTime: "22:30",
            onChange: function() { checkAvailability(); }
        });
    });

    // Auth Window Functions
    function openAuth() {
        document.getElementById('overlay').classList.add('active');
        document.getElementById('authSidebar').classList.add('active');
        switchForm('login');
    }
    function closeAuth() {
        document.getElementById('overlay').classList.remove('active');
        document.getElementById('authSidebar').classList.remove('active');
    }
    function switchForm(formType) {
        if (formType === 'register') {
            document.getElementById('loginForm').classList.remove('active');
            document.getElementById('registerForm').classList.add('active');
        } else {
            document.getElementById('registerForm').classList.remove('active');
            document.getElementById('loginForm').classList.add('active');
        }
    }

    function addToCart(name, price) {
        const existing = cart.find(item => item.name === name);
        if (existing) { existing.quantity++; } else { cart.push({ name: name, price: price, quantity: 1 }); }
        updateUI();
    }

    function updateQuantity(name, change) {
        const item = cart.find(item => item.name === name);
        if (item) {
            item.quantity += change;
            if (item.quantity <= 0) { cart = cart.filter(i => i.name !== name); }
        }
        updateUI();
    }

    function selectTable(id, cap, element) {
        if (element.classList.contains('booked')) return; 
        document.querySelectorAll('.table-unit').forEach(t => t.classList.remove('selected'));
        element.classList.add('selected');
        selectedTable = id;
        document.getElementById('hiddenTableId').value = id;
        updateUI();
    }

    async function checkAvailability() {
        const dateInput = document.getElementById('bookingDate').value;
        const timeInput = document.getElementById('bookingTime').value;

        document.getElementById('hiddenDate').value = dateInput;
        document.getElementById('hiddenTime').value = timeInput;

        if (!dateInput || !timeInput) return;

        try {
            const response = await fetch('checkAvailability?date=' + dateInput + '&time=' + timeInput);
            if (!response.ok) throw new Error("Backend not ready");
            
            const bookedTableIds = await response.json(); 

            document.querySelectorAll('.table-unit').forEach(table => { table.classList.remove('booked', 'selected'); });
            selectedTable = null; 
            document.getElementById('hiddenTableId').value = "";
            
            if(Array.isArray(bookedTableIds)) {
                bookedTableIds.forEach(id => {
                    const tableElement = document.getElementById('table-' + id);
                    if (tableElement) tableElement.classList.add('booked');
                });
            }
            updateUI();
        } catch (error) { console.warn("Backend not running yet."); }
    }

    function updateUI() {
        const container = document.getElementById('cartItemsContainer');
        let subtotal = 0;
        
        if (cart.length === 0) {
            container.innerHTML = '<p style="color:#666; text-align:center; padding:20px 0; font-size:14px;">Your cart is empty.</p>';
        } else {
            let html = '';
            cart.forEach(item => {
                subtotal += (item.price * item.quantity);
                html += '<div style="display:flex; justify-content:space-between; align-items:center; padding:12px 0; border-bottom:1px solid rgba(255,255,255,0.05);">' +
                            '<div style="flex:1;">' +
                                '<div style="font-size:14px; font-weight:600; color:white;">' + item.name + '</div>' +
                                '<div style="font-size:13px; color:#888;">$' + item.price.toFixed(2) + '</div>' +
                            '</div>' +
                            '<div style="display:flex; align-items:center; gap:8px; background:#262626; padding:4px 8px; border-radius:8px;">' +
                                '<button type="button" onclick="updateQuantity(\'' + item.name + '\', -1)" style="background:transparent; border:none; color:#E23744; font-size:18px; cursor:pointer; padding:0 5px;">-</button>' +
                                '<span style="font-size:14px; font-weight:600; width:15px; text-align:center; color:white;">' + item.quantity + '</span>' +
                                '<button type="button" onclick="updateQuantity(\'' + item.name + '\', 1)" style="background:transparent; border:none; color:#2a9d8f; font-size:16px; cursor:pointer; padding:0 5px;">+</button>' +
                            '</div>' +
                        '</div>';
            });
            container.innerHTML = html;
        }

        const tableDiv = document.getElementById('selectedTableDisplay');
        const bookFee = selectedTable ? BOOKING_FEE : 0;
        
        if (selectedTable) {
            tableDiv.style.display = 'block';
            document.getElementById('tableLabel').innerText = 'Table ' + selectedTable;
        } else { tableDiv.style.display = 'none'; }

        const tax = (subtotal + bookFee) * 0.05;
        const total = subtotal + bookFee + tax;

        document.getElementById('foodSubtotal').innerText = '$' + subtotal.toFixed(2);
        document.getElementById('bookingFee').innerText = '$' + bookFee.toFixed(2);
        document.getElementById('taxAmount').innerText = '$' + tax.toFixed(2);
        document.getElementById('grandTotal').innerText = '$' + total.toFixed(2);
        
        document.getElementById('hiddenCartData').value = JSON.stringify(cart);
        document.getElementById('hiddenTotal').value = total.toFixed(2);
        
        // SECURE CHECKOUT BUTTON LOGIC
        const mainBtn = document.getElementById('mainSubmitBtn');
        const hasItems = (cart.length > 0 || selectedTable);

        if (!hasItems) {
            mainBtn.disabled = true;
            mainBtn.innerText = "Select items or table";
            mainBtn.type = "submit"; // Default
        } 
        else if (!userIsLoggedIn) {
            // If they have items but are NOT logged in, change button to open auth modal
            mainBtn.disabled = false;
            mainBtn.innerText = "Log In to Continue ➔";
            mainBtn.type = "button"; // Stops form submission
            mainBtn.onclick = function() { openAuth(); };
        } 
        else {
            // If they have items and ARE logged in, allow standard submission
            mainBtn.disabled = false;
            mainBtn.innerText = "Complete Booking ➔";
            mainBtn.type = "submit"; 
            mainBtn.onclick = null; // Clear the modal trigger
        }
    }
</script>
<jsp:include page="footer.jsp" />
</body>
</html>