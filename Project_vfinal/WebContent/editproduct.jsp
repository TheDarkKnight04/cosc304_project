<%@ include file="jdbc.jsp" %>
<%@ include file="page.jsp" %>

<%
String idstr = request.getParameter ("id");
String pagehdr = "";
String submit_label = "";
int productid = 0;

if (idstr != null) {
    pagehdr = "Edit Product";
    submit_label = "Update product";
    productid = Integer.parseInt (idstr);
} else {
    pagehdr = "New Product";
    submit_label = "Add product";
    productid = 0;
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
    String product_name = "";
    String product_image = "";
    String product_desc = "";
    String product_price = "";
    String product_cat = "";

    if (productid > 0) {
        query = "SELECT productName, categoryId, productImageURL, productDesc, productPrice FROM product WHERE productId=?";
        pstmt = con.prepareStatement(query);

        pstmt.setInt (1, productid);
        rset = pstmt.executeQuery();
        while (rset.next()) {
            product_name = rset.getString ("productName");
            product_image = rset.getString ("productImageURL");
            product_desc = rset.getString ("productDesc");
            product_price = rset.getString ("productPrice");
            product_cat = rset.getString ("categoryId");
        }   
    }

    query = "SELECT categoryId, categoryName FROM category";
    rset = stmt.executeQuery (query);
    String catopts = "";
    
    if (product_cat.equals("")) {
        catopts = "<option value=\"\" selected>Any category</option>\n";  
    } else {
        catopts = "<option value=\"\">Any category</option>\n";
    }

    while (rset.next()) {
        if (product_cat.equals (rset.getString("categoryId"))) {
            catopts += "<option selected value=\"" + rset.getInt("categoryId") + "\">" + rset.getString("categoryName") + "</option>\n";
        } else {
            catopts += "<option value=\"" + rset.getInt("categoryId") + "\">" + rset.getString("categoryName") + "</option>\n";
        }   
    }
%>
<div class="form-product w-100 border p-4 mx-auto">
	<form name="productForm" method="post" action="updateProduct.jsp">
		<h1 class="h3 mb-3 fw-normal"><%= pagehdr %></h1>
	
        <input type="hidden" id="prodid" name="prodid" value="<%= productid %>">
		<div class="form-floating mb-2">
		  <input name="prodname" type="text" class="form-control" id="inputProdname" placeholder="Product name" value="<%= product_name %>">
		  <label for="inputProdname">Product name</label>
		</div>
        <div class="mb-2">
            <select class="form-select" aria-label="Pick product category" name="prodcat" id="prodcat"><%= catopts %></select>
        </div>
        <div class="form-floating mb-2">
            <input name="prodprice" type="text" class="form-control" id="inputProdprice" placeholder="Product price" value="<%= product_price %>">
            <label for="inputProdprice">Product price</label>
        </div>
        <div class="form-floating mb-2">
            <input name="prodimage" type="text" class="form-control" id="inputProdimage" placeholder="Product image" value="<%= product_image %>">
            <label for="inputProdimage">Product image</label>
        </div>
        <div class="mb-2">
            <label for="inputProddesc" class="form-label">Product description</label>
            <textarea class="form-control" name="proddesc" id="inputProddesc" rows="5"><%= product_desc %></textarea>
        </div>

		<button class="btn btn-primary w-100 py-2" type="submit"><%= submit_label %></button>
	</form>	
</div>
<%
}
out.print (page_footer());
out.print (doc_end());
%>