<?xml version="1.0" encoding="utf-8"?>
<!--This stylesheet will transform a serialized Array of LegislationDetail objects from GGAServices to the XML schema used by the old BillSummary.xml file-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:msxsl="urn:schemas-microsoft-com:xslt" exclude-result-prefixes="msxsl"
>
    <xsl:output method="xml" indent="yes"/>

    <!--Match on the new Root Node, ArrayOfLegislationDetail-->
    <xsl:template match="ArrayOfLegislationDetail">
      <!--Create the old Root Node-->
      <BillSummary>
        <!--Match on each of the LegislationDetail Nodes and apply the appropriate template, see below-->
        <xsl:apply-templates select="LegislationDetail" />
      </BillSummary>
    </xsl:template>
  
  <!--Match a LegislationDetail Node and transform it into a Bill Node-->
  <xsl:template match="LegislationDetail">
    <Bill>
      <!--The old schema had some of the properties as attributes.  Create the attributes here and map them to the appropriate element in the new schema-->
      <xsl:attribute name="Id">
        <xsl:value-of select="Id"/>
      </xsl:attribute>
      <xsl:attribute name="Type">
        <xsl:value-of select="DocumentType"/>
      </xsl:attribute>
      <xsl:attribute name="Num">
        <xsl:value-of select="Number"/>
      </xsl:attribute>
      <xsl:attribute name="Suffix">
        <xsl:value-of select="Suffix"/>
      </xsl:attribute>
      <xsl:attribute name="StatusDate">
        <xsl:value-of select="Status/Date"/>
      </xsl:attribute>
      <!--This is no longer supported-->
      <xsl:attribute name="Carryover">
        <xsl:value-of select="-1"/>
      </xsl:attribute>
      <!--This is no longer supported-->
      <xsl:attribute name="YearID">
        <xsl:value-of select="-1"/>
      </xsl:attribute>
      
      <!--Map elements from new schema to elements in old schema-->
      <Number>
        <xsl:value-of select="concat(DocumentType, ' ', Number, Suffix)"/>
      </Number>
      <Short_Title>
        <xsl:value-of select="Caption"/>
      </Short_Title>
      <!--This is no longer supported-->
      <CompositeCaption>
        <xsl:text>This is no longer supported</xsl:text>
      </CompositeCaption>
      <Title>
        <xsl:value-of select="Summary"/>
      </Title>
      
      <!--TODO: finish mapping elements to old schema....-->
    </Bill>
  </xsl:template>
</xsl:stylesheet>
