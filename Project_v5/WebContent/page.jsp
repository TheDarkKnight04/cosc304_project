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
        + "<title>Santam's Ski Stuff | " + title + "</title>\n"
        + "<link href=\"https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css\" rel=\"stylesheet\" integrity=\"sha384-T3c6CoIi6uLrA9TneNEoa7RxnatzjcDSCmG1MXxSR1GAsXEV/Dwwykc2MPK8M2HN\" crossorigin=\"anonymous\">\n"
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

public String page_header (String authUserid)
{
    String str = "<body>\n"
        + "<header class=\"d-flex flex-wrap align-items-center justify-content-center justify-content-md-between py-3 mb-4 border-bottom\">\n"
        + " <div class=\"col-md-3 mb-2 mb-md-0\">\n"
        + "   <a href=\"home.jsp\" class=\"h2 d-inline-flex link-body-emphasis text-decoration-none\">\n"
        + "     <span class=\"fs-4\">Santam Ski Stuff</span>\n"
        + "   </a>\n"
        + " </div>\n"
        + " <ul class=\"nav col-12 col-md-auto mb-2 justify-content-center mb-md-0\">\n"
        + "   <li><a href=\"listprod.jsp\" class=\"nav-link px-3 link-secondary\">Products</a></li>\n";
                
        if (authUserid != null) {
            str += "<li><a href=\"listorder.jsp\" class=\"nav-link px-2\">Orders</a></li>\n";
        } else {
            str += "<li><a href=\"listorder.jsp\" class=\"nav-link px-2 disabled\" aria-disabled=\"true\">Orders</a></li>\n";
        }
              
        str += "  <li><a href=\"showcart.jsp\" class=\"nav-link px-3\">Cart</a></li>\n"
             + "  <li><a href=\"faq.jsp\" class=\"nav-link px-3\">FAQs</a></li>\n"
             + "  <li><a href=\"about.jsp\" class=\"nav-link px-3\">About</a></li>\n"
             + "</ul>\n";
      
        str += "<div class=\"col-md-3 text-end\">\n";
        if (authUserid != null) {
            str += "<button type=\"button\" class=\"btn btn-outline-primary me-2\"><a href=\"customer.jsp\" style=\"color:inherit\">" + authUserid + "'s account</a></button>\n";
            str += "<button type=\"button\" class=\"btn btn-danger\"><a href=\"logout.jsp\" style=\"color:inherit\">Sign-out</a></button>\n";
        } else {
            str += "<button type=\"button\" class=\"btn btn-outline-primary me-2\"><a href=\"login.jsp\" style=\"color:inherit\">Login</a></button>\n";
            str += "<button type=\"button\" class=\"btn btn-primary me-2\"><a href=\"newUser.jsp\" style=\"color:inherit\">Sign-up</a></button>\n";
        }
    
        str += " </div>\n"
                + "</header>\n"
                + "<main class=\"flex-shrink-0\">\n"
                + "  <div class=\"container\">";
                
    return str;
}

public String page_footer()
{
    String str = "</div>\n"
        + "</main>\n"
        + "<footer class=\"footer d-flex flex-wrap justify-content-between align-items-center py-3 my-4 border-top bg-body-tertiary\">\n"
        + "<div class=\"col-md-12 d-flex align-items-center\">\n"
        + "<span class=\"mb-3 mx-auto mb-md-0 text-body-secondary\">&copy; 2023 Santam Ski Stuff Inc. &nbsp;&nbsp; <a href=\"#\">FAQ</a> | <a href=\"#\">About</a></span>\n"
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