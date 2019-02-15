# kodnet

## Librería y ayudas para el acceso a todos los objetos/clases/controles.NET de VisualFoxPro 9
Sí, .NET interop fácil para VisualFoxPro 9

**kodnet** añade una pequeña librería que permite usar clases/objetos y controles .NET dentro de su proyecto *VisualFoxPro 9*. Usted puede llamar cualquier método, campo o propiedad de cualquier clase .NET sin necesidad de crear un componente COM. Acceda a los componentes del .NET framework, a la gran cantidad de librerías .NET gratuitas, o a sus propios componentes desde VisualFoxPro 9 sin necesidad de registrar o instalar nada .

**kodnet** permite acceder incluso a enums, structs, clases y métodos genéricos, que es algo que no puede lograr generando por usted mismo un componente .COM. 
**kodnet** implícitamente provee conversión de tipos siempre que sea posible y además provee *wrappers* que permitan usar tipos nativos de .NET pero no nativos de VisualFoxPro 9. Esto es muy útil por ejemplo con métodos que aceptan *byte, float, long, Decimal* entre otros.


# ¿Quiere ser un patrocinador?

Si necesita algún requerimiento específico o desea contribuir a que este proyecto siga mejorando puede contactarnos a contacto@kodhe.com o usar el link de donación. Si desea convertirse en un patrocinador y que su logo/empresa salga en este README.md conviértase en un patrocinador que dona mensualmente y contáctenos.

* Donar a paypal [![](https://www.paypalobjects.com/en_US/i/btn/btn_donateCC_LG.gif)](https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=XTUTKMVWCVQCJ&source=url)


# Por qué migrar desde wwDotnetBridge a kodnet

**kodnet** ofrece ventajas que no ofrece wwDotnetBridge


* Código más fácil de escribir!. Llamar/asigar métodos,propiedades,campos usando el nombre propio del miembro. 
* Soporte para crear delegados y añadir/eliminar eventos
* Cree instancias de clases genéricas fácilmente
* Verdadero soporte para métodos asíncronos de .NET
* Compilar código C# dinámicamente
* Soporte para incluir controles visuales de .NET  a formularios VFP
* Hasta 8 veces más rápido en llamados a métodos de instancia [Mire el ejemplo](https://drive.google.com/file/d/1FI2I6kuYAmzSrArNgXdtGXvgFVvmUoGN/view?usp=sharing)


Si está pensando migrar, y necesita ayuda profesional, contáctenos a nuestro correo puesto más arriba. Estaremos gustosos de crear una cotización adsequible que se ajuste a sus necesidades.


### Version NET Framework soportada  

**kodnet** funciona sobre .NET Framework 4 o superior y en cualquier versión de Windows que soporte este framework y VisualFoxPro 9


# Inicie

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

## Resumen de funcionalidad


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
* Soporte para añadir/eliminar manejadores de eventos .NET (*delegados*)
* Gran rendimiento en los llamados a métodos, propiedades, porque internamente no usa *Reflexión* sino usa *CallSite* (la metodología que usa internamente *dynamic* en C#) 




# Cómo funciona

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

## Código asíncrono y eventos


Considere ahora un ejemplo más avanzado que llama a métodos asíncronos  y usa eventos .NET

```foxpro


* KODNET (contacto@kodhe.com)
* Download File asynchronous example

do fullpath("kodnet.prg")

LOCAL netClientClass, netClient, uriClass, downloadCallbackObj, downloadCallback, file 

* select a file
file= GETFILE()
IF EMPTY(m.file)
	RETURN MESSAGEBOX("Please select a file",64,"")
ENDIF 

uriClass= _screen.kodnet.getStaticWrapper("System.Uri")
netClientClass= _screen.kodnet.getStaticWrapper("System.Net.WebClient")
m.netClient= m.netClientClass.construct()





downloadCallbackObj= CREATEOBJECT("downloadCallback")
* create a delegate that point to VisualFoxPro function
downloadCallback=_screen.kodnetManager.createeventhandler(m.downloadCallbackObj, "finished", "System.ComponentModel.AsyncCompletedEventHandler")
* add the event handler 
m.netClient.add_DownloadFileCompleted(m.downloadCallback)

* this method is a .NET async method, this call will complete without finish the download
m.netClient.DownloadFileAsync(uriClass.construct("http://storage-ns01.d0stream.com/.drive/Projects/ffmpeg.tar.gz"), m.file)

* this executes before finish for demostrate that method is called async
? "Download has started. Running in background"
return 


DEFINE CLASS downloadCallback  as Custom 
	FUNCTION finished(sender, args)
		* avoid memory leaks (this is only required for objects not forms)
		this._event.destroy()
		IF !ISNULL(args.Error)
			MESSAGEBOX("Failed download: " + args.Error.Message, 48, "")
		ELSE 
			? "download finished"
			MESSAGEBOX("Finished download.", 64, "")
		ENDIF 
	ENDFUNC 
ENDDEFINE 


```


## Compilar código C#

**kodnet** permite compilar código C#. Puede guiarse con nuestro ejemplo

```Foxpro
TEXT TO m.code noshow

using System;
public class program{
	public static void main(){
	}
}
namespace Compiled
{

	public class Person{
		public string name;
		public int age;
	}
	
	public class Test
	{	
		public Person person(string name, int age){
			var p= new Person();
			p.name= name;
			p.age= age;
			return p;
		}
	
		public static int ExecuteFunc(Func<string,int> func)
		{
			return func("Method executed from .NET");
		}
		
		public static int ExecuteFunc(Func<string,int> func, string message)
		{
			return func(message);
		}
		
		public static int ExecuteFunc(Func<string,int,string,int> func, string message, int option, string title)
		{
			return func(message,option,title);
		}
	}
}


ENDTEXT 

LOCAL engine

* COMPILE C# CODE
Local asem, test, person

engine= _screen.kodnet.getStaticWrapper("jxshell.csharplanguage").construct()
m.engine.Runscript(m.code)
asem = m.engine.getCompiledAssembly()
_Screen.kodnet.loadAssembly(m.asem)


* now you can use the type compiled 
test= _screen.kodnet.getStaticWrapper("Compiled.Test").construct()
person= test.person("James", 24)
?person.name
?person.age
```


## Delegados, Tipos genéricos 


**kodnet** tiene soporte para crear delegados y objetos de tipos genéricos. En el siguiente ejemplo verá como se usa la clase  compilada en el ejemplo anterior, para mostrar el uso de delegados y tipos genéricos en este caso: System.Func<string,int>


```Foxpro
* YES! KODNET SUPPORTS DELEGATES 
LOCAL Func1, Func2, target , TestClass, needrunCompile


TRY 
	* Take a look in compilecsharp.prg example for understand
	TestClass= _screen.kodnet.getStaticWrapper("Compiled.Test")
CATCH TO ex 
	needrunCompile= .t.
ENDTRY 

IF needrunCompile 
	RETURN MESSAGEBOX("Please execute first 'compilecsharp.prg' example",64,"Kodnet")
ENDIF 



target= CREATEOBJECT("func_callback")
Func1= _screen.kodnet.getStaticWrapper("System.Func<System.String,System.Int32>").construct(m.target,"callback")
Func2= _screen.kodnet.getStaticWrapper("System.Func<System.String,System.Int32,System.String,System.Int32>").construct(m.target,"callback")

* Pass Func1 delegate to c# function 
?TestClass.executeFunc(Func1)

* pass overloaded 
?TestClass.executeFunc(Func1, "Parameter sent to c#")


* pass overloaded System.Func<string,int,string,int>
?TestClass.executeFunc(Func2, "Parameter sent to c#", 64, "Title")


* It's a good practice Free delegate, avoid memory leaks
Func1.dispose()
Func2.dispose()

DEFINE CLASS func_callback as Custom 

	FUNCTION callback( str, option, title )
		IF PCOUNT() == 3
			RETURN MESSAGEBOX(str,option,title)
		ELSE 
			RETURN MESSAGEBOX(str)
		ENDIF 

	ENDFUNC 

ENDDEFINE 
```

