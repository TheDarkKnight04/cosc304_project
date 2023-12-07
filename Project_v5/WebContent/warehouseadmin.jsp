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
		String query = "DELETE FROM warehouse WHERE warehouseId=?";
		PreparedStatement delpstmt = con.prepareStatement (query);
        
		delpstmt.setString (1, delid);
		delpstmt.executeUpdate();

        session.setAttribute ("adminMessage", "Warehouse id: " + delid + " deleted.");
	}
	closeConnection();
}
catch (SQLException ex) {
	System.err.println("SQLException: " + ex);
}	
%>

<%
  String userid = (String) session.getAttribute("authenticatedUser");
  String adminmsg = (String) session.getAttribute("adminMessage");
  
  out.print (doc_head ("Warehouse Admin"));
  out.print (page_header (userid));

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
	String query = "SELECT warehouseId, warehouseName FROM warehouse";
	ResultSet rst = stmt.executeQuery (query);

    out.println("<div class=\"row\">");
    %>
    <div class="col-md-9">&nbsp;</div>
    <div class="col-md-3">
        <button type="button" class="btn btn-primary mx-auto"><a href="editwarehouse.jsp" style="text-decoration: none;">New Warehouse</a></button>
    </div>
    <%
    
    out.println("<h3>" + "All Warehouses" + "</h3>");

    out.println("<table class=\"table\"><tr><th></th><th>Warehouse Id</th><th>Warehouse Name</th>");
    while (rst.next()) {
        String whouseId = rst.getString("warehouseId");
        String whouseName = rst.getString("warehouseName");
        %>
        <tr>
            <td>
                <a class="btn btn-outline-primary" href="editwarehouse.jsp?id=<%= whouseId %>">Edit</a>
                <!--<a class="btn btn-danger" href="warehouseadmin.jsp?delete=<%= whouseId %>">Delete</a>-->
            </td>
            <td><%= whouseId %></td>
            <td><%= whouseName %></td>
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
