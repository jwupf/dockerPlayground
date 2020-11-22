Describe "Learn how to create docker images that do different things(compiler image)" {
    BeforeAll {
        . (Join-Path -Path $PSScriptRoot -ChildPath "testHelper.ps1")
        
        $dockerRepo = "base"
        $dockerRepoTag = "0.0.1"
        $compileDockerRepo = "compiler"
        $compileDockerImageReference = ("{0}:{1}" -f $compileDockerRepo, $dockerRepoTag)
        
        $contextDir = "./compileImage"
        $srcFolder = Resolve-Path(Join-Path -Path  $PSScriptRoot -ChildPath "src")
        $outFolder = Get-FullTestDrivePath(Join-Path -Path "TestDrive:" -ChildPath "out")
        New-Item -Path $outFolder -ItemType Directory

        $compiledFilePath = Join-Path -Path $outFolder -ChildPath "prg"
         
        Remove-DockerImage -ImageName $compileDockerImageReference    
    }

    Context "Creating a image that extends the base image and has a compile script run on start" { 
        It "Build runner image using 'compileImage' as the build context, assuming the base image already exists" {
            ./buildDockerImage.ps1 -DockerPath $contextDir -ImageReference $compileDockerImageReference
            docker images -q $compileDockerImageReference | Should -Not -BeNullOrEmpty
        }

        It "Run the compile script(named 'compile.sh') that is part of the compile image if no special command was given" {
            $driveMapping = (($srcFolder, "/src", "ro"), ($outFolder, "/out", "rw"))
            $dockerOutput = ./runDockerImage.ps1 -ImageReference $compileDockerImageReference -PathMappings $driveMapping
            $dockerOutput | Should -BeNullOrEmpty
            $compiledFilePath | Should -Exist
        }
    }

    AfterAll {        
        Remove-DockerImage -ImageName $compileDockerImageReference  
    }
}
