<%@ include file="jdbc.jsp" %>

<%
String id = request.getParameter ("prodid");
String name = request.getParameter ("prodname");
String cat = request.getParameter ("prodcat");
String image = request.getParameter ("prodimage");
String desc = request.getParameter ("proddesc");
String price = request.getParameter ("prodprice");
Integer quantity = new Integer(1);

// data validation - begin
String desturl = "";
String errstr = "";

if (name == null || name.equals(""))
    errstr += "  <li>Provide a valid Product Name</li>";
if (cat == null || cat.equals(""))
    errstr += "  <li>Select a valid Product Category</li>";
if (desc == null || desc.equals(""))
    errstr += "  <li>Provide a Product description</li>";
if (price == null || price.equals(""))
    errstr += "  <li>Provide a valid Product price</li>";
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
        int product_id = Integer.parseInt (id);
        int new_id;

        if (product_id > 0) {
            query = "UPDATE product SET productName=?, categoryId=?, productImageURL=?, productDesc=?, productPrice=? WHERE productId=?";
            
            PreparedStatement updpstmt = con.prepareStatement (query);
            updpstmt.setString(1, name);
            updpstmt.setString(2, cat);
            updpstmt.setString(3, image);
            updpstmt.setString(4, desc);
            updpstmt.setString(5, price);
            updpstmt.setString(6, id);
            updpstmt.executeUpdate();

            session.setAttribute ("adminMessage", "Product id: " + id + " updated.");
        } else {
            query = "INSERT product(productName, categoryId, productImageURL, productDesc, productPrice) VALUES (?, ?, ?, ?, ?)";
        
            PreparedStatement addpstmt = con.prepareStatement (query, Statement.RETURN_GENERATED_KEYS);
            addpstmt.setString(1, name);
            addpstmt.setString(2, cat);
            addpstmt.setString(3, image);
            addpstmt.setString(4, desc);
            addpstmt.setString(5, price);

            addpstmt.executeUpdate();
            ResultSet keys = addpstmt.getGeneratedKeys();
            keys.next();
            new_id = keys.getInt(1);

            session.setAttribute ("adminMessage", "Product id: " + new_id + " added.");
        }
        closeConnection();
    } catch (SQLException ex) {
        System.err.println("SQLException: " + ex);
    }
    desturl = "productadmin.jsp";
} else {
    if (id == null || id.equals("0"))
        desturl = "editproduct.jsp";
    else
        desturl = "editproduct.jsp?id=" + id;

    session.setAttribute ("adminErrorMessage", "<h5>Please correct the following errors and submit again:</h5><ul>" + errstr + "</ul>");
}
%>
<jsp:forward page="<%= desturl %>" />