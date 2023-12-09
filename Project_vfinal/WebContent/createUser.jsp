<%@ include file="jdbc.jsp" %>
<%@ include file="page.jsp" %>
<%
  out.print (doc_head ("Add User"));
  out.print (page_header (false));
%>

<%

String firstName = request.getParameter("firstname");
String lastName = request.getParameter("lastname");
String Email = request.getParameter("email");
String PhoneNum = request.getParameter("phonenum");
String Address = request.getParameter("address");
String city = request.getParameter("city");
String state = request.getParameter("state");
String postalcode = request.getParameter("postalcode");
String country = request.getParameter("country");
String user_id = request.getParameter("username");
String pwd = request.getParameter("password");

try ( 
    Connection con = DriverManager.getConnection(url, uid, pw);
    Statement stmt = con.createStatement();
) 
{

    String sql = "SELECT userid FROM customer";
	ResultSet rst = stmt.executeQuery(sql);
	boolean validId = true;
	while (rst.next()) {
		String listId = rst.getString("userid");
		if (listId.equals(user_id)) {
			validId = false;
		}
	}

    if (validId) {
        String newusersql ="INSERT INTO customer (firstName, lastName, email, phoneNum, address, city, state, postalCode, country, userid, password) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
		PreparedStatement newuserpstmt = con.prepareStatement(newusersql);
        newuserpstmt.setString(1, firstName);
        newuserpstmt.setString(2, lastName);
        newuserpstmt.setString(3, Email);
        newuserpstmt.setString(4, PhoneNum);
        newuserpstmt.setString(5, Address);
        newuserpstmt.setString(6, city);
        newuserpstmt.setString(7, state);
        newuserpstmt.setString(8, postalcode);
        newuserpstmt.setString(9, country);
        newuserpstmt.setString(10, user_id);
        newuserpstmt.setString(11, pwd);
        newuserpstmt.executeUpdate();
        out.println("<h1 class=\"my-3 text-center\">Account Created Successful. Login.</h1>");
    } else {
            out.println("<h1 class=\"my-3 text-center\">Username already in use!</h1>");
    }

    
        // Make sure to close connection
        closeConnection();
}
catch (SQLException ex) {
    System.err.println("SQLException: " + ex);
}
%>

<!--
<h3 class="text-center mb-3">New</h3>
<div class="w-50 border p-4 mx-auto">
</div>

</body>
</html>
-->