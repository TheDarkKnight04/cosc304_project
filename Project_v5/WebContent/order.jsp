<%@ page import="java.sql.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.Calendar" %>
<%@ include file="jdbc.jsp" %>
<%@ include file="page.jsp" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>

<%
  String userid = (String) session.getAttribute("authenticatedUser");

  out.print (doc_head ("Order"));
  out.print (page_header (userid));
%>

<div class="px-5">
<% 
// Get customer id
//String custId = request.getParameter("customerId");
//String pwd = request.getParameter("password");
String userName = (String) session.getAttribute("authenticatedUser");
String userState = (String) session.getAttribute("authenticatedUserState");
@SuppressWarnings({"unchecked"})
HashMap<String, ArrayList<Object>> productList = (HashMap<String, ArrayList<Object>>) session.getAttribute("productList");

// Determine if valid customer id was entered
// Determine if there are products in the shopping cart
// If either are not true, display an error message

// Make connection
//String url = "jdbc:sqlserver://cosc304_sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True";		
//String uid = "sa";
//String pw = "304#sa#pw";

try ( 
	Connection con = DriverManager.getConnection(url, uid, pw);
	Statement stmt = con.createStatement();
) 
{

	if (userName != null) {	
	if (productList == null){	
			out.println("<H1>Your shopping cart is empty!</H1>");
			productList = new HashMap<String, ArrayList<Object>>();
	} else {
		out.println("<h1>Your Order Summary</h1>");
		out.println("<table class=\"table\"><tr><th>Product Id</th><th>Product Name</th><th>Quantity</th><th>Price</th><th>Subtotal</th></tr>");
		NumberFormat currFormat = NumberFormat.getCurrencyInstance();
		out.println("<h1>"+ userName +"</h1>");
		double ordertotal = 0;
		double tax = 0.0;

		// Get customer address and name
		PreparedStatement addrpstmt = con.prepareStatement("SELECT customerId, firstName, lastName, address, city, state, postalcode, country FROM customer WHERE userid = ?");
		addrpstmt.setString(1, userName);
		ResultSet custaddr = addrpstmt.executeQuery();
		String name = "";
		
		// Save order information to database
		String sql = "INSERT INTO ordersummary (orderDate, shiptoAddress, shiptoCity, shiptoState, shiptoPostalCode, shiptoCountry, customerId) VALUES (?, ?, ?, ?, ?, ?, ?)";
		PreparedStatement pstmt = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);		
		int custId = 0;
		while (custaddr.next()) {
			//java.sql.Date sqlDate = new java.sql.Date(System.currentTimeMillis());
			//pstmt.setDate(1, sqlDate);
			custId = custaddr.getInt("customerId");
			Calendar cal = Calendar.getInstance();
			java.util.Date currentTime = cal.getTime();
			pstmt.setTimestamp (1, new Timestamp(currentTime.getTime()));
			pstmt.setString(2, custaddr.getString("address"));
			pstmt.setString(3, custaddr.getString("city"));
			pstmt.setString(4, custaddr.getString("state"));
			pstmt.setString(5, custaddr.getString("postalCode"));
			pstmt.setString(6, custaddr.getString("country"));
			pstmt.setString(7, Integer.toString(custId));
			name = custaddr.getString("firstName") + " " + custaddr.getString("lastName");
		}
			
		// Get orderId
		pstmt.executeUpdate();
		ResultSet keys = pstmt.getGeneratedKeys();
		keys.next();
		int orderId = keys.getInt(1);
		
		Iterator<Map.Entry<String, ArrayList<Object>>> iterator = productList.entrySet().iterator();
		while (iterator.hasNext()) { 
			Map.Entry<String, ArrayList<Object>> entry = iterator.next();
			ArrayList<Object> product = (ArrayList<Object>) entry.getValue();
			String productId = (String) product.get(0);
			if (productId == null) {
				continue;
			}
			//String productName = (String) product.get(1);
			String price = (String) product.get(2);
			double pr = Double.parseDouble(price);
			int qty = ((Integer)product.get(3)).intValue();
			out.println("<tr><td>" + productId + "</td><td>" + product.get(1) + "</td><td>" + qty + "</td><td>" + currFormat.format(pr) + "</td><td>" + currFormat.format(pr * qty) + "</td></tr>");

			// Update total amount for order record
			ordertotal += (pr*qty);

			// Insert each item into OrderProduct table using OrderId from previous INSERT
			PreparedStatement addorderprod = con.prepareStatement("INSERT INTO orderproduct (orderId, productId, quantity, price) VALUES (?, ?, ?, ?)");
			addorderprod.setInt (1, orderId);
			addorderprod.setInt (2, Integer.parseInt(productId));
			addorderprod.setInt (3, qty);
			addorderprod.setDouble (4, pr);
			addorderprod.executeUpdate();
		}
		out.println("<tr><td>Items</td><td>" + currFormat.format(ordertotal) + "</td></tr>");

		PreparedStatement statepstmt = con.prepareStatement("SELECT pst, gst, hst FROM taxrates WHERE state = ?");
		statepstmt.setString(1, userState);
		ResultSet staterst = statepstmt.executeQuery();
		int gst = 0, pst = 0, hst = 0;
		while (staterst.next()) {
			pst = Integer.parseInt(staterst.getString("pst"));
			gst = Integer.parseInt(staterst.getString("gst"));
			hst = Integer.parseInt(staterst.getString("hst"));
		}
		if(pst != 0) {
			double psttax = (ordertotal * pst) / 100;
			tax += psttax;
			out.println("<tr><td>PST</td>"
				+"<td>"+currFormat.format(psttax) +"</td></tr>");
		}
		if(gst != 0) {
			double gsttax = (ordertotal * gst) / 100;
			tax += gsttax;
			out.println("<tr><td>GST</td>"
				+"<td>"+currFormat.format(gsttax) +"</td></tr>");
		}
		if(hst != 0) {
			double hsttax = (ordertotal * pst) / 100;
			tax += hsttax;
			out.println("<tr><td>HST</td>"
				+"<td>"+currFormat.format(hsttax) +"</td></tr>");
		}

		double netordertotal = ordertotal + tax;
		out.println("<tr><td><b>Order Total</b></td><td>" + currFormat.format(netordertotal) + "</td></tr></table>");


		PreparedStatement idsummary = con.prepareStatement("UPDATE ordersummary SET totalAmount = ? WHERE orderId = ?");
		idsummary.setString(1, String.valueOf(netordertotal));
		idsummary.setString(2, String.valueOf(orderId));
		idsummary.executeUpdate();

		//out.println("<h1>Order Completed. Will be shipped soon...</h1><h1>Your order reference number is: " + orderId +"</h1>");
		//out.println("<h1>Shipping to customer: " + custId + " Name: " + name + "</h1>");

		// Print out order summary
		out.println ("<div align=\"center\">");
		out.println ("<h2>Order Completed.</h2>");
		out.println ("<h3 class=\"mb-3\">Your order number: " + orderId + "</h3>");
		out.println ("<h3>The order will be shipping soon to:</h3>");
		out.println ("<h4 class=\"ml-3\">Customer Id: " + custId + "</h4>");
		out.println ("<h4 class=\"ml-3\">Customer name: " + name + "</h4>");
		out.println ("</div>");

		// Clear cart if order placed successfully
		session.removeAttribute("productList");
	}
	} else {
		out.println("<p class=\"mb-3 text-center text-danger\">Not signed in</p>");
	}
	// Close connection
	closeConnection();
}
catch (SQLException ex) {
		System.err.println("SQLException: " + ex);
}
%>
</div>
<%
out.print (page_footer());
out.print (doc_end());
%>