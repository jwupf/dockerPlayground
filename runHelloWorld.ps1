param(
    [Parameter(Mandatory=$true)][string]
    $ImageReference,
    [Parameter(Mandatory=$true)][string]
    $Command
)

docker run --rm -it $ImageReference $Command