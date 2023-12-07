<%@ include file="page.jsp" %>

<%
out.print (doc_head ("Home"));
out.print (page_header (null));

// Print prior error login message if present
if (session.getAttribute("loginMessage") != null) {
	out.println("<p class=\"mb-3 text-center text-danger\">"+session.getAttribute("loginMessage").toString()+"</p>");
	session.removeAttribute ("loginMessage");
}
%>
<div class="form-signin w-50 border p-4 mx-auto">
	<form name="loginForm" method=post action="validateLogin.jsp">
		<h1 class="h3 mb-3 fw-normal">Please sign in</h1>
	
		<div class="form-floating mb-2">
		  <input name="username" type="text" class="form-control" id="inputUsername" placeholder="Enter user id">
		  <label for="inputUsername">User Id</label>
		</div>
		<div class="form-floating mb-2">
			<input name="password" type="password" class="form-control" id="inputPassword" placeholder="Password">
			<label for="inputPassword">Password</label>
		</div>
		<p class="my-3 text-body-secondary">
			<a href="#">Forgot password</a>
		</p>
		<button class="btn btn-primary w-100 py-2" type="submit">Sign in</button>
	</form>	
</div>
<%
out.print (page_footer());
out.print (doc_end());
%>