---
title: "IOOS Animal Acoustic Telemetry (AAT) Data Project: Improving Access to AAT Observations"
keywords: homepage
tags: [ATN, AAT, observations, animal telemetry]
sidebar: mydoc_sidebar
topnav: topnav
toc: false
#permalink: index.html
summary: A brief description of the IOOS-supported project for Animal Acoustic Telemetry (AAT) in the Pacific NW.
---


<!--
* TOC
{:toc}
  -->

# Introduction and Objectives  

As part of the [IOOS Animal Telemetry Network](http://www.ioos.noaa.gov/observing/animal_telemetry/welcome.html) efforts, in 2012-2013 IOOS supported a community needs assessment and data-access standards and technology development project for animal acoustic telemetry (AAT)  data. The AAT project was co-led by IOOS, NANOOS (the IOOS Regional Association for the Pacific Northwest), the Pacific Ocean Shelf Tracking Project (POST, which is no longer in operation), and the Ocean Tracking Network (OTN). 

The _primary outcomes_ were the development of data exchange standards and best-practice data delivery systems that are now being implemented at a wider scale by OTN to provide access to their [OTN Northeast Pacific data node](http://members.oceantrack.org/data/discovery/NEPACIFIC.htm), which includes POST data.

This project has built on existing [IOOS DMAC guidance](http://www.ioos.noaa.gov/data/welcome.html ) and activities regarding biological and broader oceanographic data access.

# Principal Project Stakeholders and Other Partners

 - [U.S. Integrated Ocean Observing System (U.S. IOOS)](http://www.ioos.noaa.gov)
 - [Pacific Northwest Association of Networked Ocean Observing Systems (NANOOS)](http://www.nanoos.org)
 - [Ocean Tracking Network (OTN)](http://oceantrackingnetwork.org)
 - [Pacific Ocean Shelf Tracking Project (POST)](http://en.wikipedia.org/wiki/Pacific_Ocean_Shelf_Tracking_Project), no longer in operation

Although the AAT project focused on the Pacific NW for needs assessments and data testing, it brought together not only regional partners such as the [NOAA Northwest Fisheries Center](http://www.nwfsc.noaa.gov) and the [Hydra system](http://hydra3.sound-data.com/about/), but also national, Canadian and Australian collaborators.

# Project Documentation and Reports

  - [Statement of Work](http://habu.apl.washington.edu/mayorga/aat/Animal%20Acoustic%20Telemetry%20Obs_SOW.pdf)
  - [POST Data System Description](http://habu.apl.washington.edu/mayorga/aat/POST_DataSystemDescription_DRAFT1.0.pdf)
  - Customer Requirements Assessment
     - [Survey Questionnaire](http://habu.apl.washington.edu/mayorga/aat/AAT_CustomerRequirementsQuestionnaire.pdf)
     - [Survey results and requirements synthesis](http://habu.apl.washington.edu/mayorga/aat/AAT_CustomerRequirements_2012Sep4.pdf). This document includes a brief comparison of some existing systems.
  - [Content Standard: A metadata convention for animal acoustic telemetry data (document and tables)](http://ioostech.googlecode.com/files/AAT%20Metadata%20Convention%20v1.2.pdf)
  - [Data System Architecture Implementation Plan](http://habu.apl.washington.edu/mayorga/aat/AAT_DataSystemArchitectureImplementationPlan_FINAL.pdf)
     - [Presentation by Emilio Mayorga at the Final AAT meeting, June 2013](http://habu.apl.washington.edu/mayorga/aat/Emilio_Presentation_AATworkshop_2013Jun13.pdf)


# Project Data Services

 * Data Services being implemented by this project are based on [ERDDAP](http://coastwatch.pfeg.noaa.gov/erddap/index.html) and [GeoServer](http://geoserver.org). Configuration files and instructions to set up ERDDAP and GeoServer instances for AAT data will be provided at the end of the project.
 * A collection of Python data access and visualization scripts that illustrated these services are [accessible as IPython notebooks](https://www.mygists.info/emiliom/tags/animalacoustictelem). Here are two that access data from ERDDAP: [Example 1](http://nbviewer.ipython.org/6767422) and [Example 2](http://nbviewer.ipython.org/6767450).
 * Dataset ISO Metadata from ERDDAP, with experimental, partial XSL style sheet
   * [Live-rendering (as HTML) example, in javascript](http://habu.apl.washington.edu/mayorga/aat/ISOMetadataFinalExamplePackage/xslt_client.html)
   * [XML](http://habu.apl.washington.edu/mayorga/aat/ISOMetadataFinalExamplePackage/otnnepMOSERAnTags_iso19115.xml) and [XSL](http://habu.apl.washington.edu/mayorga/aat/ISOMetadataFinalExamplePackage/OTNmetadata_Emilio.xsl) documents used in the example. The XML document is static and was pre-fetched from ERDDAP.
 * AAT NANOOS PostgreSQL/PostGIS database and ERDDAP service configuration
    * [Package documentation](http://habu.apl.washington.edu/mayorga/aat/AAT_NANOOSConfigurations_FinalPackageDocs.pdf)
   * [Zip file with documentation, code, and configuration files](http://habu.apl.washington.edu/mayorga/aat/AAT_NANOOSpg2erddap_exchange.zip)
 * [AAT_ERDDAP_datasets_listing_and_properties.xls](http://habu.apl.washington.edu/mayorga/aat/AAT_ERDDAP_datasets_listing_and_properties.xls)
 * [ERDDAP global attributes: Dataset & Discovery Metadata](http://habu.apl.washington.edu/mayorga/aat/ERDDAPDatasetMetadata-UseAndStatus-FINAL.pdf)
 * QGIS project file
 * GeoServer GetCapabilities XML documents (static, pre-generated): [WMS](http://habu.apl.washington.edu/mayorga/aat/geoserver-otnnep-WMS-GetCapabilities.xml) & [WFS](http://habu.apl.washington.edu/mayorga/aat/geoserver-otnnep-WFS-GetCapabilities.xml)

>_**NOTE:** Other documents and configuration files that becomes available may be referenced here._

# AAT Metadata Convention 

## Origin of the Convention

The AAT Metadata Convention is based on data input forms from Pacific Ocean Shelf Tracking (POST), Ocean Tracking Network (OTN), Great Lakes Acoustic Telemetry Observation System (GLATOS), HYDRA, and The Integrated Marine Observing System (IMOS, the Australian Animal Tagging and Monitoring System (AATAMS), with additional feedback from other individual researchers and database operators such as Tagging Of Pacific Predators (TOPP) and Kintama Research.

## Purpose of the Convention

The purpose of the [AAT Metadata Convention (pdf)](http://ioostech.googlecode.com/files/AAT%20Metadata%20Convention%20v1.2.pdf) is to ensure that: 
  * Enough information is transmitted to make data understandable (hence “required” fields)
  * The origin of the data is clear, and credit (attribution) is maintained
  * The receiving system can interpret the transmitted data without human intervention, including if necessary how flat files can be reassembled into a structure such as linked database tables.

The [vocabulary defined by the AAT Metadata Convention](http://mmisw.org/ont/ioos/animal_acoustic_telemetry) is hosted on the [IOOS MMI ontological repository](http://mmisw.org/ont/ioos/). Individual terms may be referenced from it via MMI URL's, such as http://mmisw.org/ont/ioos/animal_acoustic_telemetry/animal_origin

# Other Resources 

## IOOS Biology Data projects

  * http://www.ioos.noaa.gov/dmac/biology/welcome.html
  * http://www.ioos.noaa.gov/observing/animal_telemetry/welcome.html
  * [NOAA National Ocean Service Podcast (April 2013): Today on Diving Deeper, we explore the world of animal tagging with Zdenka Willis from the U.S. Integrated Ocean Observing System.](http://oceanservice.noaa.gov/podcast/p0413.html#dd46)

## POST and relevant OTN Data repository

  * [Ocean Tracking Network NE PACIFIC Ocean Data Series](http://members.oceantrack.org/data/discovery/NEPACIFIC.htm)

## ISO Dataset metadata (the 19115-related family)
 
The NOAA Geo-IDE site has a nice [summary](https://geo-ide.noaa.gov/wiki/index.php?title=ISO_FAQ#What_are_all_of_these_numbers.3F) of the differences between the three inter-related ISO metadata standards 19139, 19115 and 19115-2. But it doesn't address the _**"Marine Community Profile (MCP) of ISO 19115"**_. Here's a summary of the 3 ISO standards and one community profile:

  * **ISO 19115** is [the base ISO metadata standard for the description of geographic information and services](http://www.fgdc.gov/metadata/geospatial-metadata-standards) (expected to be replaced by ISO 19115-1:2014 - Geographic Information – Metadata – Part 1: Fundamentals)
  * **ISO 19139** [defines an XML document that specifies the format and general content of the metadata record for ISO 19115.](http://www.fgdc.gov/metadata/geospatial-metadata-standards) So, 19115 is the content model, 19139 is the packaging.
  * **ISO 19115-2** has emerged in IOOS, oceanographic and meteorological circles as the ISO standard of choice for environmental datasets. ["Unfortunately, the name of 19115-2 is a bit misleading. It is essentially an extension of 19115 that adds information about missions, platforms and sensors, along with a few other things. Most environmental observations involve sensors, so 19115-2 is probably the right standard to use for most environmental datasets, not just imagery or gridded data."](https://geo-ide.noaa.gov/wiki/index.php?title=ISO_FAQ#What_are_all_of_these_numbers.3F). _ERDDAP uses ISO 19115-2 as its ISO dataset metadata standard._
  * The **Marine Community Profile (MCP) of ISO 19115** was defined by the Australian Ocean Data Centre around 2008. MCP ["supports the documentation and discovery of marine spatial datasets and forms the foundation of the Marine Catalogue. The MCP has been developed in accordance with the rules established by the International Standard ISO 19115 Geographic information - Metadata. The MCP is a subset of the standard and includes all ISO 19115 core metadata elements. In addition, the MCP has defined supplementary elements, codelists and controlled vocabularies to assist in the description of marine resources."](http://www.aodc.org.au/index.php?id=37). _OTN is using the MCP._

## Data Services used by animal acoustic telemetry groups 

  * [OTN](http://oceantrackingnetwork.org/): Geoserver, OGC WMS, KML

## Other relevant systems 

  * http://hydra3.sound-data.com
  * http://data.glos.us/glatos
  * http://aatams.emii.org.au/aatams/

## Miscellaneous

   * [Xtractomatic scripts for R and Matlab](http://coastwatch.pfel.noaa.gov/xtracto/), written by [Dave Foley](dave.foley@noaa.gov): the scripts make it easy to subset and extract from a remote server a satellite and other physical oceanography data (e.g., sea surface temperature, chlorophyll a) related to each point of an animal's track.
  * [Examples of IPython notebook](https://gist.github.com/rsignell-usgs), put together by Rich Signell. Many of them focus on accessing netCDF/OPeNDAP datasets.