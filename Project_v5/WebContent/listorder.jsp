<%@ page import="java.sql.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ include file="jdbc.jsp" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<%@ include file="auth.jsp" %>
<%@ include file="page.jsp" %>

<%
  String userName = (String) session.getAttribute("authenticatedUser");

  out.print (doc_head ("Orders"));
  out.print (page_header (userName));
%>
<h2 class="pb-2 border-bottom">Customer's Order List</h2>

<%
//Note: Forces loading of SQL Server driver
try
{	// Load driver class
	Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
}
catch (java.lang.ClassNotFoundException e)
{
	out.println("ClassNotFoundException: " +e);
}

// Useful code for formatting currency values:
// NumberFormat currFormat = NumberFormat.getCurrencyInstance();
// out.println(currFormat.format(5.0);  // Prints $5.00

// Make connection
String url = "jdbc:sqlserver://cosc304_sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True";		
String uid = "sa";
String pw = "304#sa#pw";

try ( 
	Connection con = DriverManager.getConnection(url, uid, pw);
	Statement stmt = con.createStatement();
)  {
	// Write query to retrieve all order summary records
	// Print out the order summary information

	String query = "SELECT ordersummary.orderId, ordersummary.orderDate, ordersummary.customerId, customer.firstName, customer.lastName, ordersummary.totalAmount FROM ordersummary JOIN customer ON ordersummary.customerId = customer.customerId WHERE customer.userid = ? ORDER BY ordersummary.orderId ASC";
	PreparedStatement pstmt = con.prepareStatement(query);	
	pstmt.setString(1, userName);
	ResultSet rst = pstmt.executeQuery();

	// For each order in the ResultSet

	out.println("<table class=\"table\"><tr><th>Order Id</th><th>Order Date</th><th>Customer Id</th><th>Customer Name</th><th>Total Amount</th></tr>");
	NumberFormat currFormat = NumberFormat.getCurrencyInstance();
	while (rst.next()){
		out.println("<tr><td>" + rst.getString("orderId") + "</td><td>" + rst.getString("orderDate") + "</td><td>" + rst.getString("customerId") + "</td><td>" + rst.getString("firstName") + " " +  rst.getString("lastName") + "</td><td>" + currFormat.format(rst.getDouble("totalAmount")) +"</td></tr>");
		
		// Write a query to retrieve the products in the order
		//   - Use a PreparedStatement as will repeat this query many times
		String orderId = rst.getString("orderId");

		// For each product in the order
		// Write out product information 

		String prodquery = "SELECT productId, quantity, price FROM orderproduct WHERE orderId = ? ORDER BY productId ASC";
		PreparedStatement prodpstmt = con.prepareStatement(prodquery);
		prodpstmt.setString(1, orderId);
		ResultSet prodrst = prodpstmt.executeQuery();
		out.println("<tr><td colspan=\"3\"></td><td><table><tr><th>Product Id</th><th>Quantity</th><th>Price</th></tr>");
		while (prodrst.next()) {
			out.println("<tr><td>" + prodrst.getString("productId") + "</td><td>" + prodrst.getString("quantity") + "</td><td>" + currFormat.format(prodrst.getDouble("price")) +"</td></tr>");	
		}
		out.println("</td></table></tr>");
	}
	out.println("</table>");
	// Close connection
	closeConnection();
}
catch (SQLException ex) {
		System.err.println("SQLException: " + ex);
}	
%>
<%
out.print (page_footer());
out.print (doc_end());
%>
