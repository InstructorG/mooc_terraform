# Demo 4 – Création de ma première infrastructure avec Terraform

## Objectifs

1. Installer le provider AWS
2. Importer une clé KMS déployée sur AWS avec l’alias `alias/student-main-key`
3. Créer un bucket S3 en utilisant le provider `random` pour générer une partie du nom du bucket
4. Chiffrer le bucket avec la clé KMS
5. Supprimer toutes les ressources une fois terminé

---

## 1. Installer le provider AWS

Crée un fichier `main.tf` et déclare le provider AWS dans le bloc `terraform` :

```hcl
terraform {
  required_version = ">= 1.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region = "eu-west-1"
}
```

Ensuite, initialise le projet :

```bash
terraform init
```

---

## 2. Importer une clé KMS existante avec l’alias `alias/student-main-key`

On n’“importe” pas la clé au sens Terraform state, mais on la **référence** en tant que data source, à partir de son alias :

```hcl
data "aws_kms_key" "kms_key" {
  key_id = "alias/alias/student-main-key"
}
```

Ce bloc recherche sur AWS la clé KMS ayant l’alias `alias/alias/student-main-key`.
Elle sera ensuite réutilisable via `data.aws_kms_key.student_main_key.arn`.

---

## 3. Créer un bucket S3 avec un nom partiellement aléatoire

On va utiliser le provider `random` pour générer une chaîne aléatoire qui sera concaténée dans le nom du bucket.

```hcl
resource "random_string" "random" {
  special = false
  length = 10
  upper = false
}

resource "aws_s3_bucket" "s3" {
  bucket        = "bucket-${random_string.random.result}"
  force_destroy = true
}
```

Résultat attendu :

* Terraform génère une chaîne du type `a1b2c3a1b23`.
* Le bucket sera nommé par exemple : `bucket-a1b2c3a1b23`.

---

## 4. Chiffrer le bucket S3 avec la clé KMS

On applique une configuration de chiffrement côté serveur avec KMS sur le bucket, en utilisant la clé récupérée précédemment :

```hcl
resource "aws_s3_bucket_server_side_encryption_configuration" "sse_custom_kms" {
  bucket = aws_s3_bucket.s3.id

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = data.aws_kms_key.kms_key.arn
      sse_algorithm     = "aws:kms"
    }
    bucket_key_enabled = false
  }
}
```

Ce que cela fait :

* Le bucket `student_bucket` est configuré pour chiffrer automatiquement tous les objets avec la clé KMS `alias/student-main-key`.
* La clé utilisée est celle référencée dans le data source `aws_kms_key.student_main_key`.

Plan et application :

```bash
terraform plan
terraform apply
```

Après `terraform apply`, tu dois voir :

* 1 ressource `random_string` créée
* 1 bucket S3 créé
* 1 configuration de chiffrement associée au bucket

---

## 5. Supprimer toutes les ressources une fois terminé

Quand tu as terminé la démonstration et que tu souhaites tout nettoyer :

```bash
terraform destroy
```


Résultat attendu :

* Le bucket S3 est supprimé (attention à bien vider le bucket avant si tu as mis des objets manuellement non gérés par Terraform).
* La ressource `random_string` est supprimée.
* La configuration de chiffrement associée au bucket est supprimée.

La clé KMS référencée en data source **n’est pas supprimée**, car elle est gérée directement dans AWS et non créée par cette configuration Terraform.
