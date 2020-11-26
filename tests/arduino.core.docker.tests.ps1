Describe "Learn how to create docker images that do different things(arduino core image)" {
    BeforeAll {
        $dockerRepo = "arduino"
        $dockerRepoTag = "0.0.1"
        $dockerImageReference = ("{0}:{1}" -f $dockerRepo, $dockerRepoTag)
        
        . (Join-Path -Path $PSScriptRoot -ChildPath "testHelper.ps1")
        
        Remove-DockerImage -ImageName $dockerImageReference    
    }
    
    Context "Handle the case that the docker build context does not exist" {        
        It "The build script fails with an exception if the context folder does not exist" {
            { ./buildDockerImage.ps1 -DockerPath "./Dockerfile.does.not.exist" -ImageReference $dockerImageReference } | Should -Throw # "DockerPath"
        }
    }

    Context "Creating the arduino image" {                
        It "Build the arduino image using 'arduinoImage' as the build context" {
            ./buildDockerImage.ps1 -DockerPath "./arduinoImage" -ImageReference $dockerImageReference
            docker images -q $dockerImageReference | Should -Not -BeNullOrEmpty
        } 

        It "Run the custom script(named 'run.sh') that is part of the base image" {
            $runResult = ./runDockerImage.ps1 -ImageReference $dockerImageReference -Command "arduino-cli version" 
            $runResult | Should -BeLike "arduino-cli Version:*"
        }
    }

    AfterAll {        
        Remove-DockerImage -ImageName $dockerImageReference       
    }
}
