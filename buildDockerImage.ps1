param(
    [Parameter(Mandatory = $true)][string]
    [ValidateScript( { Test-Path $_ })]
    $DockerPath,
    [Parameter(Mandatory = $true)][string]
    $ImageReference
)


docker build -t $ImageReference $DockerPath
