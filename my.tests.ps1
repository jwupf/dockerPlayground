Context "docker setup" {
    BeforeAll {
        $dockerRepo = "base"
        $dockerRepoTag = "0.0.1"
        $dockerImageReference = ("{0}:{1}" -f $dockerRepo, $dockerRepoTag)

        $extDockerRepo = "extended"
        $extDockerRepoTag = "0.0.1"
        $extDockerImageReference = ("{0}:{1}" -f $extDockerRepo, $extDockerRepoTag)

        if($null -ne (docker images -q $dockerImageReference)){
            docker image rm -f $dockerImageReference
        }

        if($null -ne (docker images -q $extDockerImageReference)){
            docker image rm -f $extDockerImageReference
        }
    }

    It "build script failes if file does not exist" {
        {.\buildImage.ps1 -DockerPath ".\Dockerfile.does.not.exist" -ImageReference $dockerImageReference} |Should -Throw # "DockerPath"
    }

    It "build image" {
        .\buildImage.ps1 -DockerPath ".\baseImage" -ImageReference $dockerImageReference
        docker images -q $dockerImageReference | Should -Not -BeNullOrEmpty
    } 

    It "runs hello world" {
        .\runHelloWorld.ps1 -ImageReference $dockerImageReference | Should -Be "Hello World! From Script!"
    }

    It "build ext image" {
        .\buildImage.ps1 -DockerPath ".\extImage" -ImageReference $extDockerImageReference
        docker images -q $extDockerImageReference | Should -Not -BeNullOrEmpty
    } 

    It "runs ext hello world" {
        .\runHelloWorld.ps1 -ImageReference $extDockerImageReference | Should -Be "Hello World! From ext. Script!"
    }

    AfterAll{
        if($null -ne (docker images -q $dockerImageReference)){
            docker image rm -f $dockerImageReference
        }

        if($null -ne (docker images -q $extDockerImageReference)){
            docker image rm -f $extDockerImageReference
        }
    }
}
