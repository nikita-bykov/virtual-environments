Import-Module "$PSScriptRoot/../helpers/Common.Helpers.psm1"

function Get-VSMacVersion {
    $plistPath = "/Applications/Visual Studio.app/Contents/Info.plist"
    return Run-Command "/usr/libexec/PlistBuddy -c 'Print CFBundleVersion' '$plistPath'"
}

function Get-NUnitVersion {
    $version = Run-Command "nunit3-console --version" | Select-Object -First 1 | Take-Part -Part 3
    return "NUnit ${version}"
}

function Build-XamarinTable {
    $xamarinBundles = Get-ToolsetValue "xamarin.bundles"
    $defaultSymlink = Get-ToolsetValue "xamarin.bundle-default"
    $sortRules = @{
        Expression = { [System.String]::($_.symlink) }
        Descending = $true
    }

    return $xamarinBundles | Sort-Object $sortRules | ForEach-Object {
        $defaultPostfix = ($_.symlink -eq $defaultSymlink ) ? " (default)" : ""
        [PSCustomObject] @{
            "symlink" = $_.symlink + $defaultPostfix 
            "Xamarin.Mono" = $_.mono
            "Xamarin.iOS" = $_.ios
            "Xamarin.Mac" = $_.mac
            "Xamarin.Android" = $_.android
        }
    }
}

