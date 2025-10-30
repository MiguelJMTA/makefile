# Sobre el makefile
Un Makefile global reutilizable que simplifica los comandos más comunes de Git y Docker en todos tus proyectos. Elimina la necesidad de memorizar comandos complejos y estandariza tu flujo de trabajo de desarrollo.


## Características

- **Comandos Git simplificados**: Push, pull, commit, sync y más con un solo comando
- **Gestión de Docker**: Build, run, stop, clean y push de imágenes
- **Docker Compose integrado**: Levanta y gestiona servicios multi-contenedor
- **Variables de entorno personalizables**: Adapta el Makefile a tus necesidades
- **Ayuda integrada**: `make help` muestra todos los comandos disponibles
- **Comandos combinados**: Workflows complejos en un solo comando (ej: `deploy`, `rebuild`)
- **Output con colores**: Feedback visual para mejor experiencia de usuario
- **Compatible con proyectos locales**: Sobrescribe variables por proyecto

## Instalación

### Opción 1: Makefile Global (Recomendado)

1. Clona el repositorio:

2. Copia el Makefile a tu directorio home:

3. Configura la variable de entorno en tu `~/.bashrc` o `~/.zshrc`:


### Opción 2: Por Proyecto

Simplemente copia el `Makefile` a la raíz de tu proyecto y úsalo directamente.

## Tabla de Abreviaciones

### Comandos Git

| Abreviación | Comando Completo | Descripción |
|-------------|------------------|-------------|
| `gs` | `git-status` | Estado del repositorio |
| `gp` | `git-pull` | Pull desde remote |
| `gP` | `git-push` | Push a remote |
| `gc` | `git-commit` | Commit (requiere msg="...") |
| `gsy` | `git-sync` | Pull + Commit + Push |
| `gl` | `git-log` | Ver últimos commits |
| `gb` | `git-branches` | Listar ramas |
| `gclean` | `git-clean` | Limpiar archivos no trackeados |

### Comandos Docker

| Abreviación | Comando Completo | Descripción |
|-------------|------------------|-------------|
| `db` | `docker-build` | Construir imagen |
| `dbnc` | `docker-build-nc` | Build sin cache |
| `dr` | `docker-run` | Ejecutar contenedor |
| `ds` | `docker-stop` | Detener contenedor |
| `drm` | `docker-rm` | Eliminar contenedor |
| `dl` | `docker-logs` | Ver logs |
| `dsh` | `docker-shell` | Abrir shell |
| `dps` | `docker-ps` | Listar contenedores |
| `di` | `docker-images` | Listar imágenes |
| `dpu` | `docker-push` | Subir imagen |
| `dpl` | `docker-pull` | Descargar imagen |
| `dclean` | `docker-clean` | Limpiar recursos |
| `dcleanall` | `docker-clean-all` | Limpieza total |

### Comandos Docker Compose

| Abreviación | Comando Completo | Descripción |
|-------------|------------------|-------------|
| `cu` | `compose-up` | Levantar servicios |
| `cd` | `compose-down` | Bajar servicios |
| `cl` | `compose-logs` | Ver logs |
| `cps` | `compose-ps` | Listar servicios |
| `cr` | `compose-restart` | Reiniciar servicios |
| `cb` | `compose-build` | Construir servicios |

### Comandos Combinados

| Abreviación | Comando Completo | Descripción |
|-------------|------------------|-------------|
| `rb` | `rebuild` | Stop + Remove + Build + Run |
| `dep` | `deploy` | Pull + Build + Push |
| `v` | `version` | Info de versión |
| `h` | `help` | Ayuda |


## Uso

### Comandos Básicos

Lista todos los comandos disponibles:

`make help`

#### Workflow rápido de desarrollo
`make gs`                   # Ver cambios

`make gc msg="fix: bug"`     # Commit rápido

`make gP`                    # Push


#### Docker rápido
`make db`                    # Build

`make dr`                   # Run

`make dl`                  # Ver logs

#### Docker-Compose rápido
`make cu`                   # Up

`make cl`                    # Logs

`make cd`                    # Down

#### Comandos super rápidos
`make rb`                    # Rebuild todo

`make dep`                  # Deploy completo

`make v`                     # Ver versión

