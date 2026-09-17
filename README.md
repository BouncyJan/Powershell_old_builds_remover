## Powershell Script para eliminar builds, binarios y carpetas en general cuyos proyectos no sufrieron modificaciones en X tiempo.

- Creado originalmente para eliminar las carpetas "node_modules" y "dist" de múltiples projectos NodeJS que no fueron manipulados hace tiempo.

### Uso:

Entrar al código del script y alterar los valores configurables de arriba:

- ` $dirNamesToDelete = @("node_modules","dist");` # Nombres de subcarpetas para eliminar. En este caso "node_modules" y "dist". Acepta nombres con barras diagonales"
- ` $subDirs = Get-ChildItem -Directory` # Lista de carpetas dentro del las cuales buscar los $dirsNamesToDelete (por default analiza las carpetas hermanas al script para buscar dentro de ellas) (Get-ChildItem es alias de "ls")
- ` $DiasMesesOAnios = @{Meses = 3} # Dias, Meses o Anios` # Tiempo sin recibir modificaciones despues del cual el script ingresa al proyecto para eliminar las carpetas, en caso de querer eliminar todo sin tiempo, poner numeros negativos o 0.

Luego, desde Powershell invocar el script con ./ y voilá