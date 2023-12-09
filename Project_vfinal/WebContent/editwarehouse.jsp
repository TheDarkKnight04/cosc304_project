<%@ include file="jdbc.jsp" %>
<%@ include file="page.jsp" %>

<%
String idstr = request.getParameter ("id");
String pagehdr = "";
String submit_label = "";
int whouseid = 0;

if (idstr != null) {
    pagehdr = "Edit Warehouse";
    submit_label = "Update Warehouse";
    whouseid = Integer.parseInt (idstr);
} else {
    pagehdr = "New Warehouse";
    submit_label = "Add Warehouse";
    whouseid = 0;
}

out.print (doc_head (pagehdr));  
out.print (page_header (false));

// data validation - begin
String adminerrmsg = (String) session.getAttribute("adminErrorMessage");

if (adminerrmsg != null) {
	out.println ("<div class=\"alert alert-danger\" role=\"alert\">");
	out.println (adminerrmsg);
	out.println ("</div>");
	session.removeAttribute ("adminErrorMessage");
}
// data validation - end
%>

<%
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
    String query = "";
    PreparedStatement pstmt;
    ResultSet rset;
    String whouse_name = "";

    if (whouseid > 0) {
        query = "SELECT warehouseName FROM warehouse WHERE warehouseId=?";
        pstmt = con.prepareStatement(query);

        pstmt.setInt (1, whouseid);
        rset = pstmt.executeQuery();
        while (rset.next()) {
            whouse_name = rset.getString ("warehouseName");
        }   
    }
%>
<div class="form-customer w-100 border p-4 mx-auto">
    <form class="row" name="customerForm" method=post action="updateWarehouse.jsp">
        <h1 class="h3 mb-3 fw-normal"><%= pagehdr %></h1>
    
        <input type="hidden" id="whouseid" name="whouseid" value="<%= whouseid %>">
        <div class="col-md-12">
            <div class="form-floating mb-2">
                <input name="whousename" type="text" class="form-control" id="inputWhousename" placeholder="Warehouse name" value="<%= whouse_name %>">
                <label for="inputCustfname">Warehouse name</label>
            </div>    
        </div>

        <button class="btn btn-primary w-100 py-2" type="submit"><%= submit_label %></button>
    </form>	
</div>
<%
}
out.print (page_footer());
out.print (doc_end());
%>    