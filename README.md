# kodnet

## Library and helpers for access to all .NET objects/classes/controls from VisualFoxPro 9
Yes made .NET interop easy for VisualFoxPro 9

**kodnet** añade una pequeña librería que permite usar clases/objetos y controles .NET dentro de su proyecto *VisualFoxPro 9*. Usted puede llamar cualquier método, campo o propiedad de cualquier clase .NET sin necesidad de crear un componente COM. Acceda a los componentes del .NET framework, a la gran cantidad de librerías .NET gratuitas, o a sus propios componentes desde VisualFoxPro 9 sin necesidad de registrar o instalar nada .

**kodnet** permite acceder incluso a enums, structs, clases y métodos genéricos, que es algo que no puede lograr generando por usted mismo un componente .COM. 
**kodnet** implícitamente provee conversión de tipos siempre que sea posible y además provee *wrappers* que permitan usar tipos nativos de .NET pero no nativos de VisualFoxPro 9. Esto es muy útil por ejemplo con métodos que aceptan *byte, float, long, Decimal* entre otros.


### NET Framework version support 

**kodnet** funciona sobre .NET Framework 4 o superior y en cualquier versión de Windows que soporte este framework y VisualFoxPro 9


# Getting started 

Primero cargue el entorno de kodnet

```foxpro
* Load kodnet library
do fullpath("kodnet.prg")
```

> Si usted obtiene un mensaje que dice **Unable to load CLR** problablemente se deba a que Windows bloquea los archivos descargados de internet. Para ello haga click derecho en las librerías .DLL distribuidas con *kodnet*  y haga click en desbloquear. 

```foxpro 
* you can now access to kodnet using _screen.kodnet


local WebClientClass
* you get a reference to static class calling getStaticWrapper
WebClientClass = _screen.kodnet.getStaticWrapper("System.Net.WebClient")
m.WebClientClass.DownloadFile("https://codeload.github.com/voxsoftware/kodnet/zip/master", "kodnet.zip")

* load an assembly by file
local customClass, customObject
_screen.kodnet.loadAssemblyFile("customdotnet.dll")
customClass= _screen.kodnet.getStaticWrapper("CustomClass")

* create an instance of type 
customObject= m.customClass.construct()


* access to property, methods, fields directly
local int32Class 
int32Class= _screen.kodnet.getStaticWrapper("System.Int32")
?int32Class.MaxValue
?int32Class.MinValue 
?customObject.customMethod()


```

## Getting started summary


* Accede a cualquier componente .NET incluso si no está marcado para *interop* [ComVisible]
* No necesita registrar o instalar el componente
* Llame cualquier método, propiedad directamente como cualquier otro objeto *FoxPro*
* Llamar al constructor de una clase con parámetros es posible
* Llame a cualquier sobrecarga de un método. **kodnet** seleccionar la mejor, de acuerdo a sus parámetros
* Soporte para cualquier tipo no nativo de .NET
* Accede a miembros estáticos, incluidos Structs, Enums, Generic, etc
* Accede a *.NET arrays* fácilmente usando los métodos *Get* y *Set*
* Usted puede pasar un objeto *FoxPro* y leerlo desde un método .NET usando *dynamic*
* Soporte multithread
* Incluya controles visuales de .NET dentro de sus formularios *VisualFoxPro* y acceda a sus miembros como cualquier otra clase .NET
* Soporte para añadir/eliminar manejadores de eventos .NET
* Gran rendimiento en los llamados a métodos, propiedades, porque internamente no usa *Reflexión* sino usa *CallSite* (la metodología que usa internamente *dynamic* en C#) 




# How it works

Descargue el proyecto para que vea los ejemplos y aprenda como usarlo. Principalmente consta de esto

* ClrHost.dll - Win32 dll para cargar el runtime .NET
* Unas DLL usadas para interop - La carpeta lib
* kodnet.prg - FoxPro prg, frontend al Proxy
* dotnet4.vcx - FoxPro Clase visual, para añadir controles .NET  a formularios

> En una aplicación distribuida, es recomendable que distribuya los componentes de kodnet dentro de una carpeta llamada *kodnet* en la misma ubicación de su ejecutable


Mire un ejemplo de código que usa diferentes características de los componentes .NET


```foxpro 
do fullpath("kodnet.prg")
local X509StoreClass, StoreLocation, store, X509OpenFlagsEnum, Certificates, certificate, count
X509StoreClass= _screen.kodnet.getStaticWrapper("System.Security.Cryptography.X509Certificates.X509Store")

* access to enum
StoreLocation= _screen.kodnet.getStaticWrapper("System.Security.Cryptography.X509Certificates.StoreLocation")
store= m.X509StoreClass.construct(StoreLocation.LocalMachine)

* OR use this for certificates only the user
*store= m.X509StoreClass.construct(StoreLocation.CurrentUser)



X509OpenFlagsEnum=  _screen.kodnet.getStaticWrapper("System.Security.Cryptography.X509Certificates.OpenFlags")
m.store.Open(X509OpenFlagsEnum.ReadOnly)

* manage collections  
Certificates= store.Certificates
count= Certificates.Count 

?"Certificates found: " + str(m.count)
FOR i=1 TO m.count 
	* use item for access to collection items
	certificate= m.Certificates.item(m.i - 1)
    if (!ISNULL(m.certificate))
        ? m.certificate.FriendlyName
		? m.certificate.SerialNumber
		? m.certificate.GetName()
    endif 
endfor 
```







