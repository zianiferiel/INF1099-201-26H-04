# 🧪 TP NoSQL — PostgreSQL JSONB

**Étudiant :** 300148210 — Feriel Ziani
**Cours :** INF1099-201-26H-04

---

## 🟢 Partie 1 — Docker

### Lancer PostgreSQL avec Podman

```powershell
podman container run --name postgres-nosql `
  -e POSTGRES_USER=postgres `
  -e POSTGRES_PASSWORD=postgres `
  -e POSTGRES_DB=ecole `
  -p 5432:5432 `
  -v ${PWD}/init.sql:/docker-entrypoint-initdb.d/init.sql `
  -d postgres
```

### ✅ Résultat — Conteneur lancé

<img width="935" height="409" alt="Screenshot 2026-04-19 195126" src="https://github.com/user-attachments/assets/19ea634c-8ad4-4026-9bc7-c63a9b3427db" />

---

## 🟡 Partie 2 — SQL NoSQL

### Table etudiants + données

```sql
SELECT * FROM etudiants;
```

### ✅ Résultat — Tous les étudiants

<img width="915" height="447" alt="Screenshot 2026-04-19 195254" src="https://github.com/user-attachments/assets/0228263f-44b1-4a3c-aafc-cd8b9db85b47" />

---

### Index GIN

```sql
\d etudiants
```

### ✅ Résultat — Index GIN présent


---

### Recherche par nom (opérateur `->>`)

```sql
SELECT data FROM etudiants WHERE data->>'nom' = 'Alice';
```

### Recherche par compétence (opérateur `->`)

```sql
SELECT data FROM etudiants WHERE data->'competences' ? 'Python';
```

### ✅ Résultat — Recherches

<img width="941" height="429" alt="Screenshot 2026-04-19 195413" src="https://github.com/user-attachments/assets/994c807e-8053-4f34-ab19-072fe55fdc93" />

---

## 🔵 Partie 3 — Python

### Installation des dépendances

```powershell
python -m pip install -r requirements.txt
```

### ✅ Résultat — pip install


---

### Lancement du script

```powershell
python app.py
```
<img width="927" height="355" alt="Screenshot 2026-04-19 195524" src="https://github.com/user-attachments/assets/0a8856aa-e685-412f-ba11-852a541ff3ed" />

### ✅ Résultat — app.py

<img width="935" height="292" alt="Screenshot 2026-04-19 195606" src="https://github.com/user-attachments/assets/95cb2176-b140-4029-9edb-cd06850dbfac" />

---

## 🎓 Compétences démontrées

- ✅ Déploiement container PostgreSQL avec Podman
- ✅ NoSQL avec JSONB dans PostgreSQL
- ✅ Index GIN pour la performance
- ✅ Opérateurs `->` et `->>`
- ✅ Script Python avec INSERT, SELECT, SEARCH
- ✅ Gestion des dépendances avec `requirements.txt`
