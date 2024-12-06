resource "aws_cloudfront_function" "darwin" {
  name    = "${module.solr.name_prefix}_clean_urls"
  runtime = "cloudfront-js-2.0"
  comment = "clean-and-redirect"
  publish = true
  code    = file("${path.module}/templates/darwin/cloudfront-function.js.ttfpl")
}
