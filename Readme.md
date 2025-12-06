
## L'objectif de ce réper
toire est d'apprendre à utiliser Terraform grâce à un ensemble de demos et un atelier pratique

### DEMOS: Prise en main de Terraform

- [DEMO 1 : Prise en main d'AWS](demo_1/Readme.md)
- [DEMO 2 : Configuration des Providers](demo_2/Readme.md)
- [DEMO 3 : Utilisation des commandes Terraform](demo_3/Readme.md)
- [DEMO 4 : Création de ma première infrastructure avec Terraform](demo_4/Readme.md)
- [DEMO 5 : Utilisation de Variables et Locales dans Terraform](demo_5/Readme.md)
- [DEMO 6 : Création et Utilisation de Modules Terraform](demo_6/Readme.md)
- [DEMO 7 : Tests Terraform pour la validation des configurations](demo_7/Readme.md)



### ATELIER: Application Trois tiers

Dans cette première partie, nous allons créer une application front avec un backend déployé sur une lambda en utilisant Ansible et Terraform.

- **Ansible** va nous permettre de packager notre code front et backend au format zip.
  - Dans une perspective de déploiement avec une CI/CD, Ansible sera utilisé pour décompresser le zip du front avant de le déployer.
- **Terraform** va nous permettre de créer l'ensemble de l'infrastructure décrite dans le schéma ci-dessous :

![porject_architecture.png](docs%2Fporject_architecture.png)


- [ATELIER: Application Trois tiers](atelier/Readme.md)