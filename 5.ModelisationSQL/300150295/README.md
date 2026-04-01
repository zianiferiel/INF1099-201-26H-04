# Modelisation SQL - BetFormula
**Cours : INF1099-201-26H-04 | Etudiant : 300150295**

---

## Structure du projet
```
300150295/
├── README.md
├── images/
│   ├── Les tables créées (DDL).png
│   ├── Les données insérées (DML).png
│   ├── Les requêtes (DQL).png
│   ├── Les permissions (DCL).png
│   └── La structure du projet .png
├── DDL.sql
├── DML.sql
├── DQL.sql
└── DCL.sql
```

---

## Domaine - BetFormula

BetFormula est un site web qui permet aux utilisateurs de parier sur des pilotes participant a des courses automobiles. Les utilisateurs peuvent creer un compte, consulter les courses disponibles et placer des paris avec un montant precis.

---

## Diagramme Entite-Relation (ER)
```mermaid
erDiagram
    UTILISATEUR {
        int id_user PK
        string nom
        string email
        int id_ville FK
    }
    VILLE {
        int id_ville PK
        string nom_ville
        string code_postal
    }
    PILOTE {
        int id_pilote PK
        string nom_pilote
        int id_equipe FK
    }
    EQUIPE {
        int id_equipe PK
        string nom_equipe
        int id_sponsor FK
    }
    SPONSOR {
        int id_sponsor PK
        string nom_sponsor
    }
    CIRCUIT {
        int id_circuit PK
        string nom_circuit
        int id_ville FK
    }
    EVENEMENT {
        int id_evenement PK
        string nom_evenement
        date date_evenement
        int id_circuit FK
    }
    COURSE {
        int id_course PK
        string nom_course
        date date_course
        int id_evenement FK
    }
    PARI {
        int id_pari PK
        int id_user FK
        int id_course FK
        int id_pilote FK
        float montant
        string resultat
    }
    UTILISATEUR ||--o{ VILLE : "habite a"
    PILOTE ||--o{ EQUIPE : "appartient a"
    EQUIPE ||--o{ SPONSOR : "sponsorise par"
    CIRCUIT ||--o{ VILLE : "situe a"
    EVENEMENT ||--o{ CIRCUIT : "se deroule sur"
    COURSE ||--o{ EVENEMENT : "fait partie de"
    PARI ||--o{ UTILISATEUR : "fait par"
    PARI ||--o{ COURSE : "concernant"
    PARI ||--o{ PILOTE : "sur"
```

---

## Normalisation

### 1FN - Premiere forme normale
Toutes les colonnes contiennent des valeurs atomiques (non divisibles). Chaque table possede une cle primaire unique. Aucun groupe repetitif.
```
Entites : Utilisateur, Ville, Pilote, Course, Pari, Evenement, Circuit, Equipe, Sponsor
Attributs atomiques : montant, resultat, nom, email, code_postal, date_evenement, date_course
```

### 2FN - Deuxieme forme normale
Chaque attribut non-cle depend entierement de la cle primaire. Les relations sont separees en entites distinctes pour eliminer les dependances partielles.
```
UTILISATEUR  --  FAIT       --  PARI
UTILISATEUR  --  HABITE     --  VILLE
COURSE       --  CONTIENT   --  PARI
PILOTE       --  PARTICIPE  --  COURSE
PILOTE       --  APPARTIENT --  EQUIPE
EQUIPE       --  SPONSORISE --  SPONSOR
CIRCUIT      --  ACCUEILLE  --  EVENEMENT
EVENEMENT    --  COMPREND   --  COURSE
```

### 3FN - Troisieme forme normale
Aucune dependance transitive. Chaque attribut depend uniquement et directement de la cle primaire de sa table.
```
Utilisateur (id_user, nom, email, id_ville)
Ville       (id_ville, nom_ville, code_postal)
Pilote      (id_pilote, nom_pilote, id_equipe)
Equipe      (id_equipe, nom_equipe, id_sponsor)
Sponsor     (id_sponsor, nom_sponsor)
Circuit     (id_circuit, nom_circuit, id_ville)
Evenement   (id_evenement, nom_evenement, date_evenement, id_circuit)
Course      (id_course, nom_course, date_course, id_evenement)
Pari        (id_pari, id_user, id_course, id_pilote, montant, resultat)
```

---

## DDL.sql - Definition des tables

Creation de toutes les tables avec cles primaires, cles etrangeres et contraintes d'integrite.

![Les tables creees](images/Les%20tables%20cr%C3%A9%C3%A9es%20(DDL).png)

---

## DML.sql - Insertion des donnees

Insertion de donnees realistes : 3 villes, 3 sponsors, 3 equipes, 3 pilotes, 3 utilisateurs, 3 circuits, 3 evenements, 3 courses et 4 paris.

![Les donnees inserees](images/Les%20donn%C3%A9es%20ins%C3%A9r%C3%A9es%20(DML).png)

---

## DQL.sql - Requetes

| # | Requete | Description |
|---|---------|-------------|
| 1 | SELECT + JOIN | Tous les utilisateurs avec leur ville |
| 2 | SELECT + JOIN multiple | Tous les paris avec utilisateur, course et pilote |
| 3 | SELECT + WHERE | Paris gagnes uniquement |
| 4 | SELECT + GROUP BY | Total mise par utilisateur |
| 5 | SELECT + JOIN | Pilotes avec leur equipe et sponsor |

![Les requetes](images/Les%20requ%C3%AAtes%20(DQL).png)

---

## DCL.sql - Gestion des droits

| Role | Droits |
|------|--------|
| parieur | SELECT sur Utilisateur, Course, Pilote, Pari, Evenement, Circuit |
| administrateur | ALL PRIVILEGES sur toutes les tables |

![Les permissions](images/Les%20permissions%20(DCL).png)

---

## Structure du projet

![La structure](images/La%20structure%20du%20projet%20.png)

---

## Competences demontrees

- Analyse des besoins et modelisation conceptuelle
- Diagramme Entite-Relation (ER) avec Mermaid
- Normalisation 1FN, 2FN, 3FN appliquee au domaine BetFormula
- Creation des tables avec contraintes et cles etrangeres (DDL)
- Insertion de donnees realistes (DML)
- Requetes avancees avec JOIN, GROUP BY, WHERE (DQL)
- Gestion des roles et permissions (DCL)
