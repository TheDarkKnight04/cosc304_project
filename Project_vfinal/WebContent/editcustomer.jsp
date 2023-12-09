<%@ include file="jdbc.jsp" %>
<%@ include file="page.jsp" %>

<%
String idstr = request.getParameter ("id");
String retcust = request.getParameter ("retcust");
String userid = (String) session.getAttribute("authenticatedUser");
String pagehdr = "";
String submit_label = "";
int custid = 0;

if (idstr != null) {
    pagehdr = "Edit Customer";
    submit_label = "Update customer";
    custid = Integer.parseInt (idstr);
} else {
    pagehdr = "New Customer";
    submit_label = "Add customer";
    custid = 0;
}
if (retcust == null)
    retcust = "0";

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
    String cust_fname = "";
    String cust_lname = "";
    String cust_email = "";
    String cust_phone = "";
    String cust_addr = "";
    String cust_city = "";
    String cust_state = "";
    String cust_zip = "";
    String cust_country = "";
    String cust_userid = "";
    String cust_password = "";

    if (custid > 0) {
        query = "SELECT firstName, lastName, email, phonenum, address, city, state, postalCode, country, userid, password FROM customer WHERE customerId=?";
        pstmt = con.prepareStatement(query);

        pstmt.setInt (1, custid);
        rset = pstmt.executeQuery();
        while (rset.next()) {
            cust_fname = rset.getString ("firstName");
            cust_lname = rset.getString ("lastName");
            cust_email = rset.getString ("email");
            cust_phone = rset.getString ("phonenum");
            cust_addr = rset.getString ("address");
            cust_city = rset.getString ("city");
            cust_state = rset.getString ("state");
            cust_zip = rset.getString ("postalCode");
            cust_country = rset.getString ("country");
            cust_userid = rset.getString ("userid");
            cust_password = rset.getString ("password");
        }   
    }
%>
<div class="form-customer w-100 border p-4 mx-auto">
    <form class="row" name="customerForm" method=post action="updateCustomer.jsp">
        <h1 class="h3 mb-3 fw-normal"><%= pagehdr %></h1>
    
        <input type="hidden" id="custid" name="custid" value="<%= custid %>">
        <input type="hidden" id="retcust" name="retcust" value="<%= retcust %>">
        <div class="col-md-6">
            <div class="form-floating mb-2">
                <input name="custfname" type="text" class="form-control" id="inputCustfname" placeholder="First name" value="<%= cust_fname %>">
                <label for="inputCustfname">First name</label>
            </div>    
        </div>
        <div class="col-md-6">
            <div class="form-floating mb-2">
                <input name="custlname" type="text" class="form-control" id="inputCustlname" placeholder="Last name" value="<%= cust_lname %>">
                <label for="inputCustlname">Last name</label>
            </div>    
        </div>
        
        <div class="col-md-6">
            <div class="form-floating mb-2">
                <input name="custemail" type="text" class="form-control" id="inputCustemail" placeholder="email address" value="<%= cust_email %>">
                <label for="inputCustemail">Email address</label>
            </div>    
        </div>
        <div class="col-md-6">
            <div class="form-floating mb-2">
                <input name="custphone" type="text" class="form-control" id="inputCustphone" placeholder="Phone #" value="<%= cust_phone %>">
                <label for="inputCustphone">Phone number</label>
            </div>
        </div>
        
        <div class="col-md-12">
            <div class="form-floating mb-2">
                <input name="custaddr" type="text" class="form-control" id="inputCustaddr" placeholder="Street address" value="<%= cust_addr %>">
                <label for="inputCustaddr">Address</label>
            </div>    
        </div>

        <div class="col-md-4">
            <div class="form-floating mb-2">
                <input name="custcity" type="text" class="form-control" id="inputCustcity" placeholder="City" value="<%= cust_city %>">
                <label for="inputCustcity">City</label>
            </div>    
        </div>
        <div class="col-md-2">
            <div class="form-floating mb-2">
                <input name="custstate" type="text" class="form-control" id="inputCuststate" placeholder="State" value="<%= cust_state %>">
                <label for="inputCuststate">State</label>
                <!--<label for="state" class="form-label">state</label>-->
				<!--
                <select class="form-select" name="state" id="state">
				<option value="AB">Alberta</option>
				<option value="BC">British Columbia</option>
				<option value="MB">Manitoba</option>
				<option value="NB">New Brunswick</option>
				<option value="NL">Newfoundland and Labrador</option>
				<option value="NT">Northwest Territories</option>
				<option value="NS">Nova Scotia</option>
				<option value="NU">Nunavat</option>
				<option value="ON">Ontario</option>
				<option value="PE">Prince Edward Island</option>
				<option value="QC">Quebec</option>
				<option value="SK">Saskatchewan</option>
				<option value="YT">Yukon</option>
			    </select>-->
            </div>    
        </div>
        <div class="col-md-3">
            <div class="form-floating mb-2">
                <input name="custzip" type="text" class="form-control" id="inputCustzip" placeholder="Postal code" value="<%= cust_zip %>">
                <label for="inputCustzip">Postal code</label>
            </div>    
        </div>
        <div class="col-md-3">
            <div class="form-floating mb-2">
                <input name="custcountry" type="text" class="form-control" id="inputCustcountry" placeholder="Country" value="<%= cust_country %>">
                <label for="inputCustcountry">Country</label>
            </div>    
        </div>       

        <div class="col-md-6">
            <div class="form-floating mb-2">
                <input name="custuserid" type="text" class="form-control" id="inputCustuserid" placeholder="User id" value="<%= cust_userid %>" <%= (custid > 0) ? "readonly":"" %>>
                <label for="inputCustuserid">User Id</label>
            </div>    
        </div>
        <div class="col-md-6">
            <div class="form-floating mb-2">
                <input name="custpassword" type="password" class="form-control" id="inputCustpassword" placeholder="Password" value="<%= cust_password %>">
                <label for="inputCustpassword">Password</label>
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
