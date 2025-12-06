# Demo 6 – Création et utilisation de modules Terraform


## Objectifs

1. Créer un module Terraform dans le répertoire module.
2. Dans ce module :
  * Créer un bucket S3.
  * Créer une fonction Lambda.
  * Mettre en place une notification S3 qui déclenche la Lambda.
  * Configurer les autorisations nécessaires pour que S3 puisse invoquer la Lambda.
3. Définir les variables suivantes : bucket_name, lambda_name, code_archive.
4. Définir deux outputs : output_bucket_name, output_lambda_name.
5. Générer la documentation avec terraform-docs.

---


On souhaite créer un module dans le répertoire "module".

![img.png](static/img.png)

### 1.  Dans le fichier "main.tf", nous souhaitons :

Créer un bucket S3.

```terraform
resource "aws_s3_bucket" "s3_module" {
  bucket        = var.bucket_name
  force_destroy = true
}
```


### 2.  Dans le fichier "main.tf", nous souhaitons :

Créer une fonction Lambda.

```terraform
data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "iam_for_lambda" {
  name               = "iam_for_lambda-${random_string.random.result}"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

resource "aws_iam_role_policy" "policy_one" {
  name = "plicy_for_lambda-${random_string.random.result}"
  role = aws_iam_role.iam_for_lambda.id

    policy = jsonencode({
      Version   = "2012-10-17"
      Statement = [
        {
          Action = [
            "logs:CreateLogGroup", "logs:CreateLogStream",
            "logs:PutLogEvents","iam:PassRole"
          ]
          Effect   = "Allow"
          Resource = "*"
        },
      ]
    })
}

resource "aws_lambda_function" "func" {
  function_name = var.lambda_name
  filename      = var.code_archive
  role          = aws_iam_role.iam_for_lambda.arn
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.10"
}
```


### 3.  Dans le fichier "main.tf", nous souhaitons :

Mettre en place une notification S3 qui déclenche la fonction Lambda.
Configurer les autorisations nécessaires pour exécuter la fonction Lambda.

```terraform
resource "aws_lambda_permission" "allow_bucket" {
  statement_id  = "AllowExecutionFromS3Bucket"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.func.arn
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.s3_module.arn
}


resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = aws_s3_bucket.s3_module.id

  lambda_function {
    lambda_function_arn = aws_lambda_function.func.arn
    events              = ["s3:ObjectCreated:*"]
    filter_prefix       = "input/"

  }

  depends_on = [aws_lambda_permission.allow_bucket]
}

```

### 4.  Dans le fichier "variables.tf", nous souhaitons : 

Créer des variables pour les éléments suivants :
   - Le nom du bucket S3 : "bucket_name".
   - Le nom de la fonction Lambda : "lambda_name".
   - L'emplacement du code de la Lambda : "code_archive".

```terraform
variable "bucket_name" {
  description = "(Required) Bucket name where data is received"
  type = string
}

variable "lambda_name" {
  description = "(Required) Lambda name where data is processed"
  type = string
}


variable "code_archive" {
  description = "(Required) lambda code to deploy"
  type = string
}
```

### 5.  Dans le fichier "outputs.tf", nous souhaitons : 

Créer deux sorties (outputs) :
   - Le nom du compartiment S3 : "output_bucket_name".
   - Le nom de la fonction Lambda : "output_lambda_name".

```terraform
output "output_buket_name" {
  value = aws_s3_bucket.s3_module.bucket
}

output "lambda_name" {
  value = aws_lambda_function.func.function_name
}
```

### 6.  Dans le fichier "Reamdme", nous souhaitons : 

Générer la documentation avec terraform-docs

```bash
terraform-docs  markdown . >> Readme.md
```