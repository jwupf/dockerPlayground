Describe "Learn how to create docker images that do different things(compiler image)" {
    BeforeAll {
        . (Join-Path -Path $PSScriptRoot -ChildPath "testHelper.ps1")
        
        $dockerRepo = "base"
        $dockerRepoTag = "0.0.1"
        $dockerImageReference = ("{0}:{1}" -f $dockerRepo, $dockerRepoTag)
        
        $compileDockerRepo = "compiler"
        $compileDockerImageReference = ("{0}:{1}" -f $compileDockerRepo, $dockerRepoTag)
        
        $contextDir = "./compileImage"
        $srcFolder = Resolve-Path (Join-Path -Path $contextDir -ChildPath "src" )
        $outFolder = Resolve-Path (Join-Path -Path $contextDir -ChildPath "out" )

        $compiledFile = Get-FullTestDrivePath(Join-Path -Path $outFolder -ChildPath "myProgram")

        
        
        Remove-DockerImage -ImageName $dockerImageReference    
        # Remove-DockerImage -ImageName $compileDockerImageReference    
    }

    Context "Creating a image that extends the base image and has a compile script run on start" {
        BeforeAll {
            ./buildDockerImage.ps1 -DockerPath "./baseImage" -ImageReference $dockerImageReference
        }    

        It "Build runner image using 'compileImage' as the build context, assuming the base image already exists" {
            ./buildDockerImage.ps1 -DockerPath $contextDir -ImageReference $compileDockerImageReference
            docker images -q $compileDockerImageReference | Should -Not -BeNullOrEmpty
        }

        It "Run the compile script(named 'compile.sh') that is part of the compile image if no special command was given" {
            $driveMapping = (($srcFolder,"/src"), ($outFolder,"/out"))
            $compileResult = ./runDockerImage.ps1 -ImageReference $compileDockerImageReference -Mapping $driveMapping -Command "touch /src/test1.txt"
            $compileResult | Should -Not -BeNullOrEmpty
            # $compiledFile | Should -Exist
        }


        #     ./runDockerImage.ps1 -ImageReference $runnerDockerImageReference | Should -Be "Hello World! From Script!"
        # }

        # It "Run the custom command given via the -Command switch and not the default command" {        
        #     $var = ./runDockerImage.ps1 -ImageReference $runnerDockerImageReference -Command "echo","Huh?" 
        #     $var | Should -Be "Huh?"
        # }
    }

    AfterAll {        
        Remove-DockerImage -ImageName $dockerImageReference
        #Remove-DockerImage -ImageName $compileDockerImageReference        
    }
}
