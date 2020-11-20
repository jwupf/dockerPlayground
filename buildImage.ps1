param(
    [Parameter(Mandatory=$true)][string]
    $ImageReference
)

Get-Content -Path ".\Dockerfile" | docker build -t $ImageReference -