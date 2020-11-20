Context "docker setup" {
    BeforeAll {
        $dockerRepo = "base"
        $dockerRepoTag = "0.0.1"
        $dockerImageReference = ("{0}:{1}" -f $dockerRepo, $dockerRepoTag)
        docker image rm -f $dockerImageReference
    }
    It "build image" {
        .\buildImage.ps1
        docker images -q base:0.0.1 | Should -Not -BeNullOrEmpty
    }

    It "runs hello world" {
        .\runHelloWorld.ps1 | Should -Be "Hello World!"
    }
}
