param (
   [string]$sagInstallDir = (.\misc\getSagInstallDir),
   [string]$output = "$PSScriptRoot\output\RxEPL"
)

$apamaInstallDir = "$sagInstallDir\Apama"
if (-not (Test-Path $apamaInstallDir)) {
	Throw "Could not find Apama Installation"
}

echo "Using Apama located in: $apamaInstallDir"

$apamaBin = "$apamaInstallDir\bin"

.\clean -sagInstallDir $sagInstallDir

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
$bundleResult = $bundleResult | %{$_ -replace "<%version%>", (cat .\version.txt)}
$bundleResult = $bundleResult | %{$_ -replace "<%gitHash%>", (git rev-parse --short HEAD)}
$bundleResult = $bundleResult | %{$_ -replace "<%fileList%>",$bundleFileList}
md "$output\bundles" | out-null
# Write out utf8 (no BOM)
[IO.File]::WriteAllLines("$output\bundles\rxepl.bnd", $bundleResult)

cp -r "$PSScriptRoot\misc" "$output\misc"
mv "$output\misc\deploy.bat" "$output\deploy.bat"