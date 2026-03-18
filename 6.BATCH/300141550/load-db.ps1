# ---------------------------------------
# Script PowerShell pour charger PostgreSQL
# (Compatible Podman via alias docker)
# ---------------------------------------

param(
    [string]$Container = "postgres-lab"
)

# ✅ Alias Docker -> Podman
if (-not (Get-Command docker -ErrorAction SilentlyContinue)) {
    Write-Output "Docker non trouvé, utilisation de Podman..."
    Set-Alias docker podman
}

$Database = "ecole"
$User = "postgres"

$Files = "DDL.sql","DML.sql","DCL.sql","DQL.sql"

$LogFile = "execution.log"

$startTime = Get-Date

Write-Output "=== Début du chargement ===" | Tee-Object -FilePath $LogFile

# Vérifier si le conteneur est actif
$containerRunning = docker ps --format "{{.Names}}" | Select-String $Container

if (-not $containerRunning) {
    Write-Output "ERREUR : le conteneur $Container n'est pas actif." | Tee-Object -Append -FilePath $LogFile
    exit
}

foreach ($file in $Files) {

    if (-not (Test-Path $file)) {
        Write-Output "ERREUR : fichier manquant : $file" | Tee-Object -Append -FilePath $LogFile
        exit
    }

    Write-Output "Execution de $file" | Tee-Object -Append -FilePath $LogFile

    Get-Content $file | docker exec -i $Container psql -U $User -d $Database | Tee-Object -Append -FilePath $LogFile
}

$endTime = Get-Date
$duration = $endTime - $startTime

Write-Output "=== Chargement terminé ===" | Tee-Object -Append -FilePath $LogFile
Write-Output "Temps d'exécution : $duration" | Tee-Object -Append -FilePath $LogFile
