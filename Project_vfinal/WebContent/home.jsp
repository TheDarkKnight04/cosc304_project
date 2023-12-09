<%@ include file="page.jsp" %>
<%
  out.print (doc_head ("Home"));
  out.print (page_header (true));
%>
<div class="row">
  <div class="col-lg-4">
    <div class="text-center">
      <a href="listprod.jsp"><i class="bi-basket-fill" style="font-size: 3rem; color: cornflowerblue;"></i></a>
    </div>
    <h3 class="fw-normal text-center"><a href="listprod.jsp" class="text-decoration-none">Start Shopping</a></h3>
    <p class="justify-content-center">Explore premium ski gear now. From skis to apparel, find everything for your next mountain adventure!</p>
  </div>

  <div class="col-lg-4">
    <div class="text-center">
      <a href="customer.jsp"><i class="bi-person-circle" style="font-size: 3rem; color: cornflowerblue;"></i></a>
    </div>
    <h3 class="fw-normal text-center"><a href="customer.jsp" class="text-decoration-none">Customer Account</a></h3>
    <p class="justify-content-center">Manage your account details, update information, and review past purchases in our convenient customer portal.</p>
  </div>

  <div class="col-lg-4">
    <div class="text-center">
      <a href="admin.jsp"><i class="bi-gear" style="font-size: 3rem; color: cornflowerblue;"></i></a>
    </div>
    <h3 class="fw-normal text-center"><a href="admin.jsp" class="text-decoration-none">Store Admin</a></h3>
    <p class="justify-content-center">Control customer data, manage products, warehouses, process orders, and analyze sales reports in the administrator portal.</p>
  </div>
</div>

<div class="mt-4">
  <span>Do you want to load the database afresh? </span><a href="loaddata.jsp">Load data</a>
</div>
<%
out.print (page_footer());
out.print (doc_end());
%>