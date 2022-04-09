<?xml version="1.0" encoding="UTF-8"?>
<!--
  This is the set of extra-schema business rules for OASIS genericode files
  as described in the conformance section 4.2 of the genericode specification.
  
  Not all of the rules are testable with Schematron.
  
  20210930-1400z

  Copyright (c) OASIS Open 2021. All Rights Reserved.
-->
<schema xmlns="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt2"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xsl:version="2.0">
  
  <let name="availableColumns"
       value="/*/ColumnSet/Column"/>
  <let name="requiredColumns"
       value="$availableColumns[@Use='required']"/>
  
  <pattern>
    <!--Rule 1-->
    <rule context="SimpleCodeList">
      <assert test="count(/*/ColumnSet/Key)>0"
        >Rule 1 - A code list must have at least one key, unless it is a metadata-only definition without a SimpleCodeList element</assert>
    </rule>
    <!--Rules 4, 6, 25, 27, 30, 32, 44, 48, 50-->
    <rule context="CanonicalUri | CanonicalVersionUri">
      <assert test="matches(.,'^\w+:')">Rules 4, 6, 25, 27, 30, 32, 44, 48, 50 - Must be an absolute URI, must not be relative.</assert>
    </rule>
    <!--Rule 19-->
    <rule context="Data">
      <report test="contains(@Type,':')"
        >Rule 19 - The datatype ID must not include a namespace prefix.</report>
    </rule>
    <!--Rule 24-->
    <rule context="@ExternalRef">
      <report test="starts-with(.,'#')"
        >Rule 24 - The external reference must not be prefixed with a '#' symbol.</report>
    </rule>
    <!--Rule 34-->
    <rule context="Key">
      <assert test="exists($requiredColumns[@Id=current()/ColumnRef/@Ref])"
        >Rule 34 - Only required columns can be used for keys.</assert>
    </rule>
    <!--Rule 39-->
    <rule context="ShortName">
      <report test="matches(.,'\s')"
        >Rule 39 - Must not contain whitespace characters.</report>
    </rule>
    <!--Rule 42-->
    <rule context="ComplexValue">
      <assert test="every $name in */local-name(.) satisfies
                    for $id in ancestor::Value[1]/@ColumnRef return
                    normalize-space($availableColumns[@Id=$id][1]/Data/@Type)=
                    ('*',$name)"
        >Rule 42 - The names of all direct child elements of the 'ComplexValue' element must match the datatype ID for the matching column, unless that ID is set to '*' (&lt;Row> <value-of
          select="1 + count( ancestor::Row/preceding-sibling::Row)"/>) expecting: <value-of
          select='for $id in ancestor::Value[1]/@ColumnRef return
                    normalize-space($availableColumns[@Id=$id][1]/Data/@Type)'/></assert>
      <assert test="every $uri in */namespace-uri(.)[normalize-space(.)] satisfies
                    for $id in ancestor::Value[1]/@ColumnRef return
         normalize-space($availableColumns[@Id=$id][1]/Data/@DatatypeLibrary)=
         ('*',$uri)"
        >Rule 43 - The namespace URIs of all direct child elements of the 'ComplexValue' element must match the datatype library URI for the matching column, unless that URI is set to '*' (&lt;Row> <value-of
          select="1 + count( ancestor::Row/preceding-sibling::Row)"/>) expecting: <value-of
          select='for $id in ancestor::Value[1]/@ColumnRef return
                    normalize-space($availableColumns[@Id=$id][1]/Data/@DatatypeLibrary)'/></assert>
    </rule>
    <!--rules associated with each <Row> element-->
    <rule context="Row">
      <let name="thisRowsIds" value="Value/@ColumnRef"/>

      <!--Rule 37-->
      <report test="some $id in $requiredColumns/@Id
                    satisfies not( $id = $thisRowsIds )"
        >Rule 37 - A value must be provided for each required column (&lt;Row> <value-of
          select="1 + count( preceding-sibling::Row)"/>): <value-of
          select="$requiredColumns/@Id[not(.=$thisRowsIds)]"/></report>

      <!--Miscellaneous integrity rules-->
      <!--any column can have only one definition in a given row-->
      <report test="some $ref in Value/@ColumnRef 
                    satisfies $ref = ( Value except $ref/.. )/@ColumnRef"
        >Duplicate column references not allowed in a given row (&lt;Row> <value-of
          select="1 + count( preceding-sibling::Row)"/>): <value-of
          select='for $dup in distinct-values( Value/@ColumnRef/string(.) ) return
                  if( count(Value/@ColumnRef[. = $dup]) > 1 )
                  then concat("ColumnRef=""",$dup,"""") else ()'/></report>
      
    </rule>
  </pattern>

</schema>