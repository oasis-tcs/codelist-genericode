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
  <xs:title>Distill genericode rules into entities for publishing</xs:title>
  <para>
    To preserve the integrity of the conformance rules to the rules found
    in the body of the genericode specification, this reads the genericode
    XML finding all of the declared rules and writes out two entity files,
    one for document rules and one for application rules.
  </para>
  <para>
    These entity files are incorporated into genericode.xml during the
    publishing process.
  </para>
</xs:doc>

<!--========================================================================-->
<xs:doc>
  <xs:title>Invocation parameters and input file</xs:title>
  <para>
    The main input file is the genericode.xml specification.
  </para>
  <para>
    There are no invocation parameters as the output entity filenames are
    hardwired in sync with the specification document.
  </para>
</xs:doc>

<!--========================================================================-->
<xs:doc>
  <xs:title>Main processing</xs:title>
</xs:doc>

<xs:variable>
  <para>
    Find all of the rules in the document
  </para>
</xs:variable>
<xsl:variable name="g:rules" as="element(informaltable)+" select=
     "//informaltable[@role='rule'][(.//emphasis)[1][starts-with(.,'Rule')]]"/>

<xs:template>
  <para>
    Find each of the rule types creating an entity file for each.
  </para>
</xs:template>
<xsl:template match="/">
  <!--validate the inputs-->
  <xsl:variable name="ruleReferences" as="xsd:integer*">
    <xsl:for-each select="$g:rules">
      <xsl:sequence select=
            "xsd:integer(replace((.//emphasis)[1],'Rule (\d+) \[.+$','$1'))"/>
    </xsl:for-each>
  </xsl:variable>
  <xsl:variable name="messages">
    <xsl:for-each select="1 to max($ruleReferences)">
      <xsl:choose>
        <xsl:when test="count($ruleReferences[.=current()]) = 0">
          <xsl:value-of select="'Missing rule:',.,'&#xa;'"/>
        </xsl:when>
        <xsl:when test="count($ruleReferences[.=current()]) > 1">
          <xsl:value-of select="'Duplicate rule:',.,'&#xa;'"/>
        </xsl:when>
      </xsl:choose>
    </xsl:for-each>
  </xsl:variable>
  <xsl:if test="normalize-space($messages)">
    <xsl:message select="$messages" terminate="yes"/>
  </xsl:if>
  
  <!--prepare the outputs-->
  <xsl:result-document href="rule-summary-document.ent.xml" indent="yes">
    <xsl:call-template name="g:distillPerType">
      <xsl:with-param name="type">document</xsl:with-param>
    </xsl:call-template>
  </xsl:result-document>
  <xsl:result-document href="rule-summary-application.ent.xml" indent="yes">
    <xsl:call-template name="g:distillPerType">
      <xsl:with-param name="type">application</xsl:with-param>
    </xsl:call-template>
  </xsl:result-document>
</xsl:template>

<xs:template>
  <para>
    Find each of the rules of a given type
  </para>
  <xs:param name="type">
    <para>Either 'documentation' or 'application' as a rule type</para>
  </xs:param>
</xs:template>
<xsl:template name="g:distillPerType">
  <xsl:param name="type" as="xsd:string" required="yes"/>
  <xsl:for-each select="$g:rules//entry
                        [(.//emphasis)[1][contains(.,concat('[',$type,']'))]]">
    <xsl:sort select=
                 "number(replace((.//emphasis)[1],'Rule (\d+) \[.+$','$1'))"/>
    <xsl:variable name="sectionID" select="ancestor::section[1]/@id"/>
    <para>
      <emphasis role="bold">
        <xsl:text>Rule </xsl:text>
        <xsl:value-of select=
                         "replace((.//emphasis)[1],'Rule (\d+) \[.+$','$1')"/>
        <xsl:text> [</xsl:text>
        <link linkend="{ancestor::informaltable[@role='rule'][1]/@id}">
          <xsl:value-of select="$type"/>
          <xsl:text>:: </xsl:text>
          
          <!--is this in a table inside of the declared construct?-->
          <xsl:for-each select="ancestor::informaltable[@role='rule'][1]/
                                ancestor::row[1]">
            <xsl:value-of
                    select="lower-case(ancestor::tgroup/thead/row[1]/entry[1]),
                            entry[1]"/>
            <xsl:text> in </xsl:text>
          </xsl:for-each>
          
          <!--declared construct-->
          <xsl:analyze-string select="ancestor::section[1]/title"
                              regex="^(\S+) \(([^)]+)\)$">
            <xsl:matching-substring>
              <xsl:value-of
                           select="lower-case(substring(regex-group(2),1,1))"/>
              <xsl:value-of
                       select="translate(substring(regex-group(2),2),' ','')"/>
              <xsl:text> </xsl:text>
              <xsl:value-of select="regex-group(1)"/>
            </xsl:matching-substring>
            <xsl:non-matching-substring>
              <xsl:message terminate="yes" select="
                                 concat('Unexpected rule title in section id=',
                                        $sectionID,'; ''',.,'''')"/>
            </xsl:non-matching-substring>
          </xsl:analyze-string>
        </link>
        <xsl:text>]</xsl:text>
      </emphasis>
    </para>
    <xsl:apply-templates select="ancestor::informaltable[@role='rule'][1]"/>
  </xsl:for-each>
</xsl:template>

<xs:template>
  <para>Preserve content of rule providing for specialization</para>
</xs:template>
<xsl:template match="@*|node()">
  <xsl:copy>
    <xsl:apply-templates select="@*,node()"/>
  </xsl:copy>
</xsl:template>

<xs:template>
  <para>Suppress these nodes</para>
</xs:template>
<xsl:template match="@role | @id |
                     para[emphasis][starts-with(.,'Rule')]"/>

</xsl:stylesheet>
