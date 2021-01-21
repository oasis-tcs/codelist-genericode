Members of the [OASIS Code List Representation TC](https://www.oasis-open.org/committees/codelist/) create and manage technical content in this TC GitHub repository (https://github.com/oasis-tcs/codelist-genericode/) as part of the TC's chartered work (the program of work and deliverables described in its [charter](https://www.oasis-open.org/committees/codelist/charter.php).

OASIS TC GitHub repositories, as described in [GitHub Repositories for OASIS TC Members' Chartered Work](https://www.oasis-open.org/resources/tcadmin/github-repositories-for-oasis-tc-members-chartered-work), are governed by the OASIS [TC Process](https://www.oasis-open.org/policies-guidelines/tc-process), [IPR Policy](https://www.oasis-open.org/policies-guidelines/ipr), and other policies. While they make use of public GitHub repositories, these repositories are distinct from [OASIS Open Repositories](https://www.oasis-open.org/resources/open-repositories), which are used for development of open source [licensed](https://www.oasis-open.org/resources/open-repositories/licenses) content.

## Description

The OASIS genericode specification incorporates documentation and a number of supporting machine-readable artefacts for the representation and IT-enablement of coded domains populated by "a set of codes representing X". Per the [ISO/IEC 14662 Open-edi Reference Model](https://standards.iso.org/ittf/PubliclyAvailableStandards/) this will satisfy an implementation of the Functional Services View of code lists where the Business Operational View is documented in [ISO/IEC 15944-10 IT-enabled coded domains as semantic components in business transactions](https://standards.iso.org/ittf/PubliclyAvailableStandards/).

The documentation is to be authored in XML and published in two layouts: the OASIS specification layout and the ISO/IEC Directives Part 2 layout (the latter for potential PAS submission to JTC 1 for international standardization).

Various artefacts, existing and identified to be developed, will be incorporated into the repository for inclusion in the final deliverable.

## Branches and protocol for contributions

Maintainers are asked not to check in any changes to the `main` and `review` branches:

- `main` - this is content that has been reviewed by committee members and considered acceptable to be distributed for its intended purpose (which may be for testing or for production use, not necessarily for final use)
- `review` - this is content from the editor that has not been reviewed by committee members yet, and so is not considered agreed upon for its intended purpose, but the editor has incorporated input from other sources into a package for review; when there is consensus about the content of the `review` branch, it is snapshot in the `main` branch

Contributions are requested to be submitted by pull requests against the `review` branch to be incorporated by the editor. Maintainers can create and delete any number of their own branches as they see fit. The act of checking in will automatically trigger the publishing of the authored XML into OASIS layout PDF, OASIS layout HTML, and ISO Directives Part 2 layout PDF. See "[Published results](#Published-results)" below.


## Repository contents

Directories:
- `.github/workflows` - the automated publishing and packaging process triggers performed for every check-in
- `cs01` - the results of publication of the Committee Specification 01 - 28 December 2007
- `doc` - documentation inputs
- `oXygen-frameworks` - document authoring support for the oXygen XML tool (see the directory README file)
- `sch` - Schematron value constraints
- `utilities/ant` - publishing process support
- `xsd` - W3C XML Schema structural constraints

Files:
- `produceGenericode.*` - publishing and packaging process files converting XML to end-user PDF and HTML documents
- `realta*` - publishing support files

## Published results

The published results are not stored in the GitHub repository, _per se_.

See the [Actions tab](https://github.com/oasis-tcs/codelist-genericode/actions) for the results of publishing processes and distribution packaging, being careful to note the branch indicated. At particular milestones (typically when the `main` branch is updated), these files are archived in the [committee Kavi documentation (members only)](https://www.oasis-open.org/apps/org/workgroup/codelist/documents.php) [(Public access)](https://www.oasis-open.org/committees/documents.php?wg_abbrev=codelist&show_descriptions=yes).

Each downloaded result is doubly-zipped: the outer zip for GitHub extraction purposes and the inner zip for posting to Kavi and distribution. The `archive-only-not-in-final-distribution/` subdirectory is not meant for inclusion in the final home in the [OASIS document server](https://docs.oasis-open.org/codelist), only for archive purposes in Kavi.

For genericode v1.0 cs02, the chain of package ZIP files begins [here for OASIS members](https://www.oasis-open.org/apps/org/workgroup/codelist/document.php?document_id=68158) and [here for the general public](https://www.oasis-open.org/committees/document.php?document_id=68158), but be careful to note the links are to the _start_ of the chain. See the top of the document revision history below the metadata for the most current package in the chain of uploaded revisions.

The results in the Actions tab eventually are deleted automatically by GitHub, but if you have no need for a particular build result, you can delete it to save space, because of the multiple ZIPs the downloads are quite large (>50Mb).

## Contributions

As stated in this repository's [CONTRIBUTING](https://github.com/oasis-tcs/codelist-genericode/blob/master/CONTRIBUTING.md) file, contributors to this repository must be Members of the OASIS Code List Representation TC for any substantive contributions or change requests.  Anyone wishing to contribute to this GitHub project and [participate](https://www.oasis-open.org/join/participation-instructions) in the TC's technical activity is invited to join as an OASIS TC Member. Public feedback is also accepted, subject to the terms of the [OASIS Feedback License](https://www.oasis-open.org/policies-guidelines/ipr#appendixa). 

## Licensing

Please see the [LICENSE](https://github.com/oasis-tcs/codelist-genericode/blob/master/LICENSE.md) file for description of the license terms and OASIS policies applicable to the TC's work in this GitHub project. Content in this repository is intended to be part of the Code List Representation TC's permanent record of activity, visible and freely available for all to use, subject to applicable OASIS policies, as presented in the repository [LICENSE](https://github.com/oasis-tcs/codelist-genericode/blob/master/LICENSE.md). 

## Contact

Please send questions or comments about [OASIS TC GitHub repositories](https://www.oasis-open.org/resources/tcadmin/github-repositories-for-oasis-tc-members-chartered-work) to the [OASIS TC Administrator](mailto:tc-admin@oasis-open.org).  For questions about content in this repository, please contact the TC Chair or Co-Chairs as listed on the Code List Representation TC's [home page](https://www.oasis-open.org/committees/codelist/).
