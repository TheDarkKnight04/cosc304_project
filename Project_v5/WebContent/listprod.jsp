<%@ page import="java.sql.*,java.net.URLEncoder" %>
<%@ page import="java.text.NumberFormat" %>
<%@ include file="jdbc.jsp" %>
<%@ include file="page.jsp" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>

<%
  String userid = (String) session.getAttribute("authenticatedUser");

  out.print (doc_head ("Products"));
  out.print (page_header (userid));
%>
<div class="container px-4">
	<form class="row g-3" method="get" action="listprod.jsp">
		<h2 class="pb-2 mb-3 border-bottom">
			Search Products
		</h2>
		<div class="col-md-4">
			<select class="form-select" aria-label="Pick product category" name="category" id="category">
				<option value="" selected>Any category</option>
				<option value="Skis">Skis</option>
				<option value="Snowboards">Snowboards</option>
				<option value="Jackets">Jackets</option>
				<option value="Ski Boots">Ski Boots</option>
				<option value="Snowboard Bindings">Snowboard Bindings</option>
				<option value="Helmets">Helmets</option>
				<option value="Apparel">Apparel</option>
				<option value="Goggles">Goggles</option>
			</select>
		</div>
		<div class="col-md-6">
			<div class="input-group mb-3">
				<input type="text"  name="productName" class="form-control" placeholder="Product name" aria-label="Product name" aria-describedby="button-reset">
				<button class="btn btn-outline-danger" type="button" id="button-reset">Reset</button>
			</div>
		</div>
		<div class="col-md-2">
			<input class="ml-2 btn btn-primary" type="submit" value="Submit">
		</div>
	</form>
	
	<!--
	<div align="center" class="mb-3">
		<form method="get" action="listprod.jsp">
			<select name="category" id="category">
				<option value="">All</option>
				<option value="Skis">Skis</option>
				<option value="Snowboards">Snowboards</option>
				<option value="Jackets">Jackets</option>
				<option value="Ski Boots">Ski Boots</option>
				<option value="Snowboard Bindings">Snowboard Bindings</option>
				<option value="Helmets">Helmets</option>
				<option value="Apparel">Apparel</option>
				<option value="Goggles">Goggles</option>
			</select> 
		<input type="text" name="productName" size="50" class="mx-2">
		<input class="ml-2" type="submit" value="Submit"><input class="mx-2" type="reset" value="Reset"> (Leave blank for all products)
		</form>		
	</div>
	-->

<% // Get product name to search for
String name = request.getParameter("productName");
String categorydrop = request.getParameter("category");
		
// for clearing the session, forcibly
/*
session = request.getSession(false);
if (session != null) {
	session.invalidate();
}
*/

//Note: Forces loading of SQL Server driver
try
{	// Load driver class
	Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
}
catch (java.lang.ClassNotFoundException e)
{
	out.println("ClassNotFoundException: " +e);
}

// Variable name now contains the search string the user entered
// Use it to build a query and print out the resultset.  Make sure to use PreparedStatement!

// Make the connection
String url = "jdbc:sqlserver://cosc304_sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True";		
String uid = "sa";
String pw = "304#sa#pw";

try ( 
	Connection con = DriverManager.getConnection(url, uid, pw);
	Statement stmt = con.createStatement();
)  {
	String query = "SELECT productId, productName, ProductPrice, categoryName FROM product JOIN category ON product.categoryId = category.categoryId WHERE productName LIKE CONCAT('%', ?, '%') AND categoryName LIKE CONCAT('%', ?, '%')";
	PreparedStatement pstmt = con.prepareStatement(query);
	pstmt.setString(1, name);
	pstmt.setString(2, categorydrop);
	ResultSet rst = pstmt.executeQuery();

	out.println("<div class=\"row\">");
	if (name == null || name == "") {
		if (categorydrop == "" || categorydrop == null){
			out.println("<h3>" + "All Products" + "</h3>");
		} else {
			out.println("<h3>" + "Products in category: '" + categorydrop + "'</h3>");
		}		
	} else {
		if (categorydrop == "" || categorydrop == null){
			out.println("<h3>" + "Products containing '" + name + "'</h3>");
		} else {
			out.println("<h3>" + "Products containing '" + name + "' in category: '" + categorydrop + "'</h3>");
		}
	}

	out.println("<table class=\"table\"><tr><th></th><th>Product Name</th><th>Category</th><th>Price</th>");
		
	NumberFormat currFormat = NumberFormat.getCurrencyInstance();
	while (rst.next()) {
		String productId = rst.getString("productId");
		String productName = rst.getString("productName");
		Double productPrice = rst.getDouble("productPrice");
		String category	= rst.getString("categoryName");
		out.println("<tr><td>" + "<a href=\"addcart.jsp?id=" + productId + "&name=" + productName + "&price=" + productPrice + "\">Add to Cart</a>" + "</td><td>" + "<a href=\"product.jsp?id=" + productId + "\">" + productName + "</a>" + "</td><td>" + category + "</td><td>" + currFormat.format(productPrice) + "</td></tr>");
	}
	out.println ("</table>");
	out.println ("</div>");
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