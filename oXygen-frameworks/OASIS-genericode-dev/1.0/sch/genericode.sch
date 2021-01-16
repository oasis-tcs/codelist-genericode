<?xml version="1.0" encoding="UTF-8"?>
<!--
  This is the set of extra-schema business rules for OASIS genericode files.

  $Id: oasis-genericode.sch,v 1.2 2017/09/25 23:16:23 admin Exp $
-->
<schema xmlns="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt2"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xsl:version="2.0">
  
  <let name="requiredColumnIds"
       value="/*/ColumnSet/Column[@Use='required']/@Id"/>
  
  <pattern>
    <rule context="Row">
      <let name="thisRowsIds" value="Value/@ColumnRef"/>
      
      <!--any column can have only one definition in a given row-->
      <report test="some $ref in Value/@ColumnRef 
                    satisfies $ref = ( Value except $ref/.. )/@ColumnRef"
        >Duplicate column references not allowed; see &lt;Row> <value-of
          select="1 + count( preceding-sibling::Row)"/></report>
      
      <!--every row must have all required columns-->
      <report test="some $id in $requiredColumnIds
                    satisfies not( $id = $thisRowsIds )"
        >Required column references not found in  &lt;Row> <value-of
          select="1 + count( preceding-sibling::Row)"/>: <xsl:value-of
          select="$requiredColumnIds[not(.=$thisRowsIds)]"
          separator=", "/></report>
    </rule>
  </pattern>

</schema>