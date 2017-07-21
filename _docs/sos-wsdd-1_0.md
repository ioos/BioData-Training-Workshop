---
title: IOOS SOS WSDD 1.0
tags: [formatting]
keywords: notes, tips, cautions, warnings, admonitions
last_updated: July 3, 2016
summary: IOOS SOS v1.0 Web Service Description
sidebar: mydoc_sidebar
#topnav: topnav
toc: false
#permalink: sos-wsdd-github-notoc.html
---

<!--
* TOC
{:toc}
  -->


# **Overview**{: style="color: crimson"} 

This Web Service Description Document (WSDD) provides a description of a Sensor Observation Service (SOS) that has been developed by U.S. IOOS for deployment by NOAA data providers and IOOS Regional Associations (RAs). This service provides a service consumer with the capability to access ocean observations data products, such as time series and profiles, which are encoded in XML and included in the SWE Common Data Model.

The service interface is a collection of operations, messages, types and elements descriptions. It provides detail on how the SOS data requests and responses are constructed independent of the messaging transmission technology.

The Milestone 1.0 interface is considered a composition of several OGC specifications: in addition to the cornerstone Observations and Measurements standard, elements of the OGC Sensor Web Enablement Suite (SWE) have been identified as useful for the encoding and provision of observational data. While further SWE specifications may be implemented in the future Milestones, at the present IOOS have used the following:

- **Sensor Observation Service (SOS)** v1.0.0 as a service for the provision of observational data;
- **SensorML** v1.0.0 for the provision of procedural information;  and
- **SWE Common Data Model Encoding Standard** v1.0 and v2.0 for result encoding options.

The interface is comprised of some operations, parameters and attributes, which are considered mandatory by the specifications and others which are not. This information, referred to as a Profile, includes information on specification extensions (operations, parameters and attributes not included in a specification) and exclusions (operations, parameters and attributes that are not implemented). The following sections describe the IOOS SOS Profile for Milestone 1.0 providing additional detail about parts of the OGC specifications supported by the Milestone 1.0 implementation and how they are used.

# **Conformance to Standards and Conventions**{: style="color: crimson"}

## **OGC SOS Implementation Standards**{: style="color: crimson"}

[**Figure 1**](#Fig_1) depicts the Unified Modeling Language (UML) diagram for the OGC O&M core model, which specifies the core conformance classes, which are described within the SOS specification.

As the SOS 2.0 standard has been approved as an official OGC standard while Milestone 1.0 has already been in development, the use of this new and updated version was postponed to the Milestone 2.0, and at present, the SOS v1.0.0 is used for operations.

![](./sos-wsdd-image18.png)


<a name="Fig_1"></a> **Figure 1: Core Model Diagram for Observations and Measurements (O&M)**

The subsequent sections provide more detail on the service interfaces, including information on data types, messages, operations, and interface descriptions.

## **NetCDF Climate and Forecast Metadata Convention**{: style="color: crimson"}

The Climate and Forecast (CF) Conventions introduce the standard ways for naming and description of feature types, data components, dimensions, variables and attributes, coordinate systems definition, axis order, etc. The CF Conventions were originally framed as a standard for data written in netCDF format, with model-generated climate forecast data in mind. However, it turned out to be equally applicable to observational datasets presented in various other formats. The IOOS has adopted the CF 1.6 Conventions for both 52⁰North and ncSOS implementations in order to provide SWE encodings for the feature types that are relevant for the IOOS community. In IOOS SOS implementations, the CF Conventions are used for description of data quantities (such as CF standard names, physical descriptions, code spaces, UoMs, etc.) as well as data location in space and time.

## **IOOS Convention and SOS Templates**{: style="color: crimson"}

To facilitate the practical implementation of the OGC SOS, IOOS has started the development of a series of Templates that explicitly define the IOOS SOS operation responses for the CF feature types. Within Milestone 1.0 timeframe, the templates have only been developed for “point”, “timeSeries”, and “timeSeriesProfile” feature types ([https://code.google.com/p/ioostech/source/browse/#svn/trunk/templates/Milestone1.0](https://code.google.com/p/ioostech/source/browse/#svn/trunk/templates/Milestone1.0?state=open)); the templates for other feature types are planned for Milestone 2.0. The templates are intended as a mandatory guidance for all developers of IOOS-compliant SOS applications.

The Milestone 1.0 templates fully conform to the OGC SOS 1.0.0 Implementation Standard; however, in some “grey areas” where the SOS 1.0.0 is vague and does not provide sufficient guidance, it has been refined with a special IOOS Convention. The IOOS Convention contains additional constraints, definitions, requirements and “best practice” sort of recommendations that SOS 1.0.0 lacks; for future transition, the Convention follows SOS 2.0 requirements and definitions wherever they have been considered applicable, and do not contradict the SOS 1.0.0 specification. The provisions of the IOOS Convention are captured in the IOOS SOS Templates, and described further in this document.

## **Coordinate System Axis Order**{: style="color: crimson"}

Historically, there was considerable confusion regarding axis order in GML documents, and coordinate reference systems. This confusion started with the introduction of the very first version of theOGC WMS, where axis “x” (longitude) preceeded axis “y” (latitude), while coordinate reference systems defined the opposite order of axis. After some discussion, it was agreed that if CRS is explicitly defined in the service interface or payload, then coordinate values shall be listed in the axis order specified by the referred CRS ([OGC 06-135r1 “Specification best practices](http://portal.opengeospatial.org/files/?artifact_id=17566)”).

For IOOS SOS implementations, the CRS reference procedure is defined in OGC 06-121r3 “OGC Web Services Common Specification”, and additionally specified by the IOOS Convention. As the EPSG::4326 CRS is required to identify a station horizontal coordinates, the axis order must match the EPSG::4326 definition, i.e. latitude must precede longitude. The vertical coordinate must always be listed after the horizontal ones, and explicitly follow the definition of the vertical CRS.

## **Namespaces**{: style="color: crimson"}

The XML type references in the subsequent sections make use of XML namespace prefixes to fully qualify their namespaces. The map of prefixes to standardized namespaces is:

-   sos – "http://www.opengis.net/sos/1.0"
-   swe – http://www.opengis.net/swe/1.0.1” (SWE Common v1.0)
-   swe2 – http://www.opengis.net/swe/2.0” (SWE Common v2.0)
-   ows – "http://www.opengis.net/ows/1.1"
-   gml – "http://www.opengis.net/gml"
-   om – "http://www.opengis.net/om/1.0"
-   xlink –”http://www.w3.org/1999/xlink”
-   xsi – "http://www.w3.org/2001/XMLSchema-instance"

Note that an IOOS-compliant SOS service shall conform to the following specific patterns for the namespace references in the GetCapabilities and GetObservation response XML headers:

-   In GetCapabilities, and DescribeSensor the `<swe:>` prefix may be omitted, as only one version of SWE Common is used in these operations (see list above).
-   In GetObservation, the `<swe:>` and `<swe2:>` prefixes must present, as both SWE Common v1.0 and v2.0 are used in this operation, and the prefixes refer to different versions of SWE Common (see list above).
-   In both GetCapabilities and GetObservation, the `<gml:>` prefix may omit reference to a version number, as shown above (just because GML 3.1.1 has been a default version for the O&M 1.0 schema).

## **Capitalization**{: style="color: crimson"}

The use of the upper and lower cases in SOS response documents and requests is defined by the OGC 06-121r9 “OGC Web Services Common Standard”, clauses 11.5.2 and 11.6.2. To extend and augment the OGC assertions, IOOS Convention require the following:

-   service name must always be in UPPERCASE (i.e. “SOS”);
-   in requests, parameters (keys) must be case insensitive, and values must be case sensitive;
-   operation names must always be in UpperCamelCase (e.g. GetCapabilities);
-   in XML documents, element and parameter names, titles, gml ids, and attribute values meant as human readable labels must be written in a lowerCamelCase (e.g. “sensorLocation”). Text containing acronyms should treat the acronym component as a normal word for readability (e.g. bprLocation instead of BPRLocation).

The IOOS Convention stipulates for the following exceptions:

-   the “network_all” name must always be in lowercase;
-   labels containing the short version of an identifier or definition URI that contains underscores keep their original case (e.g. air_temperature, station_12, etc);
-   identifier values and terms from established vocabularies (e.g. [http://mmisw.org/ont/cf/parameter/air_temperature](http://mmisw.org/ont/cf/parameter/air_temperature) or `urn:ioos:station:RA_authority:station_name`) keep their original (vocabulary) case.

## **Use of URL in HTTP GET and POST Requests**{: style="color: crimson"}

HTTP supports two request methods: GET and POST. In a GET method, request parameters are transmitted as part of the service URL, and in a POST method, request parameters are transmitted in the body of the POST message.

The OGC 06-121r9 “OGC Web Services Common Standard” defines a complete URL for HTTP GET requests as a URL prefix with appended additional parameters in order to construct a valid operation request. Each operation may have a different prefix, and each prefix is entirely at the discretion of the service provider.

A URL prefix for HTTP GET consists of (in order) IP servername or numeric address, optional port number, path to a server resource, and mandatory question mark “?”:

**```http://SERVERNAME:[PORT]/SOS-WEBAPP/sos?```**

A prefix is appended by operation-specific request, which is an optional string of one or more name/value pairs in the form "name=value&" (parameter name, equals sign, parameter value(s), ampersand). As “&” is just a separator between name/value pairs, it is therefore optional after the last pair in the request string:

**```http://SERVERNAME:[PORT]/SOS-WEBAPP/sos?</a>[name=value&amp;][name=value]```**

For HTTP POST operation, a URL does not require additional parameters to be appended to it in order to construct a valid target for the operation request (as opposed to a prefix as in the HTTP GET case). Thus, the URL for the HTTP POST does not end up with a question mark “?”.  The servername, port and path to SOS resource may differ from GET URL, or be the same, at the discretion of the server provider:

**```http://SERVERNAME:[PORT]/SOS-WEBAPP/sos```**

# **Operations**{: style="color: crimson"}

The OGC SOS interface is based on the OGC Web Service Common specification, thus, it has shares structures and data types of service requests with the other OGC Web Services. In the case of SOS, the operation signature is constrained by the observation schema, as it defines the response model. The SOS v1.0 defines three operational profiles:

- Core Profile operations (mandatory, within scope of the Milestone 1.0)
  - GetCapabilities
  - DescribeSensor
  - GetObservation
- Extended and Transactional Profiles operations (optional, out of scope for the Milestone 1.0)
  - RegisterSensor
  - InsertObservation
  - GetResult
  - GetFeatureOfInterest
  - GetFeatureOfInterestTime
  - DescribeFeatureOfInterest
  - DescribeObservationType
  - DescribeResultModel

The Core Profile has been identified as relevant to IOOS DMAC; the implementation of the Core Profile operations within the Mileastone 1.0 framework is described hereinafter. The Core Profile operations are based on the stateless HTTP request/response model. A diagram illustrating the basic message sequence is shown in [**Figure 2**](#Fig_2).

![](./sos-wsdd-image00.png)

<a name="Fig_2"></a> **Figure 2: SOS Request/Response Pattern**

<br>
At the start of the interaction, a consumer issues a GetCapabilities request to a server. Returned information includes metadata describing supported interface versions, supported formats, functional extensions, available offerings, etc. The supported SOS versions and features are common IOOS-wide, minimizing differences between deployed  i52N and ncSOS server instances, although the available observation data for a particular server will vary from instance to instance.

Following a successful GetCapabilties operation, a consumer optionally issues one or more DescribeSensor requests to get more information about stations/platforms and sensors. A consumer than uses the information obtained from GetCapabilities and DescribeSensor responses for a GetObservation request that specifies an observed property, offering, an optional spatial and/or temporal extent, and other criteria. The server retrieves all matching data and returns it to the consumer in the GetCoverage response.

Erroneous requests detected by the server result in a response containing an XML-based exception message rather than an SOS response.

Examples of the consumer requests and SOS server responses are shown in subsequent sections. Unless something different is specified, the encoding samples have been taken from the set of [IOOS SOS Milestone 1.0 templates](https://code.google.com/p/ioostech/source/browse/trunk/templates/Milestone1.0?state=open).

## **GetCapabilities**{: style="color: crimson"}

GetCapabilities operation provides the interface for any client to access metadata about a specific service, which in this case is SOS. This operation allows clients to retrieve service metadata about a specific service instance, including metadata about the tightly-coupled data served. In addition to more generic capabilities response elements such as filter options, the SOS GetCapabilities returns a list of so called Offerings, which are groupings of available observations described by their feature of interest, procedure, observed property, temporal coverage and the like. This allows the user application to clearly identify the types and quality of data that can be requested from this service.

Please note, that SOS in version 1.0 does not restrict creation of observation offerings. On the other hand, SOS 2.0 is more specific and defines that each observation offering is limited to be associated with exactly one procedure, which can be a network, station, or sensor. The U.S. IOOS has made a decision to imply that limitation starting at Milestone 1.0 with SOS v1.0; this not only solves the issue of the SOS 1.0 with ambiguous groupings of observations to offerings but also ensures the continuity of the Milestones.

### **GetCapabilities Request**{: style="color: crimson"}

GetCapabilities request may be sent to the server as HTTP/GET or HTTP/POST. HTTP/GET request passes parameters to the server in the HTTP URL with a number of key-value pairs (KVP) of input parameters, and HTTP/POST request sends an XML document to the server, that may also be KVP-encoded. A request to perform GetCapabilities should follow the structure as depicted in the [**Figure 3**](#Fig_3) and table below.

![](./sos-wsdd-image19.png)

<a name="Fig_3"></a> **Figure 3: GetCapabilities request schema**<br><br>


|Input Name |Cardinality |Description |
| :--- | :---: | :--- |
|**service**| 1…1 | Service name (fixed value “SOS”)|
|**request**| 1…1 | Operation name |
|**acceptVersions**| 1…1<br> for 52N | A list of specification versions accepted by client, with preferred versions listed first. Required value is “1.0.0”; if parameter is omitted or has different value, the server returns SOS v2.0 GetCapabilities document. |
|**sections**| 0…1 |When specified, identifies the sections of the GetCapabilities response to be returned to the client. One or more values in a comma-separated list may be specified. If omitted, all sections are returned. Valid values are:<br>­ -- ServiceIdentification<br>­ -- ServiceProvider<br>­ -- OperationsMetadata<br>­ -- Filter_Capabilities<br>­ -- Contents<br>­ -- All|
|**acceptFormats**| 0…1 | A list of zero or more response formats desired by client, with preferred formats listed first. Currently, IOOS Convention supports just one output format:<br><br> **text/xml;subtype="sensorML/1.0.1/profiles/ioos_sos/1.0"** |


Note, that although GetCapabilities request may contain all parameters from [**Table 1**](#Tab_1), just first three of them (service, request, and acceptVersions) are required by the IOOS Convention.

The following HTTP/GET and HTTP/POST request samples, when issued to the SOS server, will result in all available metadata for SOS v1.0.0 being returned. Although parameter names in a GET KVP request are case-insensitive, IOOS Convention recommends writing them in lower case just for ease-of-reading and consistency:

- **HTTP/GET** to both 52North and ncSOS implementations<br>
  - **`http://SERVERNAME:PORT/SOS_WEBAPP_NAME/sos?service=SOS&amp;request=GetCapabilities`**, or
  - **`http://SERVERNAME:PORT/SOS_WEBAPP_NAME/sos?service=SOS&amp;request=GetCapabilities&amp;AcceptVersions=1.0.0`**<br><br>
- **HTTP/GET** to ncSOS implementation without parameters
  - **`http://SERVERNAME:PORT/SOS_WEBAPP_NAME/sos?`**<br><br>
- **HTTP/POST**
 
```
<sos:GetCapabilities 
xmlns="http://www.opengis.net/sos/1.0" 
xmlns:ows="http://www.opengis.net/ows/1.1" 
xmlns:ogc="http://www.opengis.net/ogc" 
xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
xsi:schemaLocation="http://www.opengis.net/sos/1.0 http://schemas.opengis.net/sos/1.0.0/sosGetCapabilities.xsd" 
service="SOS" updateSequence="">
    <ows:AcceptVersions>
        <ows:Version>1.0.0</ows:Version>
    </ows:AcceptVersions>
    <ows:Sections>   
        <ows:Value>All</ows:Value>  
    </ows:Sections>
</sos:GetCapabilities>
```

### **GetCapabilities Response**{: style="color: crimson"}

The response to a GetCapabilities request is an XML encoded document that conforms to the [SOS 1.0.0 Implementation Specification [OGC 06-009r6]](http://portal.opengeospatial.org/files/?artifact_id=26667), and illustrates the characteristics of the SOS system by providing a comprehensive information about coordinate reference system (CRS), spatial or temporal filtering and other information about sensors, feature of interest, and response format. The OGC specification is constrained by the IOOS Convention that on one hand prescribes a certain way of use for some optional components, and on the other hand – facilitates the future acceptance of the SOS 2.0. At any rate, the IOOS Convention does not violate OGC specification’s requirements.

![](./sos-wsdd-image20.png)

<a name="Fig_4"></a> **Figure 4: GetCapabilities response schema**<br>

The example below shows all five sections depicted in the figure above, and assumes that a GetCapabilities request with no specified subsections was issued, resulting in a response containing all SOS Capabilities metadata:

-   ows:ServiceIdentification
-   ows:ServiceProvider
-   ows:OperationsMetadata
-   sos:Filter_Capabilities
-   sos:Contents


```XML
<sos:Capabilities 
xmlns:sos="http://www.opengis.net/sos/1.0" 
xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
xmlns:ows="http://www.opengis.net/ows/1.1" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:gml="http://www.opengis.net/gml" xmlns:ogc="http://www.opengis.net/ogc" version="1.0.0" xsi:schemaLocation="http://www.opengis.net/sos/1.0 http://schemas.opengis.net/sos/1.0.0/sosAll.xsd">
  <ows:ServiceIdentification>...</ows:ServiceIdentification>
  <ows:ServiceProvider>...</ows:ServiceProvider>
  <ows:OperationsMetadata>...</ows:OperationsMetadata>
  <sos:Filter_Capabilities>…</sos:Filter_Capabilities>
  <sos:Contents>...</sos:Contents>
</sos:Capabilities>

```
The subsections are described in more details in the following chapters.


#### **ServiceIdentification**{: style="color: crimson"}

This section contains metadata about this specific server, including the title, abstract, keywords, service type, version, fees, and access constraints if any for using this server. No IOOS-specific guidelines and conventions are applicable to this section; it is fully defined by the SOS 1.0.0 standard.

```XML
  <ows:ServiceIdentification>
    <ows:Title>TITLE</ows:Title>
    <ows:Abstract>ABSTRACT</ows:Abstract>
    <ows:Keywords>
      <ows:Keyword>KEYWORD 1</ows:Keyword>
      <ows:Keyword>KEYWORD 2</ows:Keyword>
    </ows:Keywords>
    <ows:ServiceType codeSpace="http://opengeospatial.net">OGC:SOS</ows:ServiceType>
    <ows:ServiceTypeVersion>1.0.0</ows:ServiceTypeVersion>
    <ows:Fees>NONE</ows:Fees>
    <ows:AccessConstraints>NONE</ows:AccessConstraints>
  </ows:ServiceIdentification>
```

#### **ServiceProvider**{: style="color: crimson"}

This section contains metadata about the organization operating this server, including service provider name, site, address, contact information, etc. Similar to the previous section described above, this section does not require following any IOOS-specific conventions; it is fully defined by the SOS 1.0.0 standard.

```XML
  <ows:ServiceProvider>
    <ows:ProviderName>IOOS (OR ANY OTHER PROVIDER)</ows:ProviderName>
    <ows:ProviderSite xlink:href="http://www.ioos.noaa.gov/"/>
    <ows:ServiceContact>
      <ows:IndividualName>TBA</ows:IndividualName>
      <ows:PositionName>TBA</ows:PositionName>
      <ows:ContactInfo>
        <ows:Phone>
          <ows:Voice>1-301-427-2420</ows:Voice>
        </ows:Phone>
        <ows:Address>
          <ows:DeliveryPoint>1100 Wayne Ave., Suite 1225</ows:DeliveryPoint>
          <ows:City>Silver Spring</ows:City>
          <ows:AdministrativeArea>MD</ows:AdministrativeArea>
          <ows:PostalCode>20910</ows:PostalCode>
          <ows:Country>USA</ows:Country>
          <ows:ElectronicMailAddress>noaa.ioos.webmaster@noaa.gov</ows:ElectronicMailAddress>
        </ows:Address>
      </ows:ContactInfo>
    </ows:ServiceContact>
  </ows:ServiceProvider>
```

#### **OperationsMetadata**{: style="color: crimson"}

This section contains metadata about the operations specified by this service and implemented by this server, including the URLs, parameters for operation requests. A corresponding section of the IOOS Milestone 1.0 GetCapabilities template is presented below; the template contains just the bare minimum of the required metadata that describes the server operations capability.

The URL for HTTP GET requests may either differ from the URL for POST requests or be the same. Note also, that OGC 06-121r9 “OGC Web Service Common Implementation Specification” requires GET URL to end up with a question mark (“?”), as opposed to the POST URL:

```XML
<ows:HTTP>
    <ows:Get xlink:href="SOS_SERVER_GET_URL?"/>
    <ows:Post xlink:href="SOS_SERVER_POST_URL"/>
</ows:HTTP>
```

In addition tothe SOS v1.0.0 Implementation Specification, the IOOS Convention requires an indication of the current versions for both template and software; this information is provided in the `<ows:ExtendedCapabilities>/<gml:metaDataProperty xlink:title="ioosTemplateVersion">`, and in the `<ows:ExtendedCapabilities>/<gml:metaDataProperty xlink:title="softwareVersion">` elements respectively.

```XML
  <ows:OperationsMetadata>
    <ows:Operation name="GetCapabilities">
      <ows:DCP>
        <ows:HTTP>
          <ows:Get xlink:href="SOS_SERVER_GET_URL?"/>
          <ows:Post xlink:href="SOS_SERVER_POST_URL"/>
        </ows:HTTP>
      </ows:DCP>
      <ows:Parameter name="Sections">
        <ows:AllowedValues>
          <ows:Value>ServiceIdentification</ows:Value>
          <ows:Value>ServiceProvider</ows:Value>
          <ows:Value>OperationsMetadata</ows:Value>
          <ows:Value>Contents</ows:Value>
          <ows:Value>All</ows:Value>
        </ows:AllowedValues>
      </ows:Parameter>
    </ows:Operation>
    <ows:Operation name="GetObservation">
      <ows:DCP>
        <ows:HTTP>
          <ows:Get xlink:href="SOS_SERVER_GET_URL?"/>
          <ows:Post xlink:href="SOS_SERVER_POST_URL"/>
        </ows:HTTP>
      </ows:DCP>
      <ows:Parameter name="observedProperty">
        <ows:AllowedValues>
          <ows:Value>VALUE</ows:Value>
          <ows:Value>COMPOSITE_VALUE</ows:Value>
        </ows:AllowedValues>
      </ows:Parameter>
    </ows:Operation>
    <ows:Operation name="DescribeSensor">
      <ows:DCP>
        <ows:HTTP>
          <ows:Get xlink:href="SOS_SERVER_GET_URL?"/>
          <ows:Post xlink:href="SOS_SERVER_POST_URL"/>
        </ows:HTTP>
      </ows:DCP>
      <ows:Parameter name="outputFormat">
        <ows:AllowedValues>
          <ows:Value>text/xml;subtype="sensorML/1.0.1/profiles/ioos_sos/1.0"</ows:Value>
        </ows:AllowedValues>
      </ows:Parameter>
    </ows:Operation>
    <ows:Parameter name="service">
      <ows:AllowedValues>
        <ows:Value>SOS</ows:Value>
      </ows:AllowedValues>
    </ows:Parameter>
    <ows:Parameter name="version">
      <ows:AllowedValues>
        <ows:Value>1.0.0</ows:Value>
      </ows:AllowedValues>
    </ows:Parameter>
    <ows:ExtendedCapabilities>
      <gml:metaDataProperty xlink:title="ioosTemplateVersion" 
        xlink:href="http://code.google.com/p/ioostech/source/browse/#svn%2Ftrunk%2Ftemplates%2FMilestone1.0">
        <gml:version>1.0</gml:version>
      </gml:metaDataProperty>
      <gml:metaDataProperty xlink:title="softwareVersion" 
          xlink:href="http://someURI">
          <gml:version>0.9.4.5</gml:version>
      </gml:metaDataProperty>
    </ows:ExtendedCapabilities>    
  </ows:OperationsMetadata>
```

#### **Contents**{: style="color: crimson"}

This section contains the list of all of the observation offerings available from the service, specifically the network offerings and offerings for all affiliated stations/platforms. Each of the `<sos:ObservationOffering>` elements describes a collection of related sensor system observations. However, in order to restrain the response document size and mitigate scalability problems, the IOOS Convention requires that sensor offerings must not be included in a platform offering description, i.e none of the `<sos:ObservationOffering>` elements may include a sensor procedure. In order to get a detailed description of the sensors installed on the platform, a DescribeSensor operation should be used.

The IOOS Convention impose certain general constraints on the **Contents** section:

- Advertising of the “network_all” group of platforms is required.
- Advertising of logical sub-groups of the "network_all" group (e.g. by provider, region, measurement type, etc.) is recommended.
- Advertising of the individual platforms is not recommended; instead, it is recommended to use a separate DescribeSensor document for that rather than list the individual platforms as offerings.

The definition of some SOS metadata elements that appear in the **Contents** section is also further constrained by IOOS Convention. Note that by no means that refinement steps over the boundaries of the OGC standards, i.e. all constrained elements still conform to the relevant specifications.

| Input Name | Cardinality | Description |
| :--- | :---: | --- |
|gml:id | 1…1 | Each observation offering must have a unique ID.  It is recommended that “gml:id” values should start with 'station_' for platforms and 'network_' for networks of platforms, and be augmented with the label from the station identifier as defined in IOOS Conventions for Observing Asset Identifiers. <br /><br />_**Example:** `station_21401, network_all`_ |
|gml:name | 1…1 | The IOOS Convention currently requires the “gml:name” value to be a URN that conforms to the IOOS Conventions for Observing Asset Identifiers.<br /><br />_**Example:** `urn:ioos:station:wmo:21401`_ |
|gml:description | 0…1 | It is recommended that any human-readable name or description of the network or station assigned by a data provider should be parked in this element.<br /><br />_**Example:** `250NM Southeast of Iturup Island`_ |
|gml:srsName | 0…1 | This element defines a Coordinate Reference System (CRS) used for observation offering.<br />If the element is provided, the value must be in a form of URI of one of the CRS defined by the European Petroleum Survey Group (EPSG). IOOS Convention strongly recommends the use of EPSG::4326 (WGS84) wherever possible. <br />If no `<gml:srsName>` is provided, the CRS must be specified in the “srsName” attribute of the `<gml:boundedBy/gml:Envelope>` element; this way was recommended as a preferred method for CRS specification.<br /><br />_**Example:** `EPSG::4326`_<br /><br />_**Note:** ncSOS will extract the value of the `grid_mapping` attribute from the source netCDF file, and convert the coordinates into EPSG::4326; if conversion is impossible, ncSOS will use the source srsName. An empty `grid_mapping` attribute may result in incorrect metadata as EPSG::4326 will be used by default. This issue will be addressed in the future ncSOS releases beyond v1.0._   |
|srsName | 0…1 | This attribute define a CRS as a part of the `<gml:boundedBy/gml:Envelope>` element for a single bounding box.<br />If no “srsName” attribute is provided, the CRS must be specified in the `<gml:srsName>` element. However, the IOOS Convention recommends to use the “srsName” attribute instead of the `<gml:srsName>` element.<br />If the attribute is provided, the value must be in a form of OGC-maintained URL for one of the CRS defined by the European Petroleum Survey Group (EPSG). IOOS Convention strongly recommends the use of EPSG::4326 (WGS84) wherever possible. <br /><br />_**Example:** `srsName=http://www.opengis.net/def/crs/EPSG/0/4326`_<br /><br />_**Note:** ncSOS will extract the value of the `grid_mapping` attribute from the source netCDF file, and convert the coordinates into EPSG::4326; if conversion is impossible, ncSOS will use the source srsName. An empty `grid_mapping` attribute may result in incorrect metadata as EPSG::4326 will be used by default. This issue will be addressed in the future ncSOS releases beyond v1.0._ |
|sos:time | 1…1 | Advertizes the overall temporal boundaries for the observationOffering data availability.<br />Time period limiters `<beginPosition>` and `<endPosition>` allow a use of fixed values in ISO 8601 format (2009-05-23T00:00:00.000Z) as well as evaluated “indeterminatePosition” attribute with the value ‘now’ if the end time is inexact.<br /><br />_**Examples:**_<br />{::nomarkdown}<pre>&lt;sos:time><br />  &lt;gml:TimePeriod&gt;<br />    &lt;gml:beginPosition&gt;2010-11-15T18:15:00Z&lt;/gml:beginPosition&gt;<br />    &lt;gml:endPosition&gt; 2010-11-25T23:15:00Z&lt;/gml:endPosition&gt;<br />  &lt;/gml:TimePeriod&gt;<br />&lt;/sos:time&gt;</pre><pre>&lt;sos:time&gt;<br />  &lt;gml:TimePeriod&gt;<br />    &lt;gml:beginPosition&gt;2010-11-15T18:15:00Z&lt;/gml:beginPosition&gt;<br />    &lt;gml:endPosition indeterminatePosition="now"&lt;/gml:endPosition&gt;<br />  &lt;/gml:TimePeriod&gt;<br />&lt;/sos:time&gt;</pre>{:/}<br />_**Note:** The overall start and end times do not indicate whether data gaps exist. If an offering comprises multiple sensors, each with different start or end times (for example, a new sensor was added at a later date), the start and end times indicate the overall period during which at least some data are available._  |
|sos:procedure | 1…1 | This element contains the official IOOS identifier for the platform or network in a form of URN that conforms to the IOOS Conventions for Observing Asset Identifiers.<br />Only one procedure element for a single offering is currently allowed (it is done for future compatibility – although SOS 1.0.0 does not limit that number, the SOS 2.0 only allows a single procedure per offering).<br /><br />_**Examples:**<br />`<sos:procedure xlink:href="urn:ioos:network:AUTHORITY:all"/>`<br />`<sos:procedure xlink:href=" urn:ioos:station:wmo:21401"/>`_ |
|sos:observedProperty | 1…* | This element advertizes one or more quantities observed by a specific offering.<br />The element’s value must be a URL corresponding to a Climate and Forecast (CF) Standard Name of the record in one of the IOOS Vocabularies that are currently hosted by the Marine Metadata Interoperability (MMI) project (e.g. http://mmisw.org/ont/ioos/parameter).<br />The IOOS convention only requires support of fully qualified `<sos:observedProperty>` element values (URLs); support of unqualified values is optional.<br />Along with simple observed phenomenon defined in the CF standard names parameter vocabulary (CF phenomenon), e.g. http://mmisw.org/ont/cf/parameter , the IOOS Convention allows complex composite phenomenon, that consists of a number of the CF phenomena. That composite phenomenon may be either vector variable (i.e wind, current, or wave) comprised by its scalar components (e.g. “wind_from_direction”, “wind_speed_of_gust”, etc.), or an arbitrary set of CF phenomena (e.g. wind components aggregated with “air_temperature”, “dissolved_oxygen”, etc.). At any rate, the IOOS Convention requires that composite phenomenon to be defined in one of the IOOS controlled vocabularies (e.g. IOOS Parameter Vocabulary).<br />The advertised value of the `<sos:observedProperty>` shall be used in GetObservation operation to obtain the actual data. A description of `<om:observedProperty>` in OM-GetObservation section of this document explicitly describes the IOOS Convention’s requirements for the provision of the composite phenomenon’s observed values.<br /><br />_**Examples of `observedProperty` advertisement:**<br />`observedProperty xlink:href=http://mmisw.org/ont/cf/parameter/VALUE`<br />`observedProperty xlink:href="http://mmisw.org/ont/cf/parameter/ COMPOSITE_VALUE"`_ |
|sos:responseMode | 1…* | This element indicates what modes of response are supported for this offering. The following values are allowed:<br />&nbsp;&nbsp;&nbsp;• inline<br />&nbsp;&nbsp;&nbsp;• out-of-band<br />&nbsp;&nbsp;&nbsp;• attached<br />&nbsp;&nbsp;&nbsp;• resultTemplate<br /><br />_**Note:** The value of external to the observation element (out-of-band) is recommended, if for any reason (sensistivity, legacy formats, etc.) a GetObservation response should return a reference (URL) to the data instead of data itself. The reference may also point to the file with the instruction on how to get the real data off-line._ |

The application of the IOOS Convention to the SOS 1.0.0 Implementation Standard is illustrated by a sample of the Content section of the IOOS Milestone 1.0 GetCapabilities template below; the template shows just the bare minimum of the required metadata, a real server may advertize more parameters and provide more details.

```XML
  <sos:Contents>
    <sos:ObservationOfferingList>
      <sos:ObservationOffering gml:id="network_all">
        <gml:description>All stations</gml:description>
        <gml:name>urn:ioos:network:AUTHORITY:all</gml:name>
        <gml:srsName>EPSG:4326</gml:srsName>
        <gml:boundedBy>
          <gml:Envelope srsName="http://www.opengis.net/def/crs/EPSG/0/4326">
            <gml:lowerCorner>-90 -180</gml:lowerCorner>
            <gml:upperCorner>90 180</gml:upperCorner>
          </gml:Envelope>
        </gml:boundedBy>
        <sos:time>
          <gml:TimePeriod>
            <gml:beginPosition>BEGINNING</gml:beginPosition>
            <gml:endPosition indeterminatePosition="now"/>
          </gml:TimePeriod>
        </sos:time>
        <sos:procedure xlink:href="urn:ioos:network:AUTHORITY:all"/>
        <sos:observedProperty xlink:href="http://mmisw.org/ont/cf/parameter/VALUE"/>
        <sos:observedProperty xlink:href="http://mmisw.org/ont/cf/parameter/COMPOSITE_VALUE"/>
        <sos:featureOfInterest xlink:href="FEATURE"/>
        <sos:responseFormat>text/xml;schema="om/1.0.0/profiles/ioos_sos/1.0"</sos:responseFormat>
        <sos:resultModel>om:ObservationCollection</sos:resultModel>
        <sos:responseMode>inline</sos:responseMode>
      </sos:ObservationOffering>
      <sos:ObservationOffering gml:id="network_favorites">
        <gml:description>All stations</gml:description>
        <gml:name>urn:ioos:network:AUTHORITY:favorites</gml:name>
        <gml:srsName>EPSG:4326</gml:srsName>
        <gml:boundedBy>
          <gml:Envelope srsName="http://www.opengis.net/def/crs/EPSG/0/4326">
            <gml:lowerCorner>30 -130</gml:lowerCorner>
            <gml:upperCorner>45 -110</gml:upperCorner>
          </gml:Envelope>
        </gml:boundedBy>
        <sos:time>
          <gml:TimePeriod>
            <gml:beginPosition>BEGINNING</gml:beginPosition>
            <gml:endPosition indeterminatePosition="now"/>
          </gml:TimePeriod>
        </sos:time>
       <sos:procedure xlink:href="urn:ioos:network:AUTHORITY:favorites"/>
        <sos:observedProperty xlink:href="http://mmisw.org/ont/cf/parameter/VALUE"/>
        <sos:observedProperty xlink:href="http://mmisw.org/ont/cf/parameter/COMPOSITE_VALUE"/>
        <sos:featureOfInterest xlink:href="FEATURE"/>
        <sos:responseFormat>text/xml;schema="om/1.0.0/profiles/ioos_sos/1.0"</sos:responseFormat>
        <sos:resultModel>om:ObservationCollection</sos:resultModel>
        <sos:responseMode>inline</sos:responseMode>
      </sos:ObservationOffering>
    </sos:ObservationOfferingList>
  </sos:Contents>
```

Even more details are depicted in the sample below, which presents a Contents part of the real AOOS test SOS server GetCapabilities documenmt (the sample is presented just for reference, as the response may change at any time); the sampled document advertizes more offerings, observed properties, response output format encodings, etc.

```XML
  <sos:Contents>
    <sos:ObservationOfferingList>
      <sos:ObservationOffering gml:id="urn_ioos_network_test_all">
        <gml:name>urn:ioos:network:test:all</gml:name>
        <gml:boundedBy>
          <gml:Envelope srsName="http://www.opengis.net/def/crs/EPSG/0/4326">
            <gml:lowerCorner>60.683 -151.398</gml:lowerCorner>
            <gml:upperCorner>70.4 -146.88</gml:upperCorner>
          </gml:Envelope>
        </gml:boundedBy>
        <sos:time>
          <gml:TimePeriod xsi:type="gml:TimePeriodType">
            <gml:beginPosition>2009-05-23T00:00:00.000Z</gml:beginPosition>
            <gml:endPosition>2012-08-23T08:00:00.000Z</gml:endPosition>
          </gml:TimePeriod>
        </sos:time>
        <sos:procedure xlink:href="urn:ioos:network:test:all"/>
        <sos:observedProperty xlink:href="http://mmisw.org/ont/cf/parameter/air_temperature"/>
        <sos:observedProperty xlink:href="http://mmisw.org/ont/cf/parameter/direction_of_sea_water_velocity"/>
        <sos:observedProperty xlink:href="http://mmisw.org/ont/cf/parameter/sea_water_practical_salinity"/>
        <sos:observedProperty xlink:href="http://mmisw.org/ont/cf/parameter/sea_water_speed"/>
        <sos:observedProperty xlink:href="http://mmisw.org/ont/cf/parameter/sea_water_temperature"/>
        <sos:observedProperty xlink:href="http://mmisw.org/ont/cf/parameter/wind_speed"/>
        <sos:featureOfInterest xlink:href="urn:ioos:station:test:blighreef"/>
        <sos:featureOfInterest xlink:href="urn:ioos:station:test:blighreef-10m-15m"/>
        <sos:featureOfInterest xlink:href="urn:ioos:station:test:blighreef-15m-20m"/>
        <sos:featureOfInterest xlink:href="urn:ioos:station:test:blighreef-5m-10m"/>
        <sos:featureOfInterest xlink:href="urn:ioos:station:test:nikiski-10m"/>
        <sos:featureOfInterest xlink:href="urn:ioos:station:test:nikiski-15m"/>
        <sos:featureOfInterest xlink:href="urn:ioos:station:test:nikiski-5m"/>
        <sos:featureOfInterest xlink:href="urn:ioos:station:test:prudhoe"/>
        <sos:responseFormat>application/zip</sos:responseFormat>
        <sos:responseFormat>text/xml;subtype="om/1.0.0"</sos:responseFormat>
        <sos:responseFormat>text/xml;subtype="om/1.0.0/profiles/ioos_sos/1.0"</sos:responseFormat>
        <sos:responseMode>inline</sos:responseMode>
        <sos:responseMode>resultTemplate</sos:responseMode>
      </sos:ObservationOffering>
      <sos:ObservationOffering gml:id="urn_ioos_network_test_all-air-temperature">
        <gml:name>urn:ioos:network:test:all-air-temperature</gml:name>
        <gml:boundedBy>
          <gml:Envelope srsName="http://www.opengis.net/def/crs/EPSG/0/4326">
            <gml:lowerCorner>60.84 -148.527</gml:lowerCorner>
            <gml:upperCorner>70.4 -146.88</gml:upperCorner>
          </gml:Envelope>
        </gml:boundedBy>
        <sos:time>
          <gml:TimePeriod xsi:type="gml:TimePeriodType">
            <gml:beginPosition>2009-05-23T00:00:00.000Z</gml:beginPosition>
            <gml:endPosition>2012-08-23T06:42:00.000Z</gml:endPosition>
          </gml:TimePeriod>
        </sos:time>
        <sos:procedure xlink:href="urn:ioos:network:test:all-air-temperature"/>
        <sos:observedProperty xlink:href="http://mmisw.org/ont/cf/parameter/air_temperature"/>
        <sos:observedProperty xlink:href="http://mmisw.org/ont/cf/parameter/direction_of_sea_water_velocity"/>
        <sos:observedProperty xlink:href="http://mmisw.org/ont/cf/parameter/sea_water_speed"/>
        <sos:observedProperty xlink:href="http://mmisw.org/ont/cf/parameter/sea_water_temperature"/>
        <sos:observedProperty xlink:href="http://mmisw.org/ont/cf/parameter/wind_speed"/>
        <sos:featureOfInterest xlink:href="urn:ioos:station:test:blighreef"/>
        <sos:featureOfInterest xlink:href="urn:ioos:station:test:blighreef-10m-15m"/>
        <sos:featureOfInterest xlink:href="urn:ioos:station:test:blighreef-15m-20m"/>
        <sos:featureOfInterest xlink:href="urn:ioos:station:test:blighreef-5m-10m"/>
        <sos:featureOfInterest xlink:href="urn:ioos:station:test:prudhoe"/>
        <sos:responseFormat>application/zip</sos:responseFormat>
        <sos:responseFormat>text/xml;subtype="om/1.0.0"</sos:responseFormat>
        <sos:responseFormat>text/xml;subtype="om/1.0.0/profiles/ioos_sos/1.0"</sos:responseFormat>
        <sos:responseMode>inline</sos:responseMode>
        <sos:responseMode>resultTemplate</sos:responseMode>
      </sos:ObservationOffering>
      <sos:ObservationOffering gml:id="urn_ioos_station_test_blighreef">
        <gml:name>urn:ioos:station:test:blighreef</gml:name>
        <gml:boundedBy>
          <gml:Envelope srsName="http://www.opengis.net/def/crs/EPSG/0/4326">
            <gml:lowerCorner>60.84 -146.88</gml:lowerCorner>
            <gml:upperCorner>60.84 -146.88</gml:upperCorner>
          </gml:Envelope>
        </gml:boundedBy>
        <sos:time>
          <gml:TimePeriod xsi:type="gml:TimePeriodType">
            <gml:beginPosition>2009-05-23T00:00:00.000Z</gml:beginPosition>
            <gml:endPosition>2012-08-23T06:30:00.000Z</gml:endPosition>
          </gml:TimePeriod>
        </sos:time>
        <sos:procedure xlink:href="urn:ioos:station:test:blighreef"/>
        <sos:observedProperty xlink:href="http://mmisw.org/ont/cf/parameter/air_temperature"/>
        <sos:observedProperty xlink:href="http://mmisw.org/ont/cf/parameter/direction_of_sea_water_velocity"/>
        <sos:observedProperty xlink:href="http://mmisw.org/ont/cf/parameter/sea_water_speed"/>
        <sos:observedProperty xlink:href="http://mmisw.org/ont/cf/parameter/wind_speed"/>
        <sos:featureOfInterest xlink:href="urn:ioos:station:test:blighreef"/>
        <sos:featureOfInterest xlink:href="urn:ioos:station:test:blighreef-10m-15m"/>
        <sos:featureOfInterest xlink:href="urn:ioos:station:test:blighreef-15m-20m"/>
        <sos:featureOfInterest xlink:href="urn:ioos:station:test:blighreef-5m-10m"/>
        <sos:responseFormat>application/zip</sos:responseFormat>
        <sos:responseFormat>text/xml;subtype="om/1.0.0"</sos:responseFormat>
        <sos:responseFormat>text/xml;subtype="om/1.0.0/profiles/ioos_sos/1.0"</sos:responseFormat>
        <sos:responseMode>inline</sos:responseMode>
        <sos:responseMode>resultTemplate</sos:responseMode>
      </sos:ObservationOffering>
      <sos:ObservationOffering gml:id="urn_ioos_station_test_nikiski">
        <gml:name>urn:ioos:station:test:nikiski</gml:name>
        <gml:boundedBy>
          <gml:Envelope srsName="http://www.opengis.net/def/crs/EPSG/0/4326">
            <gml:lowerCorner>60.683 -151.398</gml:lowerCorner>
            <gml:upperCorner>60.683 -151.398</gml:upperCorner>
          </gml:Envelope>
        </gml:boundedBy>
        <sos:time>
          <gml:TimePeriod xsi:type="gml:TimePeriodType">
            <gml:beginPosition>2012-08-23T06:00:00.000Z</gml:beginPosition>
            <gml:endPosition>2012-08-23T08:00:00.000Z</gml:endPosition>
          </gml:TimePeriod>
        </sos:time>
        <sos:procedure xlink:href="urn:ioos:station:test:nikiski"/>
        <sos:observedProperty xlink:href="http://mmisw.org/ont/cf/parameter/sea_water_practical_salinity"/>
        <sos:observedProperty xlink:href="http://mmisw.org/ont/cf/parameter/sea_water_temperature"/>
        <sos:featureOfInterest xlink:href="urn:ioos:station:test:nikiski-10m"/>
        <sos:featureOfInterest xlink:href="urn:ioos:station:test:nikiski-15m"/>
        <sos:featureOfInterest xlink:href="urn:ioos:station:test:nikiski-5m"/>
        <sos:responseFormat>application/zip</sos:responseFormat>
        <sos:responseFormat>text/xml;subtype="om/1.0.0"</sos:responseFormat>
        <sos:responseFormat>text/xml;subtype="om/1.0.0/profiles/ioos_sos/1.0"</sos:responseFormat>
        <sos:responseMode>inline</sos:responseMode>
        <sos:responseMode>resultTemplate</sos:responseMode>
      </sos:ObservationOffering>
      <sos:ObservationOffering gml:id="urn_ioos_station_test_prudhoe">
        <gml:name>urn:ioos:station:test:prudhoe</gml:name>
        <gml:boundedBy>
          <gml:Envelope srsName="http://www.opengis.net/def/crs/EPSG/0/4326">
            <gml:lowerCorner>70.4 -148.527</gml:lowerCorner>
            <gml:upperCorner>70.4 -148.527</gml:upperCorner>
          </gml:Envelope>
        </gml:boundedBy>
        <sos:time>
          <gml:TimePeriod xsi:type="gml:TimePeriodType">
            <gml:beginPosition>2012-08-23T06:00:00.000Z</gml:beginPosition>
            <gml:endPosition>2012-08-23T06:42:00.000Z</gml:endPosition>
          </gml:TimePeriod>
        </sos:time>
        <sos:procedure xlink:href="urn:ioos:station:test:prudhoe"/>
        <sos:observedProperty xlink:href="http://mmisw.org/ont/cf/parameter/air_temperature"/>
        <sos:observedProperty xlink:href="http://mmisw.org/ont/cf/parameter/sea_water_temperature"/>
        <sos:featureOfInterest xlink:href="urn:ioos:station:test:prudhoe"/>
        <sos:responseFormat>application/zip</sos:responseFormat>
        <sos:responseFormat>text/xml;subtype="om/1.0.0"</sos:responseFormat>
        <sos:responseFormat>text/xml;subtype="om/1.0.0/profiles/ioos_sos/1.0"</sos:responseFormat>
        <sos:responseMode>inline</sos:responseMode>
        <sos:responseMode>resultTemplate</sos:responseMode>
      </sos:ObservationOffering>
    </sos:ObservationOfferingList>
  </sos:Contents>
```

## **DescribeSensor**{: style="color: crimson"}

A **DescribeSensor** is a simple core SOS operation that returns an XML Document associated with one or more sensors, platforms or networks. It provides metadata about sensors and the observation collected by these sensors. All the information of sensor characteristics is encoded into the SensorML standard.

With some sophisticated sensors or sensor-reach platforms and networks, the metadata may be quite voluminous. Although GetCapabilities operation could provide a list of sensors and some sensor-related metadata, it is meant for delivery of only high-level information about the observable properties, locations, contact information, etc. On the contrary, DescribeSensor operation is designed to request detailed sensor metadata, and supports retrieval of the highest level of detail about the platforms and sensors associated with an SOS. The sensor characteristics can include lists and definitions of parameters supported by the sensor [SOS 1.0.0 Implementation Specification [OGC 06-009r6]](http://portal.opengeospatial.org/files/?artifact_id=26667).

The following sections illustrate DescribeSensor HTTP/GET and HTTP/POST requests, provides the list of the request parameters and description for the DescribeSensor operation response.

### **DescribeSensor Request**{: style="color: crimson"}

A DescribeSensor request may be sent to the server as HTTP/GET or HTTP/POST. While HTTP/POST request sends an XML document to the server, HTTP/GET request passes parameters to the server in the HTTP URL with a number of key-value pairs (KVP) of input parameters. A request to perform DescribeSensor operation should follow the structure that is described in this section.

The UML diagram of the DescribeSensor request is presented in [**Figure 5**](#Fig_5).


![](./sos-wsdd-image21.png)

<a name="Fig_5"></a> **Figure 5: DescribeSensor request schema**<br><br>

The input parameters of the DescribeSensor request are explained in the following table:

| Input Name | Cardinality | Description |
| :--- | :---: | --- |
| service | 1…1 | Service name (must always be **SOS**)|
| version | 1…1 | Service version (always 1.0.0 for Milestone 1.0)|
| request | 1…1 | Operation name (always DescribeSensor) |
| outputFormat | 1…1 |	The desired output format of the DescribeSensor operation;<br />for Milestone 1.0 must always be considered as _**`text/xml;subtype="sensorML/1.0.1/profiles/ioos_sos/1.0"`**_. |
| procedure | 1…1 | Defines the sensor, platform or network for which the description is to be returned. The type is “anyURI”, and it must match the value of the “xlink:href=” attribute in an `<sos:procedure>` element advertized in GetCapabilities response.<br /><br />_**Examples:**_<br />&nbsp; &nbsp; &nbsp;• Network<br />&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;`urn:ioos:network:test:all`<br />&nbsp; &nbsp; &nbsp;• Station/Platform<br />&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;`urn:ioos:station:test:station_name`<br />&nbsp; &nbsp; &nbsp;• Sensor<br />&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; `urn:ioos:sensor:test:station_name:sensor_name` |

The following examples illustrate HTTP/GET and HTTP/POST DescribeSensor requests. Although parameter names in a GET KVP request are case-insensitive, IOOS Convention recommends writing them in lower case just for ease-of-reading and consistency:

- **HTTP/GET**:

```XML
http://SERVERNAME:PORT/SOS_WEBAPP_NAME/sos?request=DescribeSensor&service=SOS&version=1.0.0&procedure=[anyURI]&outputformat=text/xml;subtype="sensorML/1.0.1/profiles/ioos_sos/1.0"
```

- **HTTP/POST**:

```XML
<sos:DescribeSensor version="1.0.0" service="SOS"
  xmlns="http://www.opengis.net/sos/1.0"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
  xsi:schemaLocation="http://www.opengis.net/sos/1.0  http://schemas.opengis.net/sos/1.0.0/sosDescribeSensor.xsd" 
  outputFormat="text/xml;subtype=&quot;sensorML/1.0.1/profiles/ioos_sos/1.0&quot;">
  <procedure>urn:ioos:network:test:all</procedure>
</sos:DescribeSensor> 
```


### **DescribeSensor Response**{: style="color: crimson"}

The response to a DescribeSensor request is a [Sensor Model Language (SensorML](http://www.opengeospatial.org/standards/sensorml)) document that describes the sensor system. In some cases, a DescribeSensor response may be quite voluminous; for example, if description of the network has been requested, and the response returns the document that contains detailed information not just about the network itself, but all network platforms and all sensors installed on each platform. A UML diagram  of such an all-inclusive DescribeSensor document is depicted in [**Figure 6**](#Fig_6) followed by the annotated outline of the document.

![](./sos-wsdd-image22.png)

<a name="Fig_6"></a> **Figure 6: DescribeSensor response schema**<br><br>

```XML
<sml:SensorML> 
    <sml:capabilities name="ioosServiceMetadata">
                Version of the IOOS Template used in this document  
    </sml:capabilities>
    <sml:member>
        <sml:System>
            <gml:description>
                      Collection of all station assets available via the RA’s network SOS service 
            </gml:description>
            <gml:name>
                      urn:ioos:network:ra_name:all
            </gml:name>
            <gml:boundedBy>
                      Spatial bounds of the content described by this network
            </gml:boundedBy>
            <sml:identification> 
                      networkID, shortName and longName 
            </sml:identification> 
            <sml:classification> 
                      All classifiers that apply to this network offering 
            </sml:classification> 
            <sml:validTime> 
                      Represents the date range of the validity of this document 
            </sml:validTime> 
            <sml:capabilities name="observationTimeRange"> 
                  TimeRange element describes the valid time range over which observations from a sensor or station exist 
            </sml:capabilities>
            <sml:contact> 
                      List all publisher and operator contacts that apply to this network 
            </sml:contact> 
            <sml:components> 
                <sml:ComponentList>
                       List all platforms in the network offering 
                    <sml:component name='platform_#01_name'>
                        <sml:System>
                            <sml:identification> 
                                      The names of the platform #01 (stationID, shortName and longName) 
                            <sml:capabilities name="observationTimeRange"> 
                               TimeRange element describes the valid time range over which observations from platform #01 exist 
                            <sml:location> 
                                      Platform #01 geographic location (lat & lon only, no z) 
                            <sml:outputs> 
                                       A list of the observed properties assotiated with the platform #01 
                            <sml:components> 
                                <sml:ComponentList>
                                       List of sensors in the platform #01 
                                    <sml:component name='sensor_A_name'>
                                        <sml:System>
                                             <gml:description>
                                                        Description of sensor A 
                                             </gml:description>
                                             <gml:name>
                                                        urn:ioos:sensor:platform_name:sensor_name 
                                             </gml:name>
                                             <sml:identification> 
                                                      Names of the sensor A (sationID, shortName and longName) 
                                             </sml:identification> 
                                             <sml:capabilities name="featureOfInterest"> 
                                               Feature of interest that sensor A belongs to 
                                             </sml:capabilities> 
                                             <sml:capabilities name="offerings"> 
                                               List of all offerings associated with the sensor A 
                                             </sml:capabilities> 
                                             <sml:capabilities name="stationProcedure"> 
                                               The ID of the platform (procedure), on which sensor A is installed 
                                             </sml:capabilities> 
                                             <sml:capabilities name="observationTimeRange"> 
                                               The valid time range over which observations from sensor A exist 
                                             </sml:capabilities> 
                                             <sml:inputs> 
                                                      Observation phenomena associated with the sensor A 
                                             </sml:inputs> 
                                             <sml:outputs> 
                                                       A list of the outputs assotiated with the sensor A 
                                             </sml:outputs> 
                                        </sml:System>
                                    </sml:component>
                                        […]
                                    <sml:component name='sensor_K_name'>
                                              Description of sensor K 
                                        […]
                                    </sml:component>
                                    <sml:component name='sensor_T_name'>
                                              Description of sensor T 
                                    </sml:component>
                                </sml:ComponentList>
                            </sml:components> 
                        </sml:System>
                    </sml:component>
                        […]
                    <sml:component name='platform_#NN_name'>
                              Description of the platform #NN 
                        […]
                    </sml:component>
                    <sml:component name='platform_#ZZ_name'>
                              Description of the platform #ZZ 
                        […]
                    </sml:component>
                </sml:ComponentList>
            </sml:components> 
        </sml:System>
    </sml:member>
</sml:SensorML>
```

In order to decrease the size of the DescribeSensor document, and limit the volume of the detailed information returned, IOOS recognizes 3 separate types of the DescribeSensor documents. For Milestone 1.0, the IOOS SOS is required to provide documents describing network and individual platform, while the description of individual sensor is optional.

#### **Platform/Station**{: style="color: crimson"}

A mandatory **DescribeSensor** response for a specific platform/station shall return:

-   information on the IOOS Template version
-   platform description
-   search keywords
-   relevant contacts about this specific platform
-   mandatory platform identifiers, such as
  -   platformID
  -   short name
  -   long name
-   mandatory platform classifiers, such as
  -   platformType
  -   operatorSector
  -   publisher
  -   sponsor
  -   parentNetwork                         
-   mandatory platform geographic location (always in EPSG::4326)
-   time range for observations
-   optional documentation (external human-readable resources about the platform)
-   list of observed properties at platform including relevant sensor information

```XML
<!-- Template document for a generic (independant of feature type) Describe Sensor Station -->
<sml:SensorML 
  xmlns:sml="http://www.opengis.net/sensorML/1.0.1" 
  xmlns:gml="http://www.opengis.net/gml" 
  xmlns:swe="http://www.opengis.net/swe/1.0.1" 
  xmlns:xlink="http://www.w3.org/1999/xlink" 
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
  xsi:schemaLocation="http://www.opengis.net/sensorML/1.0.1 http://schemas.opengis.net/sensorML/1.0.1/sensorML.xsd" 
  version="1.0.1">
  <sml:capabilities name="ioosServiceMetadata">
    <swe:SimpleDataRecord>
      <swe:field name="ioosTemplateVersion">
        <swe:Text definition="http://code.google.com/p/ioostech/source/browse/#svn%2Ftrunk%2Ftemplates%2FMilestone1.0">
          <swe:value>1.0</swe:value>
        </swe:Text>
      </swe:field>
    </swe:SimpleDataRecord>
  </sml:capabilities> 
 <sml:member>
    <sml:System>
      <gml:description>Observations at urn:ioos:station:wmo:41001 buoy station, 150 NM East of Cape HATTERAS</gml:description>
      <gml:name>urn:ioos:station:wmo:41001</gml:name>
      <sml:identification>
        <sml:IdentifierList>
          <sml:identifier name="stationID">
            <sml:Term definition="http://mmisw.org/ont/ioos/definition/stationID">
              <sml:value>urn:ioos:station:wmo:41001</sml:value>
            </sml:Term>
          </sml:identifier>
          <sml:identifier name="shortName">
            <sml:Term definition="http://mmisw.org/ont/ioos/definition/shortName">
              <sml:value>WMO 41001 Buoy, Cape Hatteras</sml:value>
            </sml:Term>
          </sml:identifier>
          <sml:identifier name="longName">
            <sml:Term definition="http://mmisw.org/ont/ioos/definition/longName">
              <sml:value>urn:ioos:station:wmo:41001 buoy station, 150 NM East of Cape HATTERAS</sml:value>
            </sml:Term>
          </sml:identifier>
          <sml:identifier name="wmoID">
            <sml:Term definition="http://mmisw.org/ont/ioos/definition/wmoID">
              <sml:value>41001</sml:value>
            </sml:Term>
          </sml:identifier>
        </sml:IdentifierList>
      </sml:identification>
      <sml:classification>
        <sml:ClassifierList>
          <sml:classifier name="parentNetwork">
            <sml:Term definition="http://mmisw.org/ont/ioos/definition/parentNetwork">
              <sml:codeSpace xlink:href="http://mmisw.org/ont/ioos/organization"/>
              <sml:value>NANOOS</sml:value>
            </sml:Term>
          </sml:classifier>
          <sml:classifier name="platformType">
            <sml:Term definition="http://mmisw.org/ont/ioos/definition/platformType">
              <sml:codeSpace xlink:href="http://mmisw.org/ont/ioos/platform"/>
              <sml:value>buoy</sml:value>
            </sml:Term>
          </sml:classifier>
          <sml:classifier name="operatorSector">
            <sml:Term definition="http://mmisw.org/ont/ioos/definition/operatorSector">
              <sml:codeSpace xlink:href="http://mmisw.org/ont/ioos/sector"/>
              <sml:value>academic</sml:value>
            </sml:Term>
          </sml:classifier>          
          <sml:classifier name="publisher">
            <sml:Term definition="http://mmisw.org/ont/ioos/definition/publisher">
              <sml:codeSpace xlink:href="http://mmisw.org/ont/ioos/organization"/>
              <sml:value>NANOOS</sml:value>
            </sml:Term>
          </sml:classifier>
          <sml:classifier name="sponsor">
            <sml:Term definition="http://mmisw.org/ont/ioos/definition/sponsor">
              <sml:codeSpace xlink:href="http://mmisw.org/ont/ioos/organization"/>
              <sml:value>ACE</sml:value>
            </sml:Term>
          </sml:classifier>
        </sml:ClassifierList>
      </sml:classification>
      <sml:validTime>
          <gml:TimePeriod>
              <gml:beginPosition>2002-05-04T00:00:00Z</gml:beginPosition>
              <gml:endPosition indeterminatePosition="now"/>
          </gml:TimePeriod>    
      </sml:validTime>
      <sml:capabilities name="observationTimeRange">
        <swe:DataRecord>
          <swe:field name="observationTimeRange">
            <swe:TimeRange definition="http://mmisw.org/ont/ioos/swe_element_type/observationTimeRange">
              <swe:value>2008-04-28T08:00:00.000Z 2012-12-27T19:00:00.000Z</swe:value>
            </swe:TimeRange>
          </swe:field>
        </swe:DataRecord>
      </sml:capabilities>     
      <sml:capabilities name="networkProcedures">
        <swe:SimpleDataRecord>
          <swe:field name="network1">
            <swe:Text definition="http://mmsiw.org/ont/ioos/definition/networkID">
              <swe:value>urn:ioos:network:nanoos:all</swe:value>
            </swe:Text>
          </swe:field>
          <swe:field name="network2">
            <swe:Text definition="http://mmsiw.org/ont/ioos/definition/networkID">
              <swe:value>urn:ioos:network:nanoos:network1</swe:value>
            </swe:Text>
          </swe:field>
          <swe:field name="network3">
            <swe:Text definition="http://mmsiw.org/ont/ioos/definition/networkID">
              <swe:value>urn:ioos:network:nanoos:network2</swe:value>
            </swe:Text>
          </swe:field>
        </swe:SimpleDataRecord>
      </sml:capabilities>
      <sml:contact>
        <sml:ContactList>
          <sml:member xlink:role="http://mmisw.org/ont/ioos/definition/operator">
            <sml:ResponsibleParty>
              <sml:organizationName>PNW Buoys</sml:organizationName>
              <sml:contactInfo>
                <sml:address>
                  <sml:deliveryPoint>1007 Balch Blvd.</sml:deliveryPoint>
                  <sml:city>Fremont</sml:city>
                  <sml:administrativeArea>WA</sml:administrativeArea>
                  <sml:postalCode>98195</sml:postalCode>
                  <sml:country>USA</sml:country>
                  <sml:electronicMailAddress>contact@buoys.com</sml:electronicMailAddress>
                </sml:address>
                <sml:onlineResource xlink:href="http://pnw.buoyoperator.org"/>
              </sml:contactInfo>
            </sml:ResponsibleParty>
          </sml:member>
          <sml:member xlink:role="http://mmisw.org/ont/ioos/definition/publisher">
            <sml:ResponsibleParty>
              <sml:organizationName>NANOOS</sml:organizationName>
              <sml:contactInfo>
                <sml:address>
                  <sml:country>USA</sml:country>
                  <sml:electronicMailAddress>mayorga@apl.washington.edu</sml:electronicMailAddress>
                </sml:address>
                <sml:onlineResource xlink:href="http://nanoos.org"/>
              </sml:contactInfo>
            </sml:ResponsibleParty>
          </sml:member>
        </sml:ContactList>
      </sml:contact>
      <sml:documentation>
        <sml:DocumentList>
          <sml:member name="qc" xlink:arcrole="qualityControlDocument">
            <sml:Document>
              <gml:description>Handbook of Automated Data Quality Control Checks and Procedures, National Data Buoy Center, August 2009</gml:description>
              <sml:format>pdf</sml:format>
              <sml:onlineResource xlink:href="http://www.ndbc.noaa.gov/NDBCHandbookofAutomatedDataQualityControl2009.pdf"/>
            </sml:Document>
          </sml:member>
          <sml:member name="wp1" xlink:arcrole="urn:ogc:def:role:webPage">
            <sml:Document>
              <gml:description>Station web page from provider</gml:description>
              <sml:format>text/html</sml:format>
              <sml:onlineResource xlink:href="STATION_WEBPAGE"/>
            </sml:Document>
          </sml:member>
          <sml:member name="wp2" xlink:arcrole="urn:ogc:def:role:webPage">
            <sml:Document>
              <gml:description>Station web page from operator</gml:description>
              <sml:format>text/html</sml:format>
              <sml:onlineResource xlink:href="STATION_WEBPAGE"/>
            </sml:Document>            
          </sml:member>
        </sml:DocumentList>
      </sml:documentation>
      <sml:history>
        <sml:EventList>
          <sml:member name="deployment_start">
            <sml:Event>
              <sml:date>2010-01-12</sml:date>
              <gml:description>Deployment start event</gml:description>
              <sml:documentation xlink:href="http://sdftest.ndbc.noaa.gov/sos/server.php?service=SOS&amp;request=DescribeSensor&amp;version=1.0.0&amp;outputformat=text/xml;subtype=&quot;sensorML/1.0.1&quot;&amp;procedure=urn:ioos:station:wmo:41001:20100112"/>
            </sml:Event>
          </sml:member>
          <sml:member name="deployment_stop">
            <sml:Event>
              <sml:date>2011-02-06</sml:date>
              <gml:description>Deployment stop event</gml:description>
              <sml:documentation xlink:href="http://sdftest.ndbc.noaa.gov/sos/server.php?service=SOS&amp;request=DescribeSensor&amp;version=1.0.0&amp;outputformat=text/xml;subtype=&quot;sensorML/1.0.1&quot;&amp;procedure=urn:ioos:station:wmo:41001:20100112"/>
            </sml:Event>
          </sml:member>
          <sml:member name="deployment_start">
            <sml:Event>
              <sml:date>2011-02-07</sml:date>
              <gml:description>Deployment start event</gml:description>
              <sml:documentation xlink:href="http://sdftest.ndbc.noaa.gov/sos/server.php?service=SOS&amp;request=DescribeSensor&amp;version=1.0.0&amp;outputformat=text/xml;subtype=&quot;sensorML/1.0.1&quot;&amp;procedure=urn:ioos:station:wmo:41001:20110207"/>
            </sml:Event>
          </sml:member>
        </sml:EventList>
      </sml:history>
      <sml:location>
        <gml:Point srsName="http://www.opengis.net/def/crs/EPSG/0/4326">
        <gml:pos>34.7 -72.73</gml:pos>
        </gml:Point>
      </sml:location>
      <sml:components>
        <sml:ComponentList>
          <sml:component name="WatertempSensor1">
            <sml:System >
              <gml:description>Surface water temperature sensor on WMO platform 41001</gml:description>
              <sml:identification xlink:href="urn:ioos:sensor:wmo:41001:watertemp1"/>
              <sml:documentation xlink:href="http://sdftest.ndbc.noaa.gov/sos/server.php?service=SOS&amp;request=DescribeSensor&amp;version=1.0.0&amp;outputformat=text/xml;subtype=&quot;sensorML/1.0.1&quot;&amp;procedure=urn:ioos:sensor:wmo:41001:watertemp1"/>
              <sml:outputs>
                <sml:OutputList>
                  <sml:output name="Water Temperature">
                    <swe:Quantity definition="http://mmisw.org/ont/cf/parameter/sea_water_temperature">
                      <swe:uom code="degC" />
                    </swe:Quantity>
                  </sml:output>
                </sml:OutputList>
              </sml:outputs>
            </sml:System>
          </sml:component>
          <sml:component name="Sensor ct1">
            <sml:System gml:id="sensor-ct1">
              <gml:description/>
              <sml:identification xlink:href="urn:ioos:sensor:wmo:41001:ct1"/>
              <sml:documentation xlink:href="http://sdftest.ndbc.noaa.gov/sos/server.php?service=SOS&amp;request=DescribeSensor&amp;version=1.0.0&amp;outputformat=text/xml;subtype=&quot;sensorML/1.0.1&quot;&amp;procedure=urn:ioos:sensor:wmo:41001:ct1"/>
              <sml:outputs>
                <sml:OutputList>
                  <sml:output name="Water Temperature">
                    <swe:Quantity definition="http://mmisw.org/ont/cf/parameter/sea_water_temperature">
                      <swe:uom code="degC" />
                    </swe:Quantity>
                  </sml:output>
                  <sml:output name="Salinity">
                    <swe:Quantity definition="http://mmisw.org/ont/cf/parameter/sea_water_salinity">
                      <swe:uom code="PSU" />
                    </swe:Quantity>
                  </sml:output>
                </sml:OutputList>
              </sml:outputs>
            </sml:System>
          </sml:component>
          <sml:component name="Sensor baro1">
            <sml:System>
              <gml:description/>
              <sml:identification xlink:href="urn:ioos:sensor:wmo:41001:baro1"/>
              <sml:documentation xlink:href="http://sdftest.ndbc.noaa.gov/sos/server.php?service=SOS&amp;request=DescribeSensor&amp;version=1.0.0&amp;outputformat=text/xml;subtype=&quot;sensorML/1.0.1&quot;&amp;procedure=urn:ioos:sensor:wmo:41001:baro1"/>
              <sml:outputs>
                <sml:OutputList>
                  <sml:output name="Barometric Pressure">
                    <swe:Quantity definition="http://mmisw.org/ont/cf/parameter/air_pressure">
                      <swe:uom code="mb" />
                    </swe:Quantity>
                  </sml:output>
                </sml:OutputList>
              </sml:outputs>
            </sml:System>
          </sml:component>
          <sml:component name="Sensor airtemp1">
            <sml:System gml:id="sensor-airtemp1">
              <gml:description/>
              <sml:identification xlink:href="urn:ioos:sensor:wmo:41001:airtemp1"/>
              <sml:outputs>
                <sml:OutputList>
                  <sml:output name="Air Temperature">
                    <swe:Quantity definition="http://mmisw.org/ont/cf/parameter/air_temperature">
                      <swe:uom code="degC" />
                    </swe:Quantity>
                  </sml:output>
                </sml:OutputList>
              </sml:outputs>
            </sml:System>
          </sml:component>
        </sml:ComponentList>
      </sml:components>
    </sml:System>
  </sml:member>
</sml:SensorML>
```

The IOOS Convention provides more specific guidance to some SensorML elements’ implementation in the DescribeSensor template for platform/station; such elements are listed in the table below, and their specifics are explained as well:

| Input Name | Cardinality | Description |
| :--- | :---: | :--- |
| sml:capabilities<br /> name="ioosServiceMetadata" | 1…1 |Provides information of the IOOS template version. |
| sml:member | 1…1 | The element that bounds the description of the platform specified in the “procedure” element of the DescribeSensor request. SensorML document contains only one \<member\> element because SOS DescribeSensor request only allows single “procedure”. Member system description must include the following sections: {::nomarkdown}<ul><li>Platform Name & Description</li><li>Platform Identifiers</li><li>Platform Classifiers</li><li>Temporal Bounds for observations</li><li>List of the networks the platform belongs to</li><li>Contacts</li><li>Components (all sensors located on the platform)</li</ul>{:/} |
| sml:identification | 1…1 | In this template provides identity and alias information for the platform (in \<sml:member/sml:System\> section), and for all component sensors (in \<sml:component/sml:System\> sections). <br /><br />For the platform, the _**stationID**_, _**shortName**_ and _**longName**_ are required; however, only _**sensorID**_ is mandatory for component sensors. In both cases, other appropriate identification information is encouraged. <br /><br />A _**wmoID**_ is an optional identifier for the Milestone 1.0 but is strongly recommended for each platform when it is available. The _**wmoID**_ should be specified as a separate identifier even if the main _**stationID**_ URN uses the WMO authority:<br />{::nomarkdown}<pre>&lt;sml:identifier name="wmoID"&gt;<br />    &lt;sml:Term definition=http://mmisw.org/ont/ioos/definition/wmoID&gt;<br />        &lt;sml:value&gt;41001&lt;/sml:value&gt;<br />    &lt;/sml:Term&gt;<br />&lt;/sml:identifier&gt;</pre>{:/} |
| sml:classification | 1…1 | In this template specifies classification values that describe the content of the network offering with terms defined in external vocabularies. The following classifiers are required by IOOS Convention for all platforms:{::nomarkdown}<ul><li>parentNetwork (e.g. “NANOOS”)</li><li>platformType (e.g. “buoy”)</li><li>operatorSector (e.g. “academic”) </li><li>publisher  (e.g. “NANOOS”)</li><li>sponsor (e.g. “ACE”)</li></ul>{:/}<br />_**Note that at least one parent network must reference an IOOS codespace and list the RA Acronym**_|
| sml:validTime | 0…1 | The \<sml:validTime\> is used only to specify a time period, in which this specific DescribeSensor document is valid. The validity period usually goes from the platform deployment date to today (indicated by 'now' in the example above) or the end of the life of the platform. <br /><br />The validity period may be different, however, if any of the sensors installed on the platform had limited functionality due to some incident, got replaced or removed. When such incident occurs, a new DescribeSensor document shall be created with a validity period going from the date of that incident to the date of the next one (or "now" if there were no more incidents), while the old document shall be archived with a validity period ending at the date of the incident.
| sml:capabilities <br />name="observationTimeRange" | 1…1 | Describes the valid time range over which observations from a whole network or a component platform exist.
| sml:capabilities <br />name="networkProcedures" | 0…1 | An optional but strongly recommended  list of all parent networks to which this platform/station belongs. In a similar manner, the DescribeSensor document for sensor indicates the parent station.
| sml:contact | 0…1 | Lists all relevant contacts for the platform specified. The mandatory contacts are _**Publisher**_ and _**Operator**_ but any other relevant contact may be described here.<br /><br />It is strongly recommended to represent any reference to external resource using an “xlink:href” attribute in the following manner: <br />`<sml:contact xlink:href="http://sdf.ndbc.noaa.gov"/>`, <br />or<br />`<sml:onlineResource xlink:href="http://pnw.buoyoperator.org"/>` <br /><br />IOOS Convention requires only \<sml:country\> and \<sml:electronicMailAddress\> for the contact address. However, it is strongly recommended to provide as detailed contact information as possible, e.g. for the address: <br />{::nomarkdown}<pre>&lt;sml:address&gt;<br />    &lt;sml:deliveryPoint/&gt;<br />    &lt;sml:city/&gt; <br />    &lt;sml:administrativeArea/&gt; <br />    &lt;sml:postalCode/><br />    &lt;sml:country/&gt; <br />    &lt;sml:electronicMailAddress/&gt;<br />&lt;/sml:address&gt; </pre>{:/} |
| sml:documentation | 0…1 | Specifes the external resources for human consumption about this platform and the observation data it produces. |
| sml:history | 0…1 | Lists events and status changes of the platform such as deployment and recovery. |
| sml:location | 1…1 | Specifes the geographic location of the platform in EPSG::4326 (lat, lon) |
| sml:components | 1…1 | Lists all sensors installed on the described platform. |
| sml:component | 1…* | Describes each individual sensor from the component list. The sensor name should be a human readable label.<br /><br />The following 2 elements are mandatory for each sensor:{::nomarkdown}<ul><li><b>&lt;sml:identification&gt;</b> <br />to indicate <i>sensorID</i> for the specific sensor;</li><li><b>&lt;sml:outputs&gt;</b> <br />to specify the list of all properties observed by the sensor.</li></ul>{:/}<br />The other 2 elements are optional but strongly recommended for each sensor:{::nomarkdown}<ul><li><b>&lt;sml:description&gt;</b> <br />to briefly describe the sensor in a human-readable form; </li><li><b>&lt;sml:documentation&gt;</b> <br />to specify the external resources for human consumption about this sensor and the observation data it produces.</li></ul>{:/} |


#### **Network of platforms/stations**{: style="color: crimson"}

A mandatory DescribeSensor response for a network of platforms/stations shall return:

-   information on the IOOS Template version
-   network description
-   search keywords
-   network identifiers, such as
  -   networkID
  -   short name
  -   long name (optional)
-   relevant contact information for this specific network
-   list of platforms of the network with their identifiers
-   list of offerings for the network
-   time range for observations
-   list of observed properties for the network

The template for a generic DescribeSensor document for network is shown below. The template is independent of feature types, and presents just enough metadata to determine what additional descriptions are needed. The specifics of some elements’ use in the network template are discussed in details later.

```XML
<sml:SensorML 
    xmlns:sml="http://www.opengis.net/sensorML/1.0.1" 
    xmlns:gml="http://www.opengis.net/gml" 
    xmlns:swe="http://www.opengis.net/swe/1.0.1" 
    xmlns:xlink="http://www.w3.org/1999/xlink" 
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
    xsi:schemaLocation="http://www.opengis.net/sensorML/1.0.1 http://schemas.opengis.net/sensorML/1.0.1/sensorML.xsd" 
    version="1.0.1">
    <sml:capabilities name="ioosServiceMetadata">
        <swe:SimpleDataRecord>
            <swe:field name="ioosTemplateVersion">
                <swe:Text definition=”http://code.google.com/p/ioostech/source/browse/#svn%2Ftrunk%2Ftemplates%2FMilestone1.0”>
                    <swe:value>1.0</swe:value>
                </swe:Text>
            </swe:field>
        </swe:SimpleDataRecord>
    </sml:capabilities> 
    <sml:member>
        <sml:System>
            <gml:description>Collection of all station assets available via the NANOOS SOS service</gml:description>
            <gml:name>urn:ioos:network:nanoos:all</gml:name>
            <gml:boundedBy>
                <gml:Envelope srsName="http://www.opengis.net/def/crs/EPSG/0/4326">
                    <gml:lowerCorner>32.7 -75.0</gml:lowerCorner>
                    <gml:upperCorner>34.7 -72.0</gml:upperCorner>
                </gml:Envelope>
            </gml:boundedBy> 
            <sml:identification>
                <sml:IdentifierList>
                    <sml:identifier name="networkID">
                        <sml:Term definition="http://mmisw.org/ont/ioos/definition/networkID">
                            <sml:value>urn:ioos:network:nanoos:all</sml:value>
                        </sml:Term>
                    </sml:identifier>
                    <sml:identifier name="shortName">
                        <sml:Term definition="http://mmisw.org/ont/ioos/definition/shortName">
                            <sml:value>NANOOS SOS station assets collection</sml:value>
                        </sml:Term>
                    </sml:identifier>
                    <sml:identifier name="longName">
                        <sml:Term definition="http://mmisw.org/ont/ioos/definition/longName">
                            <sml:value>Collection of all station assets available via the NANOOS SOS service</sml:value>
                        </sml:Term>
                    </sml:identifier>
                </sml:IdentifierList>
            </sml:identification>
            <sml:classification>
                <sml:ClassifierList>
                    <sml:classifier name="publisher">
                        <sml:Term definition="http://mmisw.org/ont/ioos/definition/publisher">
                            <sml:codeSpace xlink:href="http://mmisw.org/ont/ioos/organization"/>
                            <sml:value>NANOOS</sml:value>
                        </sml:Term>
                    </sml:classifier>
                    <sml:classifier name="parentNetwork">
                        <sml:Term definition="http://mmisw.org/ont/ioos/definition/parentNetwork">
                            <sml:codeSpace xlink:href="http://mmisw.org/ont/ioos/organization"/>
                            <sml:value>NANOOS</sml:value>
                        </sml:Term>
                    </sml:classifier>
                </sml:ClassifierList>
            </sml:classification>
            <sml:capabilities name="observationTimeRange">
                <swe:DataRecord>
                    <swe:field name="observationTimeRange">
                        <swe:TimeRange definition="http://mmisw.org/ont/ioos/swe_element_type/observationTimeRange">
                            <swe:value>2008-04-28T08:00:00.000Z 2012-12-27T19:00:00.000Z</swe:value>
                        </swe:TimeRange>
                    </swe:field>
                </swe:DataRecord>
            </sml:capabilities>     
            <sml:contact>
                <sml:ContactList>
                    <sml:member xlink:role="http://mmisw.org/ont/ioos/definition/operator">
                        <sml:ResponsibleParty>
                            <sml:organizationName>PNW Buoys</sml:organizationName>
                            <sml:contactInfo>
                                <sml:address>
                                    <sml:deliveryPoint>1007 Balch Blvd.</sml:deliveryPoint>
                                    <sml:city>Fremont</sml:city>
                                    <sml:administrativeArea>WA</sml:administrativeArea>
                                    <sml:postalCode>98195</sml:postalCode>
                                    <sml:country>USA</sml:country>
                                    <sml:electronicMailAddress>contact@buoys.com</sml:electronicMailAddress>
                                </sml:address>
                                <sml:onlineResource xlink:href="http://pnw.buoyoperator.org"/>
                            </sml:contactInfo>
                        </sml:ResponsibleParty>
                    </sml:member>
                    <sml:member xlink:role="http://mmisw.org/ont/ioos/definition/publisher">
                        <sml:ResponsibleParty>
                            <sml:organizationName>NANOOS</sml:organizationName>
                            <sml:contactInfo>
                                <sml:address>
                                    <sml:country>USA</sml:country>
                                    <sml:electronicMailAddress>mayorga@apl.washington.edu</sml:electronicMailAddress>
                                </sml:address>
                                <sml:onlineResource xlink:href="http://nanoos.org"/>
                            </sml:contactInfo>
                        </sml:ResponsibleParty>
                    </sml:member>
                </sml:ContactList>
            </sml:contact>
            <sml:components>
                <sml:ComponentList>          
                    <sml:component name="wmo_41001">
                        <sml:System>
                            <sml:identification>
                                <sml:IdentifierList>
                                    <sml:identifier name="stationID">
                                        <sml:Term definition="http://mmisw.org/ont/ioos/definition/stationID">
                                            <sml:value>urn:ioos:station:wmo:41001</sml:value>
                                        </sml:Term>
                                    </sml:identifier>
                                    <sml:identifier name="shortName">
                                        <sml:Term definition="http://mmisw.org/ont/ioos/definition/shortName">
                                            <sml:value>WMO 41001 Buoy, Cape Hatteras</sml:value>
                                    <sml:identifier name="longName">
                                        <sml:Term definition="http://mmisw.org/ont/ioos/definition/longName">
                                            <sml:value>urn:ioos:station:wmo:41001 buoy station, 150 NM East of Cape Hatteras</sml:value>
                                        </sml:Term>
                                    </sml:identifier>
                                </sml:IdentifierList>
                            </sml:identification>
                            <sml:capabilities name="observationTimeRange">
                                <swe:DataRecord>
                                    <swe:field name="observationTimeRange">
                                        <swe:TimeRange definition="http://mmisw.org/ont/ioos/swe_element_type/observationTimeRange">
                                            <swe:value>2006-02-12T00:00:00.000Z 2013-04-21T00:00:00.000Z</swe:value>
                                        </swe:TimeRange>
                                    </swe:field>
                                </swe:DataRecord>
                            </sml:capabilities>
                            <sml:location>
                                <gml:Point srsName="http://www.opengis.net/def/crs/EPSG/0/4326">
                                    <gml:pos>34.7 -72.73</gml:pos>
                                </gml:Point>
                            </sml:location>
                            <sml:outputs>
                                <sml:OutputList>
                                    <sml:output name="Sea Water Temperature">
                                        <swe:Quantity definition="http://mmisw.org/ont/cf/parameter/sea_water_temperature"/>
                                    </sml:output>
                                    <sml:output name="Dissolved Oxygen">
                                        <swe:Quantity definition="http://mmisw.org/ont/cf/parameter/dissolved_oxygen"/>
                                    </sml:output>
                                </sml:OutputList>
                            </sml:outputs>
                        </sml:System>
                    </sml:component>
                </sml:ComponentList>
            </sml:components>
        </sml:System>
    </sml:member>
</sml:SensorML>
```

The IOOS Convention provides more detailed guidance to some SensorML elements’ implementation in the template; such elements are listed in the table below, and their specifics are explained as well:

| Input Name | Cardinality | Description |
| :--- | :---: | :--- |
| sml:capabilities<br />name="ioosServiceMetadata" | 1…1 | Provides information of the IOOS template version. |
| sml:member|1…1<br /><br />_**Note: For the elements hereinafter in this table, the cardinality is for each \<sml:member\>**_ | The element that bounds the description of the network of platforms that is specified in the “procedure” element of the DescribeSensor request. SensorML document contains only one <member> element because only one “procedure” parameter is allowed in SOS DescribeSensor request. Member system description generally includes the following sections: <br />&nbsp; &nbsp; &nbsp;• Name & Description<br />&nbsp; &nbsp; &nbsp;• Temporal & Spatial Bounds<br />&nbsp; &nbsp; &nbsp;• Identifiers<br />&nbsp; &nbsp; &nbsp;• Classifiers<br />&nbsp; &nbsp; &nbsp;• Contacts<br />&nbsp; &nbsp; &nbsp;• Components (platforms/stations that belong to the network)|
| gml:boundedBy | 1…1 | Depicts spatial bounds of the network segment that is described in the document. All platforms that are located within the bounded segment must be listed in the \<sml:components\> section of the document. |
| sml:identification | 1…1 | In this template provides identity and alias information for the network itself (in \<sml:member/System\> section), and for all component platforms (in \<sml:component/System\> sections). <br />The _**networkID**_, _**shortName**_ and _**longName**_ are required for the network, and for the component platform, just _**stationID**_ and _**shortName**_ are mandatory. <br />The other appropriate identification information is optional but its presentation is strongly encouraged. <br /> A WMO ID is an optional identifier for now but it is recommended to specify it for each platform when it is available.|
| sml:classification | 1…1 | In this template specifies classification values that describe the content of the network offering with terms defined in external vocabularies. The reference to at least one parent network with IOOS codespace and RA Acronym value is required, e.g.: <br />{::nomarkdown}<pre>&lt;sml:classifier name="parentNetwork"&gt;<br />    &lt;sml:Term definition="http://mmisw.org/ont/ioos/definition/parentNetwork"&gt;<br />        &lt;sml:codeSpace xlink:href="http://mmisw.org/ont/ioos/organization"/&gt;<br />        &lt;sml:value>NANOOS</sml:value&gt;<br />    &lt;/sml:Term&gt;<br />&lt;/sml:classifier&gt;</pre>{:/} |
| sml:capabilities <br /> name="observationTimeRange" | 1…1 | Describes the valid time range over which observations from a whole network or a component platform exist, as opposed to the \<sml:validTyme\>. |
| sml:contact | 0…1 | Lists all relevant contacts for the network. The mandatory contacts are _**Publisher**_ and _**Operator**_ but any other relevant contact may be described here. <br /><br />It is strongly recommended to represent any reference to external resource using an “xlink:href” attribute in the following manner: <br /><br />`<sml:contact xlink:href="http://sdf.ndbc.noaa.gov"/>`, or<br />`<sml:onlineResource xlink:href="http://pnw.buoyoperator.org"/>` <br /><br />IOOS Convention requires only \<sml:country\> and \<sml:electronicMailAddress\> for the contact address. However, it is strongly recommended to provide as many details for contact as possible, e.g.<br />{::nomarkdown}<pre>&lt;sml:address&gt;<br />    &lt;sml:deliveryPoint/&gt;<br />    &lt;sml:city/&gt; <br />    &lt;sml:administrativeArea/&gt; <br />    &lt;sml:postalCode/&gt;<br />    &lt;sml:country/&gt; <br />    &lt;sml:electronicMailAddress/&gt;<br />&lt;/sml:address&gt;</pre>{:/} |
| sml:components | 1…1 | Lists all platforms in the network offering that are located within the spatial segment defined in the `<gml:boundedBy>` element. |
| sml:component | 1…* | Describes each individual platform from the list. The following elements and associated attributes are required for each platform: <br />{::nomarkdown}<ul><li><b>&lt;sml:identification&gt;</b> <br />to indicate <i>stationID</i>, <i>shortName</i> and <i>longName</i> (optionally) for the specific platform; an indication of a _wmoID_ is strongly recommended as well;</li><li><b>&lt;sml:capabilities  name="observationTimeRange"&gt;</b> <br />to indicate observation time range;</li><li><b>&lt;sml:location/gml:Point&gt;</b> <br />to specify the 2D geographic location of the fixed platform (always in EPSG::4326);</li><li><b>&lt;sml:outputs&gt;</b> <br />to specify the properties observed by the platform</li></ul>{:/}|


#### **Sensor**{: style="color: crimson"}

The IOOS SOS Milestone 1.0 does not require a provision of DescribeSensor documents for individual sensors. However, if an SOS server offers these documents nevertheless, the corresponding DescribeSensor response should return:

-   information on the IOOS Template version
-   sensor description
-   search keywords
-   mandatory sensor identifiers, such as
  -   sensorID
  -   short name
  -   long name (optional)
-   platform identifier for the platform, on which the sensor is located
-   time range for observations
-   list of all offerings associated with the sensor
-   list of all observed properties associated with the sensor

If the DescribeSensor document for individual sensor is provided, the IOOS Convention encourages to keep its content in line with the required network and station/platform documents. Recommended use of some SensorML elements in the DescribeSensor response for individual sensor is described in the table below:

| Input Name | Cardinality | Description |
| :--- | :---: | :--- |
| sml:capabilities <br />name="ioosServiceMetadata" | 1…1 | Provides information of the IOOS template version. |
| sml:member | 1…1 <br />_**Note: For the elements hereinafter in this table, the cardinality is for each \<sml:member\>**_ | The element that bounds the description of the sensor specified in the “procedure” element of the DescribeSensor request. SensorML document contains only one \<member\> element because SOS DescribeSensor request only allows single “procedure”. Member system description must include the following sections: {::nomarkdown}<ul><li>Sensor Name & Description</li><li>Sensor Identifiers</li><li>Sensor Capabilities</li><li>Observed properties associated with the sensor</li></ul>{:/} |
| sml:identification | 1…1 | In this template provides identity and alias information for the sensor. The _**sensorID**_ and _**shortName**_ are required; however, other appropriate identification information may also be presented. |
| sml:validTime | 0…1 | The \<sml:validTime\> is used only to specify a time period, in which this specific DescribeSensor document is valid. The validity period usually goes from the sensor deployment date to today (indicated by 'now' in the example above), unless the sensor had an incident that resulted in a limited functionality or complete replacement. When such incident occurs, a new DescribeSensor document shall be created with a validity period going from the date of that incident to the date of the next one (or "now" if there were no more incidents), while the old document shall be archived with a validity period ending at the date of the incident. |
| sml:capabilities <br />name="featuresOfInterest" | 1…1 | Describes geo-object, which is a subject to the measured values and is measured by sensor, i.e. the platform, which the sensor is installed on. |
| sml:capabilities <br />name="offerings" | 1…1 | A list of all offerings associated with the sensor. |
| sml:capabilities <br />name="stationProcedure" | 1…1 | A parent station, which the sensor installed on; in this context, it is similar to the “featureOfInterest”. |
| sml:capabilities <br />name="observationTimeRange" | 1…1 | Describes the valid time range over which observations from the sensor exist, as opposed to the \<sml:validTime\>.
| sml:inputs | 1…* | Describes the generic observed property, i.e. physical phenomena that are measured by the sensor, e.g. Wind, Current, etc. |
| sml:outputs | 1…* | Describes the specific results of the measurement of the input physical phenomena, e.g. Wind speed, Wind direction, etc. |


## **GetObservation**{: style="color: crimson"}

A **GetObservation** operation queries SOS to retrieve observation data structured according to the Observation and Measurement specification. Upon receiving a GetObservation request, a SOS shall either satisfy the request or return an exception report. The GetObservation operations provides observations based on the setting of filters that includes timing, processes, phenomena, feature of interest, and other parameters of the O&M model.

### **GetObservation Request**{: style="color: crimson"}

A **GetObservation** request contains one or more elements that constrain the observations to be retrieved from a Sensor Observation Service. Each GetObservation query element has mandatory attributes of service and version. The mandatory version element attribute must correspond to the specific service interface version negotiated between the service and client during the service binding process. The required service attribute explicitly must be “SOS”.

The UML diagram of the GetObservation request is presented in [**Figure 7**](#Fig_7), and input parameters are elaborated in the following table.

![](./sos-wsdd-image23.png)

<a name="Fig_7"></a> **Figure 7: GetObservation request schema**<br><br>

| Input Name | Cardinality | Description |
| :--- | :---: | :--- |
| service | 1…1 | Service name (always SOS) |
| version | 1…1 | Service version |
| request | 1…1 | Operation name |
| offering | 1…1 | Specifies the offering URN advertised in the GetCapabilities document. GetObservation request to IOOS-compliant SOS server shall include ONLY one offering, but may include multiple procedures instead (see below). |
| observedProperty | 1…* | Specifies the phenomenon for which observations are requested as a URL of a corresponding vocabulary record, e.g. http://mmisw.org/ont/cf/parameter/air_temperature |
| responseFormat | 1…1 | The desired output format of the GetObservation operation; must always be considered as one of the supported output formats listed in \<sos:responseFormat\>  element in GetCapabilities document.

The OGC SOS v1.0.0 Implementation Standard defines a number of other parameters that must be supported by the server but are not required in a GetObservation request. Although the use of these parameters is optional, they may significantly refine the query result:

| Input Name | Cardinality | Description |
| :--- | :---: | :--- |
| procedure | 0…* | Specifies the sensor system(s) for which observations are requested; defines a filter for the procedure property of the observations. The type is “anyURI”, and it must match the value of the “xlink:href=” attribute in an \<sos:procedure\> element advertized in GetCapabilities response . <br /><br />Examples:{::nomarkdown}<ul><li>Network<br /><pre>urn:ioos:network:test:all</pre></li><li>Station/Platform<br /><pre>urn:ioos:station:test:station_name</pre></li><li>Sensor<br /><pre>urn:ioos:sensor:test:station_name:sensor_name</pre> </li></ul>{:/}|
|eventTime | 0…1 | Specifies the time period(s) for which observations are requested. <br /><br />The time should conform to ISO format: YYYY-MM-DDTHH:mm:ss±HH. Time instance is given as one time value. Periods of time (start and end) are separated by "/". For example: 2009-06-26T10:00:00+01/2009-06-26T11:00:00+01.<br />Although SOS v1.0 specification allows requests with no temporal boundaries, the SOS v1.0 fails to properly describe the server response to such request. For that specific case, the IOOS Convention requires SOS server to follow the SOS v2.0 specification, and return all records matching a user’s request. However, as a result limit may be employed by the SOS server, a ResponseExceedsSizeLimit exception code will be returned instead if that limit is exceeded. |
| featureOfInterest | 0…* | Specifies the feature for which observations are requested. This should be presented in a form of comma-separated URIs advertised in the GetCapabilities document or a bounding box for requested data, i.e. featureOfInterest=BBOX:min_lon,min_lat,max_lon,max_lat |
| resultModel | 0…* | Specifies the name of the root element of a GetObservation response. The IOOS Convention requires resultModel to be “om:ObservationCollection”. 
| srsName | 0…1 | Attribute that defines the spatial reference system that should be used for any geometry that is returned in the response. <br />If present, it must be one of the advertised CRS values specified in \<gml:srsName\> element or “srsName” attribute of the \<gml:boundedBy/gml:Envelope\> element in the GetCapabilities document.<br />If omitted, it is assumed that the CRS is WGS 84 identified as urn:ogc:def:crs:EPSG::4326 “ |
| result | 0…1 | Instructs the SOS to only return observations where the result matches the expression or value. For example, CO-OPS supports a long list of constraints such as IGLD (`urn:ioos:def:datum:noaa::IGLD`), MHHW (`urn:ioos:def:datum:noaa::MHHW`), NAVD (`urn:ogc:def:datum:epsg::5103`), and so forth. |
| responseMode | 0…1 | Specifies whether results are requested in-line, out-of-band, as an attachment or resultTemplate. |


In addition to the standard set of parameters, some of the IOOS data providers have implemented various unique non-standard parameters. Although the use of such parameters may be advantageous, certain caution should be exercised because the support of these parameters is provider-specific; for example, some of the non-standard request parameters supported by CO-OPS are described in the table below:

| Input Name | Cardinality | Description |
| :--- | :---: | :--- |
| unit | 0…1 | Specifies units for requested water level predictions, harmonic constituents or datums data. Valid values are {::nomarkdown}<ul><li>Meters</li><li>Feet</li></ul>{:/}<br />If no unit is specified, the data in meters is retrieved. |
| timeZone | 0…1 | Specifies a time zone for requested harmonic constituents’ data only. Valid values are {::nomarkdown}<ul><li>GMT </li><li>LST (e.g. EST, CST, etc)</li></ul>{:/}<br />_GMT_ is a default value if no time zone is specified. |
| epoch | 0…1 | Specifies the epoch for requested datums data only. Valid values are {::nomarkdown}<ul><li>Current</li><li>Superseded</li></ul>{:/}<br /> _Current_ is a default value if no epoch is specified. |
| dataType | 0…1 | Specifies the data type for requested water level data or tide predictions. Valid values are {::nomarkdown}<ul><li>PreliminarySixMinute</li><li>PreliminaryOneMinute</li><li>VerifiedSixMinute</li><li>VerifiedHourlyHeight</li><li>VerifiedHighLow</li><li>VerifiedDailyMean</li><li>SixMinuteTidePredictions</li><li>HourlyTidePredictions</li><li>HighLowTidePredictions</li></ul>{:/}<br />If no data type is specified, preliminary six minute data type is retrieved for water level, six minute data type is retrieved for tide predictions. |


The following examples illustrate HTTP/GET and HTTP/POST GetObservation requests. Note that in HTTP/GET (KVP) request, the parameter names are case insensitive. The following example shows equivalent terms for a parameter “outputFormat”: outputFormat, outputformat, OUTPUTFORMAT, or OUTPUTfORMAT. As a guideline, it is suggested that lowercase names be used for ease-of-reading and consistency. On the contrary, it is recommended to use the UpperCamelCase for the parameter values like GetCapabilities or DescribeSensor, as they are case sensitive:

-   HTTP/GET:

```HTML
http://SERVERNAME:PORT/SOS_WEBAPP_NAME/sos?service=SOS&version=1.0.0&request=GetObservation&offering=urn:ioos:network:test:all&observedProperty=http://mmisw.org/ont/cf/parameter/wind_speed&procedure=urn:ioos:station:test:blighreef&responseFormat= text/xml; subtype="om/1.0.0/profiles/ioos_sos/1.0"
````

-   HTTP/POST:

```XML
<sos:GetObservation xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xsi:schemaLocation="http://www.opengis.net/sos/1.0 http://schemas.opengis.net/sos/1.0.0/sosAll.xsd"
    xmlns:sos="http://www.opengis.net/sos/1.0" 
    xmlns:om="http://www.opengis.net/om/1.0"
    service="SOS" version="1.0.0" srsName="EPSG:4326">
    <sos:offering>urn:ioos:network:test:all</sos:offering>
    <sos:observedProperty>http://mmisw.org/ont/cf/parameter/wind_speed</sos:observedProperty>
    <sos:responseFormat> text/xml; subtype="om/1.0.0/profiles/ioos_sos/1.0"</sos:responseFormat>
    <sos:resultModel>om:Observation</sos:resultModel>
    <sos:responseMode>inline</sos:responseMode>
</sos:GetObservation>
```

### **GetObservation Response**{: style="color: crimson"}

A **GetObservation** response returns a collection of observations. Each observation is composed of metadata, description of the phenomena being returned (parameter names, units of measure, reference systems) and values.

IOOS has developed a series of templates for **GetObservation** response. In general, IOOS considers GetObservation response as consisted of common generic metadata part and result block. The former contains generic, independent of feature type, metadata that describes features and observations, whereas the result block is a SWE Data Record construct that contains the values defined in the first part of the response.

Since the common metadata parts of any GetObservation response are practically the same, IOOS has developed a single [OM-GetObservation](http://code.google.com/p/ioostech/source/browse/trunk/templates/Milestone1.0/OM-GetObservation.xml) template for that part of the response. However, the result block is noticeably different depending on the feature type, and therefore IOOS has developed five individual SWE-GetObservation templates for various combinations of Milestone 1.0 feature types (i.e. TimeSeries and TimeSeriesProfile), single and multiple stations, and availability of information about data quality (QC):

-   [SWE-MultiStation-TimeSeries](http://code.google.com/p/ioostech/source/browse/trunk/templates/Milestone1.0/SWE-MultiStation-TimeSeries.xml)
-   [SWE-MultiStation-TimeSeries\_QC](http://code.google.com/p/ioostech/source/browse/trunk/templates/Milestone1.0/SWE-MultiStation-TimeSeries_QC.xml)
-   [SWE-SingleStation-SingleProperty-TimeSeries](http://code.google.com/p/ioostech/source/browse/trunk/templates/Milestone1.0/SWE-SingleStation-SingleProperty-TimeSeries.xml)
-   [SWE-SingleStation-TimeSeriesProfile](http://code.google.com/p/ioostech/source/browse/trunk/templates/Milestone1.0/SWE-SingleStation-TimeSeriesProfile.xml)
-   [SWE-SingleStation-TimeSeriesProfile\_QC](http://code.google.com/p/ioostech/source/browse/trunk/templates/Milestone1.0/SWE-SingleStation-TimeSeriesProfile_QC.xml)

Only critical templates’ components are discussed hereinafter just in order to limit the size of the document; however, all necessary measures were taken to ensure that template description completeness has not suffered. At any rate, the templates are well commented, and can provide a lot of needed information themselves.

#### **OM-GetObservation Template**{: style="color: crimson"}

The outline of the OM-GetObservation template is presented below:

```XML
<om:ObservationCollection>
    <gml:metaDataProperty xlink:title="disclaimer">
                            A human-readable disclaimer if considered useful
    </gml:metaDataProperty>
    <gml:metaDataProperty xlink:title="ioosTemplateVersion"
                            A version of the IOOS Template used in this document 
    </gml:metaDataProperty>
    <om:member>
                            Contains all observation offerings for the same feature type (e.g. timeSeries)
        <om:Observation>
            <gml:description>
                            A human-readable description of the observation. Should include station(s) name and location
                            as well as sensor or procedure information if possible                             
            </gml:description>
            <om:samplingTime>
                            Descrition of the time range over which the reported observations from a sensor or station exist 
            </om:samplingTime>
            <om:procedure>
                            List of all stations (sensor systems) for which observations are reported
            </om:procedure>
            <om:observedProperty>
                            List of the phenomena for which observations are reported
            </om:observedProperty>
            <om:featureOfInterest>
                    <gml:metaDataProperty>
                            Description of the CF Feature Type (discrete-sampling-geometry), e.g. timeSeries                    
                    </gml:metaDataProperty>
                    <gml:boundedBy>
                            Description of the geographic (lat/ lon) Bounding Box of the feature                   
                    </gml:boundedBy>
                    <gml:location>
                            List of geographical positions of the stations that fall inside the Bounding Box 
                    </gml:location>
            </om:featureOfInterest>
            <om:result>
                            SWE document conforming to one of the Milestone 1.0 SWE-GetObservation templates
            <om:result>
        </om:Observation>
    </om:member>
            […]
    <om:member>
                            Contains all observation offerings for another feature type (e.g. timeSeriesProfile)
    </om:member>
</om:ObservationCollection>
```

| Input Name | Cardinality | Description |
| :--- | :---: | :--- |
| gml:metaDataProperty <br />xlink:title="disclaimer" | 0…1 | Provides a human-readable disclaimer (if required) bounded by \<gml:description\>. |
| gml:metaDataProperty <br />xlink:title="ioosTemplateVersion" | 1…1 | Provides information of the IOOS template version. |
| om:member | 1…* <br />_**Note: For the elements hereinafter in this table, the cardinality is for each \<om:member\>**_ | A GetObservation response shall contain at least one member observation that reports offerings. All stations corresponding to the same CF feature type (discrete-sampling-geometries) shall be reported in a single \<om:member\> block. Conversely, if the GetObservation request contains more than one feature type, then each feature type shall be reported in a separate member observation block.<br /><br />Member system description generally includes the following sections: {::nomarkdown}<ul><li>Observation description</li><li>Temporal bounds for observations</li><li>List of stations reporting observations</li><li>List of the observed phenomena</li><li>Spatial bounds and other feature-type metadata</li><li>Observation result block</li></ul>{:/}<br />Single result block may contain values from multiple stations and multiple sensors of the same feature type. |
| gml:description | 0…1 | A recommended fairly free-form human-readable text that describes observations, including station(s) name and location as well as sensor or procedure information. |
| om:samplingTime | 1…1 | The samplingTime bounds the time when the result applies to the feature-of-interest, encoded as a TimeInstant or TimePeriod ISO8601 string or using the indeterminatePosition attribute (e.g. 'now'). Currently only UTC (Z) is supported. This time usually required for geospatial analysis of the result. |
| om:procedure | 1…1 | This element contains the official IOOS identifiers for the platforms in a form of URN that conforms to the [IOOS Conventions for Observing Asset Identifiers]( https://geo-ide.noaa.gov/wiki/index.php?title=IOOS_Conventions_for_Observing_Asset_Identifiers). <br /><br />The IOOS Convention requires that multiple platforms/stations are listed as members of a single process, e.g.:<br /> {::nomarkdown}<pre>&lt;om:procedure&gt;<br />  &lt;om:Process&gt;<br />    &lt;gml:member xlink:href="urn:ioos:station:wmo:41001"/&gt;<br />    &lt;gml:member xlink:href="urn:ioos:station:wmo:41002"/&gt;<br />  &lt;/om:Process&gt;<br />&lt;/om:procedure&gt;</pre>{:/}|
| om:observedProperty | 1…1 | A description of the phenomena that are being estimated through observation, e.g. "wave", "temperature", "wind", etc. <br />The IOOS Convention requires that {::nomarkdown} <ul><li>This element has a value that matches the value advertized in the Capabilities document.</li><li>The value is a URL corresponding to a Climate and Forecast (CF) Standard Name Parameter Vocabulary (http://mmisw.org/ont/cf/parameter) or IOOS Parameter Vocabulary (e.g.: http://mmisw.org/ont/ioos/parameter/wave) that are currently hosted by the Marine Metadata Interoperability (MMI) project.</li><li>The observed property shall be described in &lt;om:observedProperty&gt; as composite phenomenon using &lt;swe:CompositePhenomenon&gt; child element, even if just a single property is reported, and that property is not a compositу phenomenon’s constituent: <ul><li>Each &lt;swe:CompositePhenomenon&gt; shall have a document-wide unique &lt;gml:id&gt; attribute (it is recommended to use just a simple integer counter next to a fixed string). </li><li>Each &lt;swe:CompositePhenomenon&gt; shall have a child element &lt;gml:name&gt; with a value of any human-readable text string. </li><li>Each &lt;swe:CompositePhenomenon&gt; shall always be expanded to the list of the constituent scalar properties. </li><li>The individual scalar properties shall be defined in the IOOS Parameter Vocabulary. </li></ul></li></ul>{:/}<br />**EXAMPLE 1 (multiple scalar properties)**: <br />{::nomarkdown}<pre>&lt;om:observedProperty&gt;<br />  &lt;swe:CompositePhenomenon dimension="4" gml:id="observedproperties1"&gt;<br />      &lt;gml:name&gt;Response Observed Properties&lt;/gml:name&gt;<br />      &lt;swe:component xlink:href="http://mmisw.org/ont/cf/parameter/air_temperature"/&gt;<br />      &lt;swe:component xlink:href="http://mmisw.org/ont/cf/parameter/wind_speed"/&gt;<br />      &lt;swe:component xlink:href="http://mmisw.org/ont/cf/parameter/wind_gust"/&gt;<br />      &lt;swe:component xlink:href="http://mmisw.org/ont/ioos/parameter/dissolved_oxygen"/&gt;<br />  &lt;/swe:CompositePhenomenon&gt;<br />&lt;/om:observedProperty&gt;</pre>{:/}<br /> **EXAMPLE 2 (single scalar property)**: <br />{::nomarkdown}<pre>&lt;om:observedProperty&gt;<br />    &lt;swe:CompositePhenomenon dimension="1" gml:id="observedproperties1"&gt;<br />        &lt;gml:name&gt;Response Observed Properties&lt;/gml:name&gt;<br />        &lt;swe:component xlink:href="http://mmisw.org/ont/cf/parameter/air_temperature"/&gt;<br />    &lt;/swe:CompositePhenomenon&gt;<br />&lt;/om:observedProperty&gt;</pre>{:/} |
| om:featureOfInterest | 1…1 | Encompasses all spatial and feature-type response metadata assotiated with the observations of the same CF Feature Type (e.g., _**timeSeries**_, _**timeSeriesProfile**_, etc). IOOS Convention requires that all metadata properties associated with one feature type are aggregated in a single child element \<gml:FeatureCollection\>:<br />{::nomarkdown}<pre>&lt;om:featureOfInterest&gt;<br />    &lt;gml:FeatureCollection&gt;<br />        &lt;gml:metaDataProperty/&gt;<br />        &lt;gml:boundedBy/&gt;<br />        &lt;gml:location/&gt;<br />    &lt;/gml:FeatureCollection&gt;<br />&lt;/om:featureOfInterest&gt;</pre>{:/} |
| _gml:metaDataProperty_ | 1…1 | Contains the name and codeSpace values for the CF Feature Type: <br />{::nomarkdown}<pre>&lt;gml:metaDataProperty&gt;<br />  &lt;gml:name codeSpace="http://cf-pcmdi.llnl.gov/documents/cf-conventions/1.6/cf-conventions.html#discrete-sampling-geometries"><br />     timeSeries<br />  &lt;/gml:name&gt;<br />&lt;/gml:metaDataProperty&gt;</pre>{:/} |
| _gml:boundedBy_ | 1…1 | Defines a geographic (lat/lon) Bounding Box of the featureOfInterest. |
| _gml:location_ | 1…1 | Describes the individual platform/station geographical location information (2D only, strongly recommended to use the EPSG::4326 CRS; however, ncSOS may report coordinates in other CRS retrieved from a source netCDF file). <br />Despite having been “deprecated” (i.e., "not recommended to use") by OGC since GML 3.1.0, the IOOS Convention requires \<gml:location\> as the least complex and all-sufficient structure among many options of reporting station position. For uniformity, the IOOS Conventions imposes certain constraints on the geospatial metadata representation: {::nomarkdown}<ul><li>both single- and multi-station response must report locations using the same &lt;gml:MultiPoint&gt; structure, i.e.<ul><br /><li>for single station:<br /><pre>&lt;gml:location&gt;<br />  &lt;gml:MultiPoint srsName="http://www.opengis.net/def/crs/EPSG/0/4326"><br />     &lt;gml:pointMembers&gt;<br />        &lt;gml:Point&gt;<br />           &lt;gml:name&gt;urn:ioos:station:wmo:41001&lt;/gml:name&gt;<br />           &lt;gml:pos&gt;34.7 -72.73&lt;/gml:pos&gt;<br />        &lt;/gml:Point&gt;<br />     &lt;/gml:pointMembers&gt;<br />  &lt;/gml:MultiPoint&gt;<br />&lt;/gml:location&gt;</pre></li><li>for multiple stations:<br /><pre>&lt;gml:location&gt;<br />  &lt;gml:MultiPoint srsName="http://www.opengis.net/def/crs/EPSG/0/4326"><br />    &lt;gml:pointMembers&gt;<br />      &lt;gml:Point&gt;<br />        &lt;gml:name&gt;urn:ioos:station:wmo:41001&lt;/gml:name&gt;<br />        &lt;gml:pos&gt;34.7 -72.73&lt;/gml:pos&gt;<br />      &lt;/gml:Point&gt;<br />      &lt;gml:Point&gt;<br />        &lt;gml:name&gt;urn:ioos:station:wmo:41004&lt;/gml:name&gt;<br />        &lt;gml:pos&gt;32.5 -79.09&lt;/gml:pos&gt;<br />      &lt;/gml:Point&gt;<br />      &lt;gml:Point&gt;<br />        &lt;gml:name&gt;urn:ioos:station:wmo:41008&lt;/gml:name&gt;<br />        &lt;gml:pos&gt;31.4 -80.87&lt;/gml:pos&gt;<br />      &lt;/gml:Point&gt;<br />    &lt;/gml:pointMembers&gt;<br />  &lt;/gml:MultiPoint&gt;<br />&lt;/gml:location&gt;</li></ul></li><li>&lt;gml:name&gt; element shall be used to associate the stationID with the station coordinates in both multi- and single-station responses.</li></ul>{:/} |
| om:result | 1…1 | This block contains a SWE Data Record for a specific feature type conforming to the corresponding SWE-GetObservation template in Milestone 1.0. |



#### **SWE-GetObservation Template**{: style="color: crimson"}

The OGC SWE Common Data Model Encoding Standard v2.0 allows data components to be used as a data container as well as a data descriptor, where container defines metadata of a data set and includes the actual property values (“inline” values), while data descriptor defines metadata of a data set but does not include the actual data values. However, the Standard prohibits mixing of both guises in a single data component entity. For example, a single DataArray cannot contain both inline values and block-encoded values. Therefore, the IOOS Convention requires a Result block to include a root DataRecord composed of two basic fields – “stations” and “observationData”. The field "stations" forms a “static” part of the GetObservation response Result block that encompasses all invariable data for all stations and sensors, whereas the field “observationData” draws up a “dynamic” part that encloses observation values varying from sensor to sensor. All data components in the static block must be used as data containers and encoded inline, while the data components in the dynamic block must be used only as data descriptors, and contain a DataArray with block-encoded values:

```XML
<swe2:DataRecord definition="http://mmisw.org/ont/ioos/swe_element_type/observationRecord">
    <swe2:field name="stations">
        <swe2:DataRecord definition="http://mmisw.org/ont/ioos/swe_element_type/stations">
             [ STATIC DATA ]
        </swe2:DataRecord>
    </swe2:field>
    <swe2:field name="observationData">
        <swe2:DataArray definition="http://mmisw.org/ont/ioos/swe_element_type/sensorObservationCollection">
             [ DYNAMIC DATA (SENSOR OBSERVATIONS) ]
        </swe2:DataArray>
    </swe2:field>
</swe2:DataRecord>
```
The IOOS Convention requires that each of the following elements in the Result block is provided with a corresponding “definition” attribute:

-   \<swe2:DataRecord\>
-   \<swe2:DataArray\>
-   \<swe2:DataChoice\>
-   \<swe2:Text\>
-   \<swe2:Vector\>
-   \<swe2:Quantity\>
-   \<swe2:QuantityRange\>
-   \<swe2:Time\>

The “definition” attribute identifies the observed property that the data component represents by using a name. The OGC SWE Common Data Model Encoding Standard v2.0 requires it to map to a controlled term defined in a web accessible dictionary, registry or ontology. The IOOS Convention defines the following vocabularies that have to be used in the “definition” attribute:

-   [OGC Definition Service](http://www.opengis.net/def/property/OGC/0/) – an OGC register of potentially observable property types and names that is controlled and maintained by the OGC Naming Authority;
-   [IOOS Vocabulary and Category Definitions](http://mmisw.org/orr/#http://mmisw.org/ont/ioos/definition) – an MMI vocabulary used for clarifying the meaning of roles, classifiers and other general terms used throughout the SOS web services;
-   [IOOS SOS SWE Element Definitions Vocabulary](http://mmisw.org/orr/#http://mmisw.org/ont/ioos/swe_element_type) – a narrower MMI vocabulary of definitions that reflect the IOOS Convention for use in standard SOS SWE elements.

The value of the “definition” attribute of the same type of element may vary depending on the observed property. The [IOOS SWE Templates for Milestone 1.0](http://code.google.com/p/ioostech/source/browse/#svn%2Ftrunk%2Ftemplates%2FMilestone1.0) along with the [MMI vocabularies](http://mmisw.org/orr/#http://mmisw.org/ont/ioos/swe_element_type) provide a comprehensive guidance for a use of definitions in IOOS SOS GetObservations document; some examples are shown below:

```XML
<swe2:DataRecord   definition="http://mmisw.org/ont/ioos/swe_element_type/stations">
<swe2:DataRecord   id="stationID"   definition="http://mmisw.org/ont/ioos/swe_element_type/station">
<swe2:Text   definition="http://mmisw.org/ont/ioos/definition/stationID">
<swe2:Vector   definition=”http://www.opengis.net/def/property/OGC/0/PlatformLocation”>
<swe2:Quantity   definition=”http://mmisw.org/ont/cf/parameter/latitude”>
<swe2:Quantity   definition=”http://mmisw.org/ont/cf/parameter/height”>
<swe2:DataRecord   definition="http://mmisw.org/ont/ioos/swe_element_type/sensors">
<swe2:DataRecord   id="s"   definition="http://mmisw.org/ont/ioos/swe_element_type/sensor">
<swe2:Text   definition="http://mmisw.org/ont/ioos/definition/sensorID">
<swe2:DataArray   definition="http://mmisw.org/ont/ioos/swe_element_type/sensorObservationCollection">
<swe2:Time   definition="http://www.opengis.net/def/property/OGC/0/SamplingTime">
<swe2:Vector   definition="http://www.opengis.net/def/property/OGC/0/SensorOrientation">
<swe2:QuantityRange   axisID="Z"   definition="http://mmisw.org/ont/ioos/swe_element_type/profileBinEdges">
<swe2:Quantity   definition=”http://mmisw.org/ont/cf/parameter/height”>
<swe2:DataRecord   definition="http://mmisw.org/ont/ioos/swe_element_type/sensorObservations">
<swe2:DataChoice   definition="http://mmisw.org/ont/ioos/swe_element_type/sensors">
<swe2:DataArray   definition="http://mmisw.org/ont/ioos/swe_element_type/profileBins">
<swe2:DataArray   definition="http://mmisw.org/ont/ioos/swe_element_type/profileHeights">
```

To ensure the proper linkage between the static and dynamic data, the IOOS Convention requires that each sensor’s ID in the static portion of the result block is linked to sensor observation values (i.e., dynamic data) via an abbreviated sensor URN. That abbreviated URN is composed of the authority, label and component parts of a full sensor’s ID (see the [IOOS Conventions for Observing Asset Identifiers](https://geo-ide.noaa.gov/wiki/index.php?title=IOOS_Conventions_for_Observing_Asset_Identifiers)) separated with underscores instead of the colons, e.g. **sensorID _urn:ioos:sensor:wmo:41001:sensor1_** gets transformed into _**wmo\_41001\_sensor1**_. These abbreviated sensor URNs are used as the sensor's DataRecord ID in the static block and DataChoice item name in the dynamic block. Consequently they also appears in the dynamic \<swe:values\> encoding, and may thus be used as a marker for the metadata of a given row of the data block.

In a similar manner, an abbreviated station ID is composed of the authority and label parts of a full station ID, i.e. the **stationID _urn:ioos:sensor:wmo:41001_** transforms into _**wmo\_41001**_. The abbreviated station IDs have to be used as the station’s DataRecord ID and correspondent field names.

<br />

##### **Static Data Block**{: style="color: crimson"}

The static information for all stations and sensors in GetObservation response is encompassed within the field “stations” of the root DataRecord element. Each DataRecord’s field may recursively enclose an unlimited number of DataRecords, which makes the static data block a pretty complex structure of nested DataRecords in case of multiple stations and/or sensors, as shown in [**Figure 8**](#Fig_8).

![](./sos-wsdd-image99.png)

<a name="Fig_8"></a> **Figure 8: GetObservation static data block outline**<br><br>

In general, IOOS Convention does not prescribe how data should be allocated to the static and dynamic parts, i.e. almost any element may be considered as static or dynamic. However, the static part must include _**stationID**_, _**platformLocation**_, and _**sensors**_ description fields for each station:

```XML
<swe2:field name="stations">
  <swe2:DataRecord definition="http://mmisw.org/ont/ioos/definition/stations">
    <swe2:field name="wmo_41001">
      <swe2:DataRecord id="wmo_41001" definition="http://mmisw.org/ont/ioos/definition/station">
        <swe2:field name="stationID">
                    An identifier for the platform in a form of URN that conforms to the IOOS Conventions for Observing Asset Identifiers .
        </swe2:field>
        <swe2:field name="platformLocation">
                    The three-dimensional description of the platform’s location, expressed in latitude, longitude and altitude (height).
                    It may also be described in a dynamic part, if varies from observation to observation.
        </swe2:field>
        <swe2:field name="sensors">
          <swe2:DataRecord definition="http://mmisw.org/ont/ioos/definition/sensors">
            <swe2:field name="wmo_41001_sensor1">
              <swe2:DataRecord id="wmo_41001_sensor1" definition="http://mmisw.org/ont/ioos/definition/sensor">
                <swe2:field name="sensorID">
                    An identifier for the sensor in a form of URN that conforms to the IOOS Conventions for Observing Asset Identifiers.
                    It may either use a meaningful name (e.g. "sbe16") or be just a simple, constant string followed by an integer counter such as "sensor1", "sensor2", "salt1", etc. 
                </swe2:field>
                <swe2:field name="height">
                    The vertical position of the non-profiling sensor relative to the platformLocation.
                    It may also be described in a dynamic part, if varies among observations. 
                </swe2:field>
                <swe2:field name="sensorOrientation">
                    Optional vector parameter, recommended for a profiling sensor such as an ADCP.
                    Indicates the values of sensor’s yaw, pitch, and roll angles.
                    The angles can also be described in a dynamic part, if they vary among observations.
                </swe2:field>
                <swe2:field name="sensorLocation">
                    Describes a profiling sensor position relative to the CRS instead of the platform local frame.
                </swe2:field>
                <swe2:field name="profileBins">
                    Specifies vertical positions of the center and edges for each bin of the binned profile.
                </swe2:field>
                <swe2:field name="profileHeights">
                    Specifies fixed vertical observation positions for a non-binned profile.
                </swe2:field>
              </swe2:DataRecord>
            </swe2:field>
          </swe2:DataRecord>
        </swe2:field>
      </swe2:DataRecord>
    </swe2:field>
  </swe2:DataRecord>
</swe2:field>
```

The IOOS Convention requires that stationID or sensorID is described in the \<swe2:Text\> element rather than in \<swe2:Category\>. The value of the \<swe2:Text\> must be a full station URN as defined in the [IOOS Conventions for Observing Asset Identifiers](https://geo-ide.noaa.gov/wiki/index.php?title=IOOS_Conventions_for_Observing_Asset_Identifiers), as shown in the examples below:

```XML
<swe2:field name="stationID">
    <swe2:Text definition="http://mmisw.org/ont/ioos/definition/stationID">
        <swe2:value>urn:ioos:station:wmo:41001</swe2:value>
    </swe2:Text>
</swe2:field>
```

```XML
<swe2:field name="sensorID">
    <swe2:Text definition="http://mmisw.org/ont/ioos/definition/sensorID">
        <swe2:value>urn:ioos:sensor:wmo:41001:sensor1</swe2:value>
    </swe2:Text>
</swe2:field>
```

The IOOS Convention requires that description of each sensor's position encompasses three components: 
1. description of a Platform Location specified within a global Reference Frame; 
2. description of the Local Frame assigned to the platform; and 
3. description of the sensor position relative to the platform's Local Frame.
 
Depending on the platform type, IOOS Convention specifies two global Reference Frames:
- for floating buoys, the _**referenceFrame**_ is a 3D Compound CRS that combines EPSG::4326 for the platform horizontal coordinates with EPSG::5829 vertical CRS for the platform's vertical coordinate (referenceFrame="http://www.opengis.net/def/crs-compound?1=http://www.opengis.net/def/crs/EPSG/0/4326&2=http://www.opengis.net/def/crs/EPSG/0/5829);
- for a tide gauge or a platform at a fixed location relative to the Geoid (MSL), a single 3D CRS EPSG::4979 has to be used. (referenceFrame="http://www.opengis.net/def/crs/EPSG/0/4979").

The following fragment of the IOOS Milestone 1.0 Template illustrates the platform’s location description:

```XML
<swe2:field name="platformLocation">
  <swe2:Vector definition="http://www.opengis.net/def/property/OGC/0/PlatformLocation"
    referenceFrame="http://www.opengis.net/def/crs-compound?1=http://www.opengis.net/def/crs/EPSG/0/4326&2=http://www.opengis.net/def/crs/EPSG/0/5829"
    localFrame="#wmo_41001_frame">
      <swe2:coordinate name="latitude">
        <swe2:Quantity definition="http://mmisw.org/ont/cf/parameter/latitude" axisID="Lat">
          <swe2:uom code="deg"/>
          <swe2:value>32.382</swe2:value>
        </swe2:Quantity>
      </swe2:coordinate>
      <swe2:coordinate name="longitude">
        <swe2:Quantity definition="http://mmisw.org/ont/cf/parameter/longitude" axisID="Lon">
          <swe2:uom code="deg"/>
          <swe2:value>-75.415</swe2:value>
        </swe2:Quantity>
      </swe2:coordinate>
      <swe2:coordinate name="height">
        <swe2:Quantity definition="http://mmisw.org/ont/cf/parameter/height" axisID="Z">
          <swe2:uom code="m"/>
          <swe2:value>0.5</swe2:value>
        </swe2:Quantity>
      </swe2:coordinate>
  </swe2:Vector>
</swe2:field>
```

In regard to the position of the sensors located at the platform, the IOOS Convention only requires that sensor height relative to the platform’s _**localFrame**_ is specified for a non-profiling sensor. Regardless of platform's sensors allocation in reference to the water surface, the IOOS Convention stipulates that position description should follow the EPSG:5829, i.e.  
- sensor’s position should always be reported as height (vertical upward); and 
- sensor’s position below the water surface should be reported as height with negative value.

The following fragment of the IOOS Milestone 1.0 Template illustrates just that simplified approach to sensors’ location description; if more information about sensor orientation and relative position is available, then it must be recorded in accordance with the SWE Common v2.0 specification:

```XML
<swe2:field name="height">
    <swe2:Quantity definition="http://mmisw.org/ont/cf/parameter/height"
        axisID="Z"
        referenceFrame="#wmo_41001_frame">
        <swe2:uom code="m" />
        <swe2:value>5</swe2:value>
    </swe2:Quantity>
</swe2:field>
```
<br />

##### _Common QA/QC information_{: style="color: crimson"}

It has been a long-standing IOOS’ goal to implement the principles of Quality Assurance of Real Time Ocean Data (QARTOD) in the IOOS SOS, and the IOOS Convention has taken a first step in that direction by providing a guidance (based on the best practices of the IOOS data providers like NDBC) of reporting QA/QC information in the Milestone 1.0 templates. However, since the QARTOD has yet to develop the authoritative QA/QC procedures for all IOOS observed properties and feature types, the IOOS Convention provisions are not mandatory at the moment, and Milestone 1.0 templates should be considered as sort of “best practices” recommendations, mostly based on the NDBC’s system of pre-defined QA/QC flags (tockens).

The static data block in GetObservations document may include any common QA/QC information on the station or sensor that is invariable among the observations:  

```XML
<swe2:field name="stationID">
  <swe2:Text definition="http://mmisw.org/ont/ioos/definition/stationID">
    
    <swe2:quality>
                  Any valid static quality information about this station can be placed here.
    </swe2:quality>
 
    <swe2:value>urn:ioos:station:wmo:41001</swe2:value>
  </swe2:Text>
</swe2:field>
```

```XML
<swe2:field name="sensorID">
  <swe2:Text definition="http://mmisw.org/ont/ioos/definition/sensorID">
    
    <swe2:quality>
                  Any valid static quality information about this sensor can be placed here.
    </swe2:quality>
 
    <swe2:value>urn:ioos:station:wmo:41001:sensor2</swe2:value>
  </swe2:Text>
</swe2:field>
```

<br />

##### _Profiling sensor specifics_{: style="color: crimson"}

For profiling sensor, just the indication of the sensor’s upward or downward shift relative to the platform position is not sufficient, and the IOOS Convention provides for more precise description of sensor’s position and orientation, including description of bins and depths for binned profile sensors. Although the Convention does not require a full description of a sensor’s orientation, the Convention strongly encourages the indication of this information for all vertical profiling sensors (e.g. ADCP).

The IOOS Convention specifies a position of a profiling sensor in reference to a CRS rather than to the platform itself, just because the relative sensor’s position in the platform's _**localFrame**_ is likely to vary from observation to observation, whereas the absolute coordinates (i.e. latitude, longitude, and height) may be approximated as static. The sensor's _**localFrame**_ is referenced to the CRS similar to the the platform’s _**localFrame**_:

```XML
<swe2:field name="sensorLocation">    
  swe2:Vector definition=http://www.opengis.net/def/property/OGC/0/SensorLocation
  referenceFrame="http://www.opengis.net/def/crs-compound?1=http://www.opengis.net/def/crs/EPSG/0/4326&2=http://www.opengis.net/def/crs/EPSG/0/5829"
  localFrame="#wmo_41001_sensor1_profile_frame">
    <swe2:coordinate name="latitude">
      <swe2:Quantity definition="http://mmisw.org/ont/cf/parameter/latitude" axisID="Lat">
        <swe2:uom code="deg" />
        <swe2:value>32.382</swe2:value>
      </swe2:Quantity>
    </swe2:coordinate>
    <swe2:coordinate name="longitude">
      <swe2:Quantity definition="http://mmisw.org/ont/cf/parameter/longitude" axisID="Lon">
        <swe2:uom code="deg" />
        <swe2:value>-75.415</swe2:value>
      </swe2:Quantity>
    </swe2:coordinate>
    <swe2:coordinate name="height">
      <swe2:Quantity definition="http://mmisw.org/ont/cf/parameter/height" axisID="Z">
        <swe2:uom code="m" />
        <swe2:value>0.0</swe2:value>
      </swe2:Quantity>
    </swe2:coordinate>
  </swe2:Vector>
</swe2:field>
```
The sensor’s orientation is reported in terms of the pitch, roll, and yaw angles using the CF Conventions standard names: platform_pitch_angle, platform_roll_angle, and platform_orientation for yaw angle; the [**Figure 9**](#Fig_9) depicts a relation of the directional vectors and orientation angles.

![](./sos-wsdd-image28c.png)

<a name="Fig_9"></a> **Figure 9: Directions, Yaw, Pitch and Roll Angles** _(copied from [Wikipedia](http://en.wikipedia.org/wiki/Six_degrees_of_freedom))_<br /><br />

The following fragment of the IOOS Milestone 1.0 GetObservation Template for timeSeriesProfile provides more detailed guidance for the sensor orientation description:

```XML
<swe2:field name="sensorOrientation">
  <swe2:Vector definition="http://www.opengis.net/def/property/OGC/0/SensorOrientation"
    referenceFrame="http://www.opengis.net/def/crs/OGC/0/ENU">
    <swe2:coordinate name="platform_orientation">
      <swe2:Quantity definition="http://mmisw.org/ont/cf/parameter/platform_orientation"
        axisID="Z">
        <swe2:uom code="deg" />
        <swe2:value>0</swe2:value>
      </swe2:Quantity>
    </swe2:coordinate>
    <swe2:coordinate name="platform_pitch_angle">
      <swe2:Quantity definition="http://mmisw.org/ont/cf/parameter/platform_pitch_angle"
        axisID="X">
        <swe2:uom code="deg" />
        <swe2:value>90</swe2:value>
      </swe2:Quantity>
    </swe2:coordinate>
    <swe2:coordinate name="platform_roll_angle">
      <swe2:Quantity definition="http://mmisw.org/ont/cf/parameter/platform_roll_angle"
        axisID="Y">
        <swe2:uom code="deg" />
        <swe2:value>0</swe2:value>
      </swe2:Quantity>
    </swe2:coordinate>
  </swe2:Vector>
</swe2:field>
```

If sensor position or orientation is not stable in time, and differs with each individual observation, it has to be described in the dynamic data block of the GetObservation document instead of the static data block. In such case, the orientation parameter values must be block-encoded along with other observations data.

For binned profiling sensors, the IOOS Convention specifies bins and depths through the description of the vertical positions of each bin center with corresponding top and bottom edges. Despite the fact that the binned profile description is located in the static data block, the bins’ and depths’ values **must not** be encoded inline but shall be encoded as a data array (i.e. block-encoded) instead. To allow for ragged arrays of data from upward looking ADCP sensors, the dimension of the array shall correspond to the number of binned observations for this sensor reported in the dynamic data section:

```XML
<swe2:field name="profileBins">
    <swe2:DataArray definition="http://mmisw.org/ont/ioos/swe_element_type/profileBins">
        <swe2:description>Array of synchronous observation locations in a profile</swe2:description>
        <swe2:elementCount>
            <swe2:Count>
                <swe2:value>5</swe2:value>
            </swe2:Count>
        </swe2:elementCount>
        <swe2:elementType name="profileBinDescription">
            <swe2:DataRecord>
                <swe2:field name="binCenter">
                    <swe2:Quantity axisID="Z"
                        definition="http://mmisw.org/ont/cf/parameter/height"
                        referenceFrame="#wmo_41001_sensor1_frame">
                        <swe2:uom code="m" />
                    </swe2:Quantity>
                </swe2:field>
                <swe2:field name="binEdges">
                    <swe2:QuantityRange axisID="Z"
                        definition="http://mmisw.org/ont/ioos/swe_element_type/profileBinEdges"
                        referenceFrame="#wmo_41001_sensor1_frame">
                        <swe2:uom code="m" />
                    </swe2:QuantityRange>
                </swe2:field>
            </swe2:DataRecord>
        </swe2:elementType>
        <swe2:encoding>
            <swe2:TextEncoding
                decimalSeparator="."
                tokenSeparator=","
                blockSeparator="&#10;" />
        </swe2:encoding>
        <swe2:values>
            -10.0,-5.0 -15.0
            -20.0,-15.0 -25.0
            -30.0,-25.0 -35.0
            -40.0,-35.0 -45.0
            -50.0,-45.0 -55.0
        </swe2:values>
    </swe2:DataArray>
</swe2:field>
```

For non-binned profiling sensors, the IOOS Convention requires a description of the fixed vertical observation positions instead of bins. Similar to the description of binned sensors, it is done in a form of data array with the dimension that shall correspond to the number of observations for this sensor reported in the dynamic data section:

```XML
<swe2:field name="profileHeights">
    <swe2:DataArray definition="http://mmisw.org/ont/ioos/definition/profileHeights">
        <swe2:elementCount>
            <swe2:Count>
                <swe2:value>3</swe2:value>
            </swe2:Count>
        </swe2:elementCount>
        <swe2:elementType name="profileDefinition">
            <swe2:DataRecord>
                <swe2:field name="height">
                    <swe2:Quantity axisID="Z"
                        definition="http://mmisw.org/ont/cf/parameter/height"
                        referenceFrame="#wmo_41001_sensor2_profile_frame">
                        <swe2:uom code="m" />
                    </swe2:Quantity>
                </swe2:field>
            </swe2:DataRecord>
        </swe2:elementType>
        <swe2:encoding>
            <swe2:TextEncoding
                decimalSeparator="."
                tokenSeparator=","
                blockSeparator="&#10;" />
        </swe2:encoding>
        <swe2:values> 
            -5.0 
            -10.0 
            -20.0 
        </swe2:values>
    </swe2:DataArray>
</swe2:field>
```

##### **Dynamic Data Block (Sensor Observations)**{: style="color: crimson"}

The dynamic data block contains all measurements made by sensors and any other dynamic data (e.g. location for mobile sensors) from each sensor requested in GetObservation operation. In conformity with the OGC SWE Common Data Model Encoding Standard v2.0, the dynamic block must not contain any inline encoded data.

The simplified outline of the dynamic data block is presented below. The outline contains all the required elements with a brief description; the detailed description of the critical elements follows:

```XML
<swe2:field name="observationData">
    <swe2: DataArray definition="http://mmisw.org/ont/ioos/definition/sensorObservationCollection">
        <swe2:elementCount>
                        Defines the number of array components, i.e. the number of records in <swe2:values> below.
        </swe2:elementCount>
        <swe2:elementType name="observations">
            <swe2:DataRecord definition="http://mmisw.org/ont/ioos/definition/sensorObservations">
                          The root dynamic data record that contains all dynamic observation descriptors for each sensor.
                <swe2:field name="time">
                          The samplingTime, which defines the instants of time when observations were taken.
                </swe2:field>
                <swe2:field name="sensor">
                          Defines the dynamic data for all reported sensors via DataChoice element.
                    <swe2:DataChoice definition="http://mmisw.org/ont/ioos/definition/sensors">
                        <swe2:item name="wmo_41001_sensor1">
                                         Defines observedProperties for the “sensor1” located at the station “wmo_41001”
                            <swe2:DataRecord definition="http://mmisw.org/ont/ioos/definition/sensor">
                                <swe2:field name="air_temperature"/>
                                <swe2:field name="wind_speed"/>
                                <swe2:field name="wind_to_direction"/>
                            </swe2:DataRecord>
                        </swe2:item>
                        <swe2:item name="wmo_41001_sensor2">
                                         Defines observedProperties for the “adcpProfile_sensor2” located at the station “wmo_41001”
                            <swe2:DataRecord definition="http://mmisw.org/ont/ioos/definition/sensor">
                                <swe2:field name="adcpProfile">
                                         Contains nested DataArray for profile dynamic data to encode observations 
                                         at multiple heights in one record
                                    <swe2:DataArray definition="http://mmisw.org/ont/ioos/definition/profile">
                                        <swe2:description>Array of synchronous observations in a Profile</swe2:description>
                                    </swe2:DataArray definition="http://mmisw.org/ont/ioos/definition/profile">
                                <swe2:field name="adcpProfile">
                            </swe2:DataRecord>
                        </swe2:item>
                        <swe2:item name="wmo_41002_sensor1">
                                         Defines observedProperties for the “sensor1” located at the station “wmo_41002”
                            <swe2:DataRecord definition="http://mmisw.org/ont/ioos/definition/sensor">
                                <swe2:field name="air_temperature"/>
                            </swe2:DataRecord>
                        </swe2:item>
                        <swe2:item name="wmo_41002_sensor2">
                                         Defines observedProperties for the “sensor2” located at the station “wmo_41002”
                            <swe2:DataRecord definition="http://mmisw.org/ont/ioos/definition/sensor">
                                <swe2:field name="sea_water_temperature"/>
                            </swe2:DataRecord>
                        </swe2:item>
                        <swe2:item name="wmo_41003_sensor1">
                                         Defines observedProperties for the “sensor1” located at the station “wmo_41003”
                            <swe2:DataRecord definition="http://mmisw.org/ont/ioos/definition/sensor">
                                <swe2:field name="air_temperature"/>
                            </swe2:DataRecord>
                        </swe2:item>
                    </swe2:DataChoice>
                </swe2:field>
            </swe2:DataRecord>
        <swe2:encoding>
                          Defines used SWE Common encodings, including data value separators
        </swe2:encoding>

        <swe2:values>
                          Encompasses data values from all sensors for all sampling time instances.
        </swe2:values>
    <swe2: DataArray>
<swe2:field>
```

The _**time**_ field of the observations' DataRecord is listed outside of DataChoice construct just because sampling time is related to all sensors; however, if sampling time is defined differently for some sensors it should be reported inside the respective DataChoice \<swe2:item\> element. The sampling time must be encoded as an ISO8601 UTC (Z) TimeInstant string:

```XML
<swe2:field name="time">
  <swe2:Time definition="http://www.opengis.net/def/property/OGC/0/SamplingTime">
    <swe2:uom xlink:href="http://www.opengis.net/def/uom/ISO-8601/0/Gregorian" />
  </swe2:Time>
<swe2:field>
```

An implementation of missing or out-of-range values is completely arbitrary; however, the implementation must follow the SWECommon standard requirements. In general, a \<swe2:Quantity\> may contain any number of \<swe:nilValue\> elements for any nilValue reason, for example:

```XML
<swe2:Quantity definition="http://mmisw.org/ont/cf/parameter/air_temperature">
    ...
    <swe2:nilValues>
        <swe2:NilValues>
            <swe2:nilValue reason="http://www.opengis.net/def/nil/OGC/0/BelowDetectionRange">-9999</swe2:nilValue>
            <swe2:nilValue reason="http://www.opengis.net/def/nil/OGC/0/AboveDetectionRange">9999</swe2:nilValue>
            <swe2:nilValue reason="http://www.opengis.net/def/nil/OGC/0/OutOfService">-1</swe2:nilValue>
            <swe2:nilValue reason="http://www.opengis.net/def/nil/OGC/0/missing">8888</swe2:nilValue>
        </swe2:NilValues>
    </swe2:nilValues>
    ...
</swe2:Quantity>
```

As each sensor may perform various set of observations, the IOOS Convention requires that **DataChoice** structure is used to select a sensor and the set of observation fields to be reported in each record for that sensor in the \<swe2:values\> element of the **DataArray**. To ensure the proper linkage to the static data block, the item names must correspond to the sensor names in the static sensors’ **DataRecord**. Each **DataChoice** \<swe2:item\> element describes the dynamic sensor features such as _**observedProperty**_, _**UoM**_, etc. in a separate **DataRecord**:

```XML
<swe2:field name=”sensor”>
    <swe2:DataChoice definition="http://mmisw.org/ont/ioos/definition/sensors">
        <swe2:item name="wmo_41001_sensor1">
            <swe2:DataRecord definition="http://mmisw.org/ont/ioos/definition/sensor">
                <swe2:field name="air_temperature">
                    <swe2:Quantity definition="http://mmisw.org/ont/cf/parameter/air_temperature">
                        <swe2:uom code="Celsius" />
                    </swe2:Quantity>
                </swe2:field>
                <swe2:field name="wind_speed">
                    <swe2:Quantity definition="http://mmisw.org/ont/cf/parameter/wind_speed">
                        <swe2:uom code="m/s" />
                    </swe2:Quantity>
                </swe2:field>
                <swe2:field name="wind_to_direction">
                    <swe2:Quantity definition="http://mmisw.org/ont/cf/parameter/wind_to_direction">
                        <swe2:uom code="degrees" />
                    </swe2:Quantity>
                </swe2:field>
            </swe2:DataRecord>
        </swe2:item>
        <swe2:item name="wmo_41001_sensor2">
            <swe2:DataRecord definition="http://mmisw.org/ont/ioos/definition/sensor">
                <swe2:field name="sea_water_temperature">
                    <swe2:Quantity definition="http://mmisw.org/ont/cf/parameter/sea_water_temperature">
                        <swe2:uom code="Celsius" />
                    </swe2:Quantity>
                </swe2:field>
                <swe2:field name="dissolved_oxygen">
                    <swe2:Quantity definition="http://mmisw.org/ont/ioos/parameter/dissolved_oxygen">
                        <swe2:uom code="mg/L" />
                    </swe2:Quantity>
                </swe2:field>
            </swe2:DataRecord>
        </swe2:item>
        <swe2:item name="wmo_41002_sensor1">
            <swe2:DataRecord definition="http://mmisw.org/ont/ioos/definition/sensor">
                <swe2:field name="air_temperature">
                    <swe2:Quantity definition="http://mmisw.org/ont/cf/parameter/air_temperature">
                        <swe2:uom code="Celsius" />
                    </swe2:Quantity>
                </swe2:field>
            </swe2:DataRecord>
        </swe2:item>
        <swe2:item name="wmo_41002_sensor2">
            <swe2:DataRecord definition="http://mmisw.org/ont/ioos/definition/sensor">
                <swe2:field name="sea_water_temperature">
                    <swe2:Quantity definition="http://mmisw.org/ont/cf/parameter/sea_water_temperature">
                        <swe2:uom code="Celsius" />
                    </swe2:Quantity>
                </swe2:field>
            </swe2:DataRecord>
        </swe2:item>
        <swe2:item name="wmo_41003_sensor1">
            <swe2:DataRecord definition="http://mmisw.org/ont/ioos/definition/sensor">
                <swe2:field name="air_temperature">
                    <swe2:Quantity definition="http://mmisw.org/ont/cf/parameter/air_temperature">
                        <swe2:uom code="Celsius" />
                    </swe2:Quantity>
                </swe2:field>
            </swe2:DataRecord>
        </swe2:item>
    </swe2:DataChoice>
</swe2:field>
```

The \<swe2:encoding\> element defines all kinds of separators that are used for records and values in the \<swe2:values\> block. To facilitate the development of the SOS client applications, the IOOS Convention requires that the \<swe2:encoding\> element has always be included into GetObservation response, and strongly recommends to use the standard CSV separators, such as "." for decimal separation, "," for tockens, and LF (Line Feed) – for blocks separation. At that, the special ASCII symbols used in the capacity of separators must be encoded with the corresponding standard HTML Escape Sequences; for example, LF (Line Feed) separator must be replaced with “\&\#10;”:

```XML
<swe2:encoding>
    <swe2:TextEncoding
        decimalSeparator="."
        tokenSeparator=","
        blockSeparator="&#10;" />
</swe2:encoding>
```

The \<swe2:values\> block must report the observedProperty values in the exact order they were defined in the previous sections of the dynamic data block. The number of records must match the value of \<swe2:elementCount\>; each record must contain the observation sampling time, name of the sensor, and the observed values as defined in the **DataChoice** \<swe2:item\> element associated with that sensor.

The IOOS Convention requires that, in contrast to the \<swe2:TextEncoding\> element above, the special characters used as separators stay unencoded in the \<swe2:values\> block, e.g. Line Feed must not be converted into”&\#10;” but must be used as-is instead. The IOOS Convention also requires that the sensor names unambiguously correspond to the names used in the **DataChoice** \<swe2:item\> elements:

```XML
<swe2:values>
            2009-05-23T00:00:00Z,wmo_41001_sensor1,15.4,2.0,280
            2009-05-23T01:00:00Z,wmo_41001_sensor1,15.8,1.8,121
            2009-05-23T02:00:00Z,wmo_41001_sensor1,15.6,1.0,142
            2009-05-23T00:00:00Z,wmo_41001_sensor2,5.6,8.0
            2009-05-23T01:00:00Z,wmo_41001_sensor2,5.8,8.2
            2009-05-23T02:00:00Z,wmo_41001_sensor2,5.7,8.5
            2009-05-23T00:00:00Z,wmo_41002_sensor1,16.2
            2009-05-23T01:00:00Z,wmo_41002_sensor1,16.4
            2009-05-23T02:00:00Z,wmo_41002_sensor1,16.5
            2009-05-23T00:00:00Z,wmo_41002_sensor2,6.1
            2009-05-23T01:00:00Z,wmo_41002_sensor2,6.3
            2009-05-23T02:00:00Z,wmo_41002_sensor2,6.5
            2009-05-23T01:00:00Z,wmo_41003_sensor1,15.8
</swe2:values>
```

##### _Observation-specific QA/QC information_{: style="color: crimson"}

The dynamic data block of GetObservation response may contain observation specific QA/QC information, encoded in the same **DataArray** with other observation values.

The QA/QC flags pertaining to all observed properties for a certain sensor may be described in \<swe2:elementCount\> element of the **DataArray** definition that precedes a  description of observations \<swe2:elementType\>:

```XML
<swe2:DataArray definition="http://mmisw.org/ont/ioos/definition/sensorObservationCollection">
    <swe2:elementCount>
        <swe2:Count>
            <swe2:quality>
                <swe2:Category>
                    <swe2:constraint>
                        <swe2:AllowedTokens>
                            <swe2:value>a</swe2:value>
                            <swe2:value>b</swe2:value>
                            <swe2:value>c</swe2:value>
                        </swe2:AllowedTokens>
                    </swe2:constraint>
                </swe2:Category>
            </swe2:quality>
            <swe2:value>13</swe2:value>
        </swe2:Count>
    </swe2:elementCount>
    <swe2:elementType name="observations">
      […]
    </swe2:elementType>
      […]
</swe2:DataArray>
```

The QA/QC flags pertaining to a specific observed property may be described in a similar manner in the corresponding part of the dynamic data block of the GetObservation response. Just like the observed property values, the QA/QC flag definitions must only contain data descriptors, and the flag values must be block-encoded.

In order to define a composite flag that may have several components with various values, multiple \<swe2:quality\> elements have to be used inside a corresponding \<swe2:Quantity\> element instead of a single multi-dimensional **DataArray** as the SWE Common data model prohibits the use of embedded **DataArray** inside of \<swe2:Quantity\>. The fragment of the Milestone 1.0 template below illustrates that concept for a 2-component DQA flag; for simplicity, the second DQA component just references the values defined in the description of the first component: 

```XML
<swe2:DataArray definition="http://mmisw.org/ont/ioos/definition/sensorObservationCollection">
    […]
    <swe2:elementType name="observations">
        […]
        <swe2:DataRecord definition="http://mmisw.org/ont/ioos/definition/sensorObservations">
            <swe2:field name="sensor">
                <swe2:DataChoice definition="http://mmisw.org/ont/ioos/definition/sensors">
                    <swe2:item name="wmo_41001_sensor1">
                        <swe2:DataRecord definition="http://mmisw.org/ont/ioos/definition/sensor">
                            <swe2:field name="air_temperature">
                                <swe2:Quantity definition="http://mmisw.org/ont/cf/parameter/air_temperature">
                                    
                                    <swe2:quality>
                                        <swe2:Category definition="http://sdftest.ndbc.noaa.gov/sos/qcflags.shtml">
                                            <swe2:label>EQC Flag</swe2:label>
                                            <swe2:codeSpace xlink:href="http://sdftest.ndbc.noaa.gov/sos/qcflags.shtml"/>
                                            <swe2:constraint>
                                                <swe2:AllowedTokens id="ndbcEqcFlags">
                                                    <swe2:value>T</swe2:value>
                                                    <swe2:value>M</swe2:value>
                                                    <swe2:value>W</swe2:value>
                                                    <swe2:value>D</swe2:value>
                                                    <swe2:value>S</swe2:value>
                                                    <swe2:value>V</swe2:value>
                                                    <swe2:value>L</swe2:value>
                                                    <swe2:value>H</swe2:value>
                                                    <swe2:value>R</swe2:value>
                                                </swe2:AllowedTokens>
                                            </swe2:constraint>
                                        </swe2:Category>
                                    </swe2:quality>
                                    
                                    <swe2:quality>
                                        <swe2:Category definition="http://sdftest.ndbc.noaa.gov/sos/qcflags.shtml">
                                            <swe2:label>DQA Flag 1</swe2:label>
                                            <swe2:codeSpace xlink:href="http://sdftest.ndbc.noaa.gov/sos/qcflags.shtml"/>
                                            <swe2:constraint>
                                                <swe2:AllowedTokens id="ndbcDqaFlags">
                                                    <swe2:value>a</swe2:value>
                                                    <swe2:value>b</swe2:value>
                                                    <swe2:value>d</swe2:value>
                                                    <swe2:value>f</swe2:value>
                                                    <swe2:value>g</swe2:value>
                                                    <swe2:value>i</swe2:value>
                                                    <swe2:value>j</swe2:value>
                                                    <swe2:value>k</swe2:value>
                                                    <swe2:value>m</swe2:value>
                                                    <swe2:value>n</swe2:value>
                                                    <swe2:value>p</swe2:value>
                                                    <swe2:value>q</swe2:value>
                                                    <swe2:value>r</swe2:value>
                                                    <swe2:value>s</swe2:value>
                                                    <swe2:value>t</swe2:value>
                                                    <swe2:value>v</swe2:value>
                                                    <swe2:value>w</swe2:value>
                                                    <swe2:value>x</swe2:value>
                                                    <swe2:value>y</swe2:value>
                                                    <swe2:value>z</swe2:value>
                                                </swe2:AllowedTokens>
                                            </swe2:constraint>
                                        </swe2:Category>
                                    </swe2:quality>
                                    
                                    <swe2:quality>
                                        <swe2:Category definition="http://sdftest.ndbc.noaa.gov/sos/qcflags.shtml">
                                            <swe2:label>DQA Flag 2</swe2:label>
                                            <swe2:codeSpace xlink:href="http://sdftest.ndbc.noaa.gov/sos/qcflags.shtml"/>
                                            <swe2:constraint xlink:href="#ndbcDqaFlags"/>
                                        </swe2:Category>
                                    </swe2:quality>
                                    <swe2:uom code="Celsius" />
                                </swe2:Quantity>
                            </swe2:field>
                        </swe2:DataRecord>
                    </swe2:item>
                    […]
                </swe2:DataChoice>
            </swe2:field>
        </swe2:DataRecord>
    </swe2:elementType>	
    
    <swe2:values>
        2009-05-23T00:00:00Z,a,wmo_41001_sensor1,15.4,T,a,r,2.0,280
        2009-05-23T01:00:00Z,b,wmo_41001_sensor1,15.8,M,j,j,1.8,121
        2009-05-23T02:00:00Z,c,wmo_41001_sensor1,15.6,M,,,1.0,142
        2009-05-23T00:00:00Z,a,wmo_41001_sensor2,5.6,8.0
        2009-05-23T01:00:00Z,b,wmo_41001_sensor2,5.8,8.2
        2009-05-23T02:00:00Z,c,wmo_41001_sensor2,5.7,8.5
        2009-05-23T00:00:00Z,a,wmo_41002_sensor1,16.2
        2009-05-23T01:00:00Z,b,wmo_41002_sensor1,16.4
        2009-05-23T02:00:00Z,c,wmo_41002_sensor1,16.5
        2009-05-23T00:00:00Z,a,wmo_41002_sensor2,6.1
        2009-05-23T01:00:00Z,b,wmo_41002_sensor2,6.3
        2009-05-23T02:00:00Z,c,wmo_41002_sensor2,6.5
        2009-05-23T01:00:00Z,a,wmo_41003_sensor1,15.8
    </swe2:values>
</swe2:DataArray>
```

##### _Profiling sensor observation-specific report_{: style="color: crimson"}

The dynamic data block for profiling sensor has several important specifics that are stipulated by the ability of the sensor to perform a number of simultaneous observations at multiple points of the vertical axis. In order to provide for encoding of multiple simultaneous observations in one record, the IOOS Convention requires the use of a nested **DataArray** for each profiling sensor description in a **DataChoice** structure.

The IOOS Convention requires that the dimension of that inner **DataArray** must never be specified inline in the corresponding \<swe2:elementCount\>; instead, it must be repeated in each of the \<swe2:values\> block-encoded records to allow indication of the number of heights being encoded in this record.

The IOOS Convention also requires another \<swe2:Count\> element in a **profileIndex** or **binIndex** field that preceeds each set of observation values to indicate which height/bin is being reported (**binIndex** and **profileIndex** must correspond respectively to **profileBins** or **profileHeights** in the static data block).

Similar to the non-profiling sensors, the sensor names used in the **DataChoice** structure must correspond to the sensor names in the static data block; the same names must then be repeated in the \<swe2:values\> block:

```XML
<swe2:DataChoice definition="http://mmisw.org/ont/ioos/definition/sensors">
    <swe2:item name="wmo_41001_sensor1">
        <swe2:DataRecord definition="http://mmisw.org/ont/ioos/definition/sensor">
            
            <swe2:field name="adcpProfile">
                <swe2:DataArray definition="http://mmisw.org/ont/ioos/definition/profile">
                    <swe2:description>Array of synchronous observations in a Profile</swe2:description>
                    <swe2:elementCount>
                        <swe2:Count />
                    </swe2:elementCount>
                    <swe2:elementType name="profileObservation">
                        <swe2:DataRecord definition="http://mmisw.org/ont/ioos/definition/profileObservation">
                            
                            <swe2:field name="profileIndex">
                                <swe2:Count definition="http://mmisw.org/ont/ioos/definition/profileIndex">
                                    <swe2:constraint>
                                        <swe2:AllowedValues>
                                            <swe2:interval>0 4</swe2:interval>
                                        </swe2:AllowedValues>
                                    </swe2:constraint>
                                </swe2:Count>
                            </swe2:field>
                            
                            <swe2:field name="direction_of_sea_water_velocity">
                                <swe2:Quantity definition="http://mmisw.org/ont/cf/parameter/direction_of_sea_water_velocity">
                                    <swe2:uom code="deg" />
                                </swe2:Quantity>
                            </swe2:field>
                            
                            <swe2:field name="sea_water_speed">
                                <swe2:Quantity definition="http://mmisw.org/ont/cf/parameter/sea_water_speed">
                                    <swe2:uom code="cm/s" />
                                </swe2:Quantity>
                            </swe2:field>
                            
                        </swe2:DataRecord>
                    </swe2:elementType>
                </swe2:DataArray>
            </swe2:field>
        </swe2:DataRecord>
    </swe2:item>
    
    <swe2:item name="wmo_41001_sensor2">
        <swe2:DataRecord>
            <swe2:field name="thermisterProfile">
                <swe2:DataArray definition="http://mmisw.org/ont/ioos/definition/profile">
                    <swe2:elementCount>
                        <swe2:Count />
                    </swe2:elementCount>
                    <swe2:elementType name="profileObservation">
                        <swe2:DataRecord definition="http://mmisw.org/ont/ioos/definition/profileObservation">
                            
                            <swe2:field name="binIndex">
                                <swe2:Count definition="http://mmisw.org/ont/ioos/definition/profileIndex">
                                    <swe2:constraint>
                                        <swe2:AllowedValues>
                                            <swe2:interval>0 2</swe2:interval>
                                        </swe2:AllowedValues>
                                    </swe2:constraint>
                                </swe2:Count>
                            </swe2:field>
                            
                            <swe2:field name="sea_water_temperature">
                                <swe2:Quantity definition="http://mmisw.org/ont/cf/parameter/sea_water_temperature">
                                    <swe2:uom code="Cel" />
                                </swe2:Quantity>
                            </swe2:field>
                            
                        </swe2:DataRecord>
                    </swe2:elementType>
                </swe2:DataArray>
            </swe2:field>
        </swe2:DataRecord>
    </swe2:item>
    
</swe2:DataChoice>
```

**************



