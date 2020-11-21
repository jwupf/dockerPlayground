Describe "Learn how to create docker images that do different things(compiler image)" {
    BeforeAll {
        . (Join-Path -Path $PSScriptRoot -ChildPath "testHelper.ps1")
        
        $dockerRepo = "base"
        $dockerRepoTag = "0.0.1"
        $dockerImageReference = ("{0}:{1}" -f $dockerRepo, $dockerRepoTag)
        
        $debPackageDockerRepo = "deb.package"
        $debPackageDockerImageReference = ("{0}:{1}" -f $debPackageDockerRepo, $dockerRepoTag)
        
        $contextDir = "./debPackageImage"
        
        Remove-DockerImage -ImageName $dockerImageReference    
        Remove-DockerImage -ImageName $debPackageDockerImageReference    
    }

    Context "Creating a image that extends the base image and has a compile script run on start" {
        BeforeAll {
            ./buildDockerImage.ps1 -DockerPath "./baseImage" -ImageReference $dockerImageReference
        }    

        It "Build runner image using 'debPackageImage' as the build context, assuming the base image already exists" {
            ./buildDockerImage.ps1 -DockerPath $contextDir -ImageReference $debPackageDockerImageReference
            docker images -q $debPackageDockerImageReference | Should -Not -BeNullOrEmpty
        }

    }

    AfterAll {        
        Remove-DockerImage -ImageName $dockerImageReference
        Remove-DockerImage -ImageName $debPackageDockerImageReference  
    }
}
