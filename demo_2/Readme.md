# Demo 2 – Préparer Terraform et les providers

## Objectifs

1. Installer Terraform
2. Installer le provider AWS
3. Installer un provider pour les fichiers
4. Créer un alias pour le provider AWS avec la région `eu-west-1`
5. Initialiser Terraform

---

## 1. Installer Terraform

### a. macOS (Homebrew)

```bash
brew tap hashicorp/tap
brew install hashicorp/tap/terraform
terraform -version
```

### b. Linux (Debian / Ubuntu)

```bash
sudo apt-get update && sudo apt-get install -y gnupg software-properties-common
wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt-get update && sudo apt-get install terraform
terraform -version
```

### c. Windows (Chocolatey)

Dans un terminal PowerShell en mode administrateur :

```powershell
choco install terraform
terraform -version
```

Une fois Terraform installé, vérifiez que la commande `terraform` est disponible dans votre terminal.

---

## 2. Installer le provider AWS

Créez un fichier `main.tf` dans un nouveau dossier de travail.
Ajoutez la configuration suivante :

```hcl
terraform {
  required_version = ">= 1.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "eu-central-1"
}
```

Explications :

* Le bloc `terraform` indique à Terraform quel provider utiliser et quelle version.
* Le bloc `provider "aws"` configure le provider AWS par défaut (ici en `eu-central-1` à titre d’exemple).

Le provider sera téléchargé automatiquement lors de l’exécution de `terraform init` (étape 5).

---

## 3. Installer un provider pour les fichiers

Pour manipuler des fichiers locaux, on peut utiliser le provider `local`.
Ajoutez-le dans le même fichier `main.tf` :

```hcl
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }

    local = {
      source  = "hashicorp/local"
      version = "~> 2.0"
    }
  }
}

provider "aws" {
  region = "eu-central-1"
}
```

Exemple de ressource utilisant le provider `local` :

```hcl
resource "local_file" "exemple" {
  content  = "Bonjour depuis Terraform"
  filename = "${path.module}/exemple.txt"
}
```

Lors de `terraform apply`, ce fichier `exemple.txt` sera créé dans le répertoire du module.

---

## 4. Créer un alias pour le provider AWS avec la région `eu-west-1`

Vous pouvez définir plusieurs configurations pour le provider AWS en utilisant des alias.
Ajoutez un deuxième provider AWS dans `main.tf` :

```hcl
provider "aws" {
  region = "eu-central-1"
}

provider "aws" {
  alias  = "eu_west_1"
  region = "eu-west-1"
}
```

Utilisation de cet alias dans une ressource :

```hcl
resource "aws_s3_bucket" "bucket_ireland" {
  provider = aws.eu_west_1

  bucket = "mon-bucket-demo-eu-west-1"
}
```

Ici :

* `provider = aws.eu_west_1` indique à Terraform d’utiliser la configuration aliasée en `eu-west-1`.
* Cela permet de gérer des ressources dans plusieurs régions AWS au sein du même projet.

---

## 5. Initialiser Terraform

Dans le dossier contenant votre fichier `main.tf`, exécutez :

```bash
terraform init
```

Cette commande :

* Télécharge les providers déclarés (`aws`, `local`, etc.).
* Initialise le répertoire Terraform (création du dossier `.terraform`, etc.).
* Vérifie la configuration de base.

Si tout se passe bien, vous devriez voir un message indiquant que l’init a réussi et que les providers ont été installés. Vous pouvez ensuite continuer avec `terraform plan` et `terraform apply` pour tester votre configuration.
