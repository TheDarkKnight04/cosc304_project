<%@ include file="jdbc.jsp" %>

<%
String id = request.getParameter ("prodid");
String name = request.getParameter ("prodname");
String cat = request.getParameter ("prodcat");
String image = request.getParameter ("prodimage");
String desc = request.getParameter ("proddesc");
String price = request.getParameter ("prodprice");
Integer quantity = new Integer(1);

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
}
%>
<jsp:forward page="productadmin.jsp" />