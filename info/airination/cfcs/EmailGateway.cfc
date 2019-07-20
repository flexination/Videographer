<cfcomponent output="false">

	<cffunction name="doUpload" displayname="Save Uploaded Image to PNG" hint="Saves an Uploaded Image to PNG" access="remote" output="false" returntype="string">
		<cfargument name="pngbytes" type="binary" required="true" />
		<cfargument name="ip_suffix" type="string" default="#CGI.Remote_Addr#" required="false" />
		<cfscript>
			var myUUID = "";
			var PNGFileName = "";
			myUUID = CreateUUID();
			PNGFileName = arguments.ip_suffix & "_" & myUUID;
		</cfscript>
		<!--- save the PNG --->
		<cftry>
			<!--- create a FileOutputStream --->
			<cfobject type="java" action="CREATE" class="java.io.FileOutputStream" name="oStream">
			<cfscript>
				// call init method, passing in the full path to the desired png
				oStream.init(expandPath("../../../images/#arguments.ip_suffix#_#myUUID#.png"));
	        	oStream.write(arguments.pngbytes);
	        	oStream.close();
			</cfscript>
					
		<cfcatch type="any">
			<cfthrow message="#cfcatch.message# #cfcatch.detail# #cfcatch.RootCause#">
		</cfcatch>	
		</cftry>		

		<cfreturn PNGFileName />
	</cffunction>

	<cffunction name="sendImgToSocialNetworks" output="false" access="remote" returntype="Boolean">
		<cfargument name="fbemailaddress" required="true" />
		<cfargument name="cbxFBBln" required="true" />
		<cfargument name="flickremailaddress" required="true" />
		<cfargument name="cbxFlickrBln" required="true" />
		<cfargument name="imgName" required="true" />
		<cfargument name="imgCaption" required="true" />
		<cfscript>
			var sIP = CGI.Remote_Addr;
			if (sIP neq "127.0.0.1") {
				fileattach = "D:\home\webhtml5.info\wwwroot\flextraining\Videographer4Web\images\" & arguments.imgName;
			} else {
				fileattach = "C:\inetpub\wwwroot\flextraining\Videographer4Web\images\" & arguments.imgName;
			}
			if (arguments.cbxFBBln) {
				toMail = arguments.fbemailaddress;
			} else {
				toMail = "support@flexination.info";
			}
			if (arguments.cbxFlickrBln) {
				ccMail = arguments.flickremailaddress;
			} else {
				ccMail = "support@flexination.info";
			}
		</cfscript>

		<cftry>
			<cfmail from="owner@u-saw-it.com"
					 to="#toMail#"
					 cc="#ccMail#"
					 bcc="support@flexination.info"
					 subject="#arguments.imgCaption#" type="html">
					 <cfmailparam file="#fileattach#" type="image/png">
					 Sent from my Adobe Flex Videographer...
			</cfmail>
		<cfcatch type="any">
			<cfthrow message="#cfcatch.message# #cfcatch.detail#">
			<cfreturn false>
		</cfcatch>	
		</cftry>		
		
		<cfreturn true>
	</cffunction>

</cfcomponent>