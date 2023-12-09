<%@ include file="page.jsp" %>
<%
  out.print (doc_head ("Account"));
  out.print (page_header (false));
%>

<%
// Print prior error login message if present
if (session.getAttribute("loginMessage") != null) {
	out.println("<p class=\"mb-3 text-center text-danger\">"+session.getAttribute("loginMessage").toString()+"</p>");
	session.removeAttribute ("loginMessage");
}
%>		

<div class="form-customer w-100 border p-4 mx-auto">
    <form class="row" name="newuser" method=post action="createUser.jsp">
		<h1 class="h3 mb-3 fw-normal">Please Enter Your Details</h1>

		<div class="col-md-6">
			<div class="mb-3">
				<label for="inputFirstname" class="form-label">First Name</label>
				<input name="firstname" type="text" class="form-control" id="inputFirstname">
			</div>	
		</div>
		<div class="col-md-6">
			<div class="mb-3">
				<label for="inputLastname" class="form-label">Last Name</label>
				<input name="lastname" type="text" class="form-control" id="inputLastname">
			</div>	
		</div>

		<div class="col-md-6">
			<div class="mb-3">
				<label for="inputEmail" class="form-label">Email</label>
				<input name="email" type="text" class="form-control" id="inputEmail">
			</div>
		</div>
        <div class="col-md-6">
			<div class="mb-3">
				<label for="inputPhonenum" class="form-label">Phone Number</label>
				<input name="phonenum" type="text" class="form-control" id="inputPhonenum">
			</div>	
		</div>

		<div class="col-md-12">
			<div class="mb-3">
				<label for="inputAddress" class="form-label">Address</label>
				<input name="address" type="text" class="form-control" id="inputAddress">
			</div>	
		</div>

		<div class="col-md-3">
			<div class="mb-3">
				<label for="inputCity" class="form-label">City</label>
				<input name="city" type="text" class="form-control" id="inputCity">
			</div>	
		</div>
		<div class="col-md-4">
			<div class="mb-3">
				<label for="state" class="form-label">state</label>
				<select class="form-select" name="state" id="state">
				<option value="AB">Alberta</option>
				<option value="BC">British Columbia</option>
				<option value="MB">Manitoba</option>
				<option value="NB">New Brunswick</option>
				<option value="NL">Newfoundland and Labrador</option>
				<option value="NT">Northwest Territories</option>
				<option value="NS">Nova Scotia</option>
				<option value="NU">Nunavat</option>
				<option value="ON">Ontario</option>
				<option value="PE">Prince Edward Island</option>
				<option value="QC">Quebec</option>
				<option value="SK">Saskatchewan</option>
				<option value="YT">Yukon</option>
			</select></div>	
		</div>
		<div class="col-md-2">
			<div class="mb-3">
				<label for="inputPostalcode" class="form-label">Postal Code</label>
				<input name="postalcode" type="text" class="form-control" id="inputPostalcode">
			</div>	
		</div>
		<div class="col-md-3">
			<div class="mb-3">
				<label for="country" class="form-label">Country</label>
				<select class="form-select" name="country" id="country">
				<option value="Canada">Canada</option>
				<option value="United States">United States</option>
				</select>
			</div>	
		</div>

		<div class="col-md-6">
			<div class="mb-3">
				<label for="inputUsername" class="form-label"> Create a User id</label>
				<input name="username" type="text" class="form-control" id="inputUsername">
			</div>	
		</div>
		<div class="col-md-6">
			<div class="mb-3">
				<label for="inputPassword" class="form-label">Create a Password</label>
				<input name="password" type="password" class="form-control" id="inputPassword">
			</div>
		</div>
		
		<button type="submit" name="Submit2" class="btn btn-primary">Create Account</button>
	</form>
</div>
<%
out.print (page_footer());
out.print (doc_end());
%>