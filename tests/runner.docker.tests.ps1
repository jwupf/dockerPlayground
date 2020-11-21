Describe "Learn how to create docker images that do different things(autorun image)" {
    BeforeAll {
        $dockerRepo = "base"
        $dockerRepoTag = "0.0.1"
        $dockerImageReference = ("{0}:{1}" -f $dockerRepo, $dockerRepoTag)

        $runnerDockerRepo = "runner"
        $runnerDockerImageReference = ("{0}:{1}" -f $runnerDockerRepo, $dockerRepoTag)
        
        . (Join-Path -Path $PSScriptRoot -ChildPath "testHelper.ps1")
        
        Remove-DockerImage -ImageName $dockerImageReference
        Remove-DockerImage -ImageName $runnerDockerImageReference        
    }
    
    Context "Creating a image that extends the base image and has a default command to run on start" {
        BeforeAll {
            ./buildDockerImage.ps1 -DockerPath "./baseImage" -ImageReference $dockerImageReference
        }    

        It "Build runner image using 'runnerImage' as the build context, assuming the base image already exists" {
            ./buildDockerImage.ps1 -DockerPath "./runnerImage" -ImageReference $runnerDockerImageReference
            docker images -q $runnerDockerImageReference | Should -Not -BeNullOrEmpty
        }

        It "Run the custom script(named 'run.sh') that is still part of the runner image if no special command was given" {
            ./runDockerImage.ps1 -ImageReference $runnerDockerImageReference | Should -Be "Hello World! From Script!"
        }

        It "Run the custom command given via the -Command switch and not the default command" {        
            $var = ./runDockerImage.ps1 -ImageReference $runnerDockerImageReference -Command "echo", "Huh?" 
            $var | Should -Be "Huh?"
        }
    }

    AfterAll {        
        Remove-DockerImage -ImageName $dockerImageReference
        Remove-DockerImage -ImageName $runnerDockerImageReference        
    }
}
