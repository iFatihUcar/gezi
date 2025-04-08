<cfcomponent output="false">
    <!--- Constructor --->
    <cffunction name="init" access="public" returntype="any">
        <cfset variables.approvalModel = CreateObject("component", "gezi_onay_sistemi.models.APPROVAL")>
        <cfset variables.tokenModel = CreateObject("component", "gezi_onay_sistemi.models.TOKEN")>
        <cfreturn this>
    </cffunction>
    
    <!--- Onay Formu --->
    <cffunction name="showApprovalForm" access="public" returntype="void">
        <cfargument name="TOKEN" type="string" required="true">
        
        <!--- Token doğrulama --->
        <cfset var isValid = variables.tokenModel.validateToken(TOKEN=arguments.TOKEN)>
        
        <cfif NOT isValid>
            <cfset request.error = "Geçersiz veya süresi dolmuş bir link kullanıyorsunuz. Lütfen öğretmeninizle iletişime geçin.">
            <cfinclude template="../views/approval/error.cfm">
            <cfreturn>
        </cfif>
        
        <!--- Gezi ve öğrenci bilgilerini getir --->
        <cfset request.tripInfo = variables.approvalModel.getTripInfoByToken(TOKEN=arguments.TOKEN)>
        
        <cfif request.tripInfo.RecordCount EQ 0>
            <cfset request.error = "Bu onay linki için ilgili gezi veya öğrenci bulunamadı. Lütfen öğretmeninizle iletişime geçin.">
            <cfinclude template="../views/approval/error.cfm">
            <cfreturn>
        </cfif>
        
        <cfinclude template="../views/approval/form.cfm">
    </cffunction>
    
    <!--- Onay Kaydetme --->
    <cffunction name="saveApproval" access="public" returntype="void">
        <cfargument name="TOKEN" type="string" required="true">
        <cfargument name="APPROVAL_STATUS" type="string" required="true">
        <cfargument name="APPROVAL_NOTES" type="string" required="false" default="">
        
        <!--- Token doğrulama --->
        <cfset var isValid = variables.tokenModel.validateToken(TOKEN=arguments.TOKEN)>
        
        <cfif NOT isValid>
            <cfset request.error = "Geçersiz veya süresi dolmuş bir link kullanıyorsunuz. Lütfen öğretmeninizle iletişime geçin.">
            <cfinclude template="../views/approval/error.cfm">
            <cfreturn>
        </cfif>
        
        <!--- Gezi ve öğrenci bilgilerini getir --->
        <cfset var tripInfo = variables.approvalModel.getTripInfoByToken(TOKEN=arguments.TOKEN)>
        
        <cfif tripInfo.RecordCount EQ 0>
            <cfset request.error = "Bu onay linki için ilgili gezi veya öğrenci bulunamadı. Lütfen öğretmeninizle iletişime geçin.">
            <cfinclude template="../views/approval/error.cfm">
            <cfreturn>
        </cfif>
        
        <!--- Onayı kaydet --->
        <cfset var success = variables.approvalModel.saveApproval(
            TRIP_ID = tripInfo.TRIP_ID,
            STUDENT_ID = tripInfo.STUDENT_ID,
            APPROVAL_STATUS = arguments.APPROVAL_STATUS,
            APPROVAL_NOTES = arguments.APPROVAL_NOTES,
            APPROVAL_IP = CGI.REMOTE_ADDR
        )>
        
        <cfif success>
            <cfset request.success = true>
            <cfset request.tripInfo = tripInfo>
            <cfset request.approvalStatus = arguments.APPROVAL_STATUS>
            <cfinclude template="../views/approval/confirmation.cfm">
        <cfelse>
            <cfset request.error = "Onayınız kaydedilirken bir hata oluştu. Lütfen tekrar deneyiniz.">
            <cfset request.tripInfo = tripInfo>
            <cfinclude template="../views/approval/form.cfm">
        </cfif>
    </cffunction>
</cfcomponent>