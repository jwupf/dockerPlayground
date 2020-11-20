Describe "Learn how to create docker images that do different things(Base image)" {
    BeforeAll {
        $dockerRepo = "base"
        $dockerRepoTag = "0.0.1"
        $dockerImageReference = ("{0}:{1}" -f $dockerRepo, $dockerRepoTag)
        
        . (Join-Path -Path $PSScriptRoot -ChildPath "testHelper.ps1")
        
        Remove-DockerImage -ImageName $dockerImageReference    
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

    AfterAll {        
        Remove-DockerImage -ImageName $dockerImageReference       
    }
}
