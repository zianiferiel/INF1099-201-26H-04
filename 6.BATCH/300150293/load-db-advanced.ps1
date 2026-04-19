# -----------------------------------------------
# Script PowerShell avancé pour charger PostgreSQL
# Centre Sportif — Gestion de Terrains & Réservations
# #300150293
# -----------------------------------------------
 
param (
    [string]$Container = "postgres-sport"
)
 
$Database = "centre_sportif"
$User     = "postgres"
$LogFile  = "execution.log"
$Files    = "DDL.sql","DML.sql","DCL.sql","DQL.sql"
 
function Write-Log {
    param ([string]$Message)
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $line = "[$timestamp] $Message"
    Write-Output $line
    Add-Content -Path $LogFile -Value $line
}
 
# Vérification du conteneur
$containerRunning = podman ps --format "{{.Names}}" | Select-String $Container
 
if (-not $containerRunning) {
    Write-Log "ERREUR : le conteneur $Container n'est pas actif."
    exit
}
 
$globalStart = Get-Date
Write-Log "Chargement de la base de données centre_sportif..."
 
foreach ($file in $Files) {
 
    if (-not (Test-Path $file)) {
        Write-Log "ERREUR : fichier manquant : $file"
        exit
    }
 
    $startTime = Get-Date
    Write-Log "Execution de $file"
 
    Get-Content $file | podman exec -i $Container psql -U $User -d $Database
 
    $endTime = Get-Date
    $seconds = ($endTime - $startTime).TotalSeconds
    Write-Log "Termine en $([math]::Round($seconds, 2)) secondes."
}
 
$globalEnd    = Get-Date
$totalSeconds = ($globalEnd - $globalStart).TotalSeconds
Write-Log "Temps total : $([math]::Round($totalSeconds, 2)) secondes."
Write-Log "Base de données chargée avec succès."