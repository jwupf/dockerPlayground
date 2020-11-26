param(
    [Parameter(Mandatory = $true)][string]
    [ValidateScript( { Test-Path $_ })]
    $DockerPath,
    [Parameter(Mandatory = $true)][string]
    $ImageReference
)


$process = "docker", "build", "-t" + $ImageReference + $DockerPath
Invoke-Expression ($process -join ' ')
#docker build -t $ImageReference $DockerPath
