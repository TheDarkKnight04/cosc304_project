<%@ include file="page.jsp" %>
<%
  String userid = (String) session.getAttribute("authenticatedUser");

  out.print (doc_head ("Home"));
  out.print (page_header (userid));
%>
<div class="container px-4 py-5 align-items-center justify-content-center" id="featured-3">
  <div class="row">
        <div class="col-6">
            <h2 class="pb-2 mb-3 border-bottom">User Links</h2>
            <ol class="list-group list-group-numbered">
                <li class="list-group-item d-flex justify-content-between align-items-start">
                  <div class="ms-2 me-auto">
                    <div class="fw-bold">
                        <a href="listprod.jsp">Begin Shopping</a>
                    </div>
                    Cras justo odio
                  </div>
                </li>
                <li class="list-group-item d-flex justify-content-between align-items-start">
                  <div class="ms-2 me-auto">
                    <div class="fw-bold">
                        <a href="customer.jsp">Customer Info</a>
                        
                    </div>
                    Cras justo odio
                  </div>
                </li>
                <li class="list-group-item d-flex justify-content-between align-items-start">
                  <div class="ms-2 me-auto">
                    <div class="fw-bold">
                        <a href="admin.jsp">Administrators</a>
                    </div>
                    Cras justo odio
                  </div>
                </li>
            </ol>        
        </div>
        <div class="col-6">
            <h2 class="pb-2 mb-3 border-bottom">Test Links</h2>
            <ol class="list-group list-group-numbered">
                <li class="list-group-item d-flex justify-content-between align-items-start">
                  <div class="ms-2 me-auto">
                    <div class="fw-bold">
                        <a href="ship.jsp?orderId=1">Ship Order 1</a>
                    </div>
                    Cras justo odio
                  </div>
                </li>
                <li class="list-group-item d-flex justify-content-between align-items-start">
                  <div class="ms-2 me-auto">
                    <div class="fw-bold">
                        <a href="q=ship.jsp?orderId=3">Ship Order 3</a>
                    </div>
                    Cras justo odio
                  </div>
                </li>
            </ol>
        </div>
    </div>
</div>
<%
out.print (page_footer());
out.print (doc_end());
%>