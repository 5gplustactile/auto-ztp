# auto-ztp

Este repositorio es parte del proyecto **5G+TACTILE** y tiene como objetivo principal almacenar, auditar y versionar diversos componentes esenciales para el **Framework Zero-Touch Provisioning (ZTP)**. Su estructura está diseñada para ser una base de datos versionable y centralizada, facilitando la gestión y automatización de configuraciones en múltiples escenarios.

## Propósito

El repositorio contiene:
- **Módulos de Terraform**: Para la creación y configuración de infraestructura en la nube.
- **Recetas de Ansible**: Para la automatización de despliegues y configuraciones.
- **Helm Charts**: Para la gestión y despliegue de aplicaciones en entornos Kubernetes.
- **Scripts de Automatización**: Soluciones personalizadas para la provisión y configuración de recursos.

### Casos de uso
1. **Configuraciones Día 1**: Gestión de configuraciones iniciales del framework para la provisión de infraestructura y aplicaciones.
2. **Gemelos Digitales**: Automatización y soporte para aplicaciones y empresas que forman parte del ecosistema de gemelos digitales del consorcio.
3. **Empresas del Consorcio**: Gestión de configuraciones específicas para participantes del proyecto **5G+TACTILE**.

## Estructura del Repositorio
- **ansible/**: Contiene recetas y configuraciones específicas para la instalación y administración de RKE2.
- **docs/**: Documentación adicional para addons y configuraciones avanzadas.
- **images/**: Archivos de imagen relacionados con el proyecto.
- **sites/**: Configuraciones específicas para diferentes entornos (edge, region, wavelength).
- **templates/**: Plantillas y ejemplos de configuraciones para cluster-addons, monitoring, y otros componentes.
- **tf-modules/**: Módulos de Terraform organizados por funcionalidad (VPC, IAM, subnets, etc.).

---

**Nota**: Este repositorio es mantenido por el equipo **Telefonica** y se actualiza continuamente (hasta finalizar proyecto) para reflejar mejoras en el **Framework ZTP**.
