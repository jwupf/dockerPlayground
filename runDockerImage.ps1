param(
    [Parameter(Mandatory=$true)][string]
    $ImageReference,
    [string[]]
    $Command,    
    $Mapping #{$srcFolder,"/src"},{$outFolder,"/out"}
)

$map = $Mapping| Where-Object {$null -ne $_} | ForEach-Object { "-v {0}:{1}" -f $_[0],$_[1] }
$processArgs = "run","--rm","-it" + $map + $ImageReference + $Command
Start-process -FilePath docker -ArgumentList $processArgs -Wait -RedirectStandardOutput "retVal" # creates a file with the output ....
return $retVal
# docker run --rm -it -v /mnt/g/ExpPS/compileImage/out:/out -v /mnt/g/ExpPS/compileImage/src:/src compiler:0.0.1 touch /src/test1.txt-NOT $null 