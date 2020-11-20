Describe "Learn how to create docker images that do different things" {
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
    
    Context "Handle the case that the docker build context does not exist" {        
        It "The build script fails with an exception if the context folder does not exist" {
            { .\buildDockerImage.ps1 -DockerPath ".\Dockerfile.does.not.exist" -ImageReference $dockerImageReference } | Should -Throw # "DockerPath"
        }
    }

    Context "Creating the base image" {                
        It "Build the base image using 'baseImage' as the build context" {
            .\buildDockerImage.ps1 -DockerPath ".\baseImage" -ImageReference $dockerImageReference
            docker images -q $dockerImageReference | Should -Not -BeNullOrEmpty
        } 

        It "Run the custom script(named 'run.sh') that is part of the base image" {
            .\runDockerImage.ps1 -ImageReference $dockerImageReference -Command "/run.sh" | Should -Be "Hello World! From Script!"
        }
    }
    Context "Creating a image that extends the base image" {    
        BeforeAll{
            .\buildDockerImage.ps1 -DockerPath ".\baseImage" -ImageReference $dockerImageReference
        }    
        It "Build extended image using 'extImage' as the build context, assuming the base image already exists" {
            .\buildDockerImage.ps1 -DockerPath ".\extImage" -ImageReference $extDockerImageReference
            docker images -q $extDockerImageReference | Should -Not -BeNullOrEmpty
        } 

        It "Run the custom script(named 'run.sh') that is still part of the extended image" {
            .\runDockerImage.ps1 -ImageReference $extDockerImageReference -Command "/run.sh" | Should -Be "Hello World! From Script!"
        }

        It "Run the custom script(named 'runExt.sh') that is only part of the extended image" {
            .\runDockerImage.ps1 -ImageReference $extDockerImageReference -Command "/runExt.sh" | Should -Be "Hello World! From ext. Script!"
        }
    }

    Context "Creating a image that extends the base image and has a default command to run on start"{
        BeforeAll{
            .\buildDockerImage.ps1 -DockerPath ".\baseImage" -ImageReference $dockerImageReference
        }    

        It "Build runner image using 'runnerImage' as the build context, assuming the base image already exists" {
            .\buildDockerImage.ps1 -DockerPath ".\runnerImage" -ImageReference $runnerDockerImageReference
            docker images -q $runnerDockerImageReference | Should -Not -BeNullOrEmpty
        }

        It "Run the custom script(named 'run.sh') that is still part of the runner image if no special command was given" {
            .\runDockerImage.ps1 -ImageReference $runnerDockerImageReference | Should -Be "Hello World! From Script!"
        }

        It "Run the custom command given via the -Command switch and not the default command" {        
            $var = .\runDockerImage.ps1 -ImageReference $runnerDockerImageReference -Command "echo","Huh?" 
            $var | Should -Be "Huh?"
        }
    }
    AfterAll {        
        Remove-DockerImage -ImageName $dockerImageReference
        Remove-DockerImage -ImageName $extDockerImageReference
        Remove-DockerImage -ImageName $runnerDockerImageReference        
    }
}
