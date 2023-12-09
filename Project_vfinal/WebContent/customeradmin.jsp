<%@ page import="java.sql.*,java.net.URLEncoder" %>
<%@ include file="jdbc.jsp" %>
<%@ include file="page.jsp" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>

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

try ( 
	Connection con = DriverManager.getConnection(url, uid, pw);
	Statement stmt = con.createStatement();
)  {
	String delid = request.getParameter("delete");
	if (delid != null) {
		String query = "DELETE FROM customer WHERE customerId=?";
		PreparedStatement delpstmt = con.prepareStatement (query);
        
		delpstmt.setString (1, delid);
		delpstmt.executeUpdate();

        session.setAttribute ("adminMessage", "Customer id: " + delid + " deleted.");
	}
	closeConnection();
}
catch (SQLException ex) {
	System.err.println("SQLException: " + ex);
}	
%>


<%
  String adminmsg = (String) session.getAttribute("adminMessage");
  
  out.print (doc_head ("Customer Admin"));
  out.print (page_header (false));

  if (adminmsg != null) {
	out.println ("<div class=\"alert alert-success\" role=\"alert\">");
	out.println (adminmsg);
	out.println ("</div>");
	session.removeAttribute ("adminMessage");
  }
%>
<div class="container px-4">
    <%
try ( 
	Connection con = DriverManager.getConnection(url, uid, pw);
	Statement stmt = con.createStatement();
)  {
	String query = "SELECT customerId, userid, email, phonenum, city, state FROM customer";
	ResultSet rst = stmt.executeQuery (query);

    out.println("<div class=\"row\">");
    %>
    <div class="col-md-9">&nbsp;</div>
    <div class="col-md-3">
        <button type="button" class="btn btn-primary mx-auto"><a href="editcustomer.jsp" style="text-decoration: none;">New Customer</a></button>
    </div>
    <%
    out.println("<h3>" + "All Customers" + "</h3>");

    out.println("<table class=\"table\"><tr><th></th><th>Customer Id</th><th>User Id</th><th>Email</th><th>Phone</th><th>City</th>");
    while (rst.next()) {
        String custId = rst.getString("customerId");
        String custAccount = rst.getString("userid");
        String custEmail = rst.getString("email");
        String custPhone = rst.getString("phonenum");
        String custCity = rst.getString("city");
        String custState = rst.getString("state");
        %>
        <tr>
            <td>
                <a class="btn btn-outline-primary" href="editcustomer.jsp?id=<%= custId %>">Edit</a>
                <!--<a class="btn btn-danger" href="customeradmin.jsp?delete=<%= custId %>">Delete</a>-->
            </td>
            <td>
                <%= custId %>
            </td>
            <td><%= custAccount %></td>
            <td><%= custEmail %></td>
            <td><%= custPhone %></td>
            <td><%= custCity %>, <%= custState %></td>
        </tr>
        <%
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