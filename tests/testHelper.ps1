Function Remove-DockerImage($ImageName) {
    if ($null -ne (docker images -q $ImageName)) {
        docker image rm -f $ImageName
    }    
}

Function Get-FullTestDrivePath {
    Param(
        [string] $Path
    )
    return $Path.Replace('TestDrive:', (Get-PSDrive TestDrive).Root)
}
