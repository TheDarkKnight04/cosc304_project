<%@ include file="page.jsp" %>
<%@ include file="jdbc.jsp" %>
<%
  out.print (doc_head ("Warehouse"));
  out.print (page_header (false));
%>

<%

String url = "jdbc:sqlserver://cosc304_sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True";
String uid = "sa";
String pw = "304#sa#pw";

// TODO: Get warehouse ID
String warehouseId = request.getParameter("warehouseId");

try ( Connection con = DriverManager.getConnection(url, uid, pw);) {	
		out.println("<h1 class=\"my-3 text-center\">Product Inventory for Warehouse: " + warehouseId + "</h1>");

		String prodsql = "SELECT productinventory.productId, product.productName, productinventory.quantity FROM product JOIN productinventory ON product.productId = productinventory.productId WHERE productinventory.warehouseId = ?";
		PreparedStatement prodpstmt = con.prepareStatement(prodsql, ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
		prodpstmt.setString(1, warehouseId);
		ResultSet prodrst = prodpstmt.executeQuery();
        out.println("<table class=\"table w-50 mx-auto\"><tbody><tr><th>Product ID</th><th>Product Name</th><th>Quantity</th></tr>");
		while (prodrst.next()) {
			String prodId = prodrst.getString(1);
			String prodName = prodrst.getString(2);
			int quantity = prodrst.getInt(3);	
            if (prodId == null) {
                out.println("<h3 class=\"my-3 text-center\">No products in warehouse</h3>");
            } else {
                out.println("<tr><td>" + prodId + "</td><td>" + prodName + "</td><td>" + quantity + "</td></tr>");
            }
		}
        out.println("</tbody></table>");

		/*
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
        */			
}
catch (SQLException ex) {
	System.err.println("SQLException: " + ex); 
}

%>

<%
out.print (page_footer());
out.print (doc_end());
%>