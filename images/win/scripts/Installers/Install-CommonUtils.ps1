$commonPackages = (Get-ToolsetContent).choco.common_packages

foreach ($package in $commonPackages)
{
    Write-Host "Installing $package"
    Choco-Install -PackageName $package
}

$commonPackages = (Get-ToolsetContent).choco.common_packages_with_args

foreach ($package in $commonPackages)
{
    Write-Host "Installing ${package.name}"
    Choco-Install -PackageName $package.name -ArgumentList $package.args
}

npm install -g @bazel/bazelisk

Invoke-PesterTests -TestFile "BasicTools"