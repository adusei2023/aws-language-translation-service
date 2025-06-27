# HTML template
data "template_file" "index_html" {
  template = file("${path.module}/templates/index.html")
  
  vars = {
    API_URL      = var.api_gateway_url
    project_name = var.project
    api_gateway_url = var.api_gateway_url
  }
}

# JavaScript template
data "template_file" "app_js" {
  template = file("${path.module}/templates/app.js")
  
  vars = {
    API_URL         = var.api_gateway_url
    api_gateway_url = var.api_gateway_url
    response        = "response"
  }
}

# CSS template
data "template_file" "styles_css" {
  template = file("${path.module}/templates/styles.css")
  
  vars = {}
}