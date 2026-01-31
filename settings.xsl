<?xml version="1.0" encoding="iso-8859-1" ?>

<xsl:transform
	version="2.0"
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        xmlns:xhtml="http://www.w3.org/1999/xhtml">

<xsl:output method="xml" media-type="text/html" encoding="iso-8859-1"/>

<xsl:template match="/Router">
	<xsl:message>In Router</xsl:message>
<!--<![CDATA[
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"
"http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
]]>-->
	<xhtml>
		<header></header>
		<body>
			<xsl:apply-templates select="./ImDhcpServer"/>
			<xsl:apply-templates select="./ImFireWall"/>
		</body>
	</xhtml>
</xsl:template>

<xsl:template match="ImDhcpServer">
	<h2>DCHP Server</h2>
	<table border="1">
		<thead>
			<tr><td colspan="4">Fixed hosts</td></tr>
			<tr><td>Host</td><td>IP Address</td><td>MAC Address</td><td>Max Lease Time</td></tr>
		</thead>
		<tbody>
			<xsl:for-each select="./ImFixedHosts/*">
				<xsl:sort select="substring-after(@ipaddr, '192.168.1.')" data-type="number"/>
				<tr>
					<td>
						<xsl:value-of select="local-name(.)"/>
					</td>
					<td>
						<xsl:value-of select="@ipaddr"/>
					</td>
					<td>
						<xsl:value-of select="@macAddress"/>
					</td>
					<td>
						<xsl:value-of select="@maxLeaseTime"/>
					</td>
				</tr>
			</xsl:for-each>
		</tbody>
	</table>
	<xsl:apply-templates/>
</xsl:template>

<xsl:template match="pex_dmz|pex_in|pdmz_in">
	<xsl:message>pex_star</xsl:message>
	<h3><xsl:value-of select="local-name(.)"/></h3><br/>

<!--        <hed_tnet PolicyName='pex_dmz' SrcIpAddr='0.0.0.0' SrcIpMask='0.0.0.0' DstIpAddr='0.0.0.0' DstIpMask='0.0.0.0' IpProtocol='TCP' SrcPortNumberStart='0' SrcPortNumberEnd='65535' DstPortNumberStart='23' DstPortNumberEnd='23' InboundPermission='false' OutboundPermission='false' Timeschedule='127' > -->


	<table border="1">
		<thead>
			<tr><td colspan="8">Policy:<xsl:value-of select="local-name(.)"/></td></tr>
			<tr>
				<td>SrcIp</td>
				<td>DstIp</td>
				<td>Protocol</td>
				<td>srcPort</td>
				<td>DstPort</td>
				<td>Inbound</td>
				<td>Outbound</td>
				<td>TimeSchedule</td>
			</tr>
		</thead>
		<tbody>
			<xsl:for-each select="./ImFwFilters/*">
				<tr>
					<td>
						<xsl:value-of select="concat(@SrcIpAddr,'/',@SrcIpMask)"/>
					</td>
					<td>
						<xsl:value-of select="concat(@DstIpAddr,'/',@DstIpMask)"/>
					</td>
					<td>
						<xsl:value-of select="@Protocol"/>
					</td>
					<td>
						<xsl:value-of select="concat(@SrcPortNumberStart,'-', @SrcPortNumberEnd)"/>
					</td>
					<td>
						<xsl:value-of select="concat(@DstPortNumberStart,'-', @DstPortNumberEnd)"/>
					</td>
					<td>
						<xsl:value-of select="@InboundPermission"/>
					</td>
					<td>
						<xsl:value-of select="@OutboundPermission"/>
					</td>
					<td>
						<xsl:value-of select="@TimeSchedule"/>
					</td>
				</tr>
			</xsl:for-each>
		</tbody>
	</table>
	<xsl:apply-templates/>
	
</xsl:template>

<xsl:template match="ImFireWall">
	<xsl:message>ImFireWall</xsl:message>
	<h2>Firewall</h2>
	<xsl:apply-templates/>
</xsl:template>

</xsl:transform>