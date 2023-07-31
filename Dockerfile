# escape=`

FROM chocolatey/choco:v2.2.0-windows

WORKDIR /

SHELL [ "powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'Continue'; $verbosePreference='Continue';" ]

RUN choco install --yes `
      zip `
      visualstudio2017-workload-vctools `
      microsoft-build-tools

COPY .\BuildImage.ps1 .

ENTRYPOINT [ "BuildImage.ps1" ]
