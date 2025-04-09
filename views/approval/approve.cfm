<cfset approvalModel = CreateObject("component", "gezi_onay_sistemi.models.APPROVAL")>
<cfset tokenModel = CreateObject("component", "gezi_onay_sistemi.models.TOKEN")>

<cfparam name="form.TOKEN" default="">
<cfparam name="form.APPROVAL_STATUS" default="">
<cfparam name="form.APPROVAL_NOTES" default="">
<cfset clientIP = CGI.REMOTE_ADDR>

<cfif Len(form.TOKEN) EQ 0>
    <cfset errorMessage = "Token eksik.">
<cfelse>
    <!--- Token ile bilgileri al --->
    <cfset tripInfo = approvalModel.getTripInfoByToken(token=form.TOKEN)>

    <cfif tripInfo.RecordCount EQ 0>
        <cfset errorMessage = "Token geçersiz veya süresi dolmuş.">
    <cfelse>
        <!--- Onayı kaydet --->
        <cfset saveResult = approvalModel.saveApproval(
            TRIP_ID = tripInfo.TRIP_ID,
            STUDENT_ID = tripInfo.STUDENT_ID,
            APPROVAL_STATUS = form.APPROVAL_STATUS,
            APPROVAL_NOTES = form.APPROVAL_NOTES,
            APPROVAL_IP = clientIP
        )>

        <cfif saveResult>
            <cflocation url="form.cfm?token=#form.TOKEN#&success=1" addtoken="false">
        <cfelse>
            <cfset errorMessage = "Onay kaydedilemedi. Lütfen tekrar deneyin.">
        </cfif>
    </cfif>
</cfif>

<cfif StructKeyExists(variables, "errorMessage")>
    <cflocation url="form.cfm?token=#form.TOKEN#&error=#URLEncodedFormat(errorMessage)#" addtoken="false">
</cfif>
