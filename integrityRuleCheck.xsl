<?xml version="1.0" encoding="US-ASCII"?>
<?xml-stylesheet type="text/xsl" href="../xslstyle/xslstyle-docbook.xsl"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.CraneSoftwrights.com/ns/xslstyle"
                xmlns:xsd="http://www.w3.org/2001/XMLSchema"
                xmlns:g="urn:X-genericode"
                exclude-result-prefixes="xs xsd g"
                version="2.0">

<xs:doc info="Version 2021-05-22 14:40z"
        filename="rules2entities.xsl" vocabulary="DocBook">
  <xs:title>Confirm that the documentation matches the schema regarding
             rules</xs:title>
  <para>
    This is a consistency checker to make sure the documentation matches.
  </para>
</xs:doc>

<!--========================================================================-->
<xs:doc>
  <xs:title>Invocation parameters and input file</xs:title>
  <para>
    The main input file is the genericode.xml specification.
  </para>
</xs:doc>

<xs:param>
  <para>
    The XSD file also contain rules that need to match
  </para>
</xs:param>
<xsl:param name="xsd" as="document-node()?" required="yes"/>

<!--========================================================================-->
<xs:doc>
  <xs:title>Main processing</xs:title>
</xs:doc>

<xs:key>
  <para>
    The lookup for rules for both input files.
  </para>
</xs:key>
<xsl:key name="g:id" match="*[starts-with(@id,'R')]" use="@id"/>

<xs:template>
  <para>
    Compare the existence of rules to each other, then compare the ones
    that are the same.
  </para>
</xs:template>
<xsl:template match="/">
  <xsl:variable name="problems">
    
  </xsl:variable>
</xsl:template>

</xsl:stylesheet>
