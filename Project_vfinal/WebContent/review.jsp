<!DOCTYPE html>
<%@ page import="java.util.Date" %>
<%@ page import="java.util.Calendar" %>
<%@ include file="jdbc.jsp" %>
<%@ include file="auth.jsp" %>
<%@ include file="page.jsp" %>
<!--
<html>
<head>
<title>Santam's Grocery | Write a review</title>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.0.0/dist/css/bootstrap.min.css" integrity="sha384-Gn5384xqQ1aoWXA+058RXPxPg6fy4IWvTNh0E263XmFcJlSAwiGgFAW/dAiS6JXm" crossorigin="anonymous">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.0.0/dist/js/bootstrap.min.js" integrity="sha384-JZR6Spejh4U02d8jOt6vLEHfe/JQGiRRSQQxSfFWpi1MquVdAyjUar5+76PVCmYl" crossorigin="anonymous"></script>
</head>
<body>
	<%@ include file="shopHeader.jsp" %>

<!--<div style="margin:0 auto;text-align:center;display:inline">
-->


<%
  out.print (doc_head ("Review"));
  out.print (page_header (false));
%>
<h3 class="text-center mb-3">Thanks for reviewing!</h3>
<%

String rating = request.getParameter("rating");
String prodid = request.getParameter("prodid");
String comment = request.getParameter("comment");

try ( 
    Connection con = DriverManager.getConnection(url, uid, pw);
    Statement stmt = con.createStatement();
) 
{
    Calendar cal = Calendar.getInstance();
	java.util.Date currentTime = cal.getTime();

    PreparedStatement custpstmt = con.prepareStatement("SELECT customerId FROM customer WHERE userid = ?");
    custpstmt.setString(1, userName);
    ResultSet custrst = custpstmt.executeQuery();
    String custId = "";
    while (custrst.next()) {
        custId = custrst.getString(1);
    }

    PreparedStatement alrpstmt = con.prepareStatement("SELECT reviewId FROM review WHERE customerId = ? AND productId = ?");
    alrpstmt.setString(1, custId);
    alrpstmt.setString(2, prodid);
    ResultSet alrrst = alrpstmt.executeQuery();
    boolean reviewed = false;
    while (alrrst.next()) {
        if (alrrst.getString("reviewId") != null) {
            reviewed = true;
        }
    }
    if (!reviewed) {
        String sql = "INSERT INTO review (reviewRating, reviewDate, customerId, productId, reviewComment) VALUES (?, ?, ?, ?, ?)";
        PreparedStatement pstmt = con.prepareStatement(sql);
        Timestamp ts = new Timestamp(currentTime.getTime());
        pstmt.setString(1, rating);
        pstmt.setTimestamp (2, ts);
        pstmt.setString(3, custId);
        pstmt.setString(4, prodid);
        pstmt.setString(5, comment);
        pstmt.executeUpdate();
        out.println("<h4 class=\"text-center mb-3\"> Review successfully published</h4>");
    } else {
        out.println("<h4 class=\"text-center mb-3\">Unfortunately, you can only review products once.</h4>");
    }

    
        // Make sure to close connection
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
<!--
</body>
</html>
-->