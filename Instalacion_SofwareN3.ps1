# Instalador de software de x64 Nivel 3
# Incluye Adobe, WinRAR, Chrome y Office

# Ruta del software
# Obtine la ruta de acceso de los archivos
$Pathfiles = Get-Location
Write-Host -ForegroundColor Yellow "Ruta de archivos: $Pathfiles"

# Instaladores
$Adobe = Join-Path -Path $Pathfiles -ChildPath "AcrobatReader.exe"
$WinRAR = Join-Path -Path $Pathfiles -ChildPath "winrar_x64.exe"
$Chrome = Join-Path -Path $Pathfiles -ChildPath "ChromeSetup.exe"

# Imagen disco office
$OfficeDrive = Join-Path -Path $Pathfiles -ChildPath "ProPlus2021Retail.img"

try {    
    # Instala el sofware como Admin
    Write-Host -ForegroundColor Yellow "Iniciando instalación del software..."

    Write-Host -ForegroundColor DarkBlue "Iniciando la instalación de Adobe Reader"
    Start-Process -FilePath $Adobe -ArgumentList "/sAll /msi /norestart /quiet" -Verb RunAs -Wait
    Write-Host -ForegroundColor Green "Adobe Reader instalado con éxito!"

    Write-Host -ForegroundColor DarkBlue "Iniciando la instalación de WinRAR"
    Start-Process -FilePath $WinRAR -ArgumentList "/S" -Verb RunAs -Wait
    Write-Host -ForegroundColor Green "WinRAR instalado con éxito!"

    Write-Host -ForegroundColor DarkBlue "Iniciando la instalación de Google Chrome"
    Start-Process -FilePath $Chrome -ArgumentList "/silent /install" -Verb RunAs -Wait
    Write-Host -ForegroundColor Green "Google Chrome instalado con éxito!"

    # Monta el disco de Office
    Write-Host -ForegroundColor Yellow "Montando la imagen de Office..."
    Mount-DiskImage -ImagePath $OfficeDrive
    # Obtiene la letra asociada al disco montado
    $DriveLetter = (Get-Volume -DiskImagePath $OfficeDrive).DriveLetter
    Write-Host -ForegroundColor Yellow "Disco montado en la unidad: $DriveLetter"

    Write-Host -ForegroundColor Yellow "Ejecutando el instalador de Office..."
    $OfficeSetup = Join-Path -Path "$DriveLetter`:" -ChildPath "Setup.exe"
    Start-Process -FilePath $OfficeSetup -ArgumentList "/configure configuration.xml" -Verb RunAs -Wait

    # Desmonta la unidad
    Write-Host -ForegroundColor Yellow "Desmontando la imagen de disco..."
    Dismount-DiskImage -ImagePath $OfficeDrive

    # Elimina la carpeta de instalación
    Write-Host -ForegroundColor Yellow "Removiendo carpeta de instalación..."
    Remove-Item $Pathfiles -Force -Recurse
    Write-Host -ForegroundColor Green "Proceso completado con éxito!"   
}
catch {
    Write-Host -ForegroundColor Red "Error: $_.Exception.Message"
}
