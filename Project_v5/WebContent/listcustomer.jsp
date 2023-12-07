<!DOCTYPE html>
<%@ include file="jdbc.jsp" %>
<%@ page import="java.text.NumberFormat"%>
<html>
<head>
<title>Santam's Grocery | Customer List</title>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.0.0/dist/css/bootstrap.min.css" integrity="sha384-Gn5384xqQ1aoWXA+058RXPxPg6fy4IWvTNh0E263XmFcJlSAwiGgFAW/dAiS6JXm" crossorigin="anonymous">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.0.0/dist/js/bootstrap.min.js" integrity="sha384-JZR6Spejh4U02d8jOt6vLEHfe/JQGiRRSQQxSfFWpi1MquVdAyjUar5+76PVCmYl" crossorigin="anonymous"></script>
</head>
<body>

<%
// TODO: Include files auth.jsp and jdbc.jsp
%>
<%@ include file="shopHeader.jsp" %>
<%@ include file="auth.jsp"%>
<%
try ( 
	Connection con = DriverManager.getConnection(url, uid, pw);
	Statement stmt = con.createStatement();
) 
{
    // TODO: Write SQL query that prints out total order amount by day
    //String sql = "SELECT orderDate, SUM(totalAmount) AS total FROM ordersummary GROUP BY orderDate";
    //String sql = "SELECT orddate, SUM(total) FROM (SELECT CONVERT(DATE, orderDate) AS orddate, totalAmount AS total FROM ordersummary) src GROUP BY CONVERT(DATE, orderDate)";
    String sql = "SELECT customerId, firstName, lastName, email, phoneNum, address, city, state, postalCode, country, userid FROM customer";
    PreparedStatement pstmt = con.prepareStatement(sql);
    ResultSet rst = pstmt.executeQuery();
    out.println ("<h2 class=\"text-center mb-3\">List of Customers</h2>");
    out.println ("<table class=\"table w-50 mx-auto\"><tbody>");
    out.println("<tr><th class=\"w-50\">Customer Id</th><th class=\"w-50\">First Name</th><th class=\"w-50\">Last Name</th><th class=\"w-50\">Email</th><th class=\"w-50\">Phone Number</th><th class=\"w-50\">Address</th><th class=\"w-50\">City</th><th class=\"w-50\">State</th><th class=\"w-50\">Postal Code</th><th class=\"w-50\">Country</th><th class=\"w-50\">User Id</th></tr>");
    NumberFormat currFormat = NumberFormat.getCurrencyInstance();
    
    while (rst.next()) {
        out.println("<tr><td class=\"w-50\">" + rst.getString(1) + "</td><td class=\"w-50\">" + rst.getString(2) + "</td><td class=\"w-50\">" + rst.getString(3) + "</td><td class=\"w-50\">" + rst.getString(4) + "</td><td class=\"w-50\">" + rst.getString(5) + "</td><td class=\"w-50\">" + rst.getString(6) + "</td><td class=\"w-50\">" + rst.getString(7) + "</td><td class=\"w-50\">" + rst.getString(8) + "</td><td class=\"w-50\">" + rst.getString(9) + "</td><td class=\"w-50\">" + rst.getString(10) + "</td><td class=\"w-50\">" + rst.getString(11) + "</td></tr>");
    }
    out.println("</tbody></table>");

    closeConnection();
}
catch (SQLException ex) {
	System.err.println("SQLException: " + ex);
}
%>

<h2 align="center"><a href="admin.jsp">Administrator Portal</a></h2>
</body>
</html>

