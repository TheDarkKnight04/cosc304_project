<%@ include file="page.jsp" %>
<%
  out.print (doc_head ("About Us"));
  out.print (page_header (false));
%>

<h2 class="pb-2 mb-3 border-bottom">About Santam's Steezy Skis</h2>
<br>
<h5>Welcome to Santam's Steezy Skis, your premier destination for high-quality ski equipment. Here, we are passionate about providing enthusiasts and beginners alike with top-notch gear for an unparalleled skiing experience.</h5>
<br>
<h5>Our website is the result of cutting-edge development using Java, SQL Server, CSS, HTML and the latest web technologies.</h5>
<br>
<h5>You can find the source code for our website on <a href = "https://github.com/TheDarkKnight04/cosc304_project">GitHub.</a></h5>
<br>
<h5>Feel free to reach out for any questions or assistance at <a href = "">santam04@student.ubc.ca</a>. We're here to make your skiing experience exceptional.</h5>
<br>
<h5>Happy skiing!</h5>
<%
out.print (page_footer());
out.print (doc_end());
%>