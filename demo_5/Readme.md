# Demo 5 – Utilisation de variables et locales dans Terraform


## Objectifs

1. Créer une variable `list_of_files` avec validation.
2. Générer dynamiquement des noms de fichiers avec suffixe aléatoire.
3. Créer un fichier local pour chaque nom généré.
4. Créer un objet S3 correspondant à chaque fichier.
5. Supprimer toutes les ressources une fois l’atelier terminé.

---

## Partie 1 – Variable `list_of_files` avec validations

### 1. Créer la variable `list_of_files`

Créer une variable list_of_files avec les caractéristiques suivantes :

    Description : "Liste des fichiers et des objets S3 à créer."
    Type : Liste de chaînes de caractères.
    Valeur par défaut : ["file_first", "file_second", "file_third"]

Dans `variables.tf`, on définit la variable :

```hcl
variable "list_of_files" {
  description = "List of buckets"

  type = list(string)

  default = ["file_first", "file_second", "file_third"]
  
}
```

### 2. Ajouter deux validations à `list_of_files`

On souhaite ajouter deux validations :
* La taille de la liste doit être supérieure à 3.
* Vérifier que chaque élément de la liste commence par le terme "file".
* En cas d'erreur, afficher le message suivant : "Chaque élément de fichier doit commencer par "file_" et la liste doit contenir plus de 3 éléments."

```hcl
variable "list_of_files" {
  description = "List of buckets"

  type = list(string)

  default = ["file_first", "file_second", "file_third"]

  validation {
    condition = length(var.list_of_files) > 2 && alltrue([for v in var.list_of_files : (split("_", v)[0] == "file")])
    error_message = "Each file item should starting with \"file_\" and list should be more than 3"
  }
}
```

Ce que fait cette configuration :

* Vérifie que la liste contient plus de 3 éléments (`length(var.list_of_files) > 3`).
* Vérifie que chaque élément commence par `file_` grâce à `startswith(f, "file_")`.
* En cas d’échec, Terraform affiche le message d’erreur demandé.

---

## Partie 2 – Fichiers locaux et objets S3


### 1. Créer une variable locale `files_names` (map avec suffixe aléatoire)

Créer une variable locale **files_names** avec les caractéristiques suivantes :

* Type : Map
* Pour chaque élément de la liste list_of_files, ajouter un suffixe aléatoire.

Exemple : "file_first-er9u3"

On commence par générer un suffixe aléatoire pour chaque élément de `list_of_files` :

```hcl
resource "random_string" "random" {
  special = false
  length  = 10
  upper   = false
}
```

Ensuite, on construit la map locale `files_names` :

```hcl
locals {
  files_names = {
    for key, value in var.list_of_files : value => "${value}-${random_string.random.result}"
  }
}
```

* Clé du map : le nom de base (`file_first`, `file_second`, etc.).
* Valeur : le nom avec suffixe aléatoire (`file_first-er9u3`, etc.).

---

### 2. Créer un fichier local pour chaque entrée de `files_names` (for_each)

Créer un fichier pour chaque élément de la variable locale files_names en utilisant for_each :

* Le nom du fichier doit correspondre à la clé du map.
* Le contenu du fichier doit correspondre à la valeur du map.

On utilise le provider `local` et la propriété `for_each` :

```hcl
resource "local_file" "file" {
  for_each = local.files_names
  filename = each.key
  content  = each.value
}
```

Résultat :

* Pour chaque clé de `local.files_names`, Terraform crée un fichier `<clé>.txt`.

  * Exemple : `file_first.txt`, `file_second.txt`, etc.

---

### 3. Créer un objet S3 pour chaque fichier (count)

Créer un objet S3 dans le compartiment "s3_atelier_3" pour chaque fichier en utilisant count.

On crée un objet S3 pour chaque fichier local dans le bucket `s3_atelier_3` :

```hcl
resource "aws_s3_bucket" "s3_atelier_3" {
  bucket        = "bucket-${random_string.random.result}"
  force_destroy = true
}

resource "aws_s3_object" "example" {
  count = length(var.list_of_files)

  bucket = aws_s3_bucket.s3_atelier_3.id
  key    = "${local_file.file[var.list_of_files[count.index]].filename}-object"
  source = local_file.file[var.list_of_files[count.index]].filename
}
```

Ce que fait cette ressource :

* Utilise `count` pour créer un objet S3 par fichier.
* `key` sur S3 : par exemple `file_first.txt`.
* `source` : pointe sur le fichier local créé par `local_file.files`.

Commande à exécuter :

```bash
terraform init
terraform plan
terraform apply
```

---

### 4. Supprimer toutes les ressources

Une fois les tests terminés, on nettoie tout avec :

```bash
terraform destroy
```


Résultat attendu :

* Tous les fichiers locaux créés par Terraform sont supprimés.
* Tous les objets S3 créés dans `s3_atelier_3` par cette configuration sont supprimés.
* Les ressources `random_string` sont également détruites.
