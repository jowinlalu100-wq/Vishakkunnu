<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Date" %>
<%
    // 1. Security Check
    if(session.getAttribute("loggedInUser") == null) {
        response.sendRedirect("index.jsp");
        return;
    }

    // 2. Catch the data sent from the payment gateway
    String totalBill = request.getParameter("totalBill");
    String cartData = request.getParameter("cartData");
    String tableId = request.getParameter("tableId");
    String bookingDate = request.getParameter("bookingDate");
    String bookingTime = request.getParameter("bookingTime");
    
    // Catch the payment token
    String paymentToken = request.getParameter("stripeToken");
    if (paymentToken == null || paymentToken.isEmpty()) {
        paymentToken = request.getParameter("razorpay_payment_id");
    }
    if (paymentToken == null || paymentToken.isEmpty()) {
        paymentToken = "TXN-" + (int)(Math.random() * 1000000); 
    }

    // Generate Order ID and Live Timestamp
    String orderId = "ORD-" + (int)(Math.random() * 1000000);
    
    // Format the current date and time (e.g., "01 Apr 2026, 07:30 PM")
    SimpleDateFormat formatter = new SimpleDateFormat("dd MMM yyyy, hh:mm a");
    String currentDateTime = formatter.format(new Date());
%>
<!DOCTYPE html>
<html>
<head>
    <title>Order Confirmed - Tech Cafe</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=JetBrains+Mono:wght@400;500&display=swap" rel="stylesheet">
    
    <style>
        body { margin: 0; font-family: 'Inter', sans-serif; background: #0f0f13; color: #ffffff; }
        
        .success-wrapper {
            max-width: 600px; margin: 60px auto; padding: 0 20px;
            display: flex; flex-direction: column; align-items: center;
        }

        /* --- Animated Checkmark --- */
        .success-animation { margin-bottom: 20px; }
        .checkmark { width: 80px; height: 80px; border-radius: 50%; display: block; stroke-width: 4; stroke: #2a9d8f; stroke-miterlimit: 10; box-shadow: inset 0px 0px 0px #2a9d8f; animation: fill .4s ease-in-out .4s forwards, scale .3s ease-in-out .9s both; }
        .checkmark__circle { stroke-dasharray: 166; stroke-dashoffset: 166; stroke-width: 4; stroke-miterlimit: 10; stroke: #2a9d8f; fill: none; animation: stroke 0.6s cubic-bezier(0.65, 0, 0.45, 1) forwards; }
        .checkmark__check { transform-origin: 50% 50%; stroke-dasharray: 48; stroke-dashoffset: 48; animation: stroke 0.3s cubic-bezier(0.65, 0, 0.45, 1) 0.8s forwards; }
        @keyframes stroke { 100% { stroke-dashoffset: 0; } }
        @keyframes scale { 0%, 100% { transform: none; } 50% { transform: scale3d(1.1, 1.1, 1); } }
        @keyframes fill { 100% { box-shadow: inset 0px 0px 0px 50px rgba(42, 157, 143, 0.1); } }

        .title { font-size: 28px; font-weight: 700; margin: 0 0 10px 0; text-align: center; }
        .subtitle { color: #a0a0a0; font-size: 15px; margin: 0 0 30px 0; text-align: center; }

        /* --- Receipt Card --- */
        .receipt-card {
            background: #1c1c24; width: 100%; border-radius: 16px;
            border: 1px solid rgba(255,255,255,0.05); overflow: hidden;
            box-shadow: 0 15px 35px rgba(0,0,0,0.3);
        }

        .receipt-header {
            background: rgba(255,255,255,0.02); padding: 25px;
            border-bottom: 1px dashed rgba(255,255,255,0.1);
            display: flex; justify-content: space-between; align-items: flex-start;
        }

        .receipt-header h3 { margin: 0; font-size: 14px; color: #888; font-weight: 500; text-transform: uppercase; letter-spacing: 0.5px; }
        .order-id { font-family: 'JetBrains Mono', monospace; font-size: 20px; font-weight: 700; color: white; margin-top: 5px; }
        
        /* NEW: Date & Time Styling */
        .order-datetime { color: #a0a0a0; font-size: 13px; margin-top: 6px; display: flex; align-items: center; gap: 6px; }

        /* Reservation Badge */
        .reservation-badge {
            background: rgba(226, 55, 68, 0.1); border: 1px solid rgba(226, 55, 68, 0.2);
            padding: 15px 25px; display: flex; align-items: center; gap: 15px;
        }
        .res-icon { font-size: 24px; }
        .res-details { flex-grow: 1; }
        .res-title { color: #E23744; font-weight: 600; font-size: 14px; margin-bottom: 4px; }
        .res-time { color: white; font-size: 15px; font-weight: 500; }

        /* Items List */
        .receipt-body { padding: 25px; }
        .item-row { display: flex; justify-content: space-between; margin-bottom: 15px; font-size: 15px; }
        .item-name { color: white; font-weight: 500; }
        .item-qty { color: #888; font-size: 13px; margin-left: 8px; }
        .item-price { font-family: 'JetBrains Mono', monospace; color: #a0a0a0; }

        .receipt-footer {
            padding: 20px 25px; background: rgba(255,255,255,0.02);
            border-top: 1px dashed rgba(255,255,255,0.1);
        }
        
        .bill-row { display: flex; justify-content: space-between; margin-bottom: 10px; font-size: 14px; color: #888; }
        .bill-total { 
            display: flex; justify-content: space-between; margin-top: 15px; padding-top: 15px;
            border-top: 1px solid rgba(255,255,255,0.1); font-size: 20px; font-weight: 700; color: white; 
        }

        /* --- Actions --- */
        .action-buttons { display: flex; gap: 15px; width: 100%; margin-top: 30px; }
        .btn {
            flex: 1; padding: 16px; border-radius: 12px; font-weight: 600; font-size: 15px;
            text-align: center; text-decoration: none; transition: 0.3s; cursor: pointer; border: none;
        }
        .btn-primary { background: #E23744; color: white; }
        .btn-primary:hover { background: #ff4757; transform: translateY(-2px); box-shadow: 0 6px 20px rgba(226, 55, 68, 0.3); }
        .btn-secondary { background: #2a2a35; color: white; border: 1px solid rgba(255,255,255,0.1); }
        .btn-secondary:hover { background: #333340; transform: translateY(-2px); }

    </style>
</head>
<body>

<jsp:include page="navbar.jsp" />

<div class="success-wrapper">
    
    <div class="success-animation">
        <svg class="checkmark" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 52 52">
            <circle class="checkmark__circle" cx="26" cy="26" r="25" fill="none"/>
            <path class="checkmark__check" fill="none" d="M14.1 27.2l7.1 7.2 16.7-16.8"/>
        </svg>
    </div>

    <h1 class="title">Order Confirmed!</h1>
    <p class="subtitle">Thank you for your order, <%= session.getAttribute("loggedInUser") %>. Your payment was successful.</p>

    <div class="receipt-card">
        <div class="receipt-header">
            <div>
                <h3>Order ID</h3>
                <div class="order-id"><%= orderId %></div>
                <div class="order-datetime">🕒 <%= currentDateTime %></div>
            </div>
            <div style="text-align: right;">
                <h3>Payment Ref</h3>
                <div style="color: #888; font-size: 13px; margin-top: 10px; font-family: 'JetBrains Mono', monospace;"><%= paymentToken %></div>
            </div>
        </div>

        <% if(tableId != null && !tableId.isEmpty()) { %>
            <div class="reservation-badge">
                <div class="res-icon">🍽️</div>
                <div class="res-details">
                    <div class="res-title">Table <%= tableId %> Reserved</div>
                    <div class="res-time"><%= bookingDate %> at <%= bookingTime %></div>
                </div>
                <div style="font-size: 24px; color: #E23744;">✓</div>
            </div>
        <% } %>

        <div class="receipt-body" id="receiptItemsContainer">
            </div>

        <div class="receipt-footer">
            <div class="bill-row"><span>Food Subtotal</span><span id="receiptSubtotal">$0.00</span></div>
            <% if(tableId != null && !tableId.isEmpty()) { %>
                <div class="bill-row"><span>Booking Fee</span><span>$5.00</span></div>
            <% } %>
            <div class="bill-row"><span>Taxes (5%)</span><span id="receiptTax">$0.00</span></div>
            
            <div class="bill-total">
                <span>Amount Paid</span>
                <span>$<%= totalBill %></span>
            </div>
        </div>
    </div>

    <div class="action-buttons">
        <a href="your_booking.jsp" class="btn btn-secondary">View My Orders</a>
        <a href="index.jsp" class="btn btn-primary">Back to Home</a>
    </div>

</div>

<script>
    document.addEventListener("DOMContentLoaded", function() {
        const rawCartData = '<%= cartData != null ? cartData.replace("'", "\\'") : "[]" %>';
        const hasTable = <%= (tableId != null && !tableId.isEmpty()) ? "true" : "false" %>;
        
        try {
            const cartItems = JSON.parse(rawCartData);
            const container = document.getElementById('receiptItemsContainer');
            let subtotal = 0;

            if (cartItems.length === 0 && hasTable) {
                container.innerHTML = '<div style="text-align:center; color:#888; font-size:14px;">Table Reservation Only. No food pre-ordered.</div>';
            } else {
                let html = '';
                cartItems.forEach(item => {
                    const itemTotal = item.price * item.quantity;
                    subtotal += itemTotal;
                    
                    html += '<div class="item-row">' +
                                '<div>' +
                                    '<span class="item-name">' + item.name + '</span>' +
                                    '<span class="item-qty">x' + item.quantity + '</span>' +
                                '</div>' +
                                '<div class="item-price">$' + itemTotal.toFixed(2) + '</div>' +
                            '</div>';
                });
                container.innerHTML = html;
            }

            const tax = (subtotal + (hasTable ? 5.00 : 0)) * 0.05;
            document.getElementById('receiptSubtotal').innerText = '$' + subtotal.toFixed(2);
            document.getElementById('receiptTax').innerText = '$' + tax.toFixed(2);

        } catch(e) {
            console.error("Failed to parse cart data for receipt.", e);
        }
    });
</script>
<jsp:include page="footer.jsp" />
</body>
</html>