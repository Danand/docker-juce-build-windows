# escape=`

FROM mcr.microsoft.com/dotnet/framework/runtime:4.8-windowsservercore-ltsc2019

WORKDIR /

SHELL [ "powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'Continue'; $verbosePreference='Continue';" ]

RUN Set-ExecutionPolicy `
      Bypass `
      -Scope Process `
      -Force; `
    iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'));

COPY .\packages.config .

RUN choco install --yes packages.config

COPY .\Entrypoint.ps1 .

ENV JUCE_REV_RECOMMENDED "69795dc8e589a9eb5df251b6dd994859bf7b3fab"

ENTRYPOINT [ "Entrypoint.ps1" ]
