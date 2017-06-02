---
title: Overview of the IOOS SOS 1.0 Guidelines Documentation
keywords: sample homepage
tags: [getting_started]
sidebar: mydoc_sidebar
toc: false
permalink: index.html
summary: These brief descriptions summarize the content of the Guidelines. The other topics on this site provide additional information and detail about working with all aspects of the IOOS SOS 1.0.
---

## About IOOS SOS Application Profile

U.S. IOOS distributes ocean observations using the OGC Sensor Observation Service. To support this effort U.S. IOOS has developed a profile of SOS v1.0 (henceforth IOOS SOS v1.0) that includes specific behaviors for the SOS interface and for the output formats delivered in response to the three operations of the SOS Core Profile.
The GitHub repository contains documentation of the IOOS SOS v1.0 profile, example templates for the responses, and information on two reference implementations developed to support the IOOS SOS v1.0 profile. To facilitate the practical implementation of the SOS, IOOS has developed the IOOS Application Profile (AP) for SOS, which includes a series of operation templates, controlled vocabularies, IOOS Conventions for SOS Implementation, and a set of tests for IOOS SOS implementations.

### IOOS SOS 1.0 WSDD

The Web Service Description Document (WSDD) provides a description of a Sensor Observation Service (SOS) that has been developed by U.S. IOOS for deployment by NOAA data providers and IOOS Regional Associations (RAs). This service provides a service consumer with the capability to access ocean observations data products, such as time series and profiles, which have XML-based encodings and included in the SWE Common Data Model.

### IOOS SOS 1.0 Templates

 * GetCapabilities: A template for generic (independent of feature type) GetCapabilities response.
 * DescribeSensor-Network: A template for generic (independent of feature type) SensorML DescribeSensor response (network of stations)
 * DescribeSensor-Station: A template for generic (independent of feature type) SensorML DescribeSensor response (single station)
 * OM GetObservation: A template for a generic (independent of feature type) GetObservation response (the result block in this template is empty; see SWE templates for guidance on the result block)
* SWE-SingleStation-SingleProperty-TimeSeries: A template for SWE Data Record’s static and dynamic fields (single station with a single sensor)
 * SWE-SingleStation-TimeSeriesProfile: A template for SWE Data Record’s static and dynamic fields (a station with profiling sensors)
 * SWE-SingleStation-TimeSeriesProfile-QC: A template for SWE Data Record’s static and dynamic fields (a station with profiling sensors including quality elements for some quantities)
 * SWE-MultiStation-TimeSeries: A template for SWE Data Record’s static and dynamic fields (multiple stations with a variety of sensors)
 * SWE-MultiStation-TimeSeries-QC: A template for SWE Data Record’s static and dynamic fields (multiple stations with a variety of sensors including quality elements for some quantities)

### IOOS SOS 1.0 Compliance and Interoperability Tests

This document describes a collection of tests that have to be run in order to ensure a required level of compliance with IOOS SOS Profile 1.0 (IOOS Convention), and official OGC SOS 1.0.0 specification.
 