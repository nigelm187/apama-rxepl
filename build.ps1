param (
   [string]$sagInstallDir = (.\misc\getSagInstallDir),
   [string]$output = "$(Split-Path $MyInvocation.MyCommand.Path -Parent)\output\RxEPL"
)

if(!$PSScriptRoot){ $PSScriptRoot = Split-Path $MyInvocation.MyCommand.Path -Parent }

$apamaInstallDir = "$sagInstallDir\Apama"
if (-not (Test-Path $apamaInstallDir)) {
	Throw "Could not find Apama Installation"
}

echo "Using Apama located in: $apamaInstallDir"

$apamaBin = "$apamaInstallDir\bin"

.\clean -sagInstallDir $sagInstallDir

$version = "$(cat .\version.txt)-$(git rev-parse --short HEAD)"

md "$output" | out-null
md "$output\cdp" | out-null
& "$apamaBin\engine_deploy" --outputCDP "$output\cdp\RxEPL.cdp" src
& "$apamaBin\engine_deploy" --outputDeployDir "$output\code" src
rm "$output\code\initialization.yaml"

cp -r "$PSScriptRoot\docs" "$output\docs"

# Create the bundle
$files = & "$apamaBin\engine_deploy" --outputList stdout src | %{$_ -replace ".*\\src\\rx\\",""} | %{$_ -replace "\\","/"}
$bundleFileList = $files | %{$_ -replace "(.+)","`t`t`t<include name=`"`$1`"/>"} | Out-String
$bundleResult = cat "$PSScriptRoot\bundles\BundleTemplate.bnd"
$bundleResult = $bundleResult | %{$_ -replace "<%date%>", (Get-Date -UFormat "%Y-%m-%d")}
$bundleResult = $bundleResult | %{$_ -replace "<%version%>", $version}
$bundleResult = $bundleResult | %{$_ -replace "<%fileList%>",$bundleFileList}
md "$output\bundles" | out-null
# Write out utf8 (no BOM)
[IO.File]::WriteAllLines("$output\bundles\rxepl.bnd", $bundleResult)

cp -r "$PSScriptRoot\misc" "$output\misc"
mv "$output\misc\deploy.bat" "$output\deploy.bat"

# Write out utf8 (no BOM)
[IO.File]::WriteAllLines("$output\version.txt", $version)

# Zip
if (Get-Command Compress-Archive -errorAction SilentlyContinue) {
	Compress-Archive -Path $output -CompressionLevel Optimal -DestinationPath "$output-$version.zip"
} else {
	& "C:\Program Files\7-Zip\7z.exe" a "$output-$version.zip" $output
}