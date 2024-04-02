#Eset script by Mikel Alegría Soleto
$actualdate = Get-Date
# Buscar los 2 últimos registros con ID 15 donde aparezca "ESET Security" o "ESET Cortafuegos"
$outputt = Get-WinEvent -LogName "Application" -FilterXPath "*[System[EventID=15]]" | Where-Object { $_.Message -match "ESET Security|ESET Cortafuegos" } | Select-Object TimeCreated, Message -First 2
Write-Host "La fecha actual es = $actualdate"

    # Comprobar si las dos líneas contienen "SECURITY_PRODUCT_STATE_ON"
    if ($outputt.Count -eq 2 -and ($outputt | Where-Object { $_.Message -match "SECURITY_PRODUCT_STATE_ON" }).Count -eq 2) {
	Write-Output "Se han encontrado 2 id 15 con la siguiente descripcion y en las siguientes fechas: "
    

	$mensajes = $outputt.Message
    
	# Imprimir la descripción de los eventos
	$descripcion = "Las descripciones de los últimos eventos con ID 15 son: "
	for ($i = 0; $i -lt $fechas.Count; $i++) {
    	$descripcion += "`n" + $mensajes[$i]
	}
	Write-Host $descripcion



	# Almacenar las fechas en una variable
	$fechas = $outputt.TimeCreated
	foreach ($fecha in $fechas) {
    	Write-Host "ultimo id 15 encontrado en la fecha = $fecha"
	}
    
	# Comprobar si alguna de las fechas supera los 7 días de diferencia con la fecha actual
	$superado7dias = $false
	foreach ($fecha in $fechas) {
    	if (($actualdate - $fecha).TotalDays -gt 7) {
        	$superado7dias = $true
        	break
    	}
	}
    
	# Imprimir el mensaje correspondiente según la condición
	if ($superado7dias) {
    	#Write-Host "EL ANTIVIRUS ESET NO HA SIDO ACTUALIZADO DESDE HACE MAS DE 7 DIAS" -ForegroundColor yellow
    	$mensaje = "NEXUM INFORMÁTICA INFORMA DE QUE EL ANTIVIRUS ESET NO HA SIDO ACTUALIZADO DESDE HACE MAS DE 7 DIAS, PORFAVOR ACTUALÍCELO LO ANTES POSIBLE"
    	$IPAddress = (Test-Connection -ComputerName $env:COMPUTERNAME -Count 1).IPV4Address.IPAddressToString
    	$null = Invoke-WmiMethod -Class Win32_Process -Name Create -ArgumentList "powershell.exe -Command [System.Reflection.Assembly]::LoadWithPartialName('System.Windows.Forms'); [System.Windows.Forms.MessageBox]::Show('$mensaje', 'Alerta', 'OK', 'Warning') " -ComputerName $IPAddress


	} else {
    	Write-Host "EL ANTIVIRUS ESET ESTA ACTUALIZADO" -ForegroundColor Green
	}
} else {
	Write-Host "Hay algo mal"
}
