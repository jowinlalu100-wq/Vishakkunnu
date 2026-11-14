<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>

<%
    // Database connection setup
    String dbURL = "jdbc:mysql://localhost:3306/fooddb"; 
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
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Vishakkunnu - Command Center</title>
    
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=JetBrains+Mono:wght@500;700&display=swap" rel="stylesheet">
    
    <style>
        /* --- GLOBAL DARK THEME --- */
        body { 
            margin: 0; 
            font-family: 'Inter', sans-serif; 
            background: #0a0a0c; 
            color: white; 
            display: flex; 
            height: 100vh; 
            overflow: hidden; 
        }

        /* --- LIQUID GLASS SIDEBAR --- */
        .admin-sidebar { 
            width: 280px; 
            background: rgba(15, 15, 20, 0.6); 
            backdrop-filter: blur(20px);
            -webkit-backdrop-filter: blur(20px);
            border-right: 1px solid rgba(255,255,255,0.05); 
            padding: 40px 25px; 
            display: flex; 
            flex-direction: column; 
            z-index: 100;
        }
        .admin-brand { 
            font-size: 22px; 
            font-weight: 700; 
            color: white; 
            margin-bottom: 50px; 
            letter-spacing: -0.5px; 
            display: flex; 
            align-items: center; 
            gap: 10px; 
        }
        .admin-brand span { color: #E23744; }
        
        .nav-item { 
            padding: 16px 20px; 
            color: #a0a0a0; 
            text-decoration: none; 
            font-weight: 600; 
            font-size: 15px; 
            border-radius: 12px; 
            margin-bottom: 10px; 
            transition: all 0.3s ease; 
            cursor: pointer; 
            display: flex;
            align-items: center;
            gap: 12px;
        }
        .nav-item:hover { 
            background: rgba(255, 255, 255, 0.05); 
            color: white; 
            transform: translateX(5px);
        }
        .nav-item.active { 
            background: rgba(226, 55, 68, 0.15); 
            color: #E23744; 
            border-left: 4px solid #E23744;
        }
        
        .logout-btn { 
            margin-top: auto; 
            color: #ff4d5a; 
            background: rgba(226, 55, 68, 0.05); 
            border: 1px solid rgba(226, 55, 68, 0.2); 
            text-align: center; 
            justify-content: center;
        }
        .logout-btn:hover { background: #E23744; color: white; transform: none; }

        /* --- MAIN CONTENT AREA --- */
        .main-content { 
            flex-grow: 1; 
            padding: 50px 60px; 
            overflow-y: auto; 
            background: radial-gradient(circle at top right, rgba(226, 55, 68, 0.03), transparent 50%);
        }
        
        .page-header { margin-bottom: 40px; }
        .page-header h1 { margin: 0; font-size: 32px; font-weight: 700; letter-spacing: -0.5px; text-shadow: 0 2px 10px rgba(0,0,0,0.5); }
        .page-header p { margin: 8px 0 0 0; color: #888; font-size: 15px; }

        .dashboard-section { display: none; animation: fadeIn 0.4s cubic-bezier(0.16, 1, 0.3, 1); }
        .dashboard-section.active { display: block; }
        @keyframes fadeIn { from { opacity: 0; transform: translateY(15px); } to { opacity: 1; transform: translateY(0); } }

        /* --- GLASS CARDS --- */
        .card { 
            background: rgba(20, 20, 25, 0.4); 
            backdrop-filter: blur(16px);
            border: 1px solid rgba(255,255,255,0.05); 
            border-radius: 20px; 
            padding: 30px; 
            margin-bottom: 30px; 
            box-shadow: 0 20px 40px rgba(0,0,0,0.2); 
        }
        .card h2 { 
            margin-top: 0; 
            font-size: 20px; 
            color: white; 
            border-bottom: 1px solid rgba(255,255,255,0.05); 
            padding-bottom: 20px; 
            margin-bottom: 25px; 
        }

        /* --- MODERN FORMS --- */
        input[type="text"], input[type="number"], textarea { 
            width: 100%; 
            padding: 15px 20px; 
            margin-bottom: 20px; 
            background: rgba(0,0,0,0.3); 
            border: 1px solid rgba(255,255,255,0.1); 
            border-radius: 12px; 
            color: white; 
            font-family: 'Inter', sans-serif; 
            font-size: 14px;
            box-sizing: border-box; 
            transition: 0.3s;
        }
        input:focus, textarea:focus { outline: none; border-color: #E23744; background: rgba(0,0,0,0.5); }
        
        .action-btn { 
            background: #E23744; color: white; border: none; padding: 15px 25px; 
            border-radius: 12px; font-weight: 600; cursor: pointer; transition: 0.3s; 
            width: 100%; font-size: 15px;
        }
        .action-btn:hover { background: #ff4d5a; transform: translateY(-2px); box-shadow: 0 8px 20px rgba(226, 55, 68, 0.3); }

        .file-upload-wrapper { 
            margin-bottom: 25px; background: rgba(0,0,0,0.2); 
            border: 1px dashed rgba(255,255,255,0.2); padding: 25px; 
            border-radius: 12px; text-align: center; transition: 0.3s;
        }
        .file-upload-wrapper:hover { border-color: #E23744; background: rgba(226, 55, 68, 0.02); }
        .file-upload-wrapper label { display: block; margin-bottom: 15px; color: #a0a0a0; font-weight: 600; font-size: 14px; }
        .file-upload-wrapper input[type="file"] { color: white; font-size: 13px; cursor: pointer; }
        .file-upload-wrapper input[type="file"]::file-selector-button { 
            background: #2a2a35; color: white; border: none; padding: 10px 20px; 
            border-radius: 8px; margin-right: 15px; cursor: pointer; transition: 0.3s; font-weight: 600; 
        }
        .file-upload-wrapper input[type="file"]::file-selector-button:hover { background: #E23744; }

        /* --- PREMIUM TABLES --- */
        .table-responsive { overflow-x: auto; }
        table { width: 100%; border-collapse: separate; border-spacing: 0 8px; }
        th { color: #888; font-weight: 600; text-transform: uppercase; letter-spacing: 1px; font-size: 12px; padding: 0 20px 10px 20px; text-align: left; }
        td { 
            padding: 20px; 
            background: rgba(255,255,255,0.02); 
            color: #d0d0d0; 
            font-size: 14px; 
            transition: 0.2s;
        }
        tr td:first-child { border-top-left-radius: 12px; border-bottom-left-radius: 12px; }
        tr td:last-child { border-top-right-radius: 12px; border-bottom-right-radius: 12px; }
        tr:hover td { background: rgba(255,255,255,0.06); }
        
        .mono { font-family: 'JetBrains Mono', monospace; color: #a0a0a0; }
        
        .badge { padding: 6px 12px; border-radius: 8px; font-size: 11px; font-weight: 700; text-transform: uppercase; letter-spacing: 0.5px; }
        .badge.user { background: rgba(255, 255, 255, 0.08); color: #ccc; }
        .badge.live { background: rgba(42, 157, 143, 0.15); color: #2a9d8f; border: 1px solid rgba(42, 157, 143, 0.3); }
        
        .action-cell { display: flex; gap: 10px; }
        .btn-small { padding: 8px 16px; border: none; border-radius: 8px; font-weight: 600; font-size: 12px; cursor: pointer; transition: 0.2s; }
        .btn-edit { background: rgba(255, 255, 255, 0.1); color: white; }
        .btn-edit:hover { background: white; color: black; }
        .btn-delete { background: rgba(226, 55, 68, 0.1); color: #E23744; }
        .btn-delete:hover { background: #E23744; color: white; }

        /* --- GLASS MODAL --- */
        .modal-overlay {
            position: fixed; top: 0; left: 0; width: 100%; height: 100%;
            background: rgba(0, 0, 0, 0.8); backdrop-filter: blur(10px);
            display: flex; justify-content: center; align-items: center;
            z-index: 3000; opacity: 0; visibility: hidden; transition: 0.3s ease;
        }
        .modal-overlay.active { opacity: 1; visibility: visible; }
        .modal-content {
            background: #15151a; border: 1px solid rgba(255,255,255,0.1);
            border-radius: 24px; padding: 40px; width: 90%; max-width: 500px;
            transform: translateY(20px); transition: 0.3s ease; box-shadow: 0 20px 50px rgba(0,0,0,0.5);
        }
        .modal-overlay.active .modal-content { transform: translateY(0); }

        /* --- MOBILE RESPONSIVENESS --- */
        @media (max-width: 1024px) {
            body { flex-direction: column; overflow: auto; }
            .admin-sidebar { width: 100%; padding: 20px; border-right: none; border-bottom: 1px solid rgba(255,255,255,0.05); flex-direction: row; flex-wrap: wrap; align-items: center; justify-content: space-between; box-sizing: border-box; }
            .admin-brand { margin-bottom: 0; }
            .nav-item { margin-bottom: 0; padding: 10px 15px; }
            .logout-btn { margin-top: 0; }
            .main-content { padding: 30px 20px; overflow-y: visible; }
        }
    </style>
</head>
<body>

    <div class="admin-sidebar">
        <div class="admin-brand"> Vishakkunnu <span>Admin</span></div>
        <div style="display:flex; flex-direction:column; gap:5px; width: 100%;">
            <div class="nav-item active" onclick="switchTab('menuTab', this)">🍔 Manage Menu</div>
            <div class="nav-item" onclick="switchTab('usersTab', this)">👥 User Database</div>
            <div class="nav-item" onclick="switchTab('ordersTab', this)">📋 Active Orders</div>
            
            <div class="nav-item" onclick="switchTab('messagesTab', this)">✉️ Inbox Messages</div>
            
            <a href="adminLogout" class="nav-item logout-btn" style="margin-top: 40px;">Log Out</a>
        </div>
    </div>

    <div class="main-content">
        
        <div id="menuTab" class="dashboard-section active">
            <div class="page-header">
                <h1>Menu Management</h1>
                <p>Add new authentic dishes or update existing prices.</p>
            </div>

            <div class="card">
                <h2>➕ Add New Item</h2>
                <form action="AddMenuServlet" method="POST" enctype="multipart/form-data">
                    <input type="text" name="itemName" placeholder="Item Name (e.g., Kerala Fish Curry)" required>
                    <input type="number" step="0.01" name="itemPrice" placeholder="Price (e.g., 12.99)" required>
                    <textarea name="itemDesc" rows="3" placeholder="Appetizing description..." required></textarea>
                    
                    <div class="file-upload-wrapper">
                        <label for="itemImage">📸 Upload Dish Photo</label>
                        <input type="file" id="itemImage" name="itemImage" accept="image/png, image/jpeg, image/jpg" required>
                    </div>

                    <button type="submit" class="action-btn">Publish to Menu</button>
                </form>
            </div>
            
            <div class="card">
                <h2>Current Menu Items</h2>
                <div class="table-responsive">
                    <table>
                        <tr>
                            <th>Item ID</th>
                            <th>Name</th>
                            <th>Price</th>
                            <th>Actions</th>
                        </tr>
                        <% 
                        if (con != null) {
                            try {
                                Statement stmtMenu = con.createStatement();
                                ResultSet rsMenu = stmtMenu.executeQuery("SELECT * FROM menu ORDER BY id DESC");
                                while(rsMenu.next()) {
                                    int id = rsMenu.getInt("id");
                                    String name = rsMenu.getString("name");
                                    double price = rsMenu.getDouble("price");
                                    String desc = rsMenu.getString("description");
                        %>
                        <tr>
                            <td class="mono">#M-<%= id %></td>
                            <td style="font-weight: 600; color: white;"><%= name %></td>
                            <td class="mono" style="color: #2a9d8f;">$<%= String.format("%.2f", price) %></td>
                            <td class="action-cell">
                                <button class="btn-small btn-edit" onclick="openEditModal(<%= id %>, '<%= name.replace("'", "\\'") %>', <%= price %>, '<%= desc.replace("'", "\\'") %>')">Edit</button>
                                <form action="DeleteMenuServlet" method="POST" style="margin:0;" onsubmit="return confirm('🚨 Are you sure you want to permanently delete this dish?');">
                                    <input type="hidden" name="itemId" value="<%= id %>">
                                    <button type="submit" class="btn-small btn-delete">Delete</button>
                                </form>
                            </td>
                        </tr>
                        <% 
                                }
                                rsMenu.close(); stmtMenu.close();
                            } catch(Exception e) { out.println("<tr><td colspan='4'>Error: " + e.getMessage() + "</td></tr>"); }
                        }
                        %>
                    </table>
                </div>
            </div>
        </div>

        <div id="usersTab" class="dashboard-section">
            <div class="page-header">
                <h1>Registered Users</h1>
                <p>View all customer accounts registered on Vishakkunnu.</p>
            </div>

            <div class="card">
                <h2>User Directory</h2>
                <div class="table-responsive">
                    <table>
                        <tr>
                            <th>User ID</th>
                            <th>Full Name</th>
                            <th>Email Address</th>
                            <th>Role</th>
                        </tr>
                        <% 
                        if (con != null) {
                            try {
                                Statement stmtUsers = con.createStatement();
                                ResultSet rsUsers = stmtUsers.executeQuery("SELECT * FROM users ORDER BY id DESC");
                                while(rsUsers.next()) {
                        %>
                        <tr>
                            <td class="mono">#U-<%= rsUsers.getInt("id") %></td>
                            <td style="font-weight: 600; color: white;"><%= rsUsers.getString("fullname") %></td> 
                            <td><%= rsUsers.getString("email") %></td> 
                            <td><span class="badge user">Customer</span></td>
                        </tr>
                        <% 
                                }
                                rsUsers.close(); stmtUsers.close();
                            } catch(Exception e) { out.println("<tr><td colspan='4'>Error loading users: " + e.getMessage() + "</td></tr>"); }
                        }
                        %>
                    </table>
                </div>
            </div>
        </div>

        <div id="ordersTab" class="dashboard-section">
            <div class="page-header">
                <h1>Live Orders</h1>
                <p>Monitor incoming kitchen tickets and customer details.</p>
            </div>
            <div class="card">
                <div class="table-responsive">
                    <table>
                        <tr>
                            <th>Order ID</th>
                            <th>Customer Info</th>
                            <th>Items Ordered</th>
                            <th>Total</th>
                            <th>Status</th>
                        </tr>
                        <% 
                        if (con != null) {
                            try {
                                Statement stmtOrders = con.createStatement();
                                String query = "SELECT * FROM bookings ORDER BY id DESC";
                                ResultSet rsOrders = stmtOrders.executeQuery(query);
                                while(rsOrders.next()) {
                                    int orderId = rsOrders.getInt("id");
                                    String rawJson = rsOrders.getString("order_details");
                                    if(rawJson == null) rawJson = "";
                                    
                                    String custName = rsOrders.getString("fullname");
                                    String tableId = rsOrders.getString("table_id");
                                    String bookingTime = rsOrders.getString("booking_time");
                                    
                                    if (custName == null || custName.trim().isEmpty()) custName = "Guest Customer";
                                    if (tableId == null || tableId.trim().isEmpty()) tableId = "Takeaway";
                                    if (bookingTime == null) bookingTime = "ASAP";
                        %>
                        <tr>
                            <td class="mono">#ORD-<%= orderId %></td>
                            <td>
                                <div style="font-weight: 600; color: white; font-size: 14px;">👤 <%= custName %></div>
                                <div style="color: #888; font-size: 12px; margin-top: 6px; letter-spacing: 0.5px;">
                                    🪑 Table: <%= tableId %> | 🕒 <%= bookingTime %>
                                </div>
                            </td>
                            <td>
                                <textarea id="raw-data-<%= orderId %>" style="display:none;"><%= rawJson %></textarea>
                                <span id="pretty-output-<%= orderId %>" style="color: white; font-weight: 600; font-size: 13px; line-height: 1.6;"></span>
                                <script>
                                    (function() {
                                        var dbText = document.getElementById("raw-data-<%= orderId %>").value;
                                        var outputSpan = document.getElementById("pretty-output-<%= orderId %>");
                                        if (!dbText || dbText.trim() === "") { outputSpan.innerHTML = "<span style='color:#888;'>No items</span>"; return; }
                                        try {
                                            var orderArray = JSON.parse(dbText);
                                            var foodNames = [];
                                            for (var i = 0; i < orderArray.length; i++) {
                                                if (orderArray[i].name) { foodNames.push("• " + orderArray[i].name); }
                                            }
                                            outputSpan.innerHTML = foodNames.join('<br>'); 
                                        } catch(e) { outputSpan.innerHTML = "<span style='color:#d0d0d0; font-size:13px;'>" + dbText + "</span>"; }
                                    })();
                                </script>
                            </td>
                            <td class="mono" style="color: #2a9d8f;">$<%= rsOrders.getString("total_bill") %></td>
                            <td><span class="badge live">Cooking</span></td>
                        </tr>
                        <% 
                                }
                                rsOrders.close(); stmtOrders.close();
                            } catch(Exception e) { out.println("<tr><td colspan='5' style='color:#E23744;'>Error: " + e.getMessage() + "</td></tr>"); }
                        }
                        %>
                    </table>
                </div>
            </div>
        </div>

        <div id="messagesTab" class="dashboard-section">
            <div class="page-header">
                <h1>Customer Inbox</h1>
                <p>View feedback and support requests from your customers.</p>
            </div>
            
            <div class="card">
                <h2>Recent Messages</h2>
                <div class="table-responsive">
                    <table>
                        <tr>
                            <th>Date & Time</th>
                            <th>Customer Info</th>
                            <th>Message Content</th>
                        </tr>
                        <% 
                        if (con != null) {
                            try {
                                Statement stmtMsg = con.createStatement();
                                ResultSet rsMsg = stmtMsg.executeQuery("SELECT * FROM contact_messages ORDER BY id DESC");
                                boolean hasMsgs = false;
                                while(rsMsg.next()) {
                                    hasMsgs = true;
                        %>
                        <tr>
                            <td class="mono" style="white-space: nowrap; font-size: 12px;">
                                <%= rsMsg.getTimestamp("submitted_at") != null ? rsMsg.getTimestamp("submitted_at").toString().substring(0, 16) : "N/A" %>
                            </td>
                            <td>
                                <div style="font-weight: 600; color: white; font-size: 14px;"><%= rsMsg.getString("name") %></div>
                                <div style="color: #888; font-size: 12px; margin-top: 4px;"><%= rsMsg.getString("email") %></div>
                            </td>
                            <td style="color: #d0d0d0; line-height: 1.5; max-width: 400px; padding-right: 20px;">
                                <%= rsMsg.getString("message") %>
                            </td>
                        </tr>
                        <% 
                                }
                                if (!hasMsgs) {
                                    out.println("<tr><td colspan='3' style='text-align:center; padding:40px; color:#888;'>No messages in your inbox.</td></tr>");
                                }
                                rsMsg.close(); stmtMsg.close();
                            } catch(Exception e) { out.println("<tr><td colspan='3' style='color:#E23744;'>Error loading messages: " + e.getMessage() + "</td></tr>"); }
                        }
                        %>
                    </table>
                </div>
            </div>
        </div>

    </div>

    <div class="modal-overlay" id="editModal">
        <div class="modal-content">
            <h2 style="margin-top:0; border-bottom:1px solid rgba(255,255,255,0.05); padding-bottom:20px; color:white;">Update Menu Item</h2>
            <form action="EditMenuServlet" method="POST" enctype="multipart/form-data">
                <input type="hidden" name="itemId" id="editId">
                <input type="text" name="itemName" id="editName" required>
                <input type="number" step="0.01" name="itemPrice" id="editPrice" required>
                <textarea name="itemDesc" id="editDesc" rows="3" required></textarea>
                
                <div class="file-upload-wrapper">
                    <label>📸 Update Photo (Leave blank to keep current)</label>
                    <input type="file" name="itemImage" accept="image/png, image/jpeg, image/jpg">
                </div>
                
                <div style="display:flex; gap:15px; margin-top:10px;">
                    <button type="submit" class="action-btn" style="flex:1;">Save Changes</button>
                    <button type="button" class="action-btn" style="flex:1; background:rgba(255,255,255,0.1); color:white;" onclick="closeEditModal()">Cancel</button>
                </div>
            </form>
        </div>
    </div>

    <% if (con != null) { try { con.close(); } catch(Exception e) {} } %>

    <script>
        // Tab Switching Logic
        function switchTab(tabId, element) {
            document.querySelectorAll('.dashboard-section').forEach(sec => sec.classList.remove('active'));
            document.querySelectorAll('.nav-item').forEach(nav => nav.classList.remove('active'));
            document.getElementById(tabId).classList.add('active');
            element.classList.add('active');
        }

        // Edit Modal Logic
        function openEditModal(id, name, price, desc) {
            document.getElementById('editId').value = id;
            document.getElementById('editName').value = name;
            document.getElementById('editPrice').value = price;
            document.getElementById('editDesc').value = desc;
            document.getElementById('editModal').classList.add('active');
        }
        
        function closeEditModal() {
            document.getElementById('editModal').classList.remove('active');
        }
    </script>
</body>
</html>