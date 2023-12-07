<%
	// Remove the user from the session to log them out
	session.setAttribute("authenticatedUser",null);
	session.setAttribute("authenticatedUserState",null);
	response.sendRedirect ("home.jsp");		// Re-direct to main page
	return;
%>