<%@ page import="java.sql.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.util.Calendar" %>
<%@ include file="jdbc.jsp" %>
<%@ include file="page.jsp" %>
<%
  out.print (doc_head ("Admin"));
  out.print (page_header (false));
%>

<%

String url = "jdbc:sqlserver://cosc304_sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True";
String uid = "sa";
String pw = "304#sa#pw";

// TODO: Get order id
String orderId = request.getParameter("orderId");

try ( Connection con = DriverManager.getConnection(url, uid, pw);) {		
	Statement stmt = con.createStatement();

	// TODO: Check if valid order id in database
	String sql = "SELECT orderId FROM ordersummary";
	ResultSet rst = stmt.executeQuery(sql);
	boolean validId = false;
	while (rst.next()) {
		String listId = rst.getString("orderId");
		if (listId.equals(orderId)) {
			validId = true;
		}
	}

	if (validId) {

		out.println("<h1 class=\"my-3 text-center\">Shipping Details for Order: " + orderId + "</h1>");

		// TODO: Start a transaction (turn-off auto-commit)
		con.setAutoCommit(false);			// Set auto-commit to false so can support transactions

		// TODO: Retrieve all items in order with given id
		String prodsql = "SELECT orderproduct.productId, orderproduct.quantity, productinventory.quantity FROM orderproduct JOIN productinventory ON orderproduct.productId = productinventory.productId WHERE orderproduct.orderId = ?";
		PreparedStatement prodpstmt = con.prepareStatement(prodsql, ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
		prodpstmt.setString(1, orderId);
		ResultSet prodrst = prodpstmt.executeQuery();

		// TODO: Create a new shipment record.
		String shipsql ="INSERT INTO shipment (shipmentDate, warehouseId) VALUES (?, 1)";
		PreparedStatement shippstmt = con.prepareStatement(shipsql);
		Calendar cal = Calendar.getInstance();
		java.util.Date currentTime = cal.getTime();
		shippstmt.setTimestamp (1, new Timestamp(currentTime.getTime()));
		shippstmt.executeUpdate();

		// TODO: For each item verify sufficient quantity available in warehouse 1.

		// TODO: If any item does not have sufficient inventory, cancel transaction and rollback. Otherwise, update inventory for each item.
		boolean validship = true;
		while (prodrst.next() && validship) {
			int prodId = prodrst.getInt(1);
			int reqAmount = prodrst.getInt(2);
			int availAmount = prodrst.getInt(3);	
			int newAmount = availAmount - reqAmount;
			if (reqAmount > availAmount) {
				out.println("<p class=\"mb-3 h3 text-center text-danger\">Shipment not processed. Insufficient inventory for product id: " + prodId + "</p>");
				con.rollback();
				validship = false;
			} else {
				String itemsql= "UPDATE productinventory SET quantity = ? WHERE productId = ?";
				PreparedStatement itempstmt = con.prepareStatement(itemsql);
				itempstmt.setString(1, Integer.toString(newAmount));
				itempstmt.setString(2, Integer.toString(prodId));
				itempstmt.executeUpdate();
				//out.println("<h2>Ordered Product: " + prodId + " Qty: " + reqAmount + " Previous Inventory: " + availAmount + " New Inventory: " + newAmount + "</h2>");
			}
		}

		if (validship) {
			prodrst.beforeFirst();
			out.println ("<table class=\"table w-50 mx-auto\"><tbody>");
			out.println ("<tr><th class=\"w-25\">Product Id</th><th class=\"w-25\">Quantity</th><th class=\"w-25\">Old Inventory</th><th class=\"w-25\">New Inventory</th></tr>");
			while (prodrst.next()) {
				int prodId = prodrst.getInt(1);
				int reqAmount = prodrst.getInt(2);
				int availAmount = prodrst.getInt(3);	
				int newAmount = availAmount - reqAmount;
				out.println ("<tr>");
				out.print ("<td class=\"w-25 text-center\">" + prodId + "</td>");
				out.print ("<td class=\"w-25 text-center\">" + reqAmount + "</td>");
				out.print ("<td class=\"w-25 text-center\">" + availAmount + "</td>");
				out.print ("<td class=\"w-25 text-center\">" + newAmount + "</td>");
				out.println ("</tr>");
			}
			out.println ("</tbody></table>");
		}

		con.commit();

		// TODO: Auto-commit should be turned back on
		con.setAutoCommit(true);			

	} else {
		out.println("<h1 class=\"my-3 text-center\">Order ID not found!</h1>");
	}	
}
catch (SQLException ex) {
	System.err.println("SQLException: " + ex); 
}

%>                       				

<h2 class="my-3 text-center"><a href="home.jsp">Back to Main Page</a></h2>

<%
out.print (page_footer());
out.print (doc_end());
%>
