<?xml version="1.0" encoding="US-ASCII"?>
<?xml-stylesheet type="text/xsl"
                 href="../../../../xslstyle/xslstyle-docbook.xsl"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
              xmlns:gc="http://docs.oasis-open.org/codelist/ns/genericode/1.0/"
                xmlns:xs="http://www.CraneSoftwrights.com/ns/xslstyle"
                xmlns:xsd="http://www.w3.org/2001/XMLSchema"
                xmlns:gu="urn:X-gc2obdndr"
                xmlns:gca="http://example.org/namespace/genericode-appinfo"
                exclude-result-prefixes="xs xsd gu gc gca"
                version="2.0">

<xsl:import href="jsonsupport.xsl"/>

<xs:doc info="20210811-0130z"
        filename="gc2gcj.xsl" vocabulary="DocBook">
  <xs:title>Convert genericode XML to genericode JSON</xs:title>
  <para>
    This stylesheet supports only a subset of genericode XML in the conversion
    to JSON syntax.
  </para>
</xs:doc>

<xs:output>
  <para>Text output</para>
</xs:output>
<xsl:output method="text"/>

<!--========================================================================-->
<xs:doc>
  <xs:title>Invocation parameters and input file</xs:title>
  <para>
    The input file is an instance of a subset of the genericode XSD model
    for genericode XML. Empirical evidence is this subset is a commonly-used
    subset meeting the needs of many users.
  </para>
  <para>
    Supported at this time is only simple lists with multiple rows of multiple
    columns of simple values, not any complex values as defined by genericode.
  </para>
  <para>
    The invocation can include verbose=yes to serialize the list of code values
    as verbose as the introductory material. When not verbose (the default) the
    list of codes is simplified.
  </para>
</xs:doc>

<xs:param ignore-ns='yes'>
  <para>
    Indication of whether or not the code list values are explicit
  </para>
</xs:param>
<xsl:param name="verbose" select="'no'" as="xsd:string"/>

<!--========================================================================-->
<xs:doc>
  <xs:title>Main logic</xs:title>
</xs:doc>

<xs:template>
  <para>Get things going</para>
</xs:template>
<xsl:template match="/gc:CodeList">
  <xsl:variable name="result">
    <o>
      <xsl:apply-templates/>
    </o>
  </xsl:variable>
  <xsl:apply-templates select="$result" mode="gu:jsonSerialize"/>
</xsl:template>

<xs:template>
  <para>
    Annotations serialize the application info based on the namespaces in use.
  </para>
</xs:template>
<xsl:template match="Annotation[AppInfo]">
  <o n="Annotation">
    <xsl:for-each select="AppInfo">
      <xsl:call-template name="gu:handleGenericElement"/>
    </xsl:for-each>
  </o>
</xsl:template>

<xs:template>
  <para>
    Most elements can be transliterated.
  </para>
</xs:template>
<xsl:template match="AppInfo | Identification | SimpleCodeList">
  <xsl:apply-templates select="." mode="gu:generic"/>
</xsl:template>

<xs:template>
  <para>
    Column sets serialize the column and key components separately
  </para>
</xs:template>
<xsl:template match="ColumnSet">
  <l n="Columns">
    <xsl:for-each select="Column">
      <o>
        <xsl:if test="@Use='required'">
          <s n="Required" v="true"/>
        </xsl:if>
        <xsl:call-template name="gu:handleGenericElement">
          <xsl:with-param name="exceptions" select="@Use"/>
        </xsl:call-template>
      </o>
    </xsl:for-each>
  </l>
  <l n="Keys">
    <xsl:for-each select="Key">
      <o>
        <xsl:call-template name="gu:handleGenericElement"/>
      </o>
    </xsl:for-each>
  </l>
</xsl:template>

<xs:template>
  <para>
    Column sets serialize the column and key components separately
  </para>
</xs:template>
<xsl:template match="Data" mode="gu:generic">
  <xsl:for-each select="@Type">
    <s n="DataType" v="{.}"/>
  </xsl:for-each>
  <xsl:for-each select="@Lang">
    <s n="DataLanguage" v="{.}"/>
  </xsl:for-each>
</xsl:template>

<xs:template>
  <para>
    Column references are handled explicitly
  </para>
</xs:template>
<xsl:template match="ColumnRef" mode="gu:generic">
  <xsl:for-each select="@Ref">
    <s n="ColumnRef" v="{.}"/>
  </xsl:for-each>
</xsl:template>

<xs:template>
  <para>
    When not verbose, the list of codes is simplified
  </para>
</xs:template>
<xsl:template match="SimpleCodeList[starts-with('no',lower-case($verbose))]">
  <l n="Codes">
    <xsl:for-each select=" Row">
      <o>
        <xsl:for-each select="Value">
          <s n="{@ColumnRef}" v="{SimpleValue}"/>
        </xsl:for-each>
      </o>
    </xsl:for-each>
  </l>
</xsl:template>

<!--========================================================================-->
<xs:doc>
  <xs:title>Housekeeping, etc.</xs:title>
</xs:doc>

<xs:template>
  <para>
    Generic serializations simply create property strings.
  </para>
  <para>
    Note that this does not handle attributes and elements of the same name
    and namespace.
  </para>
  <para>
    Note that this does not handle mixed content.
  </para>
  <xs:param name="isList">
    <para>
      The invoker of this is putting the content in a list, so the name isn't
      needed.
    </para>
  </xs:param>
</xs:template>
<xsl:template match="*" mode="gu:generic">
  <xsl:param name="isList" as="xsd:boolean" select="false()"/>
  <xsl:choose>
    <xsl:when test="empty(*) and empty(@*)">
      <!--this element is just a string-->
      <xsl:choose>
        <xsl:when test="$isList">
          <s v="{.}"/>
        </xsl:when>
        <xsl:otherwise>
          <s n="{local-name(.)}" v="{.}"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:when>
    <xsl:when test="$isList">
      <o>
        <xsl:call-template name="gu:handleGenericElement"/>
      </o>
    </xsl:when>
    <xsl:otherwise>
      <!--presume the element contains element content-->
      <o n="{local-name(.)}">
        <xsl:call-template name="gu:handleGenericElement"/>
      </o>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xs:template>
  <para>
    Handle a given generic element
  </para>
  <xs:param name="exceptions">
    <para>Which nodes are not to be handled</para>
  </xs:param>
</xs:template>
<xsl:template name="gu:handleGenericElement">
  <xsl:param name="exceptions" as="node()*"/>
  <!--first do the attributes-->
  <xsl:for-each-group select="@* except $exceptions"
                      group-by="namespace-uri(.)">
    <xsl:choose>
      <xsl:when test="namespace-uri(.) = ''">
        <xsl:for-each select="current-group()">
          <s n="{local-name(.)}" v="{.}"/>
        </xsl:for-each>
      </xsl:when>
      <xsl:otherwise>
        <o n="{namespace-uri(.)}">
          <xsl:for-each select="current-group()">
            <s n="{local-name(.)}" v="{.}"/>
          </xsl:for-each>
        </o>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:for-each-group>

  <!--next do the elements-->
  <xsl:for-each-group select="* except $exceptions"
                      group-by="namespace-uri(.)">
    <xsl:choose>
      <xsl:when test="namespace-uri(.) = ''">
        <xsl:call-template name="gu:handleGenericElementContent"/>
      </xsl:when>
      <xsl:otherwise>
        <o n="{namespace-uri(.)}">
          <xsl:call-template name="gu:handleGenericElementContent"/>
        </o>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:for-each-group>
  
  <!--if no elements, then this is a string value-->
  <xsl:if test="not(*)">
    <s n="_" v="{.}"/>
  </xsl:if>
</xsl:template>

<xs:template>
  <para>Handle generic content of elements</para>
</xs:template>
<xsl:template name="gu:handleGenericElementContent">
  <xsl:for-each-group select="current-group()" group-by="local-name()">
    <xsl:choose>
      <xsl:when test="count(current-group())=1">
        <xsl:apply-templates select="." mode="gu:generic"/>
      </xsl:when>
      <xsl:otherwise>
        <l n="{local-name(.)}">
          <xsl:apply-templates select="current-group()"
                               mode="gu:generic">
            <xsl:with-param name="isList" select="true()"/>
          </xsl:apply-templates>
        </l>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:for-each-group>
</xsl:template>

<xs:template>
  <para>
    A pushed text node is ignored as it is assumed to be indentation.
  </para>
</xs:template>
<xsl:template match="text()"/>

<xs:template>
  <para>
    The identity template is used to copy all nodes not already being handled
    by other template rules.
  </para>
</xs:template>
<xsl:template match="*">
  <xsl:message select="'Not handled: ', gu:xpath(.)"/>
</xsl:template>

<xs:function>
  <para>Return the XPath of the given node</para>
  <xs:param name="node"><para>The node to report on</para></xs:param>
</xs:function>
<xsl:function name="gu:xpath" as="xsd:string">
  <xsl:param name="node" as="node()"/>
  <xsl:for-each select="$node">
    <xsl:value-of>
        <xsl:for-each select="ancestor-or-self::*">
        <xsl:text/>/<xsl:value-of select="name(.)"/>
        <xsl:if test="parent::*">[<xsl:number/>]</xsl:if>
      </xsl:for-each>
      <xsl:if test="not(self::*)">
        <!--must be an attribute-->
        <xsl:text/>/@<xsl:value-of select="name(.)"/>
      </xsl:if>
    </xsl:value-of>
  </xsl:for-each>
</xsl:function>

</xsl:stylesheet>
