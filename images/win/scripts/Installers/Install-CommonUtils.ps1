$commonPackages = (Get-ToolsetContent).choco.common_packages

foreach ($package in $commonPackages)
{
    Write-Host "Installing $package"
    Choco-Install -PackageName $package
}

Invoke-PesterTests -TestFile "BasicTools"