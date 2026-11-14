<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // 1. Security Check
    if(session.getAttribute("loggedInUser") == null) {
        response.sendRedirect("index.jsp");
        return;
    }

    // 2. Catch the data sent from order.jsp
    String totalBill = request.getParameter("totalBill");
    String cartData = request.getParameter("cartData");
    String tableId = request.getParameter("tableId");
    String bookingDate = request.getParameter("bookingDate");
    String bookingTime = request.getParameter("bookingTime");

    if(totalBill == null || totalBill.isEmpty() || totalBill.equals("0.00")) {
        response.sendRedirect("order.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Secure Checkout - Tech Cafe</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    
    <script src="https://js.stripe.com/v3/"></script>

    <style>
        body { margin: 0; font-family: 'Inter', sans-serif; background: #0f0f13; color: #ffffff; }
        
        .checkout-container {
            max-width: 900px; margin: 60px auto; display: grid;
            grid-template-columns: 1.2fr 1fr; gap: 40px; padding: 0 20px;
        }

        @media (max-width: 768px) { .checkout-container { grid-template-columns: 1fr; } }

        .payment-panel {
            background: #1c1c24; padding: 40px; border-radius: 20px;
            border: 1px solid rgba(255,255,255,0.05); box-shadow: 0 10px 30px rgba(0,0,0,0.5);
        }

        .summary-panel {
            background: linear-gradient(145deg, #1a1a24 0%, #15151c 100%);
            padding: 40px; border-radius: 20px; border: 1px solid rgba(103, 114, 229, 0.2); /* Stripe Blurple Accent */
            height: fit-content;
        }

        h2 { margin-top: 0; font-size: 24px; font-weight: 600; margin-bottom: 25px; }
        
        /* --- Form & Stripe Elements Styles --- */
        .form-group { margin-bottom: 25px; }
        .form-group label { display: block; font-size: 13px; color: #a0a0a0; margin-bottom: 10px; font-weight: 500; }
        
        .stripe-input-container {
            padding: 16px; border: 1px solid rgba(255,255,255,0.1);
            border-radius: 10px; background: rgba(255,255,255,0.03); 
            transition: 0.3s;
        }
        
        .stripe-input-container.StripeElement--focus {
            border-color: #6772e5; /* Stripe Blurple */
            background: rgba(255,255,255,0.08); 
            box-shadow: 0 0 0 4px rgba(103, 114, 229, 0.1);
        }

        /* Error message styling */
        #card-errors {
            color: #ff4757; font-size: 13px; margin-top: 10px; font-weight: 500;
        }

        .total-amount { font-size: 42px; font-weight: 700; color: white; margin-bottom: 5px; }
        .secure-badge { display: flex; align-items: center; gap: 8px; color: #6772e5; font-size: 13px; font-weight: 600; margin-top: 20px; }

        .pay-btn {
            width: 100%; padding: 18px; border: none; border-radius: 12px;
            background: #6772e5; /* Stripe brand color */
            color: white; font-weight: 700; font-size: 16px; letter-spacing: 0.5px; cursor: pointer;
            transition: all 0.3s ease; margin-top: 10px; box-shadow: 0 4px 15px rgba(103, 114, 229, 0.3);
            text-transform: uppercase;
        }
        .pay-btn:hover { transform: translateY(-3px); box-shadow: 0 8px 25px rgba(103, 114, 229, 0.5); background: #7795f8; }
        .pay-btn:disabled { background: #333; cursor: not-allowed; transform: none; box-shadow: none; color: #888; }
    </style>
</head>
<body>

<jsp:include page="navbar.jsp" />
<jsp:include page="loader.jsp" />
<div class="checkout-container">
    
    <div class="payment-panel">
        <h2>Payment Details</h2>
        
        <form action="completeOrder" method="post" id="payment-form">
            <input type="hidden" name="cartData" value='<%= cartData != null ? cartData : "" %>'>
            <input type="hidden" name="tableId" value="<%= tableId != null ? tableId : "" %>">
            <input type="hidden" name="totalBill" value="<%= totalBill %>">
            <input type="hidden" name="bookingDate" value="<%= bookingDate != null ? bookingDate : "" %>">
            <input type="hidden" name="bookingTime" value="<%= bookingTime != null ? bookingTime : "" %>">
            
            <input type="hidden" name="stripeToken" id="stripeToken">

            <div class="form-group">
                <label for="card-element">Credit or Debit Card</label>
                <div id="card-element" class="stripe-input-container"></div>
                <div id="card-errors" role="alert"></div>
            </div>

            <button type="submit" class="pay-btn" id="submit-btn">Pay $<%= totalBill %></button>
        </form>
        
        <div style="display:flex; gap:15px; margin-top: 30px; opacity: 0.5; justify-content: center;">
            <img src="https://upload.wikimedia.org/wikipedia/commons/5/5e/Visa_Inc._logo.svg" height="20">
            <img src="https://upload.wikimedia.org/wikipedia/commons/2/2a/Mastercard-logo.svg" height="20">
            <img src="https://upload.wikimedia.org/wikipedia/commons/b/b5/PayPal.svg" height="20">
        </div>
    </div>

    <div class="summary-panel">
        <p style="color: #a0a0a0; font-size: 14px; margin: 0 0 10px 0;">Total to Pay</p>
        <div class="total-amount">$<%= totalBill %></div>
        
        <div style="margin-top: 30px; border-top: 1px solid rgba(255,255,255,0.1); padding-top: 20px;">
            <p style="color: #888; font-size: 14px; line-height: 1.6;">
                <% if(tableId != null && !tableId.isEmpty()) { %>
                    Includes reservation for <strong>Table <%= tableId %></strong> on <%= bookingDate %> at <%= bookingTime %>.
                <% } else { %>
                    Takeaway order only.
                <% } %>
            </p>
        </div>

        <div class="secure-badge">
            <span>🔒</span> Secured by Stripe
        </div>
    </div>

</div>

<script>
    // 1. Initialize Stripe with your test Publishable Key
    var stripe = Stripe('pk_test_51THPTpCeJQpppi3EQjNru3SJeHI2dexCK0Xp9DF6nqT9sjvrAt0NMAfxb6jFmHMoPBnyGRMMOPDBwma9swzTh1F600XQgEpp2i'); // PASTE YOUR KEY HERE
    var elements = stripe.elements();

    // 2. Custom styling for the Stripe Element to match your Dark Mode
    var style = {
        base: {
            color: '#ffffff',
            fontFamily: '"Inter", sans-serif',
            fontSmoothing: 'antialiased',
            fontSize: '16px',
            '::placeholder': { color: '#888888' }
        },
        invalid: {
            color: '#ff4757',
            iconColor: '#ff4757'
        }
    };

    // 3. Create an instance of the card Element
    var card = elements.create('card', {style: style});

    // 4. Add an instance of the card Element into the `card-element` <div>
    card.mount('#card-element');

    // 5. Handle real-time validation errors from the card Element
    card.on('change', function(event) {
        var displayError = document.getElementById('card-errors');
        if (event.error) {
            displayError.textContent = event.error.message;
        } else {
            displayError.textContent = '';
        }
    });

    // 6. Handle form submission
    var form = document.getElementById('payment-form');
    var submitBtn = document.getElementById('submit-btn');

    form.addEventListener('submit', function(event) {
        event.preventDefault();
        
        // Disable button to prevent double clicks
        submitBtn.disabled = true;
        submitBtn.innerText = "Processing...";

        // Send the card info to Stripe securely
        stripe.createToken(card).then(function(result) {
            if (result.error) {
                // Inform the user if there was an error
                var errorElement = document.getElementById('card-errors');
                errorElement.textContent = result.error.message;
                submitBtn.disabled = false;
                submitBtn.innerText = "Pay $<%= totalBill %>";
            } else {
                // Success! Send the token to your Java server
                stripeTokenHandler(result.token);
            }
        });
    });

    // 7. Submit the token and your hidden order data to your Java backend
    function stripeTokenHandler(token) {
        // Insert the token ID into the hidden field so it gets sent to the server
        document.getElementById('stripeToken').value = token.id;
        
        // Finally, submit the form!
        form.submit();
    }
</script>

</body>
</html>