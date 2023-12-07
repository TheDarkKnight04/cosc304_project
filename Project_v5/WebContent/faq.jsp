<%@ include file="page.jsp" %>
<%
  String userid = (String) session.getAttribute("authenticatedUser");

  out.print (doc_head ("FAQs"));
  out.print (page_header (userid));
%>



<%
out.print (page_footer());
out.print (doc_end());
%>