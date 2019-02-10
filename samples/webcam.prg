LPARAMETERS arg,arg1, arg2, arg3, arg4, arg5


*** WEBCAM SAMPLE

LOCAL path
IF TYPE("MAINPATH")=="C"
	path=MAINPATH
ELSE
	path= ADDBS(JUSTPATH(SYS(16)))
ENDIF 


DO (m.path+"../kodnet.prg")
DO (m.path+"helper.prg")



* if you will use controls 
_screen.dotnet4manager.initui()




LOCAL htmlAs
htmlAs = m.path+ "lib/AForge.dll"
_Screen.dotnet4.loadAssemblyFile(m.htmlAS)
htmlAs = m.path+ "lib/AForge.Video.dll"
_Screen.dotnet4.loadAssemblyFile(m.htmlAS)
htmlAs = m.path+ "lib/AForge.Video.DirectShow.dll"
_Screen.dotnet4.loadAssemblyFile(m.htmlAS)



DO FORM (m.path + "/forms/webcam")