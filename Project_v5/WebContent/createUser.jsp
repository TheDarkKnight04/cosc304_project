<%@ include file="jdbc.jsp" %>
<%@ include file="page.jsp" %>
<%
  String userid = (String) session.getAttribute("authenticatedUser");

  out.print (doc_head ("New USer"));
  out.print (page_header (userid));
%>
<!--
<!DOCTYPE html>
<html>
<head>
<title>Santam's Grocery | New User</title>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.0.0/dist/css/bootstrap.min.css" integrity="sha384-Gn5384xqQ1aoWXA+058RXPxPg6fy4IWvTNh0E263XmFcJlSAwiGgFAW/dAiS6JXm" crossorigin="anonymous">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.0.0/dist/js/bootstrap.min.js" integrity="sha384-JZR6Spejh4U02d8jOt6vLEHfe/JQGiRRSQQxSfFWpi1MquVdAyjUar5+76PVCmYl" crossorigin="anonymous"></script>
</head>
<body>
	<%@ include file="shopHeader.jsp" %>
<div style="margin:0 auto;text-align:center;display:inline">
-->


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
String userid = request.getParameter("username");
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
		if (listId.equals(userid)) {
			validId = false;
		}
	}

    if (validId) {
        String newusersql ="INSERT INTO customer (firstName, lastName, email, phoneNum, address, city, state, postalCode, country, userid, password) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
		PreparedStatement newuserpstmt = con.prepareStatement(newusersql);
        out.println("<h3>" + firstName + lastName + Email + PhoneNum + Address + city + state + postalcode + country + userid + pwd+"</h3>");
        newuserpstmt.setString(1, firstName);
        newuserpstmt.setString(2, lastName);
        newuserpstmt.setString(3, Email);
        newuserpstmt.setString(4, PhoneNum);
        newuserpstmt.setString(5, Address);
        newuserpstmt.setString(6, city);
        newuserpstmt.setString(7, state);
        newuserpstmt.setString(8, postalcode);
        newuserpstmt.setString(9, country);
        newuserpstmt.setString(10, userid);
        newuserpstmt.setString(11, pwd);
        newuserpstmt.executeUpdate();
        out.println("<h3>Account Created Successful. Login.</h3>");
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