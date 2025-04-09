<cfcomponent output="false">
    <!--- Token oluşturma --->
    <cffunction name="createToken" access="public" returntype="string">
        <cfargument name="TRIP_ID" type="numeric" required="true">
        <cfargument name="STUDENT_ID" type="numeric" required="true">
        <cfargument name="CREATED_BY" type="numeric" required="true">
        <cfargument name="EXPIRE_DAYS" type="numeric" required="false" default="30">
        
        <cfset var token = "">
        <cfset var expireDate = DateAdd("d", arguments.EXPIRE_DAYS, Now())>
        
        <!--- Benzersiz bir token oluştur --->
        <cfset token = Hash(arguments.TRIP_ID & "-" & arguments.STUDENT_ID & "-" & CreateUUID() & "-" & Now(), "SHA-256")>
        
        
        
        <cftry>
            <!--- Önce bu öğrenci için bu geziye dair bir token var mı kontrol edelim --->
            <cfquery name="checkToken" datasource="DEV_DB_MSSQL">
                SELECT TOKEN_ID, TOKEN
                FROM APPROVAL_TOKENS
                WHERE 
                    STUDENT_ID = <cfqueryparam value="#arguments.STUDENT_ID#" cfsqltype="CF_SQL_INTEGER">
                    AND TRIP_ID = <cfqueryparam value="#arguments.TRIP_ID#" cfsqltype="CF_SQL_INTEGER">
                    AND EXPIRE_DATE > <cfqueryparam value="#Now()#" cfsqltype="CF_SQL_TIMESTAMP">
            </cfquery>
            
            <cfif checkToken.RecordCount GT 0>
                <!--- Mevcut token'ı döndür --->
                <cfset token = checkToken.TOKEN>
            <cfelse>
                <!--- Yeni token oluştur --->
                <cfquery name="insertToken" datasource="DEV_DB_MSSQL">
                    INSERT INTO APPROVAL_TOKENS (
                        TRIP_ID,
                        STUDENT_ID,
                        TOKEN,
                        CREATED_BY,
                        CREATED_DATE,
                        EXPIRE_DATE
                    ) VALUES (
                        <cfqueryparam value="#arguments.TRIP_ID#" cfsqltype="CF_SQL_INTEGER">,
                        <cfqueryparam value="#arguments.STUDENT_ID#" cfsqltype="CF_SQL_INTEGER">,
                        <cfqueryparam value="#token#" cfsqltype="CF_SQL_VARCHAR">,
                        <cfqueryparam value="#arguments.CREATED_BY#" cfsqltype="CF_SQL_INTEGER">,
                        <cfqueryparam value="#Now()#" cfsqltype="CF_SQL_TIMESTAMP">,
                        <cfqueryparam value="#expireDate#" cfsqltype="CF_SQL_TIMESTAMP">
                    )
                </cfquery>
            </cfif>
            
            <cfreturn token>
            
            <cfcatch type="any">
                <cfreturn "">
            </cfcatch>
        </cftry>
    </cffunction>
    

        <!--- Token doğrulama --->
    <cffunction name="validateToken" access="public" returntype="boolean">
        <cfargument name="TOKEN" type="string" required="true">
        
        
        
        <cfquery name="checkToken" datasource="DEV_DB_MSSQL">
            SELECT TOKEN_ID
            FROM APPROVAL_TOKENS
            WHERE 
                TOKEN = <cfqueryparam value="#arguments.TOKEN#" cfsqltype="CF_SQL_VARCHAR">
                AND EXPIRE_DATE > <cfqueryparam value="#Now()#" cfsqltype="CF_SQL_TIMESTAMP">
        </cfquery>
        
        <cfreturn checkToken.RecordCount GT 0>
    </cffunction>
    
    <!--- Belirli bir öğrenci için onay linki oluşturma --->
    <cffunction name="generateApprovalLink" access="public" returntype="string">
        <cfargument name="TRIP_ID" type="numeric" required="true">
        <cfargument name="STUDENT_ID" type="numeric" required="true">
        <cfargument name="CREATED_BY" type="numeric" required="true">
        <cfargument name="EXPIRE_DAYS" type="numeric" required="false" default="30">
        <cfargument name="BASE_URL" type="string" required="false" default="/gezi_onay_sistemi/views/approval/form.cfm">
        
        <cfset var token = createToken(
            TRIP_ID = arguments.TRIP_ID,
            STUDENT_ID = arguments.STUDENT_ID,
            CREATED_BY = arguments.CREATED_BY,
            EXPIRE_DAYS = arguments.EXPIRE_DAYS
        )>
        
        <cfif token NEQ "">
            <cfreturn "#arguments.BASE_URL#?token=#token#">
        <cfelse>
            <cfreturn "">
        </cfif>
    </cffunction>
    
    <!--- Öğrenci ve gezi için tüm token'ları getirme --->
    <cffunction name="getTokensByTripAndStudent" access="public" returntype="query">
        <cfargument name="TRIP_ID" type="numeric" required="true">
        <cfargument name="STUDENT_ID" type="numeric" required="true">
        
        
        
        <cfquery name="qTokens" datasource="DEV_DB_MSSQL">
            SELECT 
                TOKEN_ID,
                TRIP_ID,
                STUDENT_ID,
                TOKEN,
                CREATED_BY,
                CREATED_DATE,
                EXPIRE_DATE,
                CASE WHEN EXPIRE_DATE > <cfqueryparam value="#Now()#" cfsqltype="CF_SQL_TIMESTAMP"> THEN 'Active' ELSE 'Expired' END AS TOKEN_STATUS
            FROM 
                APPROVAL_TOKENS
            WHERE 
                TRIP_ID = <cfqueryparam value="#arguments.TRIP_ID#" cfsqltype="CF_SQL_INTEGER">
                AND STUDENT_ID = <cfqueryparam value="#arguments.STUDENT_ID#" cfsqltype="CF_SQL_INTEGER">
            ORDER BY 
                CREATED_DATE DESC
        </cfquery>
        
        <cfreturn qTokens>
    </cffunction>
    
    <!--- Token'ın süresini uzatma --->
    <cffunction name="extendTokenExpiry" access="public" returntype="boolean">
        <cfargument name="TOKEN" type="string" required="true">
        <cfargument name="EXTEND_DAYS" type="numeric" required="false" default="30">
        
        
        
        <cftry>
            <cfquery name="updateToken" datasource="DEV_DB_MSSQL">
                UPDATE APPROVAL_TOKENS
                SET
                    EXPIRE_DATE = <cfqueryparam value="#DateAdd('d', arguments.EXTEND_DAYS, Now())#" cfsqltype="CF_SQL_TIMESTAMP">
                WHERE
                    TOKEN = <cfqueryparam value="#arguments.TOKEN#" cfsqltype="CF_SQL_VARCHAR">
            </cfquery>
            
            <cfreturn true>
            
            <cfcatch type="any">
                <cfreturn false>
            </cfcatch>
        </cftry>
    </cffunction>
</cfcomponent>