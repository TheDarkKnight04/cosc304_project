<%@ include file="jdbc.jsp" %>
<%@ page import="java.text.NumberFormat"%>
<%@ include file="page.jsp" %>

<%
  out.print (doc_head ("Sales Report"));
  out.print (page_header (false));
%>

<%
try ( 
	Connection con = DriverManager.getConnection(url, uid, pw);
	Statement stmt = con.createStatement();
) 
{
    // TODO: Write SQL query that prints out total order amount by day
    String sql = "SELECT CONVERT(DATE, orderDate) orddate, SUM(totalAmount) AS total FROM ordersummary GROUP BY CONVERT(DATE, orderDate)";
    PreparedStatement pstmt = con.prepareStatement(sql);
    ResultSet rst = pstmt.executeQuery();

    out.println ("<h2 class=\"pb-2 border-bottom text-center mb-3\">Administrator Sales Report by Day</h2>");
    out.println ("<table class=\"table w-50 mx-auto\"><tbody>");
    out.println("<tr><th class=\"w-50 text-right\">Order Date</th><th class=\"w-50 text-left\">Total Order Amount</th></tr>");
    NumberFormat currFormat = NumberFormat.getCurrencyInstance();
    
    while (rst.next()) {
        out.println("<tr><td class=\"w-50 text-right\">" + rst.getString("orddate") + "</td><td class=\"w-50 text-left\">" + currFormat.format(rst.getDouble("total")) + "</td></tr>");
    }
    out.println("</tbody></table>");

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