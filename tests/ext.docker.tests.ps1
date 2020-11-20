Describe "Learn how to create docker images that do different things(extend image)" {
    BeforeAll {
        $dockerRepo = "base"
        $dockerRepoTag = "0.0.1"
        $dockerImageReference = ("{0}:{1}" -f $dockerRepo, $dockerRepoTag)

        $extDockerRepo = "extended"
        $extDockerImageReference = ("{0}:{1}" -f $extDockerRepo, $dockerRepoTag)

        . (Join-Path -Path $PSScriptRoot -ChildPath "testHelper.ps1")
        
        Remove-DockerImage -ImageName $dockerImageReference
        Remove-DockerImage -ImageName $extDockerImageReference     
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

    AfterAll {        
        Remove-DockerImage -ImageName $dockerImageReference
        Remove-DockerImage -ImageName $extDockerImageReference      
    }
}
