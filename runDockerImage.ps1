param(
    [Parameter(Mandatory=$true)][string]
    $ImageReference,
    [string[]]
    $Command,    
    $Mapping #{$srcFolder,"/src"},{$outFolder,"/out"}
)

$map = $Mapping| Where-Object {$null -ne $_} | ForEach-Object { "-v {0}:{1}" -f $_[0],$_[1] }
$process = "docker","run","--rm","-it" + $map + $ImageReference + $Command
Invoke-Expression  ($process -join ' ')