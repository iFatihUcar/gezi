<cfcomponent>
    <!-- Uygulama ayarları -->
    <cfset this.name = "GeziOnaySistemi">
    <cfset this.sessionManagement = true>
    <cfset this.sessionTimeout = createTimeSpan(0, 2, 0, 0)>
    
    <!-- Varsayılan datasource tanımı -->
    <cfset this.datasource = "DEV_DB_MSSQL">
    
    <!-- Mapping tanımı -->
    <cfset this.mappings = {
        "/models" = expandPath("./models"),
        "/controllers" = expandPath("./controllers"),
        "/views" = expandPath("./views"),
        "/includes" = expandPath("./includes")
    }>
    
    <!-- Debug ayarları -->
    <cfset this.debuggingIPAddresses = "*">
    <cfset this.customDebugOutput = false>
    
    <!-- Hata sayfası -->
    <cferror type="exception" template="error.cfm">
    <cferror type="request" template="error.cfm">
    
    <!-- Hata yönetimi -->
    <cffunction name="onError" returnType="void" output="true">
        <cfargument name="exception" required="true">
        <cfargument name="eventName" type="string" required="true">
        <cfdump var="#arguments.exception#" label="Hata Detayları">
        <cfabort>
    </cffunction>
</cfcomponent>