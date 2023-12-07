<%@ include file="jdbc.jsp" %>

<%
String id = request.getParameter ("whouseid");
String name = request.getParameter ("whousename");

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
    int wh_id = Integer.parseInt (id);
    int new_id;

    if (wh_id > 0) {
        query = "UPDATE warehouse SET warehouseName=? WHERE warehouseId=?";
        
        PreparedStatement updpstmt = con.prepareStatement (query);
        updpstmt.setString(1, name);
        updpstmt.setString(2, id);
        updpstmt.executeUpdate();

        session.setAttribute ("adminMessage", "Warehouse id: " + id + " updated.");
    } else {
        query = "INSERT INTO warehouse (warehouseName) VALUES (?)";
    
        PreparedStatement addpstmt = con.prepareStatement (query, Statement.RETURN_GENERATED_KEYS);
        addpstmt.setString(1, name);

        addpstmt.executeUpdate();
		ResultSet keys = addpstmt.getGeneratedKeys();
		keys.next();
		new_id = keys.getInt(1);

        session.setAttribute ("adminMessage", "Warehouse id: " + new_id + " added.");
    }
}
%>
<jsp:forward page="warehouseadmin.jsp" />