<%@ page import="java.sql.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.Calendar" %>
<%@ include file="jdbc.jsp" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>

<%
	String output = "";
	String confout = "";
%>


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
		output += "<div class=\"alert alert-warning\" role=\"alert\">";
		output += "Your shopping cart is empty!";
		output += "</div>\n";
		productList = new HashMap<String, ArrayList<Object>>();
	} else {
		output += "<h3 class=\"pb-2 mb-3 border-bottom\">Your Order Summary</h2>\n";
		output += "<table class=\"table table-striped\">\n";
		output += "  <tr>\n";
		output += "    <th>Product Id</th><th>Product Name</th><th>Quantity</th><th>Price</th><th>Subtotal</th>\n";
		output += "  </tr>\n";

		NumberFormat currFormat = NumberFormat.getCurrencyInstance();
		//out.println("<h1>"+ userName +"</h1>");
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
			output += "<tr>\n";
			output += "  <td>" + productId + "</td><td>" + product.get(1) + "</td><td>" + qty + "</td><td>" + currFormat.format(pr) + "</td><td>" + currFormat.format(pr * qty) + "</td>\n";
			output += "</tr>\n";

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
		output += "<tr>\n";
		output += "  <td colspan=\"4\">Items</td><td>" + currFormat.format(ordertotal) + "</td>\n";
		output += "</tr>";

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
			output += "<tr>\n";
			output += "  <td colspan=\"4\">PST</td><td>" + currFormat.format(psttax) + "</td>\n";
			output += "</tr>\n";
		}
		if(gst != 0) {
			double gsttax = (ordertotal * gst) / 100;
			tax += gsttax;
			output += "<tr>\n";
			output += "  <td colspan=\"4\">GST</td><td>" + currFormat.format(gsttax) + "</td>\n";
			output += "</tr>\n";
		}
		if(hst != 0) {
			double hsttax = (ordertotal * pst) / 100;
			tax += hsttax;
			output += "<tr>\n";
			output += "  <td colspan=\"4\">HST</td><td>" + currFormat.format(hsttax) + "</td>\n";
			output += "</tr>\n";
		}

		double netordertotal = ordertotal + tax;
		output += "  <tr>\n";
		output += "    <td colspan=\"4\"><b>Order Total</b></td><td>" + currFormat.format(netordertotal) + "</td>\n";
		output += "  </tr>\n";
		output += "</table>\n";


		PreparedStatement idsummary = con.prepareStatement("UPDATE ordersummary SET totalAmount = ? WHERE orderId = ?");
		idsummary.setString(1, String.valueOf(netordertotal));
		idsummary.setString(2, String.valueOf(orderId));
		idsummary.executeUpdate();

		//out.println("<h1>Order Completed. Will be shipped soon...</h1><h1>Your order reference number is: " + orderId +"</h1>");
		//out.println("<h1>Shipping to customer: " + custId + " Name: " + name + "</h1>");

		// Print out order summary
		confout += "<h3 class=\"pb-2 mb-3 border-bottom\">Order Completed!</h2>\n";
		confout += "<div class=\"alert alert-success\" role=\"alert\">\n";
		confout += "  <p class=\"fs-5 text-center\">Your order number is</p>\n";
		confout += "  <p class=\"fs-1 fw-bold text-center my-2\">" + orderId + "</p>\n";
		confout += "  <p class=\"fs-5\">The order will be shipping soon to</p>\n";
		confout += "  <p class=\"fs-5 text-center\">Customer id: " + custId + " &nbsp;&nbsp;&nbsp;&nbsp;Customer name: " + name + "</p>\n";
		confout += "</div>";

		// Clear cart if order placed successfully
		session.removeAttribute ("productList");
	}
	} else {
		output += "<div class=\"alert alert-success\" role=\"alert\">\n";
		output += "Not signed in!\n";
		output += "</div>";
	}
	// Close connection
	closeConnection();
}
catch (SQLException ex) {
		System.err.println("SQLException: " + ex);
}
%>

<%@ include file="page.jsp" %>
<%
out.print (doc_head ("Order"));
out.print (page_header (false));
out.print (confout);
out.print (output);
out.print ("<h5 class=\"mt-5\"><a href=\"listprod.jsp\" class=\"text-decoration-none\">&larr; Continue Shopping</a></h5>");
out.print (page_footer());
out.print (doc_end());
%>