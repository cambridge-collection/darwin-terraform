resource "aws_cloudfront_function" "darwin" {
  name    = "${module.solr.name_prefix}_clean_urls"
  runtime = "cloudfront-js-2.0"
  comment = "clean-and-redirect"
  publish = true
  code    = file("${path.module}/templates/darwin/cloudfront-function.js.ttfpl")
}

# No AWS managed response headers policy sets Cache-Control, so /search needs a custom one.
resource "aws_cloudfront_response_headers_policy" "no_store" {
  name    = "${local.environment}-no-store"
  comment = "Prevents browser and proxy caching"

  custom_headers_config {
    items {
      header   = "Cache-Control"
      value    = "no-store"
      override = true
    }
  }
}
