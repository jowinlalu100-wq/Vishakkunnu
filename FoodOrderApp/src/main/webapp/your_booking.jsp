<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="com.app.DBConnection" %>
<!DOCTYPE html>
<html>
<head>
    <title>Your Orders - Tech Cafe</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=JetBrains+Mono:wght@400;500&display=swap" rel="stylesheet">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <style>
        body { margin: 0; font-family: 'Inter', sans-serif; background: #0f0f13; color: white; }
        
        .bookings-container { max-width: 700px; margin: 60px auto; padding: 0 20px; }
        h1 { margin-top: 0; font-size: 28px; font-weight: 700; margin-bottom: 30px; letter-spacing: -0.5px; }
        
        .message-box { text-align: center; padding: 40px; background: #1c1c24; border-radius: 16px; border: 1px dashed rgba(255,255,255,0.1); color: #888; }
        
        /* --- Zomato/Swiggy Style Order Cards --- */
        .orders-list { display: flex; flex-direction: column; gap: 20px; }
        
        .order-card {
            background: #1c1c24; border-radius: 16px; border: 1px solid rgba(255,255,255,0.05);
            padding: 20px; transition: 0.3s; box-shadow: 0 4px 15px rgba(0,0,0,0.2);
        }
        .order-card:hover { border-color: rgba(255,255,255,0.1); box-shadow: 0 8px 25px rgba(0,0,0,0.4); }

        /* Card Header */
        .order-header { display: flex; justify-content: space-between; align-items: flex-start; border-bottom: 1px dashed rgba(255,255,255,0.1); padding-bottom: 15px; margin-bottom: 15px; }
        .order-id { font-family: 'JetBrains Mono', monospace; font-size: 16px; font-weight: 700; color: white; display: block; margin-bottom: 4px; }
        .order-context { font-size: 13px; color: #888; display: flex; align-items: center; gap: 6px; }
        .table-badge { background: rgba(226, 55, 68, 0.1); color: #E23744; padding: 2px 8px; border-radius: 4px; font-weight: 600; font-size: 11px; text-transform: uppercase; }

        /* Status Badge */
        .status { padding: 6px 12px; border-radius: 8px; font-size: 12px; font-weight: 700; text-transform: uppercase; letter-spacing: 0.5px; }
        .status.confirmed { background: rgba(42, 157, 143, 0.1); color: #2a9d8f; }
        .status.pending { background: rgba(233, 196, 106, 0.1); color: #e9c46a; }
        .status.cancelled { background: rgba(230, 57, 70, 0.1); color: #e63946; }

        /* Items Section */
        .order-items { font-size: 14px; color: #d0d0d0; line-height: 1.6; margin-bottom: 15px; }
        .item-row { display: flex; align-items: flex-start; gap: 8px; margin-bottom: 6px; }
        .item-dot { color: #E23744; font-size: 10px; margin-top: 5px; }
        .item-qty { font-weight: 600; color: #fff; }

        /* Card Footer */
        .order-footer { display: flex; justify-content: space-between; align-items: center; border-top: 1px solid rgba(255,255,255,0.05); padding-top: 15px; }
        .total-label { font-size: 13px; color: #888; }
        .total-amount { font-size: 18px; font-weight: 700; color: white; font-family: 'JetBrains Mono', monospace; }
        
        .reorder-btn { background: rgba(255,255,255,0.05); color: white; border: none; padding: 8px 16px; border-radius: 8px; font-size: 13px; font-weight: 600; cursor: pointer; transition: 0.2s; }
        .reorder-btn:hover { background: rgba(255,255,255,0.1); color: #E23744; }
    </style>
</head>
<body>
<jsp:include page="navbar.jsp" />
<jsp:include page="loader.jsp" />

<div class="bookings-container">
    <h1>Your Order History</h1>

    <% 
        String currentUser = (String) session.getAttribute("loggedInUser");

        if (currentUser == null) {
    %>
        <div class="message-box">
            <p>You need to be logged in to view your orders.</p>
            <br>
            <a href="index.jsp" style="background: #E23744; color: white; padding: 10px 20px; border-radius: 8px; font-weight: bold; text-decoration: none;">Log In</a>
        </div>
    <% 
        } else {
    %>
        <div class="orders-list">
            <% 
                try (Connection con = DBConnection.getConnection();
                     PreparedStatement ps = con.prepareStatement(
                             "SELECT * FROM bookings WHERE fullname = ? ORDER BY id DESC")) {
                    
                    ps.setString(1, currentUser);
                    ResultSet rs = ps.executeQuery();
                    
                    boolean hasBookings = false;
                    while (rs.next()) {
                        hasBookings = true;
                        
                        // 1. Pull data directly from your database table
                        String status = rs.getString("status");
                        String bDate = rs.getString("booking_date");
                        String bTime = rs.getString("booking_time");
                        String tId = rs.getString("table_id");
                        String tBill = rs.getString("total_bill");
                        
                        // This is where the magic happens: Pulling the JSON cart string
                        String orderDetails = rs.getString("order_details");

                        // Safe Status Handling
                        String statusClass = "pending";
                        if (status != null) {
                            statusClass = status.equalsIgnoreCase("Confirmed") ? "confirmed" : 
                                          status.equalsIgnoreCase("Cancelled") ? "cancelled" : "pending";
                        } else { status = "Unknown"; }
                        
                        // Safe Table/Takeaway Handling
                        boolean isTakeaway = (bDate == null || bDate.equals("2099-01-01"));
                        String displayContext = isTakeaway ? "Takeaway Order" : (bDate + " • " + (bTime != null ? bTime : ""));
                        String displayTable = (tId == null || tId.equals("None") || tId.trim().isEmpty()) ? "" : "Table " + tId;
                        String displayBill = (tBill == null || tBill.trim().isEmpty()) ? "0.00" : tBill;
            %>
                        <div class="order-card">
                            <div class="order-header">
                                <div>
                                    <span class="order-id">#ORD-<%= String.format("%04d", rs.getInt("id")) %></span>
                                    <div class="order-context">
                                        <% if (!displayTable.isEmpty()) { %>
                                            <span class="table-badge"><%= displayTable %></span>
                                        <% } %>
                                        <span><%= displayContext %></span>
                                    </div>
                                </div>
                                <div class="status <%= statusClass %>"><%= status %></div>
                            </div>
                            
                            <div class="order-body">
                                <div class="raw-cart-data" style="display:none;"><%= orderDetails != null ? orderDetails : "[]" %></div>
                                
                                <div class="order-items"></div>
                            </div>

                            <div class="order-footer">
                                <div>
                                    <div class="total-label">Total Paid</div>
                                    <div class="total-amount">$<%= displayBill %></div>
                                </div>
                                <button class="reorder-btn" onclick="window.location.href='order.jsp'">Reorder</button>
                            </div>
                        </div>
            <% 
                    }
                    if (!hasBookings) {
                        out.println("<div class='message-box'>Looks like you haven't ordered anything yet.<br><br><a href='order.jsp' style='color:#E23744; text-decoration:none; font-weight:600;'>Browse Menu ➔</a></div>");
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                    out.println("<div class='message-box' style='color:#ff4d5a;'>Server connection error. Please check the console.</div>");
                }
            %>
        </div>
    <% 
        } 
    %>
</div>

<script>
    document.addEventListener("DOMContentLoaded", function() {
        // 1. Find every single order card on the page
        const orderCards = document.querySelectorAll('.order-card');
        
        orderCards.forEach(card => {
            // 2. Find the hidden JSON string and the empty target container in this specific card
            const rawDataElement = card.querySelector('.raw-cart-data');
            const itemsContainer = card.querySelector('.order-items');
            
            if (rawDataElement && itemsContainer) {
                try {
                    // 3. Clean up the text and parse it into an actual JavaScript Array
                    let rawStr = rawDataElement.textContent.trim();
                    if (!rawStr || rawStr === "null") rawStr = "[]"; // Handle old empty bookings safely
                    
                    const cartItems = JSON.parse(rawStr);
                    
                    if (cartItems.length === 0) {
                        itemsContainer.innerHTML = '<span style="color:#888; font-style:italic;">Table Reservation Only</span>';
                        return;
                    }
                    
                    // 4. Loop through the array and build beautiful Swiggy-style HTML!
                    let itemsHtml = '';
                    cartItems.forEach(item => {
                        itemsHtml += '<div class="item-row">' +
                                        '<span class="item-dot">■</span>' +
                                        '<div>' +
                                            '<span class="item-qty">' + item.quantity + ' x</span> ' + item.name +
                                        '</div>' +
                                     '</div>';
                    });
                    
                    // 5. Inject the beautiful HTML into the visible container
                    itemsContainer.innerHTML = itemsHtml;
                    
                } catch (error) {
                    console.error("Could not parse order details", error);
                    itemsContainer.innerHTML = '<span style="color:#888;">Items unavailable</span>';
                }
            }
        });
    });
</script>
<jsp:include page="footer.jsp" />
</body>
</html>