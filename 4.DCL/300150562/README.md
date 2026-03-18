🛒 Boutique de Maillots – Base de Données PostgreSQL
📌 Description

Base de données pour gérer une boutique de maillots :

👤 Clients

📍 Adresses

🛍️ Commandes

👕 Maillots & Catégories

💳 Paiements

🚚 Livraisons & Livreurs

# 1. Créer la base
createdb boutique_maillots

# 2. Exécuter les scripts
psql -d boutique_maillots -f ddl.sql
psql -d boutique_maillots -f dml.sql
