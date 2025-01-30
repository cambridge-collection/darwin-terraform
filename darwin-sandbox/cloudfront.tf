resource "aws_cloudfront_function" "darwin" {
  name    = "${local.environment}-clean_urls"
  runtime = "cloudfront-js-2.0"
  comment = "clean-and-redirect"
  publish = true
  code    = file("${path.module}/templates/darwin/cloudfront-function.js.ttfpl")
}
