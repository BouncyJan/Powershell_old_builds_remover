$dirNamesToDelete = @("node_modules","dist"); # Nombres de subcarpetas para eliminar
$dirNamesToEvaluateUsage = @("src") # OPCIONAL, Nombres de subcarpetas a consider para calcular recursivamente la fecha de ultima modificacion, Por default el sistema solo evalua los hijos directos de la carpeta original, aqui podemos elegir uno o varios de esos hijos para evaluar recursivamente la ultima modificación real de todo su arbol de descendencia, pueden ser las mismas que las carpetas a eliminar.
#un valor "*" analiza recursivamente todo el proyecto (+overhead), si la carpeta no existe se desestima. 
$subDirs = Get-ChildItem -Directory # Lista de carpetas dentro del las cuales analizar
$DiasMesesOAnios = @{Meses = 3} # Dias, Meses o Anios

function CalcularMaximaFechaDeUltimaModificacion{
    
    param(
        [parameter(ParameterSetName="Dias")][int]$Dias,
        [parameter(ParameterSetName="Meses")][int]$Meses,
        [parameter(ParameterSetName="Anios")][int]$Anios
    )

    [datetime]$now = Get-Date

    if($PSBoundParameters.ContainsKey('Dias')){
        return $now.AddDays(-$Dias)
    }

    if($PSBoundParameters.ContainsKey('Meses')){
        return $now.AddMonths(-$Meses)
    }

    if($PSBoundParameters.ContainsKey('Anios')){
        return $now.AddYears(-$Anios)
    }

    return $now

}

function ObtenerMayorLastWriteTime {

    param(
        $directorioPadre
    )

    [datetime]$realLastModificationTime = $directorioPadre.LastWriteTime

    foreach ($dirToEvaluate in $dirNamesToEvaluateUsage)
    {
        $dir = "$directorioPadre/$dirToEvaluate"

        if (-not (Test-Path "$dir")){
            continue
        }

        $items = Get-ChildItem $dir -Recurse | Sort-Object LastWriteTime -Descending
  
        $localLastModifiedFile = $items | Select-Object FullName, LastWriteTime -First 1

        if ($localLastModifiedFile.LastWriteTime -gt $realLastModificationTime){
            $realLastModificationTime = $localLastModifiedFile.LastWriteTime
        }  
    }

    return $realLastModificationTime

}

$fechaDeGracia = CalcularMaximaFechaDeUltimaModificacion @DiasMesesOAnios
Write-Output $fechaDeGracia
$ContadorDeEliminaciones = 0

foreach ($subDir in $subDirs)
{
    Write-Output "-----------------------------"
    Write-Output "Procesando ${subDir}:"

    $LastWriteTime = ObtenerMayorLastWriteTime $subdir
    Write-Output $LastWriteTime
    if($LastWriteTime -gt $fechaDeGracia){
        Write-Output $subDir.LastWriteTime
        Write-Output $fechaDeGracia
        Write-Output "`t La ultima modificacion se encuentra dentro del periodo de gracia establecido"
        continue
    }

    $subDirName = $subDir.name

    Write-Output "`tEliminando Carpetas"
    
    foreach ($dirToDelete in $dirNamesToDelete)
    {
        if(-not (Test-Path "$subDirName/$dirToDelete"))
        {
            Write-Output "`t$subDirName/${dirToDelete}: `tNo existente"
            continue
        }
        Write-Host "`t$subDirName/${dirToDelete}: Eliminando..." -NoNewline
        Remove-Item "$subDirName/$dirToDelete" -Recurse -Force
        
        Write-Host "`r`t$subDirName/${dirToDelete}:     Eliminado"
        $ContadorDeEliminaciones++
    }

}
Write-Output "-----------------------------"
Write-Output "Se eliminaron $ContadorDeEliminaciones conjuntos de carpetas"