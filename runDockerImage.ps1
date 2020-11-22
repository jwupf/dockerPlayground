param(
    [Parameter(Mandatory = $true)][string]
    $ImageReference,
    [string[]]
    $Command, 
    [string[][]]   
    $PathMappings
)

$mappings = $PathMappings | Where-Object { $null -ne $_ } | ForEach-Object { "-v {0}" -f ($_ -join ':') }
$process = "docker", "run", "--rm", "-it" + $mappings + $ImageReference + $Command
Invoke-Expression  ($process -join ' ')