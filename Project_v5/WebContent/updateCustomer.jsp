<%@ include file="jdbc.jsp" %>

<%
String id = request.getParameter ("custid");
String fname = request.getParameter ("custfname");
String lname = request.getParameter ("custlname");
String email = request.getParameter ("custemail");
String phone = request.getParameter ("custphone");
String addr = request.getParameter ("custaddr");
String city = request.getParameter ("custcity");
String state = request.getParameter ("custstate");
String zip = request.getParameter ("custzip");
String country = request.getParameter ("custcountry");
String userid = request.getParameter ("custuserid");
String password = request.getParameter ("custpassword");

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
    int customer_id = Integer.parseInt (id);
    int new_id;

    if (customer_id > 0) {
        query = "UPDATE customer SET firstName=?, lastName=?, email=?, phonenum=?, address=?, city=?, state=?, postalCode=?, country=?, userid=?, password=? WHERE customerId=?";
        
        PreparedStatement updpstmt = con.prepareStatement (query);
        updpstmt.setString(1, fname);
        updpstmt.setString(2, lname);
        updpstmt.setString(3, email);
        updpstmt.setString(4, phone);
        updpstmt.setString(5, addr);
        updpstmt.setString(6, city);
        updpstmt.setString(7, state);
        updpstmt.setString(8, zip);
        updpstmt.setString(9, country);
        updpstmt.setString(10, userid);
        updpstmt.setString(11, password);
        updpstmt.setString(12, id);
        updpstmt.executeUpdate();

        session.setAttribute ("adminMessage", "Customer id: " + id + " updated.");
    } else {
        query = "INSERT INTO customer (firstName, lastName, email, phonenum, address, city, state, postalCode, country, userid, password) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
    
        PreparedStatement addpstmt = con.prepareStatement (query, Statement.RETURN_GENERATED_KEYS);
        addpstmt.setString(1, fname);
        addpstmt.setString(2, lname);
        addpstmt.setString(3, email);
        addpstmt.setString(4, phone);
        addpstmt.setString(5, addr);
        addpstmt.setString(6, city);
        addpstmt.setString(7, state);
        addpstmt.setString(8, zip);
        addpstmt.setString(9, country);
        addpstmt.setString(10, userid);
        addpstmt.setString(11, password);

        addpstmt.executeUpdate();
		ResultSet keys = addpstmt.getGeneratedKeys();
		keys.next();
		new_id = keys.getInt(1);

        session.setAttribute ("adminMessage", "Customer id: " + new_id + " added.");
    }
}
%>
<jsp:forward page="customeradmin.jsp" />