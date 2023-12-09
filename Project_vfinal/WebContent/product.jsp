<%@ page import="java.util.HashMap" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<%@ include file="jdbc.jsp" %>
<%@ include file="page.jsp" %>

<%
String auth_userid = (String) session.getAttribute ("authenticatedUser");
String productId = request.getParameter("id");

out.print (doc_head ("Product"));
out.print (page_header (false));

try ( 
	Connection con = DriverManager.getConnection(url, uid, pw);
	Statement stmt = con.createStatement();
) 
{
    NumberFormat currFormat = NumberFormat.getCurrencyInstance();
    String sql = "SELECT productName, productPrice, productImageURL, productImage, productDesc, category.categoryName FROM product JOIN category ON product.categoryId = category.categoryId WHERE productId = ?";
    PreparedStatement pstmt = con.prepareStatement(sql);

    pstmt.setString(1, productId);
    ResultSet rst = pstmt.executeQuery();
    String prodname = "";
    Double prodprice = 0.0;
    String imgurl ="";
    String image ="";
    String proddesc = "";
    String catname = "";
    String cartlink = "";

    while (rst.next()) {
        prodname = rst.getString("productName");
        prodprice = rst.getDouble("productPrice");
        imgurl = rst.getString("productImageURL");
        image = rst.getString("productImage");
        proddesc = rst.getString("productDesc");
        catname = rst.getString("categoryName");
        cartlink = "addcart.jsp?id=" + productId + "&name=" + prodname +  "&price=" + prodprice;
    }
%>
<div class="row">
    <div class="col-md-6">
        <img src="<%= imgurl %>" class="rounded mx-auto img-fluid" alt="product image">
    </div>
    <div class="col-md-6">
        <h2><%= prodname %></h2>
        <p>Category: <%= catname %><br />
           Rating: 3.5 out of 5</p>
        <h3 class="mb-3"><%= currFormat.format(prodprice) %></h3>
        <p><a class="btn btn-primary" href="<%= cartlink %>">Add to cart</a></p>
    </div>
</div>
<div class="row">
    <div class="col-md-12">
        <div class="h6 mt-3 mb-1">Product description:</div>
        <p><%= proddesc %></p>
    </div>
</div>

<div class="row">
    <div class="col-md-6">
        <h2 class="pb-2 mb-3 border-bottom">Product Reviews</h2>

        <ol class="list-group list-group-numbered">       
<%
String rev_userid = "";
int rev_rating = 0;
java.sql.Date rev_date;
String rev_comment = "";
int user_revid = 0;
int num_reviews = 0;

sql = "SELECT reviewId, reviewRating, reviewDate, reviewComment, customer.userid FROM review JOIN customer ON review.customerId = customer.customerId WHERE productId = ?";
pstmt = con.prepareStatement(sql);

pstmt.setString (1, productId);
rst = pstmt.executeQuery();
while (rst.next()) {
    rev_userid = rst.getString("userid");
    if (rev_userid.equals (auth_userid)) {
        user_revid = rst.getInt ("reviewId");
    }
    rev_rating = rst.getInt ("reviewRating");
    rev_date = rst.getDate ("reviewDate");
    rev_comment = rst.getString ("reviewComment");
    num_reviews++;

    %>
    <li class="list-group-item d-flex justify-content-between align-items-start">
        <div class="ms-2 me-auto">
            <div class="fw-bold"><%= rev_userid %>: <%= rev_rating %> out of 5</div>
                <%= rev_comment %><br />
                <%= new java.util.Date(rev_date.getTime()) %>
        </div>
    </li>
    <%
}

if (num_reviews == 0) {
    %>
    <li class="list-group-item d-flex justify-content-between align-items-start">
        <div class="ms-2 me-auto">
            <div class="fw-bold">
                No reviews yet!
            </div>
            Be the first to review this product!
        </div>
    </li>
    <%
}

%>
        </ol>
    </div>
    <div class="col-md-6">
        <h2 class="pb-2 mb-3 border-bottom">Write a Review</h2>
        <form name="reviewForm" method="post" action="review.jsp">
            <h4><%= prodname %></h4>
            <input type="hidden" id="prodid" name="prodid" value="<%= productId %>">
            <div class="mb-3">
                <label for="review-rating" class="form-label">Rating</label>
                <select id="review-rating" name="rating" class="form-select" aria-label="Product rating">
                    <option value="1">One</option>
                    <option value="2">Two</option>
                    <option value="3">Three</option>
                    <option value="4">Four</option>
                    <option value="5">Five</option>
                </select>
              </div>
              <div class="mb-3">
                <label for="review-comment" class="form-label">Write your review</label>
                <textarea class="form-control" id="review-comment" name="comment" rows="3"></textarea>
              </div>
              <button type="submit" class="btn btn-primary">Submit</button>
        </form>
    </div>
</div>
<%
    /*
    out.println ("<tr><td colspan=\"2\" class=\"border-0\"><h3 class=\"text-center\"><a href=\"listprod.jsp\">Continue Shopping</a></h3></td></tr>");
    out.println ("</table>");
    */
  
    /*
    out.println ("<div class=\"h4\"><a href=\"review.jsp?id=" + productId + "&amp;name=" + prodname +  "&amp;price=" + prodprice + "\">Add a review</a></div>");
    

    out.println ("<div class=\"w-50 border p-4 mx-auto\">");
        out.println("<form name=\"review\" method=\"post\" action=\"review.jsp?prodid=" + productId + "\">");
            out.println("<div class=\"mb-3\"><label for=\"rating\" class=\"form-label\">Rating</label>");
                out.println("<select name=\"rating\" id=\"rating\"><option value=\"\"></option><option value=\"5\">5</option><option value=\"4\">4</option><option value=\"3\">3</option><option value=\"2\">2</option><option value=\"1\">1</option></select></div>");
                out.println("<div class=\"mb-3\"><label for=\"inputComment\" class=\"form-label\">Comment</label><input name=\"comment\" type=\"text\" class=\"form-control\" id=\"inputComment\"></div><button type=\"submit\" name=\"Submit2\" class=\"btn btn-primary\">Publish Review</button></form></div>");
                out.print ("<div class=\"h5\">Reviews: ");
                    
                    String revsql = "SELECT reviewId, reviewRating, reviewDate, customer.userid, reviewComment FROM review JOIN customer ON customer.customerId = review.customerId WHERE productId = ?";
                    PreparedStatement revpstmt = con.prepareStatement(revsql);
                    revpstmt.setString(1, productId);
                    ResultSet revrst = revpstmt.executeQuery();
                    out.println("<table>");
                    while(revrst.next()) {
                        String reviewid = revrst.getString("reviewId");
                        String rating = revrst.getString("reviewRating");
                        String date = revrst.getString("reviewDate");
                        String name = revrst.getString("userid");
                        String comment = revrst.getString("reviewComment");
                        out.print("<tr><th>" + name + "</th><td>" + rating + "</td><td>" + date + "</td><td>" + comment + "</td></tr>");
                    }
                    out.println("</table>");
                    out.print ("</div>");    
       
    // TODO: If there is a productImageURL, display using IMG tag
    
    // TODO: Retrieve any image stored directly in database. Note: Call displayImage.jsp with product id as parameter.
    //NumberFormat currFormat = NumberFormat.getCurrencyInstance();
    //out.println("<table><tr><th></th><th></th></tr><tr><td><b>Id</b></td><td>" + productId + "</td></tr><tr><td><b>Price</b></td><td>" + currFormat.format(prodprice) +"</td></tr></table>");        

    // TODO: Add links to Add to Cart and Continue Shopping
    */

    // Close connection
    closeConnection();
}
catch (SQLException ex) {
		System.err.println("SQLException: " + ex);
}

out.print (page_footer());
out.print (doc_end());
%>