Class App.Installer
{

XData setup
{
<Manifest>
  <Default Name="Namespace" Value="IRISAPP"/>
  <Default Name="APPPATH" Dir="/opt/irisapp/"/>
  <Default Name="app" Value="irisapp" />

  <Namespace Name="${Namespace}" Code="${Namespace}" Data="${Namespace}" Create="yes" Ensemble="0">
    <Configuration>
      <Database Name="${Namespace}" Dir="/opt/${app}/data" Create="yes" Resource="%DB_${Namespace}"/>
    </Configuration>
    <CSPApplication Url="/csp/${app}" Directory="${cspdir}${app}" ServeFiles="1" Recurse="1" MatchRoles=":%DB_${Namespace}" AuthenticationMethods="32"/>
  </Namespace>

</Manifest>
}

ClassMethod setup(ByRef pVars, pLogLevel As %Integer = 3, pInstaller As %Installer.Installer, pLogger As %Installer.AbstractLogger) As %Status [ CodeMode = objectgenerator, Internal ]
{
  #; Let XGL document generate code for this method. 
  Quit ##class(%Installer.Manifest).%Generate(%compiledclass, %code, "setup")
}

ClassMethod BuildCubes() As %Status
{
  Write !,"Building DeepSee cubes...",!
  Set tSC = ##class(%DeepSee.Utils).%BuildCube("waterPollutionCube", 0, 1)
  If $System.Status.IsError(tSC) {
    Write !,"WARNING: ", $System.Status.GetErrorText(tSC), !
  } Else {
    Write !,"Cube build completed successfully.",!
  }
  Quit tSC
}

ClassMethod SetupDSWAddons() As %Status
{
  Write !,"Registering DSW addons...",!
  Set path = ##class(%File).NormalizeDirectory("/usr/irissys/csp/dsw/")
  Set path = ##class(%File).SubDirectoryName(path, "addons", 1)
  If '##class(%File).Exists(path) {
    Write !,"WARNING: DSW addons directory not found: ", path, !
    Quit $System.Status.Error(5001, "DSW addons directory not found")
  }

  Set rs = ##class(%File).FileSetFunc(path, "*.js")
  Set list = ##class(%ListOfDataTypes).%New()
  For {
    Quit:'rs.%Next()
    Do list.Insert("/dsw/addons/" _ rs.ItemName)
  }

  If list.Count() = 0 {
    Write !,"WARNING: No DSW addon files found.",!
    Quit $System.Status.OK()
  }

  Set tSC = ##class(MDX2JSON.Utils).CreateAddons(list)
  For i = 1:1:list.Count() {
    Set file = list.GetAt(i)
    Set addon = $Piece(##class(%File).GetFilename(file), ".", 1)
    Set sc = $System.OBJ.Compile("DSW.Addons." _ addon, "ck")
    If $System.Status.IsError(sc) {
      Set tSC = $System.Status.AppendStatus(tSC, sc)
    }
  }
  If $System.Status.IsError(tSC) {
    Write !,"WARNING: ", $System.Status.GetErrorText(tSC), !
  } Else {
    Write !,"DSW addons registered successfully.",!
  }
  Quit tSC
}

}
