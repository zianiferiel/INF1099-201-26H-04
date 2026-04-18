# ============================================================
# load-db.ps1 - Script PowerShell pour charger PostgreSQL
# Cours : INF1099 | Domaine : AeroVoyage (Compagnie Aerienne)
# ============================================================

param(
    [string]$Container = "postgres-lab"
)

$Database = "aerovoyage"
$User     = "postgres"

$Files = @(
    "DDL.sql",
    "DML.sql",
    "DCL.sql",
    "DQL.sql"
)

# Verification que le conteneur est actif
$containerRunning = docker ps --format "{{.Names}}" | Select-String $Container

if (-not $containerRunning) {
    Write-Output "ERREUR : le conteneur $Container n'est pas actif."
    Write-Output "Lance d'abord : docker run -d --name $Container -e POSTGRES_PASSWORD=postgres -e POSTGRES_DB=$Database -p 5432:5432 postgres"
    exit
}

Write-Output "============================================"
Write-Output " Chargement de la base de donnees AeroVoyage"
Write-Output "============================================"

$startTime = Get-Date

foreach ($file in $Files) {

    if (-not (Test-Path $file)) {
        Write-Output "ERREUR : fichier manquant : $file"
        exit
    }

    Write-Output ""
    Write-Output ">>> Execution de $file ..."
    Get-Content $file | docker exec -i $Container psql -U $User -d $Database
    Write-Output "<<< $file termine."
}

$endTime = Get-Date
$duration = $endTime - $startTime

Write-Output ""
Write-Output "============================================"
Write-Output " Base de donnees chargee avec succes !"
Write-Output " Temps d'execution : $($duration.TotalSeconds) secondes"
Write-Output "============================================"
