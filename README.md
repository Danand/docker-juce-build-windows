# `juce-build-windows`

Docker image that builds VST3 plugins for Windows Server 2019 written with JUCE Framework.

Image based on `mcr.microsoft.com/dotnet/framework/runtime:4.8-windowsservercore-ltsc2019` and contains all required dependencies to build project on JUCE Framework.

Currently recommended version of JUCE Framework is [7.0.5](https://github.com/juce-framework/JUCE/releases/tag/7.0.5)

## How to use

```bash
docker login \
  --username "your-username" \
  --password "${GITHUB_TOKEN}" \
  ghcr.io

project_root="my-project-dir"
jucer_project="my-project.jucer"
juce_repo="JUCE"
outputs_dir="${project_root}/Builds/VisualStudio2019"
cwd="$(pwd)"

mkdir -p "${outputs_dir}"

docker run \
  --rm \
  --user "$(id -u):$(id -g)" \
  --mount "type=bind,source=${cwd}/${project_root},target=/project-root" \
  --mount "type=bind,source=${cwd}/${juce_repo},target=/JUCE" \
  --env "JUCER_PROJECT=${jucer_project}" \
  ghcr.io/danand/docker-juce-build-windows/juce-build-windows:0.1.1
```
