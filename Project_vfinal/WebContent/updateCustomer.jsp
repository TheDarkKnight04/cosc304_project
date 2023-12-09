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
String user_id = request.getParameter ("custuserid");
String password = request.getParameter ("custpassword");
String retcust = request.getParameter ("retcust");
String destpage = "";

if (retcust != null && retcust.equals ("1"))
    destpage = "customer.jsp";
else
    destpage = "customeradmin.jsp";

// data validation - begin
String desturl = "";
String errstr = "";

if (fname == null || fname.equals(""))
    errstr += "  <li>Provide a valid First Name</li>";
if (lname == null || lname.equals(""))
    errstr += "  <li>Provide a valid Last Name</li>";
if (email == null || email.equals(""))
    errstr += "  <li>Provide a valid Email</li>";
if (phone == null || phone.equals(""))
    errstr += "  <li>Provide a valid Phone Number</li>";
if (addr == null || addr.equals(""))
    errstr += "  <li>Provide a valid Address</li>";
if (city == null || city.equals(""))
    errstr += "  <li>Provide a valid City</li>";
if (state == null || state.equals(""))
    errstr += "  <li>Provide a valid State</li>";
if (zip == null || zip.equals(""))
    errstr += "  <li>Provide a valid Postal Code</li>";
if (country == null || country.equals(""))
    errstr += "  <li>Provide a valid Country</li>";
if (user_id == null || user_id.equals(""))
    errstr += "  <li>Provide a valid User Id</li>";
if (password == null || password.equals(""))
    errstr += "  <li>Provide a valid Password</li>";
// data validation end

if (errstr == null || errstr == "") {
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

        query = "SELECT userid FROM customer";
        ResultSet userrst = stmt.executeQuery(query);
        boolean insertvalidId = true;
        while (userrst.next()) {
            String listId = userrst.getString("userid");
            if (listId.equals(user_id)) {
                insertvalidId = false;
            }
        }


        if (customer_id > 0) {
            query = "SELECT customerId, userid FROM customer";
            ResultSet updrst = stmt.executeQuery(query);
            boolean updatevalidId = true;
            while (updrst.next()) {
                String listId = updrst.getString("userid");
                String custlistId = updrst.getString("customerid");
                if (listId.equals(user_id)) {
                    if (custlistId == id) {
                        updatevalidId = false;
                    }
                }
            }
            if (updatevalidId) {
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
                updpstmt.setString(10, user_id);
                updpstmt.setString(11, password);
                updpstmt.setString(12, id);
                updpstmt.executeUpdate();

                session.setAttribute ("adminMessage", "Customer id: " + id + " updated.");
            } else {
                session.setAttribute ("adminMessage", "Username already in use!");
                //out.println("<h1 class=\"my-3 text-center\">Username already in use!</h1>");
            }
        } else {
            if (insertvalidId) {
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
            addpstmt.setString(10, user_id);
            addpstmt.setString(11, password);

            addpstmt.executeUpdate();
            ResultSet keys = addpstmt.getGeneratedKeys();
            keys.next();
            new_id = keys.getInt(1);

            session.setAttribute ("adminMessage", "Customer id: " + new_id + " added.");
            }
            else {
                session.setAttribute ("adminMessage", "Username already in use!");
                //out.println("<h1 class=\"my-3 text-center\">Username already in use!</h1>");
            }
        }
        closeConnection();
    }catch (SQLException ex) {
        System.err.println("SQLException: " + ex);
    }
    desturl = destpage;
} else {
    if (id == null || id.equals("0"))
        desturl = "editcustomer.jsp";
    else
        desturl = "editcustomer.jsp?id=" + id;

    session.setAttribute ("adminErrorMessage", "<h5>Please correct the following errors and submit again:</h5><ul>" + errstr + "</ul>");
}
%>
<jsp:forward page="<%= desturl %>" />