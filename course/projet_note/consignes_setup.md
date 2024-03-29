# Projet noté

## Barème 
**60 points ramenés sur 20**
- Setup : 10 points
- Qualité du code / Commentaires / Explications  : 10 points
- Questions : 40 points
    - Pour chaque question, vous indiquerez dans un fichier `questions.md` (à la racine du repository) si vous l'avez traitée ou non :
    ```
    # questions.md
    - part_I_1_a : Oui
    - part_I_1_b : Oui
    ...
    - part_V_1 : Non
    ...
    ```
    - Les points sont tous attribués dès que le résultat est correct. Partiellement attribués si le résultat est partiel ou partiellement correct.

## Setup et documentation (10 points)


### Points d'attention

- Une partie de votre code sera exécuté automatiquement donc veillez à respecter les consignes

- Pour chaque question, on vous indique si c'est un fichier `.ipynb` ou un fichier `.sql` qui est attendu pour la réponse : **Ces fichiers doivent se trouver à la racine du repository**

### Versions et librairies

- Veiller à utiliser la même version de Python que dans le cours (3.11.2) via un environnement virtuel 
    ```bash
    # windows
    # Installer la version de Python
    pyenv install 3.11.2
    # Créer l'environnement dans le dossier courant
    ~/.pyenv/pyenv-win/versions/3.11.2/python.exe -m venv env
    ```
- Vous utiliserez uniquement `pymongo` et `psycopg2` pour les interactions avec MongoDB et PostgreSQL (pas `sqlalchemy`)
- Créer un repository public par groupe 
    - Inclure un `.gitignore` qui contient au moins l'environnement virtuel (`env`) et le fichier `.env` pour ne pas les commit sur Git
    - Ajouter l'URL au tableau des projets 
    - À la racine du repository, créer un fichier `.env` avec les variables qui permettent de se connecter aux base de données
        ```
            # MongoDB local
            MONGO_DB_USER=<user>
            MONGO_DB_PASSWORD=<password>

            # PostgreSQL Local
            POSTGRESQL_LOCAL_USER=<user>
            POSTGRESQL_LOCAL_PASSWORD=<password>

            # PostgreSQL Scalingo
            POSTGRESQL_SCALINGO_URL=<url>


        ```
- À la racine du repository, créer un fichier  `requirements.txt` : (on utilise `pip show <library>` avec l'environnement virtuel d'activé.)

    ```
    dnspython==2.4.2
    ipykernel==6.26.0
    #... toute autre librairie que vous utilisez

    ```

### Architecture du repository

```
projet_note
├── .env
├── env
├── requirements.txt
├── questions.md 
├── test_env.sql 
├── test_env.ipynb
├── part_1_1.sql 
├── part_1_2.sql
└── ...
```

### SQL

- Connexion à SQL (Locale) : 

    ```python
    import os
    from dotenv import load_dotenv
    # Le .env est aussi à la racine
    load_dotenv(".env")

    USER_PSQL = os.environ.get("POSTGRESQL_LOCAL_USER")
    PASSWORD_PSQL = os.environ.get("POSTGRESQL_LOCAL_PASSWORD")

    import psycopg2
    conn = psycopg2.connect(user=USER_PSQL, password=PASSWORD_PSQL, host="localhost", port="5432")
    # OU si nécessaire : 
    # conn = psycopg2.connect(user=USER_PSQL, password=PASSWORD_PSQL, dbname=<VOTRE VALEUR> host="localhost", port="5432")

    ```


- Connexion à SQL (Scalingo) : 

    ```python
    import os
    from dotenv import load_dotenv
    import psycopg2
    from urllib.parse import urlparse

    # Le .env est aussi à la racine
    load_dotenv(".env")

    URL_PSQL = os.environ.get("SCALINGO_URL")
    url_corrected = "postgresql" + url[8:]

    result = urlparse(url_corrected)
    username = result.username
    password = result.password
    database = result.path[1:]
    hostname = result.hostname
    port = result.port

    conn = psycopg2.connect(
        database = database,
        user = username,
        password = password,
        host = hostname,
        port = port
    )
    ```


### MongoDB

- Connexion à MongoDB (locale) : 


    ```python
    import os
    from dotenv import load_dotenv
    load_dotenv(".env")

    import pymongo

    USER_MONGODB = os.environ.get("MONGO_DB_USER")
    PASSWORD_MONGODB = os.environ.get("MONGO_DB_PASSWORD")

    uri = f"mongodb://{USER_MONGODB}:{PASSWORD_MONGODB}@localhost:27017/?retryWrites=true&w=majority"
    client = pymongo.mongo_client.MongoClient(uri)
    ```

### Vérification

#### SQL :

- Créer une base de données `course` localement (via l'invite de commande ou pg_admin...)

- Dans un fichier `test_env.sql`, écrire le code SQL pour : 
    - Créer deux tables `tp` et `notebooks` : 
        - La table `tp` contient deux colonnes `tp_id` et `tp_name` (seulement pour tp1 et tp2)
        - La table `notebooks` contient `notebook_id` et `tp_id` (qui est une Foreign Key sur `tp`) et `notebook_name` (0_sql_intro_northwind.ipynb... seulement les notebooks, pas les autres fichiers)
        - Insérer les données pour les 2 premiers tps

    - Vérifier que tout fonctionne : `psql -U <user> -d course -f test_env.sql`


- Dans un fichier `test_env_view.sql`, écrire le code SQL pour : 

    - Créer une vue `tp_and_notebook` qui permet d'afficher tout le contenu de la table `notebook` ainsi que le `tp_name` pour chaque notebook

    - Vérifier que tout fonctionne : `psql -U <user> -d course -f test_env_view.sql`



#### SQL & MongoDB : `test_env.ipynb`


- Reproduire la démarche précédente, toujours avec SQL dans un fichier `test_env.ipynb`
- Dans le même notebook : créer une connexion locale à MongoDB
- Créer une base de données `course`
- Créer deux collections `tp` et `notebook` avec des champs correspondant aux colonnes des tables SQL
- Écrire une fonction qui permet d'afficher les mêmes données que la vue `tp_and_notebook`