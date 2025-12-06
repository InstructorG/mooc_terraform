# Demo 7 – Tests Terraform et pipeline GitHub Actions

## Objectifs

* Créer un fichier de test Terraform pour le module de l’atelier 4 situé dans `module/`.
* Tester le module avec la méthode `plan`.
* Vérifier que les variables `bucket_name` et `lambda_name` sont bien utilisées par le module.
* Ajouter l’initialisation, les tests et l’apply Terraform dans le job `deploy` du workflow GitHub Actions.

---

## 1. Créer un fichier de test Terraform

### 1.1. Fichier de test avec la méthode `plan`

Créez un fichier de test avec les propriétés suivantes :

* Testez avec la méthode "plan".
* Testez le module de la demo 6  situé dans le répertoire "module".
* Spécifiez une variable "bucket_name" et vérifiez que le nom du compartiment qui sera créé par le module a la même valeur.
* Spécifiez une variable "lambda_name" et vérifiez que le nom de la fonction Lambda qui sera créée par le module a la même valeur.

Crée un fichier de test au même niveau que le répertoire module :

```hcl
run "valid_names" {

  command = plan

  module {
    source = "./module"
  }

  variables  {
    bucket_name  = "bucket-test"
    lambda_name  = "lambda-test"
    code_archive = "../../data/lambda.zip"
  }


  assert {
    condition     = aws_s3_bucket.s3_module.bucket  == "bucket-test"
    error_message = "S3 bucket name did not match expected"
  }

  assert {
    condition     = aws_lambda_function.func.function_name == "lambda-test"
    error_message = "Lambda bucket name did not match expected"
  }

}
```

### 1.2. Exécuter le test avec la commande `terraform test`

Depuis la racine du projet, exécute :

```bash
terraform test
```

Ce que cette commande va faire :

* Lancer le `run` avec la commande `plan`.
* Charger le module depuis `./module`.
* Injecter les variables `bucket_name` et `lambda_name` avec les valeurs de test.
* Vérifier que :

  * Le nom du bucket S3 planifié (`aws_s3_bucket.this.bucket`) est égal à `bucket_name`.
  * Le nom de la fonction Lambda planifiée (`aws_lambda_function.this.function_name`) est égal à `lambda_name`.

En cas d’échec d’une des conditions, `terraform test` retournera une erreur avec le message fourni dans `error_message`.


### 1.3. Voir si le test marche

Changer la logique du module et verifier si le teste fonctionne toujours 