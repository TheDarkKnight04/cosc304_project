<!DOCTYPE html>
<html>
<head>
<title>Santam's Grocery CheckOut Line</title>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.0.0/dist/css/bootstrap.min.css" integrity="sha384-Gn5384xqQ1aoWXA+058RXPxPg6fy4IWvTNh0E263XmFcJlSAwiGgFAW/dAiS6JXm" crossorigin="anonymous">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.0.0/dist/js/bootstrap.min.js" integrity="sha384-JZR6Spejh4U02d8jOt6vLEHfe/JQGiRRSQQxSfFWpi1MquVdAyjUar5+76PVCmYl" crossorigin="anonymous"></script>

<style>
	header {
  background-color: #666;
  padding: 3px;
  text-align: center;
  font-size: 18px;
  color: white;
}
</style>
</head>
<body>

  <%@ include file="shopHeader.html" %>
  <div class="px-5">
  <h2 align="center" class="my-3">Enter your customer id and password to complete the transaction:</h2>

  <div class="w-50 mx-auto">
    <form method="get" action="order.jsp">
      <table class="table" border="0">
      <tr><td><b>Customer ID :</b> </td>  <td><input type="text" name="customerId" size="50"></td></tr>
      <tr><td><b>Password :</b></td><td><input type="password" name="password" size="50"></td></tr>
      <tr><td><input type="submit" value="Submit"></td><td><input type="reset" value="Reset"></td>
      </table>
      </form>      
  </div>
    
</div>
</body>
</html>

