
#  **SISTEMA DE GESTIÓN DE PROCESOS DE NEGOCIO DE LA ASCC**

##### **Sitio web**
[Página de ascc](http://www.agenciasustentabilidad.cl/)

### **Tabla de contenido**
- [Quiénes somos](#quiénes-somos)
- [Descripción de la Aplicación](#descripción-de-la-aplicación)
- [Tecnologías Utilizadas](#tecnologías-utilizadas)
- [Prerrequisitos de Instalación](#prerrequisitos-de-instalación)
- [Configuración e Instalación](#configuración-e-instalación)
- [Inicialización](#inicialización)
- [Más información](#más-información)
- [Licencia](#licencia)
- [Créditos](#créditos)

## **Quiénes Somos**

La ***Agencia de Sustentabilidad*** y ***Cambio Climático*** es un comité de la ***Corporación de Fomento de la Producción (CORFO)*** cuya misión institucional es Fomentar la producción sustentable y la mitigación y adaptación al cambio climático en las empresas, con énfasis en las PYME y en los territorios, a través del diálogo y la colaboración público privada.

Aspiramos a ser referente en materia de cooperación público privada en el desarrollo de una economía sustentable, resiliente y baja en carbono, y en el cumplimiento de los compromisos internacionales asumidos por Chile en estas materias.

## **Descripción de la Aplicación**

Esta plataforma de código libre tiene como fin último permtir el reporte de las contribuciones realizadas por las empresas en conjunto con la agencia y otras organizaciones a la Agenda 2030 para el Desarrollo Sustentable y a la lucha contra el cambio climático.

Si bien esa es la visión última de su desarrollo, en su estado actual tiene como productos operables el sistema de postulación de ideas de acuerdo, la generación, auditoría y certificación de cumplimiento de las metas y acciones comprometidas por organizaciones, incluyendo funcionalidades de notificacion, recordatorios, encuestas, consultas públicas, inventarios de datos productivo-ambientales, generación dinámica de documentos, un sistema de gestión de permisos bastante configurable, un sistema de reporte y seguimiento de sugerencias y errores, así como otras funcionalidades que otorgan bastante libertad para adaptar su uso.

Existen aún varias funcionalidades en curso, por desarrollar, por pulir y por profundizar. Nuestra intención al disponer esta plataforma de manera libre, es permitir que usuarios institucionales la puedan modificar y adaptar a sus propios fines, fortaleciendo al mismo tiempo las funcionalidades base de la misma. Lo único importante es que esas versiones sigan siendo libres,  decir, se distribuyan y/o modifiquen bajo los términos de la licencia GNU General Public License publicados por la Free Software Foundation en su versión 3 (GNU GPLv3).

## **Tecnologías Utilizadas**

A continuación se detallan las diferentes tecnologías utilizadas para el desarrollo de esta aplicación web.

#### **1. Sistema Operativo:**
- **Distribución LINUX derivada de Debian GNU/Linux versión 9 (‘stretch’)**  ![enter image description here](https://lh3.googleusercontent.com/JeTKWT50GN6RVZM9BaaROtkVa65bRUTMYMwZ1gdo5TJhasN6xb-wkVPgUzwi4o6UgmA3jAgUCQ0=s70 "debian_logo")  
Se sugiere utilizar esta la versión mas reciente del **Sistema Operativo Debian GNU/Linux versión 9 (‘stretch’)**, debido a que esta soporta las versiones utilizadas de ***"Ruby", "Rails", "PostgreSQL",*** entre otros, ademas de poseer las ultimas actualizaciones de seguridad. Para mas información sobre esta versión, visitar la [Página oficial del SIstema Operativo Debian](https://www.debian.org/releases/stretch/). También se puede utilizar Ubuntu versión 18.04 o superior. 

#### **2. Lenguajes de Programación:**
- **Ruby versión 2.5.0** ![enter image description here](https://lh3.googleusercontent.com/A1ibQrtMd_JtiEOu5af1u5PIGyZE6UwJ6z-mbL7O89PEEDTcksT6sOgOSzgFykx7dI1SKK0r_PQ=s40 "ruby_logo")  
  El proyecto fue desarrollado utilizando el lenguaje de programación orientado a objetos ***Ruby*** sobre el framework RAILS , pues es versátil, dinámico y ***puede ser instalado en cualquier Sistema Operativo***. Además, tiene ***soporte de multihilos (multithreading)*** en todas las plataformas en las que corra ***Ruby***, sin importar si el sistema operativo lo soporta o no, ¡incluso en ***MS-DOS***!. Además permite el control centralizado de sus  librerías extendidas de código abierto, llamadas '***gemas***', en un sistema de repositorios similar a ***apt*** de ***Debian*** o ***apt-get*** de ***Ubuntu***.   Para mas información sobre esta versión, visitar la [Página oficial de Ruby](https://www.ruby-lang.org/es/).
- **JavaScript**  ![enter image description here](https://lh3.googleusercontent.com/uW8SZLwuZMLMDmPG1Rs7hXROS5qkq0lfaHgxX3qRlclgN33Lp8UYlYFHS_NNFjCeODKZ8Zacmto=s50 "java_logo")  
  **JavaScript** (**JS**) es un lenguaje ligero e interpretado, orientado a objetos con funciones de primera clase, más conocido como el ***lenguaje de script*** para ***páginas web***, pero también usado, a nivel de servidor como por ejemplo ***[node.js***,  ***Apache*** ***CouchDB*** y ***Adobe Acrobat*** Es un ***lenguaje script multi-paradigma***, basado en prototipos, dinámico, soporta los estilos de programación funcional, orientada a objetos e imperativa. [Leer más sobre JavaScript](https://developer.mozilla.org/es/docs/JavaScript/Acerca_de_JavaScript).
  - **jQuery**![enter image description here](https://lh3.googleusercontent.com/5HVXQCPf1ytvK4SqTtiCjru_LUlNspBfg8Dqf8-aXwgdHxGHzOfBSK77Xlqa2JWZ_jTdIZfMnD4=s50 "jquery_logo")  
  ***jQuery*** es una biblioteca de ***JavaScript*** rápida, pequeña y con muchas funciones. Permite que la realización de actividades complejas -como la manipulación de documentos ***HTML***, el manejo de eventos, la animación y ***Ajax***- sea mucho más simple con una API fácil de utilizar que funciona en una gran cantidad de navegadores. Con una combinación de versatilidad y extensibilidad, ***jQuery*** ha cambiado la forma en que millones de personas escriben ***JavaScript***. Para mas información ir a [Pàgina Oficial de jQuery](https://jquery.com/).

- **Shell de Linux o Bash** ![enter image description here](https://lh3.googleusercontent.com/Udn0O9Cg6pJp9JovvJe5iuGMWSvdfFEYAH9pfq6voAZoJ0vDgc0-VLUTgx29-8JSJ8jciVMH_k4=s35 "bash_logo")  
Es un intérprete de comandos, que consiste en la interfaz de usuario tradicional de los sistemas operativos basados en ***Unix*** y similares, como ***GNU/Linux***. El proyecto requiere la programación en 'shell' de acciones recurrentes a nivel de sistema operativo, independizadas del servidor 'rails', como por ejemplo el envío de correos electrónicos cada cierto tiempo y a ciertos actores,  Para más información hacer click [aquí](https://es.wikipedia.org/wiki/Shell_de_Unix).

#### **3. Framework**
- **Rails versión 5.1.6** ![enter image description here](https://lh3.googleusercontent.com/p9e_9HjDwdFRG8QMjcsuaYkOYPJnGsMKHo0GwSm6tT5Q1gAa7hM0wT-2BcHstipY5s2nXpC6qyE=s50 "rails_logo")  
Como se mencionó mas arriba, se utiliza el lenguaje Ruby sobre el framework **Rails**, lo que se denomina como **Ruby on Rails**, **RoR** (o solo ' **Rails**') . Es un ***Framework*** de ***aplicaciones web*** de ***código abierto*** escrito en el lenguaje de programación ***Ruby***, siguiendo el patrón de programación [***Modelo Vista Controlador (MVC)***](https://es.wikipedia.org/wiki/Modelo_Vista_Controlador). Combina exitosamente la simplicidad con la posibilidad de desarrollar aplicaciones del mundo real escribiendo menos código que con otros frameworks y con un mínimo de configuración. El lenguaje de programación ***Ruby*** permite la ***metaprogramación***, de la cual ***Rails*** hace uso, lo que resulta en una sintaxis simple, casi en lenguaje natural, y que muchos de sus usuarios encuentran mas legible. Rails se distribuye a través de ***RubyGems***, que es el formato oficial de paquete y canal de distribución de bibliotecas y aplicaciones ***Ruby***. [Ver más acerca de Ruby on Rails](https://rubyonrails.org/).

- **Bootstrap 4**![enter image description here](https://lh3.googleusercontent.com/k4BMWTIMACs3LrmJjaAcMC2EclVi6xJODXoALrVPTbr_e4kG_yxjvLDsCfM9RtfqjG6FONdprLI=s70 "bootstrap_logo")  
**Bootstrap** es una biblioteca multilenguaje de código abierto para diseño de sitios y aplicaciones web. Contiene plantillas con tipografía, formularios, botones, cuadros, menús de navegación y otros elementos de diseño basado en ***HTML*** y ***CSS***, así como extensiones de ***JavaScript*** adicionales. Para más información ir a [la página oficial de Bootstrap](https://getbootstrap.com/docs/4.3/getting-started/introduction/).

#### **4. Base de Datos**
- **PostgreSQL versión 9.6** ![enter image description here](https://lh3.googleusercontent.com/wmFGtHlFHfOa6ik3_3X4tUgU0xDTPwoR1DDND9hsGBJzifFl-BJnG4hWW_QYj8WthpLS89nilds=s90 "pg_logo")  
***PostgreSQL*** es un potente sistema de base de datos relacional de código abierto con más de 30 años de desarrollo activo que le ha ganado una sólida reputación de confiabilidad, solidez de características y rendimiento. Para más información acerca de ***PostgreSQL*** ver [acá](https://www.postgresql.org/docs/9.6/index.html).

#### **5. Herramientas adicionales**
- **Ruby Version Manager (RVM) versión 1.2.9.3** ![enter image description here](https://lh3.googleusercontent.com/UvdZ5h6i7sbCWAJVZc4_XjWHKPHDJWg1GmErrdrJX3qj1MxzPlTbEXx8hs-avdiokpehUXK0lP0=s40 "rvm_logo")  
***RVM*** es una herramienta que se ejecuta en nivel de consola (línea de comando), que  permite instalar, administrar y trabajar fácilmente con múltiples versiones de ***ruby*** en la misma máquina, y distintos conjuntos de ***gemas*** asociadas a cada versión. Más acerca de ***RVM*** [acá](https://rvm.io/).

- **API de Google Maps** ![enter image description here](https://lh3.googleusercontent.com/4zVML0kmwXTcAtjmGPUjgsQIPVIxlsBkczDjzQFUfVa8ivg9R-BWyjOJV8AtOxWyVr9OoDLrd3g=s30 "gogle-maps_logo")  
Las ***API*** son un conjunto de comandos, funciones y protocolos informáticos que permiten a los desarrolladores utilizar funcionalidades previamente disponibilizadas desde otros sistemas. En el proyecto, se utiliza la ***API de Google Maps*** para mostrar los **mapas** de **Google** para las direcciones e indicaciones georeferenciadas (latitud y longitud) utilizadas. Para más información, vistar [la página web de Google Maps Plataform](https://cloud.google.com/maps-platform/?hl=es). 
**NOTA**: *El uso de esta API condiciona el despliegue de los mapas a que el servicio de Google Maps se encuentre funcionando, de forma tal que si Google cambia la API o las condiciones de uso del servicio, es posible que los mapas no se desplieguen adecuadamente.*

- **Capistrano** ![enter image description here](https://lh3.googleusercontent.com/tKEw84s8aR8zOJ2ujCZIZF2V1bymuwnD-z-ZRs2chwrC8S_-JO7bbF0yL_xeGgLrBLAyn6FskcA=s70 "capistrano_logo")  
***Capistrano*** es un sistema para la automatización y control remoto de servidores, y herramienta para realizar el despliegue de proyectos en dichos servidores, mediante el uso de ***scripts*** de implementación automatizada. Aunque ***Capistrano*** está escrito en ***Ruby***, se puede usar fácilmente para implementar proyectos de cualquier lenguaje o ***framework***, ya sea ***Rails***, ***Java*** o ***PHP***. Para saber acerca de ***Capistrano*** ir a la siguiente [Página Web]. (https://capistranorb.com/documentation/overview/what-is-capistrano/).

- **NGINX versión 1.10.3** ![enter image description here](https://lh3.googleusercontent.com/Sbt5CLZmdGQ6m7-Q1w-khiHETp92mPi4H3g0UQKpCau7B6qOBHsVe7u0GhmbHGFThXcr0QyWQUU=s50 "nginx_logo")  
***NGINX*** es un ***servidor web*** ligero de alto rendimiento y un ***proxy/proxy inverso*** para protocolos de ***correo electrónico: MAP y POP3,*** además es ***Multiplataforma***, pues permite ser ejecutado en cualquier ***Sistema Operativo*** en base a ***Unix*** (***GNU/Linux***, ***BSD***, ***Solaris***, ***Mac OS X***, etc.) o  ***Windows***, y permite mantener separados los ambientes de desarrollo, pruebas y producción, pero desplegados en la misma maquina. Más información en [la página oficial de NGINX](https://docs.nginx.com/).

- **Servidor Web Puma** ![enter image description here](https://lh3.googleusercontent.com/ypDkg911fEOb3NlceC3Cp4E9Qbpgfe_R4DYslwkGGRupcvYpyC6otoC7L-_Mz_9XqEeIhbA-SDY=s60 "puma_logo")  
***Puma*** es una pequeña biblioteca que proporciona un ***servidor HTTP 1.1*** muy rápido y concurrente para las ***aplicaciones web de Ruby***. Está diseñado para ejecutar solamente aplicaciones ***Rack***, y permite independizar el proyecto la prexistencia de otro servidor web en el servidor. Para más información, visitar [la página web oficial de Puma](http://puma.io/)

- **Haml** ![enter image description here](https://lh3.googleusercontent.com/Qg0oMN01M4TTmACHozE0HSu_oqEeuIevMHugrEjIHCmdV4mjTPZ8Qk7o2FsRIKxVRwEowf5n9bo=s50 "haml_logo")  
***Haml*** es un ***lenguaje de framework ligero*** que se usa para describir el ***XHTML*** de un ***documento web*** sin emplear el código embebido tradicional. Está diseñado para solucionar varios problemas de los motores de plantillas tradicionales y también para ser un ***lenguaje de framework*** tan elegante como sea posible. ***Haml*** funciona como reemplazo de sistemas de plantillas de páginas embebidas como ***PHP***, ***RHTML*** y ***ASP***. Sin embargo, ***Haml*** elimina la necesidad de escribir ***XHTML*** explícito dentro de la plantilla, por ser en sí una descripción de ***XHTML***, más algo de código para generar contenido dinámico. Acerca de ***Haml*** ir a [la página web oficial de Haml](http://haml.info/docs.html)

- **Sass** ![enter image description here](https://lh3.googleusercontent.com/FBf876snVKK6KHFSbGlL3io6Yga0giz1bWdUkDT5Ig1m1qERc5PjPTTZSCDOW8Rw3r_zlYCc_1I=s35 "sass_logo")  
***Sass (Syntactically Awesome Stylesheets)*** es un ***metalenguaje de Hojas de Estilo en Cascada*** (***CSS***). Es un lenguaje de ***script*** que es traducido a ***CSS***, y que permite el uso de ***indented syntax («sintaxis con sangrado»)*** -similar a ***Haml***-  para separar bloques de código, y el carácter nueva línea para separar reglas. 
La sintaxis más reciente, ***SCSS***, permite también el uso del formato de bloques como ***CSS***. Para más información, visitar [la página oficial de SaaS](https://sass-lang.com/)

#### **6. Otros**
- **Gemas (librerías) de Ruby usadas en el proyecto**
A continuación se listaran todas las gemas utilizadas en el ambiente de producción de este proyecto, sin incluir las gemas de desarrollo, como ***Capistrano***, contenidas en el archivo Gemfile, y que se instalarán automáticamente al ejecutar  `bundle install` desde la consola de comando, con una breve descripción de las mas importantes:

```ruby
  gem "animate-rails"
  gem "hashid-rails", "~> 1.0"
  gem 'activerecord-session_store'
  gem 'autonumeric-rails'
  gem 'axlsx' #para crear y manejar el contenido de archivos 'xls' y 'xlsx'
  gem 'axlsx_rails' #para agrega la funcionalidad de la gema 'axlsx' a rails
  gem 'bootstrap', '~> 4.0.0'
  gem 'carrierwave', '~> 1.0' #para el manejo y almacenamiento de archivos 'subidos' al sistema
  gem 'chartkick'#para la contrucción de gráficos en las vistas 
  gem 'ckeditor', github: 'galetahub/ckeditor'
  gem 'crontab_syntax_checker' #para manejar el uso del daemon 'cron' a nivel del sistema operativo
  gem 'daemons' #para controlar acceder y controlar otros daemons del sistema operativo
  gem 'data-confirm-modal'
  gem 'datejs-rails' 
  gem 'delayed_job' #para agendar la ejecución de tareas en el futuro
  gem 'delayed_job_active_record' #complementa la gema 'delayed_job'
  gem 'devise' #para control de usuarios y credenciales de acceso
  gem 'devise_invitable' #complementa la gema 'devise'
  gem 'font-awesome-rails' #para el uso de la librería de íconos 'font-awesome'
  gem 'geocoder' 
  gem 'geoxml-rails' 
  gem 'haml' #para uso de haml
  gem 'haml-rails', '~> 1.0' #complementa la gema 'haml'
  gem 'htmltoword'
  gem 'httparty'
  gem 'jquery-datatables' #para mayor control en ruby de la librería 'datatable' de JQuery 
  gem 'jquery-rails' #para el uso de la librería JQuery
  gem 'nested_form' #para el uso adecuado de formularios anidados
  gem 'pg' #para manejar el acceso a PostgreSQL
  gem 'prawn', '~>2.2.2'
  gem 'puma', '~> 3.7' #para el uso puma
  gem 'pundit'
  gem 'puredocx', '~> 0.0.2' #para crear y manejar el contenido de archivos 'doc' y 'docx'
  gem 'quilljs-rails'
  gem 'rails', '~> 5.1.6' #implementa el framework RAILS
  gem 'roo' #extiene del uso de archivos 'xls'
  gem 'roo-xls'
  gem 'ruby-units', '~> 2.3'
  gem 'rubyzip', '~> 1.2.0' #para manejar la compresión 'zip' de archivos
  gem 'rut_validation' 
  gem 'sass-rails', '~> 5.0' #para el uso de sass
  gem 'simple_form' #para el uso de formularios simplificados
  gem 'uglifier', '>= 1.3.0'
  gem 'zip-zip' #complementa el manejo de archivos 'zip'
```

## **Prerrequisitos de Instalación**

#### **1. Sistema Operativo Debian GNU/Linux versión 9 (‘stretch’)**
 Para instalar este ***Sistema Operativo***, se deben seguir las instrucción de [la página oficial de Debian](https://www.debian.org/distrib/). Si se desea instalar Ubuntu, puede visitar [la página web de Ubuntu](https://www.ubuntu.com)
 
#### **2. Conexión a Internet en el servidor**


## **Configuración e Instalación**

Para configurar e instalar el sistema es necesario utilizar un usuario con privilegios de administrador. Se recomienda crear un usuario distinto de root, y a continuación se indicará como obtener y utilizar dicho usuario:

#### **Creación y configuración del usuario**

* Para crear el usuario, ingresar a la consola la siguiente línea de comando, reemplazando ***"nombreusuario"*** por el nombre que desee. Este comando se utiliza para crear los usuarios o cuentas del sistema operativo.

  ```
  sudo adduser nombreusuario
  ```
  
* **Asignar privilegios *SUDO* al usuario creado**:
Para añadir permisos y privilegios al usuario creado, ingrese la siguiente linea de comando en la consola, reemplazando ***"nombreusuario"*** por el nombre de usuario creado con anterioridad.

  ```
  sudo usermod -aG sudo nombreusuario
  ```
  
* **Asignar contraseña o password al usuario creado**:
Una vez asignado los permisos y privilegios al usuario creado, se puede asignar una contraseña o password al usuario, solo debe ingresar en consola, la siguiente linea de comando en la consola, 
 reemplazando ***"nombreusuario"*** por el nombre de usuario creado con anterioridad.
 
  ```
  sudo passwd nombreusuario
  ```
  
#### **Instalación de Ruby**

Se debe utilizar el usuario creado previamente para la realización de los siguientes pasos:
* **Dependencias de Ruby**:  
El primer paso es instalar algunas dependencias para **Ruby y Rails**.
Para asegurarnos de que tenemos todo lo necesario para el soporte de **Webpacker en Rails**, primero comenzaremos agregando los repositorios **Node.js** y **Yarn** a nuestro sistema LINUX antes de instalarlos.

Para ello ingresar en la consola de comando lo siguiente:
En Ubuntu para instalar los paquetes del sistema operativo se debe usar el comando 'apt-get', En Debian, se usa el comando 'apt' :
  ```bash
  sudo apt-get install curl
  
  curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash -
  curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
  echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list

  sudo apt-get update
  sudo apt-get install git-core curl zlib1g-dev build-essential libssl-dev libreadline-dev libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt1-dev libcurl4-openssl-dev software-properties-common libffi-dev nodejs yarn
  ```
  Una vez concluida la instalación, favor continuar con el siguiente paso.

* **Instalar Ruby versión 2.5.0 con rvm**:  
En el desarrollo del proyecto se utilizó la versión 2.5.0 de ***Ruby***, que es la que debe instalarse  utilizando **rvm**,  ejecutando en consola de comando lo siguiente:
  ```bash
  sudo apt-get install libgdbm-dev libncurses5-dev automake libtool bison libffi-dev
  gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3   7D2BAF1CF37B13E2069D6956105BD0E739499BDB
  curl -sSL https://get.rvm.io | bash -s stable
  source ~/.rvm/scripts/rvm
  rvm install 2.5.0
  rvm use 2.5.0 --default
  ruby -v
  ```

* **Instalar la gema Bundler**:  
Después de  finalizar la instalación de ***ruby***, se debe instalar la ***gema bundler***, que permite instalar las demás gemas del proyecto enunciadas en el archivo Gemfile (y listadas mas arriba), manteniendo un correcto control de compatibilidad entre ellas. Se debe ejecutar en consola de comando, lo siguiente:
  ```bash
  gem install bundler
  ```

#### **3. Configurar Git**

El proyecto fue desarrollado utilizando el sistema de control de configuración y versionamiento   ***Git***, que permite el uso de ***Github***. Si aún no tiene una cuenta ***Github***, asegúrese de [registrarse](https://github.com/) .

Se debe reemplazar el ***nombre y dirección de correo electrónico*** en los siguientes pasos con su cuenta de ***Github***:

```bash
git config --global color.ui true
git config --global user.name "YOUR NAME"
git config --global user.email "YOUR@EMAIL.com"
ssh-keygen -t rsa -b 4096 -C "YOUR@EMAIL.com"
```
El siguiente paso es tomar la clave SSH recién generada y agregarla a la cuenta de Github, ejecutando el siguiente comando en consola:

```bash
cat ~/.ssh/id_rsa.pub
```

```bash
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDPgbgJq4oZJwtdCtWHXITAefS9tb9HfuKlLL/PWrL/F+NoZuvHER/40rDwe2uKEkMT56jL2nJzi011PxKutVevuKy03casnVFLsAZXKch/gcXOz8V7jstUk7TLQAwEsLkAXfhswJNCQXThBz5ZrK14hhokVwViGM9nWEUz5EBUx4+LaL9jHJ1/XhJZ1QM4jTXJ4NhA50yG3mbhja+J1rYYgg3PREqdfF+n6ih+Fx0lfuXnFDpFfulGM7c6G5G7u7nAr8Vk0u9VVZT9Xbz8SjttronwagIwBb/7qUfvOXuF xxxxxxx@xxxxxxxx.com
```

Se debe copiar la salida del comando anteriormente ingresado y [pegarlo aquí](https://github.com/settings/ssh) .

Una vez hecho esto, se puede verificar su correcto funcionamiento con el comando:

```bash
ssh -T git@github.com
```

Que debe entregar un mensaje como este:

```bash
Hi user! You've successfully authenticated, but GitHub does not provide shell access.
```

#### **4. Instalar Rails**

Previo a la instalación de ***Rails***, se debe contar con un motor  de ejecución de ***Javascript*** como ***NodeJS***, que ya fue instalado como dependencia de ***Ruby*** en los pasos anteriores. Esto le permite usar ***Coffeescript*** y ***[Asset Pipeline](http://guides.rubyonrails.org/asset_pipeline.html)*** en ***Rails***, que combina y comprime las librerías de ***Javascript*** utilizadas,  para proporcionar un entorno de producción más rápido.

En caso de que haya habido algún problema en la instalación de nodejs, se puede instalar desde su repositorio oficial:
```bash
curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash -
sudo apt-get install -y nodejs
```

Luego , se debe instalar ***Rails***, ejecutando el siguiente comando en consola

```bash
gem install rails -v 5.1.6.1
```
Para verificar su correcta instalación, se debe ejecutar `rails -v`en consola:

```bash
rails -v
# Rails 5.1.6.1
```

#### **5. Configurando PostgreSQL**

***PostgreSQL*** se instala desde su repositorio oficial, con los siguientes pasos:

```bash
sudo sh -c "echo 'deb http://apt.postgresql.org/pub/repos/apt/ xenial-pgdg main' > /etc/apt/sources.list.d/pgdg.list"
wget --quiet -O - http://apt.postgresql.org/pub/repos/apt/ACCC4CF8.asc | sudo apt-key add -
sudo apt-get update
sudo apt-get install postgresql-common
sudo apt-get install postgresql-9.5 libpq-dev
```

Se debe crear la base de datos que usará el proyecto, para lo cual debe ejecutar:
```bash
sudo -u postgres createdb nombre_de_la_base_de_datos
```

Luego es necesario configurar un ***usuario***  con permisos para acceder a dicha base de datos:

```bash
#creación del usuario (reemplazar nombre_del_usuario por el nombre que usted desee)
sudo -u postgres createuser nombre_del_usuario -s

# agregar la contraseña del usuario
sudo -u postgres psql 
alter user nombre_del_usuario with password 'nueva_contraseña_del_usuario';

# agregar los permisos de acceso a la base de datos, para el usuario creado
sudo -u postgres psql
grant all privileges on database nombre_de_la_base_de_datos to nombre_de_usuario;
```

#### **Configuración de Variables de entorno**

Las ***variables de entorno*** corresponden a variables asociadas a los usuarios del sistema, en forma general (variables para todos los usuarios) o específica (variables para un solo usuario). Se recomienda configurar variables específicas para el usuario que instalará la aplicación. Estas variables permiten modificar ciertas configuraciones (como por ejemplo la IP y credenciales de acceso a la base de datos) sin alterar el código de la aplicación.

#### **Variables de entorno**

Pueden configurarse dentro de los archivos ``.profile`` o ``.bash_profile`` o ``.bashrc``, pero como el proyecto usa la gema ***Capistrano*** para realizar el despliegue, y ello se realiza mediante un shell no interactivo, es necesario que dichas variables sean configuradas en el encabezado del archivo ``.bashrc``, antes de la ejecución de las siguientes líneas de código contenidas en dicho archivo:
``
executed by bash(1) for non-login shells.
``

***Las variables de entorno utilizadas son:***

 **Variables de entorno para ambiente de producción/pruebas:**
  
 Variable | Descripción
--- | ---
PGPASSWORD|Contraseña de PGP
GOOGLE_API_KEY | LLave para uso de la API de Google para manejo de mapa, [Mas información](https://developers.google.com/maps/documentation/javascript/get-api-key)
SECRET_KEY_BASE | Se utiliza para verificar la integridad de las cookies firmadas.
LOCALHOST_PSQL_SERVER | URL/IP de conexión al servidor de base de datos
LOCALHOST_PSQL_USERNAME | Nombre del usuario que accede a la base de datos
LOCALHOST_PSQL_PASSWORD | Contraseña del usuario que accede a la base de datos
MAILER_ASSET_HOST| URL del ambiente de producción
MAILER_ASSET_HOST_STAGING| URL del ambiente de pruebas
MAILER_DEFAULT_URL_OPTIONS_HOST | URL del ambiente de desarrollo de la aplicación
MAILER_DEFAULT_URL_OPTIONS_HOST_STAGING | URL del ambiente de pruebas de la aplicación
MAILER_DEFAULT_URL_OPTIONS_PORT | Puerto por defecto del servidor de envío de correos
MAILER_DEFAULT_CONTACTO | Email de contacto para los correos enviados
MAILER_SMTP_SETTINGS_ADDRESS | URL/IP de servidor de envío de correos
MAILER_SMTP_SETTINGS_PORT | Puerto que utiliza el servidor de envío de correos
MAILER_SMTP_SETTINGS_DOMAIN | Dominio del servidor de envío de correos
MAILER_SMTP_SETTINGS_USER_NAME | Nombre del usuario que accede al servidor de envío de correos
MAILER_SMTP_SETTINGS_PASSWORD | Contraseña del usuario que accede al servidor de envío de correos
MAILER_SMTP_SETTINGS_AUTHENTICATION | Tipo de autenticación del servidor de envío de correos
MAILER_SMTP_SETTINGS_ENABLE_STARTTLS_AUTO | 'true' si el servidor de envío de correos utiliza certificado SSL


**Variables de entorno para despliegue**:

 Variable | Descripción
--- | ---
ASCC_SHARED_DIR | Ubicación de la carpeta con archivos comunes a todas las versiones desplegadas
PROD_ASCC_APP_DIR | Ubicación de la carpeta del ambiente de producción
PROD_ASCC_REPO_URL | Acceso al repositorio git del proyecto (por ejemplo 'https://github.com/AgenciaSustentabilidadyCambioClimatico/accion.git')
PROD_ASCC_REPO_BRANCH | Rama del git desde la cual se hará el despliegue para el ambiente de producción (por ejemplo 'master')
PROD_ASCC_SERVER_USER | Nombre del usuario para acceder al servidor sobre el cual se desplegará el proyecto en ambiente de producción
PROD_ASCC_SERVER_HOST | URL/IP del servidor sobre el cual se desplegará el proyecto en ambiente de producción
PROD_ASCC_SERVER_DOMAIN | Domino del servidor en ambiente de producción
PROD_ASCC_GATEWAY_USER | Nombre del usuario para acceder al servidor de acceso intermedio
PROD_ASCC_GATEWAY_HOST | URL/IP del servidor de acceso intermedio para realizar el despliegue en ambiente de producción
STAG_ASCC_APP_DIR | Ubicación de la carpeta del ambiente de pruebas
STAG_ASCC_REPO_URL | Acceso al repositorio git del proyecto (por ejemplo 'https://github.com/AgenciaSustentabilidadyCambioClimatico/accion.git')
STAG_ASCC_REPO_BRANCH | Rama del git desde la cual se hará el despliegue para el ambiente de pruebas (por ejemplo 'master')
STAG_ASCC_SERVER_USER | Nombre del usuario para acceder al servidor sobre el cual se desplegará el proyecto en ambiente de pruebas
STAG_ASCC_SERVER_HOST | URL/IP del servidor sobre el cual se desplegará el proyecto en ambiente de pruebas
STAG_ASCC_SERVER_DOMAIN | Domino del servidor en ambiente de pruebas
STAG_ASCC_GATEWAY_USER | URL/IP del servidor de acceso intermedio para realizar el despliegue en ambiente de pruebas

#### **Archivo** [database.yml](config/database.yml)

Modificar el nombre de la base de datos ``database:`` por la que haya escogido previamente 

## **Inicialización**
El sistema puede inicializarse en forma local o remota:

#### **I. En forma local**
El sistema puede 'descargarse' desde github, ya sea mediante el botón 'download' contenido en esta misma página, ya mediante el comando de consola
```
git clone https://github.com/AgenciaSustentabilidadyCambioClimatico/accion.git
```

El sistema se inicializa como cualquier proyecto rails:

#### **I.i. Gemas**
Se deben instalar/actualizar las gemas mediante el comando:
```
bundle install
```

#### **I.ii. Base de datos**
Se debe inicializar la base de datos mediante los comandos:
```
#para crear la base de datos (si no se ha creado previamente)
rails db:create 

#para que se ejecuten las migraciones (creacíon de las tablas, relaciones, procedimientos de almacenaje y demás constrains)
rails db:migrate 

#para que se ingresen datos necesarios a las tablas correndientes
rails db:seed
```

#### **I.iii. Servicio**
El sistema se levanta en el ambiente de desarrollo con el comando:
```
rails server
```
El ambiente de producción se levanta con el comando 
```
rails server -e production
```
Y el ambiente de pruebas con el comando 
```
rails server -e staging
```
Para más información, [Sitio oficial Ruby on Rails](https://rubyonrails.org/)

#### **II. En forma remota**
Esta opción esta pensada para que un desarrollador del proyecto pueda realizar despliegues en forma remota sobre los servidores que contienen los ambientes de producción y pruebas (que pueden ser el mismo).
Para tal efecto es necesario que el desarrollador ya cuente con el proyecto debidamente instalado en su computador, y que el o los servidores remotos cuenten con una carpeta **carpeta_del_usuario/ascc/ambiente_a_desplegar/shared/config/** (por ejemplo: /home/usuario1/ascc/production/shared/config/) con los siguientes archivos debidamente configurados: 
 - **database.yml**
 - **secrets.yml**
 - **email.yml**
 - **puma.rb**

Contando con lo anterior, el despliegue de una nueva versión (o de la versión inicial) es tan simple como ejecutar desde la carpeta del sistema en la consola del desarrollador:

Para el ambiente de producción:
```
cap production deploy
```
Para el ambiente de pruebas:
```
cap staging deploy
```
Terminado el proceso de instalación, el sistema ya estará desplegado y en ejecución en el ambiente de producción o pruebas, respectivamente, y se puede acceder a él ingresando la URL correspondiente a ese ambiente en el navegador de internet. Además en el servidor remoto se habrán creado las siguientes carpetas:

**carpeta_del_usuario/ascc/ambiente_a_desplegar/current**  => que contiene una referencia (link simbólico) a la última versión desplegada del sistema.

**carpeta_del_usuario/ascc/ambiente_a_desplegar/releases** => que contiene las últimas tres versiones desplegadas, para el caso que se quiera revertir el ambiente a una versión distinta de la actual.

**carpeta_del_usuario/ascc/ambiente_a_desplegar/repo** =>  que corresponde a la carpeta '.git' del desarrollador.
 

## **Más información**
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
