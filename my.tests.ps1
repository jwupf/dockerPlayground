Describe "docker setup" {
    BeforeAll {
        $dockerRepo = "base"
        $dockerRepoTag = "0.0.1"
        $dockerImageReference = ("{0}:{1}" -f $dockerRepo, $dockerRepoTag)

        $extDockerRepo = "extended"
        $extDockerImageReference = ("{0}:{1}" -f $extDockerRepo, $dockerRepoTag)

        $runnerDockerRepo = "runner"
        $runnerDockerImageReference = ("{0}:{1}" -f $runnerDockerRepo, $dockerRepoTag)
        
        Function Remove-DockerImage($ImageName) {
            if ($null -ne (docker images -q $ImageName)) {
                docker image rm -f $ImageName
            }    
        }
        
        Remove-DockerImage -ImageName $dockerImageReference
        Remove-DockerImage -ImageName $extDockerImageReference
        Remove-DockerImage -ImageName $runnerDockerImageReference        
    }

    Context "base image" {        
        It "build script failes if file does not exist" {
            { .\buildImage.ps1 -DockerPath ".\Dockerfile.does.not.exist" -ImageReference $dockerImageReference } | Should -Throw # "DockerPath"
        }

        It "build image" {
            .\buildImage.ps1 -DockerPath ".\baseImage" -ImageReference $dockerImageReference
            docker images -q $dockerImageReference | Should -Not -BeNullOrEmpty
        } 

        It "runs hello world" {
            .\runHelloWorld.ps1 -ImageReference $dockerImageReference -Command "/run.sh" | Should -Be "Hello World! From Script!"
        }
    }
    Context "extended base image" {    
        BeforeAll{
            .\buildImage.ps1 -DockerPath ".\baseImage" -ImageReference $dockerImageReference
        }    
        It "build ext image" {
            .\buildImage.ps1 -DockerPath ".\extImage" -ImageReference $extDockerImageReference
            docker images -q $extDockerImageReference | Should -Not -BeNullOrEmpty
        } 

        It "runs hello world in ext base" {
            .\runHelloWorld.ps1 -ImageReference $extDockerImageReference -Command "/run.sh" | Should -Be "Hello World! From Script!"
        }

        It "runs ext hello world in ext base" {
            .\runHelloWorld.ps1 -ImageReference $extDockerImageReference -Command "/runExt.sh" | Should -Be "Hello World! From ext. Script!"
        }
    }

    Context "runner image"{
        BeforeAll{
            .\buildImage.ps1 -DockerPath ".\baseImage" -ImageReference $dockerImageReference
        }    

        It "build a runner image" {
            .\buildImage.ps1 -DockerPath ".\runnerImage" -ImageReference $runnerDockerImageReference
            docker images -q $runnerDockerImageReference | Should -Not -BeNullOrEmpty
        }

        It "runs hello world without given command" {
            .\runHelloWorld.ps1 -ImageReference $runnerDockerImageReference | Should -Be "Hello World! From Script!"
        }

        It "runs hello world with custom command" {
            $var = .\runHelloWorld.ps1 -ImageReference $runnerDockerImageReference -Command "echo","Huh?" 
            $var | Should -Be "Huh?"
        }
    }
    AfterAll {        
        Remove-DockerImage -ImageName $dockerImageReference
        Remove-DockerImage -ImageName $extDockerImageReference
        Remove-DockerImage -ImageName $runnerDockerImageReference        
    }
}
