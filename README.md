## Powershell Script para eliminar builds, binarios y carpetas en general cuyos proyectos no sufrieron modificaciones en X tiempo.

- Creado originalmente para eliminar las carpetas "node_modules" y "dist" de múltiples projectos NodeJS que no fueron manipulados hace tiempo porque pesan mucho :/.
- Fue un desarrollo de un par de horitas
- Ninguna LLM AI fue utilizada en el desarrollo o troubleshooting de este proyectito

### Uso:

Entrar al código del script y alterar los valores configurables de arriba:

- ` $dirNamesToDelete = @("node_modules","dist");` # Nombres de subcarpetas para eliminar. En este caso "node_modules" y "dist". Acepta nombres con barras diagonales"
- ` $subDirs = Get-ChildItem -Directory` # Lista de carpetas dentro del las cuales buscar los $dirsNamesToDelete (por default analiza las carpetas hermanas al script para buscar dentro de ellas) (Get-ChildItem es alias de "ls")
- `$dirNamesToEvaluateUsage = @("src")` # OPCIONAL, Nombres de subcarpetas a consider para calcular recursivamente la fecha de ultima modificacion, Por default el sistema solo evalua cambios en los hijos directos de la carpeta original para determinar su LastWriteTime, aqui podemos elegir uno o varios de esos hijos para evaluar recursivamente la ultima modificación real de todo su arbol de descendencia, pueden ser las mismas que las carpetas a eliminar. Un valor "*" analiza recursivamente todo el proyecto (+overhead). Si la carpeta ingresada no existe se desestima. 
- ` $DiasMesesOAnios = @{Meses = 3} # Dias, Meses o Anios` # Tiempo sin recibir modificaciones despues del cual el script ingresa al proyecto para eliminar las carpetas, en caso de querer eliminar todo sin tiempo, poner numeros negativos o 0.

Luego, desde Powershell invocar el script con ./ y voilá