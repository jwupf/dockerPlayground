Function Remove-DockerImage($ImageName) {
    if ($null -ne (docker images -q $ImageName)) {
        docker image rm -f $ImageName
    }    
}