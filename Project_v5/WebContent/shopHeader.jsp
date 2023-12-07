<%
	String userName = (String) session.getAttribute("authenticatedUser");
    String userState = (String) session.getAttribute("authenticatedUserState");
%>
<div class="bg-light">
    <h1 align="center" class="p-3">
        <font face="cursive" color="#3399ff">
                <a href="index.jsp">Santam's Grocery</a>
        </font>
    </h1>
    <table class="table border-bottom">
        <tr>
            <td width="33%" class="text-center border-0 fs-4 text-uppercase fw-bold"><a href="listprod.jsp">Products</a></td>
            <td width="34%" class="text-center border-0 fs-4 text-uppercase fw-bold"><a href="listorder.jsp">Orders</a></td>
            <td width="33%" class="text-center border-0 fs-4 text-uppercase fw-bold"><a href="showcart.jsp">Cart</a></td>
        </tr>
        <tr>
            <td class="border-0">&nbsp;</td>
            <td class="border-0">&nbsp;</td>
            <td class="text-right border-0" style="padding-right: 100px;">
                <%
                if (userName != null) {
                    out.print ("<div class=\"fw-bold fs-6\">Signed-in as: <a href=\"customer.jsp\">" + userName + "</a> (" + "<a href=\"logout.jsp\">Log out</a>" + ")</div>");
                } else {
                    out.print ("<div class=\"fw-bold fs-6\"><a href=\"login.jsp\">&rarr;&nbsp;Login</a></div>");
                }
                %>
            </td>
        </tr>
    </table>        
</div>
<!--<hr align="center" width="50%" />-->