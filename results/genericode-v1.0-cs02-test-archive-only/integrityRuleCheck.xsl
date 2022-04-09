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

<xs:output>
  <para>The result is a text file</para>
</xs:output>
<xsl:output method="text"/>

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

<xs:variable>
  <para>
    The documentation file put into a variable for use in key()
  </para>
</xs:variable>
<xsl:variable name="doc" as="document-node()" select="/"/>

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
  <xsl:variable name="problems" as="text()*">
    <!--check all in doc against all in schema-->
    <xsl:call-template name="g:compare-a-b">
      <xsl:with-param name="a" select="/"/>
      <xsl:with-param name="b" select="$xsd"/>
    </xsl:call-template>
    <xsl:call-template name="g:compare-a-b">
      <xsl:with-param name="a" select="$xsd"/>
      <xsl:with-param name="b" select="/"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:variable name="problemReport" as="xsd:string">
    <xsl:value-of>
      <xsl:for-each select="$problems">
        <xsl:sort select="."/>
        <xsl:sequence select="."/>
      </xsl:for-each>
    </xsl:value-of>
  </xsl:variable>
  <xsl:if test="normalize-space($problemReport)">
    <xsl:value-of select="$problemReport"/>
    <xsl:message terminate="yes" select="$problemReport"/>
  </xsl:if>
</xsl:template>

<xs:template>
  <para>
    Compare the existence of rules to each other, then compare the ones
    that are the same.
  </para>
  <xs:param name="a">
    <para>The A document to compare</para>
  </xs:param>
  <xs:param name="b">
    <para>The B document to compare</para>
  </xs:param>
</xs:template>
<xsl:template name="g:compare-a-b">
  <xsl:param name="a" as="document-node()"/>
  <xsl:param name="b" as="document-node()"/>
  <!--check all in doc against all in schema-->
  <xsl:for-each select="$a//*[starts-with(@id,'R')]">
    <xsl:variable name="arule" select="key('g:id',@id,$a)"/>
    <xsl:variable name="brule" select="key('g:id',@id,$b)"/>
    <xsl:choose>
      <xsl:when test="empty($brule)">
        <xsl:value-of select="concat('Rule ',$arule/@id,' in ',
            if( $a is $xsd ) then 'schema' else 'documentation',
            ' is not found in ',
            if( $b is $xsd ) then 'schema' else 'documentation', '&#xa;' )"/>
      </xsl:when>
      <xsl:when test="$a is $xsd">
        <!--the comparison already was done when $a was documentation-->
      </xsl:when>
      <xsl:when test="normalize-space( if( exists( $arule//para ) ) then
                string-join( $arule//para[not(emphasis)], ' ') else $arule ) !=
                      normalize-space( if( exists( $brule//para ) ) then
                string-join( $brule//para[not(emphasis)], ' ') else $brule )">
        <xsl:value-of select="concat('Rule ',$arule/@id,
                                     ' text does not match &#xa;')"/>
      </xsl:when>
      <xsl:otherwise>
        <!-- nothing wrong to report-->
      </xsl:otherwise>
    </xsl:choose>
  </xsl:for-each>
</xsl:template>

</xsl:stylesheet>
