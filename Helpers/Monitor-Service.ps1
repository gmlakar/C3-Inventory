# Read From User
$GroupName = read-host "Service Group Name"

$Services = read-host "Semi-Colon Separated Service List"

#Prepare Parameters for XML Replacement
$EscapedName = $GroupName.replace(" ","-").ToLower()

$HTMLServiceList = ""
foreach($Service in $Services.Split(";")){
    $HTMLServiceList += "<LI>"
    $HTMLServiceList += "$Service"
    $HTMLServiceList += "</LI>"
}


$XML = @"
<?xml version="1.0" encoding="UTF-8"?>

<BES xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:noNamespaceSchemaLocation="BES.xsd">
	<Fixlet>
		<Title>Config - Service Monitor - $GroupName - Windows</Title>
		<Description><![CDATA[<P>Configures the BES Service Monitor (<STRONG>Fixlet: </STRONG>Invoke - Service Monitor - Windows) to monitor services.</P>
<P>Specifically, this fixlet configures it to monitor the following Windows Services:</P>
<OL>
$HTMLServiceList
</OL>
<P>For general information or to report issues with C3 Inventory content please visit GitHub here: <A href="https://github.com/strawgate/C3-Inventory">https://github.com/strawgate/C3-Inventory</A></P>]]></Description>
		<Relevance>windows of operating system</Relevance>
		<Relevance>exists services (substrings separated by ";" of "$Services")</Relevance>
		<Relevance>not exists values whose (it = "$Services") of settings "besservicemonitor-$EscapedName" of client</Relevance>
		<Category>Service Monitor</Category>
		<Source>Internal</Source>
		<SourceID></SourceID>
		<SourceReleaseDate>2016-10-25</SourceReleaseDate>
		<SourceSeverity></SourceSeverity>
		<CVENames></CVENames>
		<SANSID></SANSID>
		<Domain>BESC</Domain>
		<DefaultAction ID="Action1">
			<Description>
				<PreLink>Click </PreLink>
				<Link>here</Link>
				<PostLink> to deploy this action.</PostLink>
			</Description>
			<ActionScript MIMEType="application/x-Fixlet-Windows-Shell">setting "besservicemonitor-$EscapedName"="$Services" on "{now}" for client</ActionScript>
		</DefaultAction>
	</Fixlet>
</BES>
"@

$XML > "$PSScriptRoot\Config - Service Monitor - $GroupName - Windows.bes"

invoke-item "$PSScriptRoot\Config - Service Monitor - $GroupName - Windows.bes" 