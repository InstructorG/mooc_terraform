# Demo – Découvrir AWS avec la console et l’AWS CLI

## Objectifs

Cette démo est découpée en deux grandes parties :

1. Prendre en main la console AWS et découvrir les services :
   - Amazon S3
   - AWS Lambda
   - AWS Identity and Access Management (IAM)

2. Installer l’AWS CLI en local et initialiser un profil AWS pour se connecter à un compte.

---

## Prérequis

- Un compte AWS (ou un environnement de type sandbox fourni par votre formateur).
- Un poste avec droits d’installation pour l’AWS CLI (Windows, macOS ou Linux).

---

## Partie 1 – Découverte de la console AWS

### 1. Connexion à la console AWS

1. Accédez à l’URL de la console AWS : https://console.aws.amazon.com/
2. Connectez-vous avec vos identifiants :
   - Soit un compte root (à éviter en production).
   - Soit un utilisateur IAM doté de permissions suffisantes.
3. Vérifiez la région sélectionnée en haut à droite (ex. `eu-west-1` – Ireland).

Note : La région impacte les ressources visibles (S3, Lambda, etc.).

---

### 2. Découverte de Amazon S3

Objectif : comprendre le stockage d’objets dans AWS.

1. Dans la barre de recherche de la console, tapez `S3` et ouvrez le service.
2. Liste des buckets 
3. Créer un bucket (optionnel, si vous avez les droits) :
   - Cliquez sur `Create bucket`.
   - Donnez un nom unique (ex. `demo-console-s3-votre-nom`).
   - Choisissez une région (de préférence la même que pour la suite de la démo).
   - Laissez les options par défaut pour la démo et validez.
4. Téléverser un objet :
   - Cliquez sur votre bucket.
   - Cliquez sur `Upload`.
   - Ajoutez un petit fichier (ex. un fichier texte).
   - Validez l’upload.
5. Observez :
   - Les détails de l’objet (taille, Storage class, URL).
   - Les options de permissions et de versioning (si activé).

---

### 3. Découverte de AWS Lambda

Objectif : voir comment exécuter du code sans gérer de serveur.

1. Dans la barre de recherche, tapez `Lambda` et ouvrez le service.
2. Liste des fonctions :
   - Affichez les fonctions existantes (s’il y en a).
3. Créer une fonction simple (si autorisé) :
   - Cliquez sur `Create function`.
   - Choisissez `Author from scratch`.
   - Donnez un nom (ex. `demo-console-lambda`).
   - Runtime : `Python 3.x` (par exemple `Python 3.10`).
   - Rôle d’exécution : laissez AWS créer un nouveau rôle de base.
   - Validez la création.
4. Tester la fonction :
   - Dans l’éditeur, laissez le code par défaut ou affichez-le.
   - Cliquez sur `Test`.
   - Créez un nouvel évènement de test par défaut et exécutez.
   - Observez le résultat dans les logs (console de sortie, logs CloudWatch).

Ressources :

Code :

```python
import os
import json
import boto3
from botocore.exceptions import ClientError

s3 = boto3.client("s3")

def lambda_handler(event, context):
    # 1) Récupération bucket/key depuis event ou env
    bucket = (event or {}).get("bucket") or os.environ.get("BUCKET_NAME")
    key = (event or {}).get("key") or os.environ.get("CSV_KEY")

    if not bucket or not key:
        return {
            "statusCode": 400,
            "headers": {"Content-Type": "application/json"},
            "body": json.dumps({
                "error": "Missing 'bucket'/'key' in event or BUCKET_NAME/CSV_KEY in environment."
            })
        }

    # 2) Lecture de l'objet S3
    obj = s3.get_object(Bucket=bucket, Key=key)
    raw = obj["Body"].read()

    # 3) Décodage (UTF-8 par défaut)
    # Si ton CSV est dans un autre encodage, adapte ici.
    csv_text = raw.decode("utf-8")

    # 4) Renvoi du CSV en réponse
    return {
        "statusCode": 200,
        "headers": {
            "Content-Type": "text/plain; charset=utf-8"
            # ou "text/csv; charset=utf-8" si tu préfères
        },
        "body": csv_text
    }
```
Exemple d'event :

```json
{
  "bucket": "demo-bucket-12343404094",
  "key": "plantes.csv"
}
```



---

### 4. Découverte de IAM (Identity and Access Management)

Objectif : comprendre la gestion des identités et permissions.

1. Dans la barre de recherche, tapez `IAM` et ouvrez le service.
2. Parcours rapide :
   - `Users` : liste des utilisateurs IAM.
   - `Groups` : groupes d’utilisateurs.
   - `Roles` : rôles utilisés par des services (comme Lambda).
   - `Policies` : politiques JSON définissant les permissions.
3. Consultez un utilisateur IAM existant (si possible) :
   - Regardez ses permissions (policies attachées).
4. Consultez un rôle IAM (par exemple celui utilisé par une Lambda) :
   - Vérifiez les policies attachées (ex. `AWSLambdaBasicExecutionRole`).

Idée clé : IAM contrôle qui peut faire quoi, sur quelles ressources.

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": ["s3:GetObject"],
      "Resource": "arn:aws:s3:::mon-bucket/*"
    }
  ]
}
```

---

## Partie 2 – Installer l’AWS CLI et configurer un profil

Objectif : se connecter à AWS depuis la ligne de commande.

### 1. Installation de l’AWS CLI

Selon votre environnement, choisissez une des méthodes ci-dessous.

#### macOS (Homebrew)

```bash
brew update
brew install awscli
aws --version
````

#### Windows (via MSI ou package manager)

Option 1 : Installer via package MSI (téléchargé depuis le site AWS), puis vérifier :

```powershell
aws --version
```

Option 2 : Si vous utilisez `choco` :

```powershell
choco install awscli
aws --version
```

#### Linux (exemple Debian/Ubuntu)

```bash
sudo apt-get update
sudo apt-get install awscli -y
aws --version
```

Une fois l’installation terminée, la commande `aws` doit être reconnue dans votre terminal.

---

### 2. Récupérer les identifiants IAM

Vous avez besoin d’un utilisateur IAM avec :

* Un `Access Key ID`
* Un `Secret Access Key`

Dans IAM (console AWS) :

1. Allez dans `Users`.
2. Sélectionnez l’utilisateur qui servira à la démo.
3. Onglet `Security credentials`.
4. Créez une nouvelle access key si nécessaire.
5. Notez soigneusement l’`Access key ID` et le `Secret access key` (ne les partagez pas).

---

### 3. Initialiser un profil AWS avec `aws configure`

Nous allons utiliser le profil  `default`.

Dans un terminal :

```bash
aws configure 
```

Répondez aux questions :

* `AWS Access Key ID` : l’access key IAM.
* `AWS Secret Access Key` : le secret key associé.
* `Default region name` : par exemple `eu-west-1`.
* `Default output format` : par exemple `json`.

Les informations sont stockées dans :

* `~/.aws/credentials`
* `~/.aws/config`

---

### 4. Vérifier la connexion avec le profil

Test simple pour confirmer que le profil est bien configuré.

```bash
aws sts get-caller-identity
```

Vous devriez obtenir un résultat de ce type :

* `Account` : ID du compte AWS.
* `Arn` : ARN de l’utilisateur ou du rôle.
* `UserId` : identifiant de l’entité.

Autres tests possibles :

* Lister les buckets S3 :

  ```bash
  aws s3 ls 
  ```

* Lister les fonctions Lambda (dans une région donnée) :

  ```bash
  aws lambda list-functions --region eu-west-1
  ```
