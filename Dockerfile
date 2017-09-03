# escape=`
FROM microsoft/dotnet-framework:3.5
MAINTAINER p2@phase2online.com
SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

RUN Install-WindowsFeature NET-Framework-45-ASPNET ; `
    Install-WindowsFeature Web-Asp-Net45
	
RUN wget "https://dist.nuget.org/win-x86-commandline/latest/nuget.exe" `
    -OutFile "C:\windows\nuget.exe" -UseBasicParsing

ENV chocolateyUseWindowsCompression false	
RUN wget "https://chocolatey.org/install.ps1" -OutFile "C:\choco.ps1" -UseBasicParsing ;`
	powershell.exe -NoProfile -ExecutionPolicy Bypass -File C:\choco.ps1; `
	[Environment]::SetEnvironmentVariable('PATH', $env:PATH + ';C:\ProgramData\chocolatey\bin', 'Machine')

RUN	choco config set cachelocation C:\chococache ;`
    choco install dotnet4.6.1 --confirm
	
RUN choco install visualstudio2017professional `
		--package-parameters '--passive --locale en-US --includeRecommended --includeOptional' `
		--confirm `
		--limit-output `
		--timeout 216000 `
		-pre
		
RUN choco install --confirm`
			visualstudio2017-workload-netweb `
			visualstudio2017-workload-netcoretools `
			visualstudio2017-workload-manageddesktop
			
RUN choco install sql2014.smo --confirm
			 
RUN choco install wixtoolset --confirm;
RUN cmd /c del /S /Q C:\chococache

RUN [Environment]::SetEnvironmentVariable('PATH', `
							$env:PATH + ';C:\Program Files (x86)\Microsoft Visual Studio\2017\Professional\MSBuild\15.0\Bin', `
							'Machine');` 
    [Environment]::SetEnvironmentVariable('MSBUILD_DIR', 'C:\Program Files (x86)\Microsoft Visual Studio\2017\Professional\MSBuild\15.0\Bin', 'Machine');
 
CMD ["msbuild.exe"]
