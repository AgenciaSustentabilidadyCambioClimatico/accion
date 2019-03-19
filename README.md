# ASCC

### Tabla de contenido
- [Empresa](#empresa)
- [Aplicación web](#alicación-web)
- [Requisitos](#requisitos)
- [Configuración](#configuración)
- [Inicialización](#inicialización)
- [Más información](#más-información)
- [Licencia](#licencia)
- [Créditos](#créditos)

## Empresa

La Agencia de Sustentabilidad y Cambio Climático es un Comité de la Corporación de Fomento de la Producción (CORFO) y tenemos como misión fomentar la producción sustentable en las empresas chilenas, con énfasis en las PYME, en un marco de diálogo y participación público privado, con una perspectiva de desarrollo territorial y regional, para lograr prosperidad, cooperación y confianza. Esto, a través de acuerdos voluntarios, coordinación con otras instituciones públicas, iniciativas de fomento y la ejecución de programas y proyectos que aporten a la construcción de una economía sustentable, resiliente y baja en carbono. Al mismo tiempo apoyar el cumplimiento de los compromisos internacionales de Chile en estas materias.

**[Sitio web](http://www.agenciasustentabilidad.cl/)**

## Aplicación web

Esta plataforma nace para reforzar el compromiso de Chile con la Agenda 2030 para el Desarrollo Sustentable, con la lucha contra el cambio climático mediante el Acuerdo de París, con la alianza del pacífico y con la imagen país y promoción de exportaciones. Además, esta plataforma permite cumplir compromisos de reporte a Convención Marco de Naciones Unidas como resultado del registro de los Acuerdos de Producción Limpia como primera acción de mitigación chilena registrada

**[Sitio web](https://accion.ascc.cl/)**


## Requisitos

```
Ruby 2.5.0
Gema bundle
Postgresql >=10
```

## Configuración

#### Variables de entorno

Su función principal es brindar seguridad a la aplicación. Permite asociar datos sensibles o información comprometedora sin ingresarlo directamente al código. Las variables quedan guardadas en el servidor donde se montará la aplicacón web.

Se definen dentro del archivo ``.profile`` o ``.bash_profile`` o ``.bashrc``

Variable | Descripción
--- | ---
GOOGLE_API_KEY | API de Google para manejo de mapa, [Mas información](https://developers.google.com/maps/documentation/javascript/get-api-key)
SECRET_KEY_BASE | Se utiliza para verificar la integridad de las cookies firmadas.
LOCALHOST_PSQL_SERVER | URL de conexión al servidor de base de datos
LOCALHOST_PSQL_USERNAME | Usuario de conexión al servidor de base de datos
LOCALHOST_PSQL_PASSWORD | Contraseña de conexión al servidor de base de datos
EXTERNAL_PSQL_SERVER | URL de conexión al servidor de base de datos de FPL ASCC
EXTERNAL_PSQL_USERNAME | Usuario de conexión al servidor de base de datos de FPL ASCC
EXTERNAL_PSQL_PASSWORD | Contraseña de conexión al servidor de base de datos de FPL ASCC
MAILER_DEFAULT_URL_OPTIONS_HOST | URL de servidor emisor de correos
MAILER_DEFAULT_URL_OPTIONS_PORT | Puerto de servidor emisor de correos
MAILER_DEFAULT_OPTIONS_FROM | Email de emisor de correos
MAILER_ASSET_HOST | URL de servidor que contiene adjuntos de correos
MAILER_SMTP_SETTINGS_ADDRESS | URL de servicio de correos
MAILER_SMTP_SETTINGS_PORT | Puerto de servicio de correos
MAILER_SMTP_SETTINGS_DOMAIN | Dominio de servicio de correos
MAILER_SMTP_SETTINGS_USER_NAME | Usuario de conexión a servicio de correos
MAILER_SMTP_SETTINGS_PASSWORD | Contraseña de conexión a servicio de correos
MAILER_SMTP_SETTINGS_AUTHENTICATION | Tipo de autenticación al servicio de correos
MAILER_SMTP_SETTINGS_ENABLE_STARTTLS_AUTO | Utilizar certificado SSL
MAILER_DEFAULT_CONTACTO | Email de contacto por defecto en correos

#### Archivo [database.yml](config/database.yml)

Modificar el nombre de base de datos ``database`` según requiera el ambiente.

## Inicialización

El sistema se inicializa como cualquier proyecto rails:

#### 1. Instalar gemas requeridas
```
bundle install
```

#### 2. Cargar base de datos
```
rails db:create
rails db:migrate
```

#### 3. Iniciar servicio
```
rails server
```

Más detalles, [Sitio oficial Ruby on Rails](https://rubyonrails.org/)


## Más información
- [Agencia de sustentabilidad](http://www.agenciasustentabilidad.cl/)
- [Fondo de producción limpia](http://fpl.cpl.cl/)
- [Ruby on Rails](https://rubyonrails.org/)
- [Google Maps API key](https://developers.google.com/maps/documentation/javascript/get-api-key)

## Licencia

ACCION

Copyright © 2019 Agencia de Sustentabilidad y Cambio Climático. 

Este programa es un software libre: puede ser distribuido y/o modificado bajo los términos de la licencia GNU General Public License publicados por la Free Software Foundation en su versión 3 (GNU GPLv3). Mire el archivo [LICENSE](LICENSE) para más detalles. 

## Créditos

BinaryBag es una empresa chilena del tipo “Boutique” formada con el espíritu de resolver problemas difíciles en el ámbito de los productos de software. Somos una empresa de ingeniería de sistemas que desde su creación el año 2007, ha brindado al mercado soluciones de alto nivel, eficientes y que brindan un gran valor a los procesos que nuestros clientes han resuelto con nuestras soluciones.

BinaryBag ha desarrollado una sólida línea de trabajo en proyectos de ingeniería informática, haciendo posible que las nuevas tecnologías sean de uso diario en las organizaciones ampliando las posibilidades de ellas y haciendo más eficientes todos los procesos que ellas desarrollan.

Nuestra empresa se ha especializado en dar servicios de alto valor agregado contando con experiencia en el desarrollo exitoso de diversos proyectos. Poseemos experiencias recientes que nos posicionan de manera importante y diferenciada en el mercado.


