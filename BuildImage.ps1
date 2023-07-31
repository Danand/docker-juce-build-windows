# Builds VST3 for specified JUCE project.
#
# Volumes:
# - `/project-root`
# - `/outputs`
# - `/JUCE`

$VOLUME_PROJECT_ROOT = "c:\project-root"
$VOLUME_OUTPUTS = "c:\outputs"
$VOLUME_JUCE = "c:\JUCE"

Write-Output "Starting to build $Env:JUCER_PROJECT"
Write-Output

Write-Output "Current recommended revision of JUCE is $Env:JUCE_REV_RECOMMENDED"
Write-Output

Set-Location "${VOLUME_PROJECT_ROOT}"

$project_path = "$(Get-Location)\$Env:JUCER_PROJECT"

Push-Location "$VOLUME_JUCE\extras\Projucer\Builds\VisualStudio2017"

$msbuild = "${Env:ProgramFiles(x86)}\Microsoft Visual Studio\2017\BuildTools\MSBuild\Current\Bin\MSBuild.exe"

& $msbuild Projucer.sln

$projucer = "$((Get-Location).Path)\x64\Debug\App\Projucer.exe"

$job = Start-Job -ScriptBlock { `
  param($executable, $project) `
  & $executable "--resave", "${project}" `
} `
  -ArgumentList `
    "${projucer}", `
    "${project_path}"

Start-Sleep -Seconds 20
Receive-Job -Job $job
Remove-Job -Job $job

Pop-Location
Push-Location "$VOLUME_PROJECT_ROOT\Builds\VisualStudio2017"

$solution_name = (Get-ChildItem "*.sln" | Select-Object -First 1).Name

& $msbuild "$solution_name"

$vst3_files = Get-ChildItem -Recurse "*.vst3"

foreach ($vst3_file in $vst3_files) {
  $arch = $vst3_file.Directory.Parent.Parent.Name
  New-Item -Path "$VOLUME_OUTPUTS" -Name $arch -ItemType Directory
  Copy-Item -Path $vst3_file.FullName -Destination "$VOLUME_OUTPUTS"
}

