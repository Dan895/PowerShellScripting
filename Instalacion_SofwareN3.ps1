# Instalador de software de x64 Nivel 3
# Incluye Adobe, WinRAR, Chrome y Office

# Ruta del software
# Obtine la ruta de acceso de los archivos
$Pathfiles = Get-Location
Write-Host -f Yellow "Ruta de archivos"

# Instaladores
$Adobe = Join-Path -Path $Pathfiles -ChildPath "AcrobatReader.exe"
$WinRAR = Join-Path -Path $Pathfiles -ChildPath "winrar_x64.exe"
$Chrome = Join-Path -Path $Pathfiles -ChildPath "ChromeSetup.exe"

# Imagen disco office
$OfficeDrive = Join-Path -Path $Pathfiles -ChildPath "ProPlus2021Retail.img"

try {    
    # Instala el sofware como Admin
    Write-Host -f Yellow "Iniciando instalación del software..."

    Write-Host -f DarkBlue "Iniciando la instalación de Adobe Reader"
    Start-Process -FilePath $Adobe -ArgumentList "/S" -Verb RunAs -Wait
    Write-Host -f Green "Sofware instalado con éxito!"

    Write-Host -f DarkBlue "Iniciando la instalación de Win$WinRAR"
    Start-Process -FilePath $WinRAR -ArgumentList "/S" -Verb RunAs -Wait
    Write-Host -f Green "Sofware instalado con éxito!"

    Write-Host -f DarkBlue "Iniciando la instalación de Google Chrome"
    Start-Process -FilePath $Chrome -ArgumentList "/S" -Verb RunAs -Wait
    Write-Host -f Green "Sofware instalado con éxito!"

    # Monta el disco de office
    Mount-DiskImage -ImagePath $OfficeDrive
    # Obtiene la letra asociada al disco montado
    Write-Host -f Yellow "Drive mounted in..."
    $DriveLetter = (Mount-DiskImage "$OfficeDrive" -PassThru | Get-Volume).DriveLetter
    $DriveLetter

    Write-Host -f Yellow "Executing installer..."
    $OfficeSetup = $DriveLetter + ":\Setup.exe"
    $SetupPath
    Start-Process -FilePath $OfficeSetup -ArgumentList "\S" -Verb -RunAs -Wait

    # Desmonta la unidad
    Write-Host -f Yellow "Dismounting disk..."
    Dismount-DiskImage -ImagePath $Office

    # Elimina la carpeta de instalación
    Write-Host -f Yellow "Removiendo carpeta de instalación..."
    Remove-Item $Pathfiles -Force -Recurse
    Write-Host -f Green "Hecho!"   
}
catch {
    Write-Host -f Red "Error: " $_.Exception.Message
}