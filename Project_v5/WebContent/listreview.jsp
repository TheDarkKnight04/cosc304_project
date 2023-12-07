<%@ include file="jdbc.jsp" %>
<%@ page import="java.text.NumberFormat"%>
<%@ include file="auth.jsp"%>
<%@ include file="page.jsp" %>
<%
  String userid = (String) session.getAttribute("authenticatedUser");

  out.print (doc_head ("Reviews"));
  out.print (page_header (userid));
%>

<%
try ( 
	Connection con = DriverManager.getConnection(url, uid, pw);
	Statement stmt = con.createStatement();
) 
{
    String userName = (String) session.getAttribute("authenticatedUser");
    String sql = "SELECT orderproduct.productId, product.productName FROM ordersummary JOIN orderproduct ON ordersummary.orderId = orderproduct.orderID JOIN customer ON customer.customerId = ordersummary.customerId JOIN product ON orderproduct.productId = product.productId WHERE userid = ?";
    PreparedStatement pstmt = con.prepareStatement(sql);
    String options = "";

    pstmt.setString (1, userName);
    ResultSet rst = pstmt.executeQuery();
    while (rst.next()) {
        options += "<option value=\"" + rst.getString(1) + "\">" + rst.getString(2) + "</option>";
    }
    %>
    <div class="form-review w-50 border p-4 mx-auto">
        <form name="reviewForm" method=post action="review.jsp">
            <h1 class="h3 mb-3 fw-normal">Review Products</h1>
            <div class="mb-3">
                <select class="form-select" aria-label="Pick product" name="prodid" id="prodid">
                    <%= options %>
                </select>
            </div>
            <div class="mb-3">
                <label for="rating" class="form-label">Rating</label>
                <select id="review" name="rating" class="form-select" aria-label="Product rating">
                    <option selected>Rate this product</option>
                    <option value="1">One</option>
                    <option value="2">Two</option>
                    <option value="3">Three</option>
                    <option value="4">Four</option>
                    <option value="5">Five</option>
                </select>
            </div>
            <div class="mb-3">
                <label for="inputComment" class="form-label">Write your review</label>
                <textarea class="form-control" name="comment" id="inputComment" rows="3"></textarea>
            </div>
            <button type="submit" class="btn btn-primary">Submit</button>
        </form>
    </div>
    <%
    /*
    out.println ("<h2 class=\"text-center mb-3\">Kindly provide Feedback on your purchases.</h2>");
    out.println ("<div class=\"w-50 border p-4 mx-auto\">");
    out.println("<form name=\"review\" method=post action=\"review.jsp\">");
    out.println("<div class=\"mb-3\"><select name=\"prodid\" id=\"prodid\">");
    while(rst.next()) {
        out.println("<option value=\"" + rst.getString(1) + "\">" + rst.getString(2) + "</option>");
    }
    out.println("</select>");
    out.println("<label for=\"rating\" class=\"form-label\">Rating</label>");
    out.println("<select name=\"rating\" id=\"rating\"><option value=\"\"></option><option value=\"5\">5</option><option value=\"4\">4</option><option value=\"3\">3</option><option value=\"2\">2</option><option value=\"1\">1</option></select></div>");
    out.println("<div class=\"mb-3\"><label for=\"inputComment\" class=\"form-label\">Comment</label><input name=\"comment\" type=\"text\" class=\"form-control\" id=\"inputComment\"></div><button type=\"submit\" name=\"Submit2\" class=\"btn btn-primary\">Publish Review</button></form></div>");
    */

    closeConnection();
}
catch (SQLException ex) {
	System.err.println("SQLException: " + ex);
}

out.print (page_footer());
out.print (doc_end());
%>