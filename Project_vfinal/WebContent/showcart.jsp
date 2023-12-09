<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Map" %>
<%@ include file="jdbc.jsp" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
	
<%@ include file="auth.jsp" %>

<%
String userState = (String) session.getAttribute("authenticatedUserState");
// Get the current list of products
@SuppressWarnings({"unchecked"})
String delid = request.getParameter("delete");
String updid = request.getParameter("update");
HashMap<String, ArrayList<Object>> productList = (HashMap<String, ArrayList<Object>>) session.getAttribute("productList");

if (delid != null) {
	productList.remove(delid);
	session.setAttribute("productList", productList);
}
%>

<%@ include file="page.jsp" %>
<%
  out.print (doc_head ("Warehouse"));
  out.print (page_header (false));
%>

    <div class="px-5">

<%
if (updid != null) {
	String updqty = request.getParameter("newqty");
	try 
		{ 
			int updqtyint = Integer.parseInt(updqty); 
			if (updqtyint > 0) {
				//ArrayList<Object> product = new ArrayList<Object>();
				ArrayList<Object> product = (ArrayList<Object>) productList.get(updid);
				product.set(3, updqtyint);
				session.setAttribute("productList", productList);
			} else {
				out.println("<h3>Invalid quantity</h3>"); 
			}
		}  
		catch (NumberFormatException e)  
		{ 
			out.println("<h3>Invalid quantity</h3>"); 
		}
}

try ( 
	Connection con = DriverManager.getConnection(url, uid, pw);
	Statement stmt = con.createStatement();
) {
/*
PreparedStatement restorepstmt = con.prepareStatement("SELECT incart.productId, product.productName, product.productPrice, quantity FROM incart JOIN customer ON incart.customerId = customer.customerId JOIN product ON product.productId = incart.productId WHERE userid = ?");
restorepstmt.setString(1, userName);
ResultSet restorerst = restorepstmt.executeQuery();	
out.println("<h4>"+ userName+ "</h4>");
boolean empty = true;
while (restorerst.next()) {
	String prodid = restorerst.getString(1);
	String name = restorerst.getString(2);
	String price = restorerst.getString(3);
	Integer quantity = Integer.valueOf(restorerst.getString(4));
	ArrayList<Object> product = new ArrayList<Object>();
	product.add(prodid);
	product.add(name);
	product.add(price);
	product.add(quantity);
	if (productList.containsKey(prodid)) {
		product = (ArrayList<Object>) productList.get(prodid);
		int curAmount = ((Integer) product.get(3)).intValue();
		product.set(3, new Integer(curAmount+1));
	}
	else
		productList.put(prodid,product);
	session.setAttribute("productList", productList);
}
*/
if (productList == null || productList.size() == 0) {
	out.println("<h2 class=\"text-center m-1\">Your shopping cart is empty!</h2>");
	productList = new HashMap<String, ArrayList<Object>>();
} else
{
	NumberFormat currFormat = NumberFormat.getCurrencyInstance();
	out.println("<form name=\"formcart\">");
	out.println("<h2 class=\"pb-2 mb-3 border-bottom\">Your Shopping Cart</h2>");
	out.print("<table class=\"table\"><tr><th>Id</th><th>Product Name</th><th>Quantity</th>");
	out.println("<th>Price</th><th>Subtotal</th><th></th><th></th></tr>");

	double total =0;
	int i = 1;
	Iterator<Map.Entry<String, ArrayList<Object>>> iterator = productList.entrySet().iterator();
	while (iterator.hasNext()) 
	{	Map.Entry<String, ArrayList<Object>> entry = iterator.next();
		ArrayList<Object> product = (ArrayList<Object>) entry.getValue();
		if (product.size() < 4)
		{
			out.println("Expected product with four entries. Got: "+product);
			continue;
		}
		Object prodid = product.get(0);
		int productid = 0;
		try
		{
			productid = Integer.parseInt(prodid.toString());
		}
		catch (Exception e)
		{
			out.println("Invalid id for product: "+product.get(0));
		}

		out.print("<tr><td>" + product.get(0) + "</td>");
		out.print("<td>" + product.get(1)+"</td>");
		

		out.print("<td class=\"text-center\"><input type=\"text\" name=\"newqty" + i +"\" size =\"3\" value=\"" + product.get(3) +"\"></td>");
		Object price = product.get(2);
		Object itemqty = product.get(3);
		double pr = 0;
		int qty = 0;
		
		try
		{
			pr = Double.parseDouble(price.toString());
		}
		catch (Exception e)
		{
			out.println("Invalid price for product: "+product.get(0)+" price: "+price);
		}
		try
		{
			qty = Integer.parseInt(itemqty.toString());
		}
		catch (Exception e)
		{
			out.println("Invalid quantity for product: "+product.get(0)+" quantity: "+qty);
		}		

		out.print("<td align=\"right\">"+currFormat.format(pr)+"</td>");
		out.print("<td align=\"right\">"+currFormat.format(pr*qty)+"</td>");
		out.print("<td><a href =" + "\"showcart.jsp?delete=" + prodid + "\">Remove Item</a></td>");
		String updateLink = "<input size=\"2\" type=\"button\" ";
		updateLink += "onclick=\"javascript:update(" + prodid + ", document.formcart.newqty" + i + ".value)\"";
		updateLink += " value=\"Update Quantity\">";
		out.print ("<td>" + updateLink + "</td>");
		out.print("</tr>");
		i++;
		total += pr*qty;
	}

	PreparedStatement statepstmt = con.prepareStatement("SELECT pst, gst, hst FROM taxrates WHERE state = ?");
	statepstmt.setString (1, userState);
	ResultSet staterst = statepstmt.executeQuery();
	int gst = 0, pst = 0, hst = 0;
	while (staterst.next()) {
		pst = Integer.parseInt(staterst.getString("pst"));
		gst = Integer.parseInt(staterst.getString("gst"));
		hst = Integer.parseInt(staterst.getString("hst"));
	}
	double tax = 0.0;
	out.println("<tr><td colspan=\"4\" align=\"right\"><b>Items</b></td>"
		+"<td align=\"right\">"+currFormat.format(total)+"</td></tr>");
	if(pst != 0) {
		double psttax = (total * pst) / 100;
		tax += psttax;
		out.println("<tr><td colspan=\"4\" align=\"right\"><b>PST</b></td>"
			+"<td align=\"right\">"+currFormat.format(psttax) +"</td></tr>");
	}
	if(gst != 0) {
		double gsttax = (total * gst) / 100;
		tax += gsttax;
		out.println("<tr><td colspan=\"4\" align=\"right\"><b>GST</b></td>"
			+"<td align=\"right\">"+currFormat.format(gsttax) +"</td></tr>");
	}
	if(hst != 0) {
		double hsttax = (total * pst) / 100;
		tax += hsttax;
		out.println("<tr><td colspan=\"4\" align=\"right\"><b>HST</b></td>"
			+"<td align=\"right\">"+currFormat.format(hsttax) +"</td></tr>");
	}
	double nettotal = total + tax;
	out.println("<tr><td colspan=\"4\" align=\"right\"><b>Order Total</b></td>"
			+"<td align=\"right\">"+currFormat.format(nettotal)+"</td></tr>");
	out.println("</table>");

	//out.println("<h2><a href=\"order.jsp\">Check Out</a></h2>");
	%>
	<div class="row">
		<div class="col-md-4">&nbsp;</div>
		<div class="col-md-4"><a href="order.jsp" class="btn btn-primary text-decoration-none">Check Out</a></div>
		<div class="col-md-4">&nbsp;</div>
	</div>
	<%
	closeConnection();
}
} catch (SQLException ex) {
	System.err.println("SQLException: " + ex);
}
out.print("</form>");
%>
<h5 class="mt-5"><a href="listprod.jsp" class="text-decoration-none">&larr; Continue Shopping</a></h5>
</div>
<script>
	function update(newid, newqty) {
		window.location = "showcart.jsp?update=" + newid +"&newqty="+ newqty;
	}
</script>
<%
out.print (page_footer());
out.print (doc_end());
%>