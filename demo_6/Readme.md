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



On souhaite créer un module dans le répertoire "module".

![img.png](static/img.png)

1. Dans le fichier "main.tf", nous souhaitons :

   - Créer un bucket S3.
   - Créer une fonction Lambda.
   - Mettre en place une notification S3 qui déclenche la fonction Lambda.
   - Configurer les autorisations nécessaires pour exécuter la fonction Lambda.

2. Créer des variables pour les éléments suivants :
   - Le nom du bucket S3 : "bucket_name".
   - Le nom de la fonction Lambda : "lambda_name".
   - L'emplacement du code de la Lambda : "code_archive".

3. Créer deux sorties (outputs) :
   - Le nom du compartiment S3 : "output_bucket_name".
   - Le nom de la fonction Lambda : "output_lambda_name".

4. Générer la documentation avec terraform-docs. (terraform-docs markdown . > Readme.md)

Indications :

- Pour la fonction Lambda :
   - Utilisez le code situé dans le répertoire : "data/lambda.zip".
   - La handler : "lambda_function.lambda_handler".
   - La runtime : "python3.10".

- Vous pouvez trouver un exemple de code dans la documentation Terraform.