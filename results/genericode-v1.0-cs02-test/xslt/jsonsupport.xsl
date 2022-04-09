<?xml version="1.0" encoding="UTF-8"?>
<?xml-stylesheet type="text/xsl" href="../../xslstyle/xslstyle-docbook.xsl"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.CraneSoftwrights.com/ns/xslstyle"
                xmlns:xsd="http://www.w3.org/2001/XMLSchema"
                xmlns:gu="urn:X-gc2obdndr"
                exclude-result-prefixes="xs gu xsd"
                version="2.0">

<xs:doc info="20210811-0130z"
        filename="jsonsupport.xsl" vocabulary="DocBook" internal-ns="gu">
  <xs:title>Common code for handling JSON</xs:title>
  <para>
    Support for serializing JSON structures: objects, Boolean values, 
    number, strings, lists of string or number items.
  </para>
</xs:doc>

<xs:template>
  <para>Handle a nested item in JSON syntax</para>
</xs:template>
<xsl:template match="o" mode="gu:jsonSerialize">
  <xsl:for-each select="ancestor::*"><xsl:text>  </xsl:text></xsl:for-each>
  <xsl:for-each select="@n">
    <xsl:text>"</xsl:text>
    <xsl:value-of select='replace(replace(.,"""","\\"""),"\n","\\n")'/>
    <xsl:text>": </xsl:text>
  </xsl:for-each>
  <xsl:text>{&#xa;</xsl:text>
  <xsl:apply-templates select="*" mode="gu:jsonSerialize"/>
  <xsl:for-each select="ancestor::*"><xsl:text>  </xsl:text></xsl:for-each>
  <xsl:text>  }</xsl:text>
  <xsl:if test="following-sibling::*">,</xsl:if>
  <xsl:text>&#xa;</xsl:text>
</xsl:template>

<xs:template>
  <para>Handle a list item in JSON syntax</para>
</xs:template>
<xsl:template match="l" mode="gu:jsonSerialize">
  <xsl:for-each select="ancestor::*"><xsl:text>  </xsl:text></xsl:for-each>
  <xsl:for-each select="@n">
    <xsl:value-of select='gu:jsonString(.)'/>: <xsl:text/>
  </xsl:for-each>
  <xsl:text>[&#xa;</xsl:text>
  <xsl:apply-templates select="*" mode="gu:jsonSerialize"/>
  <xsl:for-each select="ancestor::*"><xsl:text>  </xsl:text></xsl:for-each>
  <xsl:text>  ]</xsl:text>
  <xsl:if test="following-sibling::*">,</xsl:if>
  <xsl:text>&#xa;</xsl:text>
</xsl:template>

<xs:template>
  <para>Handle a string item in JSON syntax</para>
</xs:template>
<xsl:template match="s" mode="gu:jsonSerialize">
  <xsl:for-each select="ancestor::*"><xsl:text>  </xsl:text></xsl:for-each>
  <xsl:value-of select="concat(@n/concat(gu:jsonString(.),': '),
                               gu:jsonString(@v))"/>
  <xsl:if test="following-sibling::*">,</xsl:if>
  <xsl:text>&#xa;</xsl:text>
</xsl:template>

<xs:template>
  <para>Handle a number item in JSON syntax</para>
</xs:template>
<xsl:template match="n" mode="gu:jsonSerialize">
  <xsl:for-each select="ancestor::*"><xsl:text>  </xsl:text></xsl:for-each>
  <xsl:value-of select="concat(gu:jsonString(@n),': ',@v)"/>
  <xsl:if test="following-sibling::*">,</xsl:if>
  <xsl:text>&#xa;</xsl:text>
</xsl:template>

<xs:template>
  <para>Handle a false Boolean value in JSON syntax</para>
</xs:template>
<xsl:template match="f" mode="gu:jsonSerialize">
  <xsl:for-each select="ancestor::*"><xsl:text>  </xsl:text></xsl:for-each>
  <xsl:value-of select="concat(gu:jsonString(@n),': false')"/>
  <xsl:if test="following-sibling::*">,</xsl:if>
  <xsl:text>&#xa;</xsl:text>
</xsl:template>

<xs:template>
  <para>Handle a true Boolean value in JSON syntax</para>
</xs:template>
<xsl:template match="t" mode="gu:jsonSerialize">
  <xsl:for-each select="ancestor::*"><xsl:text>  </xsl:text></xsl:for-each>
  <xsl:value-of select="concat(gu:jsonString(@n),': true')"/>
  <xsl:if test="following-sibling::*">,</xsl:if>
  <xsl:text>&#xa;</xsl:text>
</xsl:template>

<xs:template>
  <para>Unhandled item in JSON syntax</para>
</xs:template>
<xsl:template match="*" mode="gu:jsonSerialize">
  <xsl:message terminate="yes">
    <xsl:text>Unhandled: </xsl:text>
    <xsl:for-each select="ancestor-or-self::*">
      <xsl:text>/</xsl:text>
      <xsl:value-of select="name(.)"/>
      <xsl:for-each select="
                   count(preceding-sibling::*[name(.)=name(current())])[.!=0]">
        <xsl:text/>[<xsl:value-of select="."/>]<xsl:text/>
      </xsl:for-each>
    </xsl:for-each>
  </xsl:message>
</xsl:template>

<xs:function>
  <para>
    Escape a JSON string value
  </para>
  <xs:param name="gu:value"><para>The value of the string.</para></xs:param>
</xs:function>
<xsl:function name="gu:jsonString" as="xsd:string">
  <xsl:param name="gu:value" as="xsd:string"/>
  <xsl:value-of select='concat("""",
       replace(
         replace(
           replace(
             replace(
               replace($gu:value,"\\","\\\\"),
                     """","\\"""),
                   "\n","\\n"),
                 "\r","\\r"),
               "\t","\\t"),
                               """")'/>
</xsl:function>

</xsl:stylesheet>
