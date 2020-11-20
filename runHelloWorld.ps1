param(
    [Parameter(Mandatory=$true)][string]
    $ImageReference,
    [string[]]
    $Command
)

docker run --rm -it $ImageReference $Command