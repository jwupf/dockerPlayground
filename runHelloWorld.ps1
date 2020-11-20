param(
    [Parameter(Mandatory=$true)][string]
    $ImageReference
)

docker run --rm -it $ImageReference echo "Hello World!"