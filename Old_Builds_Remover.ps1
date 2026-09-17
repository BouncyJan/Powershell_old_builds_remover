$dirNamesToDelete = @("node_modules","dist"); # Nombres de subcarpetas para eliminar
$subDirs = Get-ChildItem -Directory # Lista de carpetas dentro del las cuales analizar
$DiasMesesOAnios = @{Meses = 3} # Dias, Meses o Anios

function CalcularMaximaFechaDeUltimaModificacion{
    
    param(
        [parameter(ParameterSetName="Dias")][int]$Dias,
        [parameter(ParameterSetName="Meses")][int]$Meses,
        [parameter(ParameterSetName="Anios")][int]$Anios
    )

    [datetime]$now = Get-Date

    if($Dias){
        return $now.AddDays(-$Dias)
    }

    if($Meses){
        return $now.AddMonths(-$Meses)
    }

    if($Anios){
        return $now.AddYears(-$Anios)
    }

}

$fechaDeGracia = CalcularMaximaFechaDeUltimaModificacion @DiasMesesOAnios
#Write-Output $fechaDeGracia
$ContadorDeEliminaciones = 0

foreach ($subDir in $subDirs)
{
    Write-Output "-----------------------------"
    Write-Output "Procesando ${subDir}:"
    
    if($subDir.LastWriteTime -gt $fechaDeGracia){
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