<%@ include file="jdbc.jsp" %>
<%@ page import="java.text.NumberFormat"%>
<%@ include file="auth.jsp"%>
<%@ include file="page.jsp" %>
<%
  String userid = (String) session.getAttribute("authenticatedUser");

  out.print (doc_head ("Admin"));
  out.print (page_header (userid));
%>
<div class="container px-4 py-5 align-items-center justify-content-center" id="featured-3">
  <div class="row" >
    <div class="col-6">
      <h2 class="pb-2 border-bottom">Shop Administration</h2>
      <ol class="list-group list-group-numbered">
          <li class="list-group-item d-flex justify-content-between align-items-start">
            <div class="ms-2 me-auto">
              <div class="fw-bold">
                  Manage Products
              </div>
              <a href="editproduct.jsp">Add product</a>,
              <a href="productadmin.jsp">Products</a>
            </div>
          </li>
          <li class="list-group-item d-flex justify-content-between align-items-start">
            <div class="ms-2 me-auto">
              <div class="fw-bold">
                Manage Customers
              </div>
              <a href="editcustomer.jsp">Add customer</a>,
              <a href="customeradmin.jsp">Customers</a>
            </div>
          </li>
          <li class="list-group-item d-flex justify-content-between align-items-start">
            <div class="ms-2 me-auto">
              <div class="fw-bold">
                Manage warehouses
              </div>
              <a href="editwarehouse.jsp">Add warehouse</a>,
              <a href="warehouseadmin.jsp">Warehouses</a>
            </div>
          </li>
      </ol>        
    </div>
    <div class="col-6">
      <h2 class="pb-2 border-bottom">Shop Operations</h2>
      <ol class="list-group list-group-numbered">
        <li class="list-group-item d-flex justify-content-between align-items-start">
          <div class="ms-2 me-auto">
            <div class="fw-bold">
                <a href="salesrep.jsp">Sales Reports</a>
            </div>
            Cras justo odio
          </div>
        </li>
        <li class="list-group-item d-flex justify-content-between align-items-start">
          <div class="ms-2 me-auto">
            <div class="fw-bold">
                <a href="listorderadmin.jsp">Order Admin</a>
            </div>
            Cras justo odio
          </div>
        </li>
        <li class="list-group-item d-flex justify-content-between align-items-start">
          <div class="ms-2 me-auto">
            <div class="fw-bold">
                <a href="stats.jsp">Shop Statistics</a>
                
            </div>
            Cras justo odio
          </div>
        </li>
        <li class="list-group-item d-flex justify-content-between align-items-start">
          <div class="ms-2 me-auto">
            <div class="fw-bold">
                <a href="loaddata.jsp">Reset Database</a>
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