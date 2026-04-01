# ============================================================
# load-db-advanced.ps1 - Script PowerShell pour charger PostgreSQL
# Base de données École
# #300151492 - HAMMICHE MOHAND L'HACENE
# Usage : .\load-db-advanced.ps1 [nom-du-conteneur]
# ============================================================

param (
    [string]$Container = "postgres-lab"
)

$Database  = "ecole"
$User      = "postgres"
$LogFile   = "execution.log"

$Files = @(
    "DDL.sql",
    "DML.sql",
    "DCL.sql",
    "DQL.sql"
)

# ── Fonction log ────────────────────────────────────────────
function Write-Log {
    param([string]$Message)
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $line = "[$timestamp] $Message"
    Write-Output $line
    Add-Content -Path $LogFile -Value $line
}

# ── Démarrage ───────────────────────────────────────────────
$startTime = Get-Date
Write-Log "========================================"
Write-Log "HAMMICHE MOHAND L'HACENE - #300151492"
Write-Log "Demarrage du chargement de la base de donnees"
Write-Log "Conteneur : $Container | Base : $Database"
Write-Log "========================================"

# ── Vérification du conteneur ───────────────────────────────
$containerRunning = docker ps --format "{{.Names}}" | Select-String $Container

if (-not $containerRunning) {
    Write-Log "ERREUR : le conteneur '$Container' n'est pas actif."
    Write-Log "Lancez d'abord : docker container run -d --name $Container -e POSTGRES_PASSWORD=postgres -e POSTGRES_DB=$Database -p 5432:5432 postgres"
    exit 1
}

Write-Log "Conteneur '$Container' detecte. OK"

# ── Vérification des fichiers ────────────────────────────────
foreach ($file in $Files) {
    if (-not (Test-Path $file)) {
        Write-Log "ERREUR : fichier manquant : $file"
        exit 1
    }
}

Write-Log "Tous les fichiers SQL sont presents. OK"
Write-Log "----------------------------------------"

# ── Exécution des fichiers SQL ───────────────────────────────
foreach ($file in $Files) {
    Write-Log "Execution de $file ..."
    Get-Content $file | docker exec -i $Container psql -U $User -d $Database
    Write-Log "$file termine."
    Write-Log "----------------------------------------"
}

# ── Temps d'exécution ────────────────────────────────────────
$endTime  = Get-Date
$duration = ($endTime - $startTime).TotalSeconds

Write-Log "Base de donnees chargee avec succes!"
Write-Log "Temps d'execution total : $([math]::Round($duration, 2)) secondes"
Write-Log "Log sauvegarde dans : $LogFile"
