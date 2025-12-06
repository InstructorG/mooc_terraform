
## L'objectif de ce répertoire est d'apprendre à utiliser Terraform grâce à un ensemble de demos et un atelier pratique

### DEMOS: Prise en main de Terraform

- [DEMO 1 : Prise en main d'AWS](demo_1/README.md)
- [DEMO 2 : Configuration des Providers](demo_2/README.md)
- [DEMO 3 : Utilisation des commandes Terraform](demo_3/README.md)
- [DEMO 4 : Création de ma première infrastructure avec Terraform](demo_4/README.md)
- [DEMO 5 : Utilisation de Variables et Locales dans Terraform](demo_5/README.md)
- [DEMO 6 : Création et Utilisation de Modules Terraform](demo_6/README.md)
- [DEMO 7 : Tests Terraform pour la validation des configurations](demo_7/README.md)



### ATELIER: Application Trois tiers

Dans cette première partie, nous allons créer une application front avec un backend déployé sur une lambda en utilisant Ansible et Terraform.

- **Ansible** va nous permettre de packager notre code front et backend au format zip.
  - Dans une perspective de déploiement avec une CI/CD, Ansible sera utilisé pour décompresser le zip du front avant de le déployer.
- **Terraform** va nous permettre de créer l'ensemble de l'infrastructure décrite dans le schéma ci-dessous :

![porject_architecture.png](docs%2Fporject_architecture.png)

## Partie 1 : Packaging avec Ansible

1. Prenez le temps de parcourir le code front et backend situés dans le dossier **code**.

2. Créez deux playbooks Ansible permettant de créer les archives zip du front et du backend avec la bonne version et, si nécessaire, de décompresser le front.

3. Dans le fichier **create_front_and_backend_archives.yml** situé dans le dossier **infrastructure/ansible**, ajoutez une tâche pour créer un dossier **build** :

   - **Emplacement du dossier** : `../../build`

4. Dans le fichier **create_front_and_backend_archives.yml**, ajoutez une tâche pour créer l'archive du backend :

   - **dossier_source** : `../../build/backend-{{ version }}.zip`
   - **dossier_cible** : `../../code/backend`

5. Dans le fichier **create_front_and_backend_archives.yml**, ajoutez une tâche pour créer l'archive du front :

   - **dossier_source** : `../../build/front-{{ version }}.zip`
   - **dossier_cible** : `../../code/front`

6. Générez les archives backend et front avec la commande `ansible-playbook`.

7. Dans le fichier **unzip_archive**, ajoutez une tâche pour décompresser l'archive du front :

   - **dossier_source** : `./front-{{ version }}.zip`
   - **dossier_cible** : `./front_extracted`
   - **emplacement** : `../../build`

8. Vérifiez que le playbook fonctionne en utilisant la commande `ansible-playbook`.


## Partie 2 : Création de l'infrastructure avec Terraform

1. Dans le fichier **main.yaml**, modifiez la valeur `<changer-le-nom>` de la variable locale `component_name` avec une 
valeur qui vous est propre.

2. Créez un bucket S3 pour héberger le code du front :
   - **Nom du bucket** : `s3-${local.component_name}`

3. Rattachez les ressources suivantes au bucket précédemment créé :
   - `aws_s3_bucket_website_configuration`
   - `aws_s3_bucket_public_access_block`
   - `aws_s3_bucket_policy` ( ! N'oubliez pas le champ Resource dans le Statement)

4. Chargez les fichiers suivants dans le bucket :
   - **Nom du fichier** : `index.html`, **content_type** : `text/html`
   - **Nom du fichier** : `script.js`, **content_type** : `application/javascript`
   - **Nom du fichier** : `style.css`, **content_type** : `text/css`

5. Créez une fonction Lambda avec les propriétés suivantes :
   - **function_name**    : `lambda-${local.component_name}`
   - **role**             : `aws_iam_role.lambda_exec.arn`
   - **handler**          : `lambda_function.lambda_handler`
   - **runtime**          : `python3.8`
   - **filename**         : `../../build/backend-${var.version_backend}.zip`
   - **source_code_hash** : `filebase64sha256("../../build/backend-${var.version_backend}.zip")`

6. Appelez le module **apigateway**.

7. Modifiez l'output `s3_url` dans le fichier **output.tf**.

8. Créez l'infrastructure en utilisant la commande `terraform apply`.

9. En accédant à l'interface web et en appuyant sur le bouton, quel est le résultat ? Pouvez-vous l'expliquer ?

10. Modifiez la valeur du fichier `script.js` avec la bonne valeur dans le dossier **front_extracted**.

11. Relancez l'exécution avec la commande `terraform apply` et testez si tout fonctionne correctement.

