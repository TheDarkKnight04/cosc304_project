<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.ArrayList" %>
<%!
    public int cartlen = 0;
    public String userid = null;
    public boolean page_isauth = false; 
%>
<%
    userid = (String) session.getAttribute ("authenticatedUser");
    HashMap<String, ArrayList<Object>> page_productList = (HashMap<String, ArrayList<Object>>) session.getAttribute("productList");

    if (userid != null)
        page_isauth = true;
    else 
        page_isauth = false;
    if (page_productList != null)
        cartlen = page_productList.size();
    else
        cartlen = 0;
%>

<%!
public String doc_head (String title)
{
    String str = "<!doctype html>\n"
        + "<html lang=\"en\" data-bs-theme=\"dark\"></html>\n"
        + "<head>\n"
        + "<meta charset=\"utf-8\">\n"
        + "<meta name=\"viewport\" content=\"width=device-width, initial-scale=1\">\n"
        + "<meta name=\"description\" content=\"\">\n"
        + "<meta name=\"author\" content=\"Santam Bhattacharya\">\n"
        + "<title>Santam's Steezy Ski's | " + title + "</title>\n"
        + "<link href=\"https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css\" rel=\"stylesheet\" integrity=\"sha384-T3c6CoIi6uLrA9TneNEoa7RxnatzjcDSCmG1MXxSR1GAsXEV/Dwwykc2MPK8M2HN\" crossorigin=\"anonymous\">\n"
        + "<link rel=\"stylesheet\" href=\"https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.2/font/bootstrap-icons.min.css\">\n"
        + "<link href=\"css/shop.css\" rel=\"stylesheet\">"
        + "</head>\n";

    return str;
}

public String doc_end()
{
    String str = "	<script src=\"https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js\" integrity=\"sha384-C6RzsynM9kWDrMNeT87bh95OGNyZPhcTNXj1NW7RuBCsyN/o0jlpcV8Qyq46cDfL\" crossorigin=\"anonymous\"></script>\n"
        + "</body>\n"
        + "</html>";

    return str;
}

public String page_header (boolean is_home)
{
    String str = "<body>\n"
        + "<header class=\"d-flex flex-wrap align-items-center justify-content-center justify-content-md-between py-3 mb-1 border-bottom\">\n"
        + " <div class=\"col-md-3 mb-2 mb-md-0\">\n"
        + "   <a href=\"home.jsp\" class=\"h2 d-inline-flex link-body-emphasis text-decoration-none\">\n"
        + "     <span class=\"fs-4\">Santam's Steezy Skis</span>\n"
        + "   </a>\n"
        + " </div>\n"
        + " <ul class=\"nav col-12 col-md-auto mb-2 justify-content-center mb-md-0\">\n"
        + "   <li><a href=\"listprod.jsp\" class=\"nav-link px-3\">Products</a></li>\n";
                
        if (page_isauth) {
            str += "<li><a href=\"listorder.jsp\" class=\"nav-link px-2\">Orders</a></li>\n";
        } else {
            str += "<li><a href=\"listorder.jsp\" class=\"nav-link px-2 disabled\" aria-disabled=\"true\">Orders</a></li>\n";
        }
              
        str += "  <li><a href=\"faq.jsp\" class=\"nav-link px-3\">Help</a></li>\n"
             + "  <li><a href=\"about.jsp\" class=\"nav-link px-3\">About</a></li>\n";
        
        if (cartlen > 0) {
            //str += "  <li><a href=\"showcart.jsp\" class=\"nav-link px-3\">Cart (" + cartlen + ")</a>\n";
            str += "  <li><a href=\"showcart.jsp\" class=\"nav-link px-3\"><i class=\"bi-cart-fill\"></i>(" + cartlen + ")</a>\n";    
        } else {
            //str += "  <li><a href=\"showcart.jsp\" class=\"nav-link px-3 disabled\" aria-disabled=\"true\">Cart</a></li>\n";
            str += "  <li class=\"ms-3\"><a href=\"showcart.jsp\" class=\"nav-link px-3 disabled\" aria-disabled=\"true\"><i class=\"bi-cart\"></i></a></li>\n";
        }
        str += "</ul>\n";

          
        str += "<div class=\"col-md-3 text-end\">\n";
        if (page_isauth) {
            str += "<button type=\"button\" class=\"btn btn-outline-primary me-2\"><a href=\"customer.jsp\" style=\"color:inherit\">" + userid + "'s account</a></button>\n";
            str += "<button type=\"button\" class=\"btn btn-danger\"><a href=\"logout.jsp\" style=\"color:inherit\">Sign-out</a></button>\n";
        } else {
            str += "<button type=\"button\" class=\"btn btn-outline-primary me-2\"><a href=\"login.jsp\" style=\"color:inherit\">Login</a></button>\n";
            str += "<button type=\"button\" class=\"btn btn-primary me-2\"><a href=\"newUser.jsp\" style=\"color:inherit\">Sign-up</a></button>\n";
        }
    
        str += " </div>\n"
                + "</header>\n";

        if (is_home) {
            str += "<section id=\"masthead\" class=\"py-5 text-center\">\n"
                    + " <div class=\"row py-lg-5\">\n"
                    + "   <div class=\"col-lg-6 col-md-8 mx-auto\">\n"
                    + "     <h1 class=\"text-danger fw-bold\">Steezy Skis</h1>\n"
                    + "     <p class=\"lead text-success fw-bold\">Explore a carefully curated ski haven - crafted for enthusiasts, backed by expertise, and ready to elevate your experience.</p>\n"
                    + "     <p>\n"
                    + "       <a href=\"listprod.jsp\" class=\"btn btn-primary my-2\">View Products</a>\n"
                    + "       <a href=\"about.jsp\" class=\"btn btn-secondary my-2\">Learn more</a>\n"
                    + "     </p>\n"
                    + "   </div>\n"
                    + " </div>\n"
                    + "</section>\n";
        }

        str += "<main class=\"flex-shrink-0\">\n"
                + "  <div class=\"container\">";
                
    return str;
}

public String page_footer()
{
    String str = "</div>\n"
        + "</main>\n"
        + "<footer class=\"footer d-flex flex-wrap justify-content-between align-items-center py-3 my-4 border-top bg-body-tertiary\">\n"
        + "<div class=\"col-md-12 d-flex align-items-center\">\n"
        + "<span class=\"mb-3 mx-auto mb-md-0 text-body-secondary\">&copy; 2023 Santam's Steezy Skis Inc. &nbsp;&nbsp; <a href=\"faq.jsp\">Help</a> | <a href=\"about.jsp\">About</a></span>\n"
        + "</div>\n"
        + "</footer>";

    return str;
}

public String category_list (String selname)
{
    String str = "<select class=\"form-select\" aria-label=\"Pick product category\" name=\"category\" id=\"category\">\n"
        + "<option value=\"\" selected>Any category</option>\n"
        + "<option value=\"Skis\">Skis</option>\n"
        + "<option value=\"Snowboards\">Snowboards</option>\n"
        + "<option value=\"Jackets\">Jackets</option>\n"
        + "<option value=\"Ski Boots\">Ski Boots</option>\n"
        + "<option value=\"Snowboard Bindings\">Snowboard Bindings</option>\n"
        + "<option value=\"Helmets\">Helmets</option>\n"
        + "<option value=\"Apparel\">Apparel</option>\n"
        + "<option value=\"Goggles\">Goggles</option>\n"
        + "</select>\n";

    return str;
}
%>