param(
    [Parameter(Mandatory=$true)][string]
    [ValidateScript({Test-Path $_})]
    $DockerPath,
    [Parameter(Mandatory=$true)][string]
    $ImageReference
)

Get-Content -Path $DockerPath | docker build -t $ImageReference -