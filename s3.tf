module "s3_bucket" {
  source = "terraform-aws-modules/s3-bucket/aws"

  bucket = "${var.s3_bucket_name}-${count.index}"
  acl    = "private"

  control_object_ownership = true
  object_ownership         = "ObjectWriter"

  versioning = {
    enabled = true
  }
  website = {
    index_document = "index.html"
  }
  attach_policy = true
  policy        = templatefile("policy.json", { bucket = var.s3_bucket_name, id = module.cdn.cloudfront_origin_access_identity_ids[0] })
  count = 2
}

resource "aws_s3_bucket_object" "object" {
  depends_on   = [local_file.index, module.s3_bucket]
  bucket       = "${var.s3_bucket_name}-${count.index}"
  key          = "index.html"
  source       = "index.html"
  content_type = "text/html"

  # The filemd5() function is available in Terraform 0.11.12 and later
  # For Terraform 0.11.11 and earlier, use the md5() function and the file() function:
  # etag = "${md5(file("path/to/file"))}"
  count=2
}

resource "aws_s3_bucket_object" "php" {
  depends_on   = [local_file.php, module.s3_bucket]
  bucket       = "${var.s3_bucket_name}-${count.index}"
  key          = "index.php"
  source       = "index.php"
  content_type = "text/html"
  count=2
  # The filemd5() function is available in Terraform 0.11.12 and later
  # For Terraform 0.11.11 and earlier, use the md5() function and the file() function:
  # etag = "${md5(file("path/to/file"))}"
}


resource "local_file" "index" {
  filename = "index.html"
  content  = <<EOF
    <!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
</head>

<body>
    <h1>Response From Backend</h1>
    <h1 id="response"></h1>
</body>
<script>
    const getData = async () => {
        const data = await fetch("https://harshilkhamarbackend.dns-poc-onprem.tk/index.php")
        const res = document.getElementById("response");
        res.innerHTML = await data.text() 
        console.log(await data.text())
    }
    getData()
</script>

</html>
EOF
}

resource "local_file" "php" {
  filename = "index.php"
  content  = <<EOF
    <?php

    header("Access-Control-Allow-Origin: *");
    $con = mysqli_connect("harshilkhamarrds.dns-poc-onprem.tk","${var.username}","${var.password}","${var.db_name}");

    if (mysqli_connect_errno()) {
        echo "Failed to connect to MySQL: " . mysqli_connect_error();
        exit();
    }
    else
    {
            echo "Connection Successful with Database ";
    }
?>
EOF
}

module "cdn" {
  source = "terraform-aws-modules/cloudfront/aws"

  aliases = ["harshilkhamarwebsite.dns-poc-onprem.tk"]

  enabled     = true
  price_class = "PriceClass_All"

  create_origin_access_identity = true
  origin_access_identities = {
    s3_bucket = "S3 Static Website Identity"
  }

  origin = {
    s3 = {
      domain_name = module.s3_bucket.s3_bucket_bucket_domain_name
      s3_origin_config = {
        origin_access_identity = "s3_bucket"
      }
    }
  }

  default_cache_behavior = {
    target_origin_id       = "s3"
    viewer_protocol_policy = "allow-all"

    allowed_methods = ["GET", "HEAD", "OPTIONS"]
    cached_methods  = ["GET", "HEAD"]
    compress        = true
    query_string    = true
  }


  viewer_certificate = {
    acm_certificate_arn = var.certificate_arn
    ssl_support_method  = "sni-only"
  }
}