<%@ include file="auth.jsp"%>
<%@ page import="java.text.NumberFormat" %>
<%@ include file="jdbc.jsp" %>
<%@ include file="page.jsp" %>
<%
  out.print (doc_head ("Account"));
  out.print (page_header (false));
%>

<%
try ( 
	Connection con = DriverManager.getConnection(url, uid, pw);
	Statement stmt = con.createStatement();
) 
{
String userName = (String) session.getAttribute("authenticatedUser");
String updemail = request.getParameter("newqty");
if (updemail != null) {
	if (updemail.contains("@") && updemail.contains(".com")) {
		if (updemail.length() < 50) {
			String updsql = "UPDATE customer SET email = ? WHERE userid = ?";
			PreparedStatement updpstmt = con.prepareStatement(updsql);
			updpstmt.setString(1, updemail);
			updpstmt.setString(2, userName);
			updpstmt.executeUpdate();
		} else {
			out.println("<h4>Email is too long.</h4>");
		}
	} else {
		out.println("<h4>Invalid Email</h4>");
	}
} 

	// TODO: Print Customer information
	if (userName != null) {
		String sql = "SELECT customerId, firstName, lastName, email, phoneNum, address, city, state, postalCode, country FROM customer WHERE userid = ?";
		PreparedStatement pstmt = con.prepareStatement(sql);
		pstmt.setString(1, userName);
		ResultSet rst = pstmt.executeQuery();
		int custId =0;
		String firstName, lastName, email, phoneNum, address, city, state, postalCode, country;
		firstName = lastName = email = phoneNum = address = city = state = postalCode = country = "";
		while (rst.next()) {
			custId = rst.getInt("customerId");
			firstName = rst.getString("firstName");
			lastName = rst.getString("lastName");
			email = rst.getString("email");
			phoneNum = rst.getString("phoneNum");
			address = rst.getString("address");
			city = rst.getString("city");
			state = rst.getString("state");
			postalCode = rst.getString("postalCode");
			country = rst.getString("country");
		}

		out.println ("<h2 class=\"pb-2 mb-3 border-bottom\">Customer Profile For " + firstName + "</h2>");
		out.println("<form name=\"formcust\">");
		out.println ("<table class=\"table w-75 mx-auto\"><tbody>");
		out.println ("<tr><td class=\"w-25 text-right\">Id</td><td class=\"w-75 text-left\">" + custId + "</td></tr>");
		out.println ("<tr><td class=\"w-25 text-right\">First Name</td><td class=\"w-75 text-left\">" + firstName + "</td></tr>");
		out.println ("<tr><td class=\"w-25 text-right\">Last Name</td><td class=\"w-75 text-left\">" + lastName + "</td></tr>");
		String updateLink = "<input type=\"button\"";
		updateLink += "onclick=\"javascript:update(" + custId + ", document.formcust.newemail.value)\"";
		updateLink += " value=\"Update Field\">";
		//out.println ("<tr><td class=\"w-25 text-right\">Email</td><td class=\"w-50 text-left\">" + email + "</td></tr>");
		out.println ("<tr><td class=\"w-25 text-right\">Email</td><td class=\"w-75 text-left\"><input type=\"text\" name=\"newemail" +"\" size =\"20\" value=\"" + email +"\">&nbsp;&nbsp;" + updateLink + "</td>");
		//out.println ("<td class=\"w-50 text-right\">" + updateLink + "</td></tr>");
		out.println ("<tr><td class=\"w-25 text-right\">Phone Number</td><td class=\"w-50 text-left\">" + phoneNum + "</td></tr>");
		out.println ("<tr><td class=\"w-25 text-right\">Address</td><td class=\"w-50 text-left\">" + address + "</td></tr>");
		out.println ("<tr><td class=\"w-25 text-right\">City</td><td class=\"w-50 text-left\">" + city + "</td></tr>");
		out.println ("<tr><td class=\"w-25 text-right\">State</td><td class=\"w-50 text-left\">" + state + "</td></tr>");
		out.println ("<tr><td class=\"w-25 text-right\">Postal Code</td><td class=\"w-50 text-left\">" + postalCode + "</td></tr>");
		out.println ("<tr><td class=\"w-25 text-right\">Country</td><td class=\"w-50 text-left\">" + country + "</td></tr>");
		out.println ("<tr><td class=\"w-25 text-right\">User Id</td><td class=\"w-50 text-left\">" + userName + "</td></tr>");
		out.println ("</tbody></table>");
		//out.println ("<h2 class=\"text-center mb-3\"><a href=\"listreview.jsp\">Feedback</a></h2>");
		%>
		<div class="row">
			<div class="col-md-4">&nbsp;</div>
			<div class="col-md-2">
				<button type="button" class="btn btn-primary mx-auto">
					<a href="editcustomer.jsp?id=<%= custId %>&retcust=1" style="text-decoration: none;">Edit profile</a>
				</button>
			</div>
			<div class="col-md-2">
				<button type="button" class="btn btn-primary mx-auto">
					<a href="listreview.jsp" style="text-decoration: none;">Reviews</a>
				</button>
			</div>
			<div class="col-md-4">&nbsp;</div>
		</div>
		<%
	} else {
		out.println("<p class=\"mb-3 text-center text-danger\">Not signed in</p>");
	}
	// Make sure to close connection
	closeConnection();
}
catch (SQLException ex) {
		System.err.println("SQLException: " + ex);
}
out.print("</form>");
%>
<script>
	function update(newid, newqty) {
		window.location = "customer.jsp?update=" + newid +"&newqty="+ newqty;
	}
</script>
<%
out.print (page_footer());
out.print (doc_end());
%>