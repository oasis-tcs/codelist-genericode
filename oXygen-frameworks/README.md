# oXygen framework for genericode files

- _Note: This directory is provided as a convenience to users and is not considered part of the formal specification for genericode nor a formal work product._

This directory assembles the validation artefacts (XML schema and Schematron schema) used to validate a genericode file being edited in the [oXygen Editor](http://oxygenxml.com) tool. Both in-development and stable versions of the artefacts are available.

To add these to your environment (per v23), add this git subdirectory named "'oXygen-framework'" as one of your document type association locations. The locations are found in the preferences dialogue in "Locations" under "Document Type Association". This location is the parent directory of the added frameworks. Exit the preferences with "OK" (important for cache reasons!).

Revisit the Preferences "Document Type Association" dialogue and you should see two document types "OASIS genericode 1.0" and "OASIS genericode 1.0 Development", both external frameworks with priority "Normal". The types are ordered alphabetically, upper-case before lower-case.

Whichever version of the framework you wish to use in real time must have higher priority than the framework you do not wish to use. Edit the entry in the Document Type Association list to move a given type up or down in the priority groups, but be careful only to change the Priority control and not anything else.
