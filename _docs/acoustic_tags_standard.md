---
title: "Data Exchange Standard for Acoustic, Archival and Satellite Tags, Version 1.0"
keywords: homepage
tags: [ATN, AAT, observations, animal telemetry]
sidebar: mydoc_sidebar
topnav: topnav
toc: false
#permalink: index.html
summary:  Data and metadata template to use for sharing acoustic, archival and satellite telemetry data between organizations.
---

 <!-- 
* TOC
{:toc}
-->


# **Introduction**

The standard proposed hereafter is primarily based on the metadata convention developed for acoustic telemetry projects (Payne et al. 2013) and the structure of the IMOS Animal Tracking acoustic database (IMOS Animal Tracking 2016), with additional metadata information gathered from various projects (e.g. OTN, TOPP, Movebank) (Kranstauber et al. 2011). The need for such a standard has become obvious due to a growing number of projects (e.g. TOPP, POST, AATAMS) collecting important volumes of data (Kranstauber et al. 2011, Campbell et al. 2015, Dwyer et al. 2015, Campbell et al. 2016), which are more likely to result in the publication of articles in high impact factor journals (Block et al. 2011, Hussey et al. 2015, Kays et al. 2015).
The present convention follows the nomenclature used in Payne et al. (2013) with database fields flagged as ‘required’ or ‘optional’ for users to get a minimum amount of viable information for each dataset. Constraints and relationships between database tables highlight how information from different tables can be respectively kept consistent and joined together (Figure 1). For additional database related logic, refer to Payne et al. (2013). The proposed tables were designed using the PostgreSQL database language and the PostGIS extension to convert longitude/latitude coordinates into geometries. All PostgreSQL queries along with other documents relevant to this standard are publicly available at https://github.com/xhoenner/biologging_data-sharing.

&nbsp; 

********************

# **1. Database schema design**

All metadata related to individual tag or receiver deployments (the equivalent of global attributes for netCDF files) are stored in 13 different tables detailed below and in [Section 3](#database-schema). In contrast, metadata for each variable in a dataset, commonly referred to as variable attributes in the netCDF format, are not included in the current standard but may be added in the future if required. The present data exchange standard also includes a database structure to hold animal location data estimated from Argos, Fastloc GPS, light levels, and acoustic receivers. These location datasets are stored in four distinct tables because of different diagnostic information inherent to each technology. Furthermore two monitoring tables store information about metadata editing and data file uploads.

Detailed field names and meanings for each database table are provided in [Section 3](#database-schema). Each table has (1) a primary key, which constrains some fields to have a unique combination of values, and (2) foreign keys, which explicitly link tables so that information from different tables can be extracted in a flat CSV table format. These foreign keys also prevent accidental deletion and erroneous insertion of data. Database views can then be built to join information between tables and subsequently be used by a web-based application.

## **1.1 Metadata tables**

1.  [**Device**](#device): information about tags including manufacturer name and model.

2.  [**Instrument**](#instruments): additional information about each tag, *e.g.* firmware/software version, tag configuration, on board sensors.

3.  [**Installation station**](#installation-station): information about acoustic installations and stations within installations.

4.  [**Receiver deployment and recovery**](#receiver-deployment-recovery): information about     acoustic receiver deployments and recoveries.

5.  [**Surgery**](#surgery): specifies which tag was deployed as part of an animal release and how. This is a mapping table between the `device` and `animal_release_recovery` tables allowing multiple tag deployments.

6.  [**Animal release and recovery**](#animal-release-recovery): information about animal capture, release, and potential recovery.

7.  [**Animal**](#animal): information about each animal equipped with tags including sex, species, and age.

8.  [**Species**](#species): read-only table providing a list of species for users to choose from. This list should eventually follow a comprehensive standard approved upon by the tagging community (_e.g._ [WoRMS for marine species](http://www.marinespecies.org/)).

9.  [**Animal measurement**](#animal-measurement): lists all the morphological measurements taken for each tagged animal.

10. [**Project**](#project): information on tagging projects (_e.g._ abstract, distribution statement), and which data center hosts their data (if any).

11. [**Data center**](#data-center): name and attributes of each data center.

12. [**Users**](#user): names and contact details of users.

13. [**Project role**](#projectp-role): mapping table between the project and users tables.


## **1.2 Monitoring tables**

1.  [**Activity log**](#activity-log): lists modifications made by users through the GUI to metadata tables.

2.  [**Uploaded files**](#uploaded-files): lists all data files uploaded by users.


## **1.3 Data tables**

1.  [**GPS locations**](#gps-locations): animal location data and diagnostic information obtained using the Fastloc GPS technology.

2.  [**Argos locations**](#argos-locations): animal location data and diagnostic information obtained using the Argos technology.

3.  [**GLS locations**](#gls-locations): animal location data obtained using light level sensor tags.

4.  [**Acoustic detections**](#acoustic-detections): animal location data and sensor values obtained from acoustic receivers.

&nbsp;

**********************************

# **2. Discussion**


## **2.1 Infrastructure**

We propose that the relational database tables described above be supported by an online, web-based interface for users to enter/edit metadata, upload data, and search, filter and download data. These three use cases should dictate the overall design of the graphical user interface (GUI) to make it as intuitive as possible to users.
To avoid hosting data without a minimum amount of metadata, an error should be generated when uploading data files for tags that are not registered in the database with the exception of acoustic data for which tags detected are not necessarily owned by receiver owners. A key requirement will therefore be for users to register their tags using the exact same name as in their data files so that observations can be internally joined with tag and deployment metadata.
While duplicate observations can be flagged directly within the database using PostgreSQL functions, all data files for upload via the GUI (*e.g.* GPS locations, acoustic detections) will have to follow clearly defined conventions. Tools may therefore have to be developed to convert data files provided by each manufacturer into the required format and checkers should be set up within the web application so that bad and uncompliant data does not end up in the database. Hosting additional data products (_e.g._ CTD or TDR data, receiver events) is consequently feasible but will require additional work on conversion tools and compliance checkers.<br><br>

## **2.2 Data flow**

The following section explains the proposed flow of data in the system covering the three use cases outlined above: *i.e.* metadata editing, data upload, data download. Unregistered users will only have access to the latter section while registered users (*e.g.* system administrator, principal investigator) who are member of a given project will also be able to enter metadata and upload data files. A security logic restricting access to sensitive data (*e.g.* PhD projects, species at risk of being targeted for exploitation) could be implemented similarly to the one in place in the [IMOS Animal Tracking web application](https://github.com/aodn/aatams). Doing so will nonetheless add substantial complexity to the online infrastructure code and hence increase its maintenance cost greatly.


### _**Metadata entry**_

This menu option will only be available to registered users who are members of a project. This menu consists of a logical sequence of questions:

1.  *Does your project exist in the database?*

   - **No ->** user is prompted to enter details about their project.

   - **Yes ->** user can edit project details and/or proceed to Step 2.

2.  *Does your device exist in the database?*

    - **No ->** user is prompted to enter details about their device and instruments.

    - **Yes ->** user can edit device and instruments details and/or proceed to Step 3 if the device has been deployed or recovered.

3.  *Does a deployment/recovery event exist for this device in the database?*

     - **No ->** user is prompted to enter details about tag deployment and/or recovery on an animal, animal information (species, measurements) **OR** receiver deployment and/or recovery on an acoustic installation/station.

     - **Yes ->** user can edit tag or receiver deployment/recovery details and/or proceed to Step 4.

4.  *What do you want to do next?*

     - Register a new tag in the database proceed to Step 2.

     - Add other deployment/recovery information proceed to Step 3.

     - Upload data files see next section.



### _**Data upload**_

This menu option will only be available to registered users who are members of a project.

1.  Users will first be asked which type of data file they would like to upload and be reminded of (a) the expected file format convention and (b) that all tag IDs in their data file must have a matching record in the database (except in the case of acoustic data files, see second paragraph of the Discussion).

2.  Users will then be able to upload their data file. A checker will verify that the file format complies with the expected convention and that all tag IDs in the data file are found under the `device_name` field in the `device` table.

3.  Three outcomes are then possible:

   - Data file successfully passed all tests.

   - One or more tests of the data file checker have failed; error messages should be shown to users accordingly.

   - Some tag IDs (or receiver IDs) are not found under the `device_name` field in the `device` table: users should be given a list of unknown tag IDs and be prompted to enter tag and deployment metadata for those tags.

### _**Data download**_

This menu option will be available to unregistered users but data availability may vary depending on whether we choose to implement security constraints. Users should be able to subset and download data using the following filters:

-   Data type, *e.g.* GPS location, acoustic detections

-   Date start and end

-   Geographic bounding box

-   Species

-   Tag IDs

-   Project name

&nbsp;

**********************************

# **3. Database schema: tables and relationships**

<!-- ![Relational_database_diagram](animal-telemetry-jekyll/database1.jpg){:height="600"} -->


<img src="/animal-telemetry-jekyll/database1.jpg" height="800">

<a name="Fig_1"></a>_**Figure 1: Database schema showing the content of each table and their relationships. Metadata, monitoring, and data tables are shown in the green, orange, and red dashed rectangle respectively. Foreign key relationships from the  `receiver_deployment_recovery` and `animal_release_recovery` to the `users` table are not represented to improve readability.**_

<br><br>


## **3.1 Metadata tables**

### _**Device**_

**Provides information about tags and acoustic receivers including manufacturer name and model**
	 	
_Field name_ | _Description_ | _Required_ | _Data type_ |_Constraints_ | _Authority_ 
:-----------------: | :-----------------: | :---------------: | :---------------: | :-----------------: | :---------------: 
id| Device ID (unique). | required | numeric | Primary key | 
device_name | Device name for each project (_e.g._ **ct111-030-13**). <br><br>For acoustic tags, the _**`device_name`**_ value should be automatically generated using values for the _**`code_map`**_ and _**`ping_code`**_ fields below (i.e. _**`device_name`**_ = _**`code_map`-`ping_code`**_). <br><br>For acoustic receivers, , the _**`device_name`**_ value should be automatically generated using values for the _**`model_name`**_ and _**`serial_number`**_ fields below (i.e. _**`device_name`**_ = _**`model_name`-`serial_number`**_). <br><br>The _**`device_name`**_ value needs to match the content of the _**`device_name`**_ field in the data tables for data to be joined to metadata. | required | text | | 
project_id | Project ID. | required | numeric | Foreign key to project table | 
device_type | Type of device, can only take the following values: _**archival**_, _**pop-up**_, _**satellite**_, _**acoustic tag**_, or _**acoustic receiver**_ | required | text | Controlled vocabulary implemented via a check constraint | 
manufacturer | Name of manufacturer. | required | text | Controlled vocabulary implemented via a check constraint | 
model_name | Model name. | required | text | Controlled vocabulary implemented via a check constraint | 
serial_number | Device serial number. | required | text | The combination of _**`manufacturer`**_, _**`model_name`**_, and _**`serial_number`**_ must be unique. | 
code_map | For acoustic tags only (_e.g._ **‘A69-9002’**). Additional database constraints can be generated based on this value since some code maps are pingers only and some are sensors only [https://github.com/aodn/aatams/issues/240 - issuecomment-214596557](https://github.com/aodn/aatams/issues/240#issuecomment-214596557).
optional | text | Not null if _**`device_type`**_ = _**`acoustic tag`**_ | 
ping_code | For acoustic tags only. | optional | numeric | Not null if _**`device_type`**_ = _**`acoustic tag`**_ | 
ptt | Platform Transmitting Terminal (PTT) number for Argos transmission. For pop-up and satellite tags only. | optional | text | Null if _**`device_type`**_ = _**`acoustic`**_ or _**`archival`**_ | 
device_wmo_ref | World Meteorological Organization (WMO) number allocated to this device. For pop-up and satellite tags only. | optional | text | Null if _**`device_type`**_ = _**`acoustic`**_ or _**`archival`**_ | 
infourl | URL to tag model specifications. | required | text | | ERDDAP 

### _**Instruments**_

**Provides additional information about each tag, _e.g._ firmware/software version, tag configuration, on board sensors.**

_Field name_ | _Description_ | _Required_ | _Data type_ |_Constraints_ | _Authority_ 
:-----------------: | :-----------------: | :---------------: | :---------------: | :-----------------: | :---------------: 
id | Instrument ID (unique). | required | numeric | Primary key | 
device_id | Device ID. The list of parameters below available to users through the GUI should be based on the type of device selected previously (see ‘device_type’ in the device table), e.g. if ‘device_type’ = ‘acoustic’ then only pressure, temperature, pinger, range_test can be edited. | required | numeric | Foreign key to device table | 
firmware_version | Version number of the firmware used to build the tag. | required | text |  | 
software_version | Version number of the software used for the tag. | required | text |  | 
configuration_parameters | Parameter settings used to configure the tag for deployment; could also provide users with the possibility to upload a text file of specifications. | required | text |  | 
pressure | Was pressure data recorded? | required | boolean |  | 
temperature | Was temperature data recorded? | required | boolean |  | 
light | Was light data recorded? | required | boolean |  | 
conductivity | Was conductivity data recorded? | required | boolean |  | 
fluorescence | Was fluorescence data recorded? | required | boolean |  | 
accelerometer_3d | Was speed data recorded? | required | boolean |  | 
magnetometer_3d | Was orientation data recorded? | required | boolean |  | 
stomach_temperature | Was stomach temperature data recorded? | required | boolean |  | 
argos_location<br><br>gps_location<br><br>geolocation  | Which type(s) of location estimates was provided by the tag? | required | boolean |  | 
geolocation_data_processing | If geolocation = TRUE then specify which algorithm was used to process GLS raw data | required | text | Not null if device.device_type = ‘archival’ | 
pinger | Was this device a pinger tag? | required | boolean | Not null if device.device_type = ‘archival’  | 
range_test | Was this device a range test tag? | required | boolean | Not null if device.device_type = ‘archival’  | 
intercept | Intercept and slope of the sensor (found in the transmitter specifications) | required | boolean | Not null if device.device_type = ‘acoustic tag’ and pinger = FALSE and range_test = FALSE | 
slope |  Slope of the sensor (found in the transmitter specifications)  | required | boolean | Not null if device.device_type = ‘acoustic tag’ and pinger = FALSE and range_test = FALSE | 
unit | Implement constraints based on sensor type (i.e. if temperature = true then unit = '°C', pressure = true then unit = 'm', accelerometer then unit = 'm.s-2'). | required | boolean | Not null if device.device_type = ‘acoustic tag’ and pinger = FALSE and range_test = FALSE | 

### _**Installation station**_

**Provides information about acoustic installations and stations within installations.**

_Field name_ | _Description_ | _Required_ | _Data type_ |_Constraints_ | _Authority_ 
:-----------------: | :-----------------: | :---------------: | :---------------: | :-----------------: | :---------------: 
id | Installation station ID (unique). | required | numeric | Primary key | 
project_id | Project ID. | required | numeric | Foreign key to project table | 
installation_name | Name of acoustic installation. An installation is made of several receiving stations | required | text | Unique constraint | 
station_name | Name of installation station. The same installation cannot have two stations with the same name. | required | text | The combination of `installation_name` and `station_name` must be unique. | 
station_location | Longitude and latitude of each installation station, transformed into a geometry (point). | required | geometry |  |  

### _**Receiver deployment and recovery**_ 

**Provides information about acoustic receiver deployments and recoveries.**


_Field name_ | _Description_ | _Required_ | _Data type_ |_Constraints_ | _Authority_ 
:-----------------: | :-----------------: | :---------------: | :---------------: | :-----------------: | :---------------: 
id | Receiver deployment and recovery ID (unique). | required | numeric | Primary key | 
receiver_id | Receiver ID. | required | numeric | Foreign key to device table (where device_type = ‘Acoustic receiver’) | 
installation_station_id | Installation station ID | required | numeric | Foreign key to installation_station table | 
bottom_depthm | Depth to bottom (m) | optional | numeric |  | 
comments | Deployment comments | optional | text |  | 
deployer_id | ID of the person who deployed the acoustic receiver. | required | numeric | Foreign key to users table. | 
initialisation_datetime | Acoustic receiver initialisation date and time (UTC). | required | timestamp |  | 
deployment_datetime | Acoustic receiver deployment date and time (UTC). | required | timestamp |  | 
depth_below_surfacem | Depth from the surface to the receiver (m) | optional | numeric |  | 
mooring_descriptor | Description of the type of mooring that was used | optional | text |  | 
mooring_type | Fixed or floating? | optional | text | Controlled vocabulary implemented via a check constraint | 
receiver_orientation | Up, down, or sideways | optional | text | Controlled vocabulary implemented via a check constraint | 
deployment_location | Longitude and latitude of receiver deployment, transformed into a geometry (point). | required | geometry |  | 
recoverer_id | ID of the person who recovered the acoustic receiver. | optional | numeric | Foreign key to users table. | 
recovery_datetime | Acoustic receiver deployment date and time (UTC). | optional | timestamp | If recoverer_id is not null then these three elds cannot be null. Controlled vocabulary implemented on `recovery_status` via a check constraint | 
recovery_location | Longitude and latitude of receiver recovery, transformed into a geometry (point). | optional | geometry |  | 
recovery_status | Retired, damaged, stolen, recovered, lost, or returned to vendor? | optional | text |  |  

### _**Surgery**_

**Specifies which tag was deployed as part of an animal release and how.**

_Field name_ | _Description_ | _Required_ | _Data type_ |_Constraints_ | _Authority_ 
:-----------------: | :-----------------: | :---------------: | :---------------: | :-----------------: | :---------------: 
id | Surgery ID (unique). | required | numeric | Primary key |  |
device_id | Device ID. | required | numeric | Foreign key to device table |  |
release_id | Animal release ID. | required | numeric | Foreign key to animal_release_recovery table |  |
attachment_method | Describe how the tag was attached (e.g. glued, implant). | required | text | Controlled vocabulary implemented via a check constraint |  |
attachment_details | Describe tag attachment (e.g. location of tag on animal, use of anaesthetics). | optional | text |  |  |

### _**Animal release and recovery**_

**Provides information about animal capture, release, and potential recovery.**

_Field name_ | _Description_ | _Required_ | _Data type_ |_Constraints_ | _Authority_ 
:-----------------: | :-----------------: | :---------------: | :---------------: | :-----------------: | :---------------: 
id | Animal release and recovery ID (unique). | required | numeric | Primary key |  
animal_id | Animal ID. | required | numeric | Foreign key to animal table |  
tagger_id | ID of the person who deployed the device on the animal. | required | numeric | Foreign key to users table. |  
animal_capture_locality | Locality, State/Territory, Country of capture | optional | text |   |  
animal_capture_location | Longitude and latitude of capture, transformed into a geometry (point). | optional | geometry |   |  
animal_capture_datetime | Date and time (UTC) of capture. | optional | timestamp |   |  
deployment_locality | Locality, State/Territory, Country of tag deployment | required | text |   |  
deployment_location | Longitude and latitude of tag deployment, transformed into a geometry (point). | required | geometry |   |  
deployment_datetime | Date and time (UTC) of tag deployment. | required | timestamp |   |  
deployment_comments | Describe the deployment event and whether any samples were taken during tag deployment (e.g. tissue, blubber, blood). | optional | text |   |  
recoverer_id | ID of the person who recovered the device on the animal | optional | numeric | Foreign key to users table |  
recovery_locality | Locality, State/Territory, Country of recovery | optional | text |   |  
recovery_location | Longitude and latitude of recovery, transformed into a geometry (point). | optional | geometry | If recoverer_id is not null then these two fields cannot be null. |  
recovery_datetime | Date and time (UTC) of tag recovery. | optional | timestamp | If recoverer_id is not null then these two fields cannot be null. |  
recovery_comments | Describe the recovery event (e.g. damage on tag, biofouling, tag sent back to manufacturer for refurbishing). | optional | text |   |  

### _**Animal**_

**Provides information about each animal equipped with tags including sex, species, and age.**
 
_Field name_ | _Description_ | _Required_ | _Data type_ |_Constraints_ | _Authority_ 
:-----------------: | :-----------------: | :---------------: | :---------------: | :-----------------: | :---------------: 
id	|	Animal ID (unique).	|	required	|	numeric	|	Primary key	|	
unique_id	|	Unique ID for each animal (e.g. numbered tag, band, transponder)	|	required	|	text	|		|	
species_id	|	Species ID.	|	required	|	numeric	|	Foreign key to species table	|	
sex	|	Sex of animal.	|	required	|	text	|	Can only be female, male, or unknown.	|	Darwin Core
lifeStage	|	Animal life stage (e.g. adult, juvenile, subadult, weaner)	|	required	|	text	|	Controlled vocabulary implemented via a check constraint	|	Darwin Core
ageUnit	|	Unit of age (e.g. days, months, years)	|	optional	|	text	|	Controlled vocabulary implemented via a check constraint	|	
value	|	Age of animal	|	optional	|	numeric	|		|	
estimate	|	Is the age value an estimate?	|	optional	|	boolean	|		|	
comments	|	Additional information on animal (e.g. animal origin – wild vs. hatchery, stock, injuries)	|	optional	|	text	|		|	

### _**Species**_

**Simplified list of species (read only). This list should eventually follow a comprehensive standard approved upon by the tagging community (*e.g.* [WoRMS for marine species](http://www.marinespecies.org/))**
  
_Field name_ | _Description_ | _Required_ | _Data type_ |_Constraints_ | _Authority_ 
:-----------------: | :-----------------: | :---------------: | :---------------: | :-----------------: | :---------------: 
id	|	Species ID (unique).	|	required	|	numeric	|	Primary key	|	
worms_aphiaID	|	WoRMS Aphia ID	|	required	|	numeric	|		|	
kingdom	|	Taxonomical information for each species, see http://rs.tdwg.org/dwc/terms/index.htm#taxonindex for more details.	|	required	|	text	|		|	Darwin Core
phylum	|	Taxonomical information for each species, see http://rs.tdwg.org/dwc/terms/index.htm#taxonindex for more details.	|	required	|	text	|		|	Darwin Core
class_name	|	Taxonomical information for each species, see http://rs.tdwg.org/dwc/terms/index.htm#taxonindex for more details.	|	required	|	text	|		|	
order_name	|	Taxonomical information for each species, see http://rs.tdwg.org/dwc/terms/index.htm#taxonindex for more details.	|	required	|	text	|		|	
family	|	Taxonomical information for each species, see http://rs.tdwg.org/dwc/terms/index.htm#taxonindex for more details.	|	required	|	text	|		|	Darwin Core
genus	|	Taxonomical information for each species, see http://rs.tdwg.org/dwc/terms/index.htm#taxonindex for more details.	|	required	|	text	|		|	Darwin Core
subgenus	|	Taxonomical information for each species, see http://rs.tdwg.org/dwc/terms/index.htm#taxonindex for more details.	|	optional	|	text	|		|	Darwin Core
specificEpithet	|	Taxonomical information for each species, see http://rs.tdwg.org/dwc/terms/index.htm#taxonindex for more details.	|	required	|	text	|		|	Darwin Core
infraspecificEpithet	|	Taxonomical information for each species, see http://rs.tdwg.org/dwc/terms/index.htm#taxonindex for more details.	|	required	|	text	|		|	Darwin Core
scientificName	|	Taxonomical information for each species, see http://rs.tdwg.org/dwc/terms/index.htm#taxonindex for more details.	|	required	|	text	|		|	Darwin Core
acceptedNameUsage	|	Taxonomical information for each species, see http://rs.tdwg.org/dwc/terms/index.htm#taxonindex for more details.	|	required	|	text	|		|	Darwin Core
vernacularName	|	Taxonomical information for each species, see http://rs.tdwg.org/dwc/terms/index.htm#taxonindex for more details.	|	required	|	text	|		|	Darwin Core
scientificNameAuthorship	|	Recognised authority (author and date) for each species name, and source of this information.	|	required	|	text	|		|	Darwin Core
date_modified	|	Date on which each species entry was last modified.	|	required	|	timestamp	|		|	NACDD

### _**Animal measurement**_

**Lists all the morphological measurements taken for each tagged animal.**

_Field name_ | _Description_ | _Required_ | _Data type_ |_Constraints_ | _Authority_ 
:-----------------: | :-----------------: | :---------------: | :---------------: | :-----------------: | :---------------: 
id	|	Animal measurement ID (unique).	|	required	|	numeric	|	Primary key	|	
animal_id	|	Animal ID.	|	required	|	numeric	|	Foreign key to animal table	|	
type	|	Type of measurement (e.g. length, weight, total length, carapace length, carapace width, fork length, width).	|	required	|	text	|	Controlled vocabulary implemented via a check constraint	|	
unit	|	Unit of measurement (e.g. mm, cm, m, g, kg).	|	required	|	text	|	Controlled vocabulary implemented via a check constraint	|	
value	|	Measurement value.	|	required	|	text	|		|	
estimate	|	Is the measurement value an estimate?	|	required	|	boolean	|		|	
comments	|	Additional information on each measurement.	|	optional	|	text	|		|	

### _**Project**_

**Provides information on tagging projects, which data center hosts data, who is the principal investigator.**
  
_Field name_ | _Description_ | _Required_ | _Data type_ |_Constraints_ | _Authority_ 
:-----------------: | :-----------------: | :---------------: | :---------------: | :-----------------: | :---------------: 
id	|	Project ID (unique).	|	required	|	numeric	|	Primary key	|	
datacenter_id	|	ID of data center. Not a compulsory so that people who would like to contribute can do so without having their data in a data centre.	|	optional	|	numeric	|	Foreign key to datacenter table	|	
title	|	Project name	|	required	|	text	|	Unique constraint	|	NACDD
summary	|	Description of project including background, methods, and objectives.	|	required	|	text	|		|	NACDD
citation	|	Citation to be used in publications using the data from the project should follow the following format: “ProjectName. [year-of-data-download], [Title], [Data access URL], accessed [date-of-access]”.	|	required	|	text	|		|	
infourl	|	URL to project information website or metadata record.	|	optional	|	text	|		|	ERDDAP
publications	|	Published or web-based references that describe the data or methods used to produce the data from the project. Multiple references should be separated with a semicolon. If available DOIs should be given.	|	optional	|	text	|		|	
license	|	Describe the project restrictions to data access and distribution.	|	optional	|	text	|		|	NACDD
distribution_statement	|	Statement describing data distribution policy (e.g. ‘You accept all risks and responsibility for losses, damages, costs and other consequences resulting directly or indirectly from using the data from this project’).	|	optional	|	text	|		|	
date_modified	|	Date on which the project data was last modified.	|	required	|	timestamp	|		|	NACDD
location	|	Min and max longitude and latitude of the project data, transformed into a geometry (polygon).	|	required	|	geometry	|		|	
timestamp_start	|	Start date and time (UTC) of the project data.	|	required	|	timestamp	|		|	
timestamp_end	|	End date and time (UTC) of the project data.	|	required	|	timestamp	|		|	

### _**Data center**_

**Provides name and attributes of each data center.**

_Field name_ | _Description_ | _Required_ | _Data type_ |_Constraints_ | _Authority_ 
:-----------------: | :-----------------: | :---------------: | :---------------: | :-----------------: | :---------------: 
id	|	Data center ID (unique).	|	required	|	numeric	|	Primary key	|	
manager_id	|	ID of manager of data center.	|	required	|	numeric	|	Foreign key to users table	|	
title	|	Data center name	|	required	|	text	|	Unique constraint	|	NACDD
summary	|	Description of data center including background, methods, and objectives.	|	required	|	text	|		|	NACDD
citation	|	Citation to be used in publications using the data from the data center should follow the following format: “DataCenterName. [year-of-data-download], [Title], [Data access URL], accessed [date-of-access]”.	|	required	|	text	|		|	
infourl	|	URL to data center information website or metadata record.	|	required	|	text	|		|	ERDDAP
license	|	Describe the data center restrictions to data access and distribution.	|	optional	|	text	|		|	NACDD
distribution_statement	|	Statement describing data distribution policy (e.g. ‘You accept all risks and responsibility for losses, damages, costs and other consequences resulting directly or indirectly from using the data from this project’).	|	optional	|	text	|		|	
date_modified	|	Date on which the data center data was last modified.	|	required	|	timestamp	|		|	NACDD

### _**Users**_

**Provides names and contact details of users.**

_Field name_ | _Description_ | _Required_ | _Data type_ |_Constraints_ | _Authority_ 
:-----------------: | :-----------------: | :---------------: | :---------------: | :-----------------: | :---------------: 
id	|	User ID.	|	required	|	numeric	|		|	
organisation_name	|	Name of organisation.	|	required	|	text	|	Primary key	|	
name	|	Name of user	|	required	|	text	|	Should be unique.	|	
email_address	|	Email address of user	|	required	|	text	|	Should be unique.	|	
department	|	Department name within organisation	|	required	|	text	|		|	
phone_number	|	Phone number of user, including country and area code.	|	optional	|	text	|		|	
postal_address	|	Postal address of organisation	|	required	|	text	|		|	

### _**Project role**_

**Provides mapping between the project and users table.**

 _Field name_ | _Description_ | _Required_ | _Data type_ |_Constraints_ | _Authority_ 
:-----------------: | :-----------------: | :---------------: | :---------------: | :-----------------: | :---------------: 
id	|	Project role ID.	|	required	|	numeric	|	Primary key	|	
user_id	|	User ID.	|	required	|	numeric	|	Foreign key to users table.	|	
project_id	|	Project ID.	|	required	|	numeric	|	Foreign key to project table.	|	
role_type	|	Role of user in project (_e.g._ Principal Investigator, Co-Investigator, Administrator, Student).	|	required	|	text	|	Controlled vocabulary implemented via a check constraint	|

<br>	

## **3.2 Monitoring tables**

### **Activity log**

**Lists modifications made by users through the GUI to metadata tables.**
 
 _Field name_ | _Description_ | _Required_ | _Data type_ |_Constraints_ | _Authority_ 
:-----------------: | :-----------------: | :---------------: | :---------------: | :-----------------: | :---------------: 
id	|	Activity log ID (unique).	|	required	|	numeric	|	Primary key	|	
user_id	|	ID of the person who made the modification.	|	required	|	numeric	|	Foreign key to users table	|	
class_name	|	Name of the table that was modified.	|	required	|	text	|		|	
property_name	|	Name of the column that was modified.	|	required	|	text	|		|	
persisted_object_id	|	Row number where the modification was made.	|	required	|	text	|		|	
event_type	|	Type of modification made: i.e. delete, insert, or update	|	required	|	text	|	Controlled vocabulary implemented via a check constraint	|	
new_value	|	Value after modification was made	|	optional	|	text	|		|	
old_value	|	Value before modification was made	|	optional	|	text	|		|	

### _**Uploaded files**_

**Lists all data files uploaded by users.**
 
_Field name_ | _Description_ | _Required_ | _Data type_ |_Constraints_ | _Authority_ 
:-----------------: | :-----------------: | :---------------: | :---------------: | :-----------------: | :---------------: 
id	|	Data file ID (unique).	|	required	|	numeric	|	Primary key	|	
user_id	|	ID of the person who uploaded the data file.	|	required	|	numeric	|	Foreign key to users table	|	
file_type	|	Type of data file uploaded, i.e. acoustic detections, GPS, Argos, or GLS locations.	|	required	|	text	|	Controlled vocabulary implemented via a check constraint	|	
file_name	|	Name of data file uploaded.	|	required	|	text	|		|	
upload_datetime	|	Date and time (UTC) of file upload.	|	required	|	timestamp	|		|	
status	|	Processed, processing, or error.	|	required	|	text	|	Controlled vocabulary implemented via a check constraint	|	
err_msg	|	Potential error message from the data file checkers.	|	required	|	text	|		|	

<br>

## **3.3 Data tables**

### **GPS locations**

**Provides animal location data and diagnostic information obtained using the Fastloc GPS technology.**

_Field name_ | _Description_ | _Required_ | _Data type_ |_Constraints_ | _Authority_ 
:-----------------: | :-----------------: | :---------------: | :---------------: | :-----------------: | :---------------: 
id | GPS location ID (unique), self-generated by database during data import. | required | numeric | Primary key 
file_id | Corresponding file ID  | required | numeric | Foreign key to uploaded_file table 
device_name | The `device_name` value needs to match the content of the `device_name` field in the device table for data to be joined to metadata. | required | text | Foreign key to device table 
timestamp | Date and time (UTC) of the GPS location. | required | timestamp |  
decimalLatitude | In decimal format and degree North. | required | numeric | -90 < lat < 90 | Darwin Core
decimalLongitude | In decimal format and degree East. | required | numeric | -180 < lon < 180 | Darwin Core
nsats_detected | Diagnostic information for each timestamp, longitude, latitude combination. Need to confirm the usefulness and meaning of each of these fields. | optional | numeric | Need controlled vocabulary 
nsats_transmitted | Diagnostic information for each timestamp, longitude, latitude combination. Need to confirm the usefulness and meaning of each of these fields. | optional | numeric |  
pseudoranges | Diagnostic information for each timestamp, longitude, latitude combination. Need to confirm the usefulness and meaning of each of these fields. | optional | text |  
max_csn | Diagnostic information for each timestamp, longitude, latitude combination. Need to confirm the usefulness and meaning of each of these fields. | optional | numeric |  
residual | Diagnostic information for each timestamp, longitude, latitude combination. Need to confirm the usefulness and meaning of each of these fields. | optional | numeric |  
timeshift | Diagnostic information for each timestamp, longitude, latitude combination. Need to confirm the usefulness and meaning of each of these fields. | optional | numeric |  
duplicate | Does this GPS location already exist in this table? A PostgreSQL function flags this field as TRUE if the combination of `device_name` and `timestamp` is found multiple times. | optional | boolean |  

### _**Argos locations**_

**Provides animal location data and diagnostic information obtained using the Argos technology.**

_Field name_ | _Description_ | _Required_ | _Data type_ |_Constraints_ | _Authority_ 
:-----------------: | :-----------------: | :---------------: | :---------------: | :-----------------: | :---------------: 
id | Argos location ID (unique), self-generated by database during data import. | required | numeric | Primary key
file_id | Corresponding file ID  | required | numeric | Foreign key to uploaded_file table
device_name | The `device_name` value needs to match the content of the `device_name` field in the device table for data to be joined to metadata. | required | text | Foreign key to device table
timestamp | Date and time (UTC) of the Argos location. | required | timestamp | 
decimalLatitude | In decimal format and degree North. | required | numeric | -90 < lat < 90 | Darwin Core
decimalLongitude | In decimal format and degree East. | required | numeric | -180 < lon < 180 | Darwin Core
location_quality | Location Quality assigned by Argos (-1 = class A, -2 = class B, 9 = class Z). | required | text | Need controlled vocabulary
alt_latitude | Alternative solution to position equations, in decimal format and degree North. | optional | numeric | 
alt_longitude | Alternative solution to position equations, in decimal format and degree East. | optional | numeric | 
n_mess | Number of uplinks received during the satellite pass. | optional | numeric | 
n_mess_120 | Number of uplinks received with signal strength > -120 dB. | optional | numeric | 
best_level | Signal strength of strongest uplink (dB). | optional | numeric | 
pass_dur | Duration of satellite overpass (seconds). | optional | numeric | 
freq | Measured frequency of SRDL signal at the satellite (Hz). | optional | numeric | 
duplicate | Does this Argos location already exist in this table? A PostgreSQL function flags this field as TRUE if the combination of `device_name` and `timestamp` is found multiple times. | optional | boolean | 

### **GLS locations**

**Provides animal location data obtained using light level sensor tags.**

_Field name_ | _Description_ | _Required_ | _Data type_ |_Constraints_ | _Authority_ 
:-----------------: | :-----------------: | :---------------: | :---------------: | :-----------------: | :---------------: 
id | GLS location ID (unique), self-generated by database during data import. | required | numeric | Primary key
file_id | Corresponding file ID  | required | numeric | Foreign key to uploaded_file table
device_name | The `device_name` value needs to match the content of the `device_name` field in the device table for data to be joined to metadata. | required | text | Foreign key to device table
timestamp | Date and time (UTC) of the GLS location | required | timestamp | 
decimalLatitude | In decimal format and degree North. | required | numeric | -90 < lat < 90 | Darwin Core
decimalLongitude | In decimal format and degree East. | required | numeric | -180 < lon < 180 | Darwin Core
duplicate | Does this GLS location already exist in this table? A PostgreSQL function flags this field as TRUE if the combination of `device_name` and `timestamp` is found multiple times. | optional | boolean | 

### *Acoustic detections*

**Provides animal location data and sensor values obtained from acoustic receivers.**

_Field name_ | _Description_ | _Required_ | _Data type_ |_Constraints_ | _Authority_ 
:-----------------: | :-----------------: | :---------------: | :---------------: | :-----------------: | :---------------: 
id | Detection ID (unique), self-generated by database during data import. | required | numeric | Primary key
file_id | Corresponding file ID  | required | numeric | Foreign key to uploaded_file table
receiver_name | Name of receiver on which transmitter was detected. The `receiver_name` value needs to match the content of the `device_name` field in the device table for data to be joined to metadata. | required | text | Foreign key to device table
transmitter_id | The `transmitter_id` value needs to match the content of the `device_name` field in the device table for data to be joined to metadata. | required | text | Foreign key to device table
timestamp | Date and time (UTC) of the acoustic detection. | required | timestamp | 
sensor_value | Value recorded by the sensor tag. | required | numeric | 
sensor_unit | Corresponding unit for the sensor_value. | required | text | 
duplicate | Does this acoustic detection already exist in this table? A PostgreSQL function flags this field as TRUE if the combination of `transmitter_id`, `receiver_name`, and `timestamp` is found multiple times. | optional | boolean | 

&nbsp;

**********************************

# **4. Reference Information**
<br>
## **4.1 Contribution**

| Name  | Association  |
|:---|:---|
| Xavier Hoenner | Integrated Marine Observing System, University of Tasmania, Private Bag 110, Hobart, TAS 7001, Australia |
| Lenore Bajona,<br>Marta Mihoff, Jonathan Pye | Ocean Tracking Network (OTN) Biology, Department Dalhousie University, 1355 Oxford Street PO Box 15000 Halifax, NS, Canada, B3H 4R2 |
| Hassan Moustahfid | NOAA. U.S. Integrated Ocean Observing System, Silver Spring, MD, USA |
| Rob Harcourt | Department of Biological Sciences, Faculty of Science and Engineering, Macquarie University, Sydney, NSW 2109, Australia |

<br>

## **4.2 Citation sources**

1. Block BA, Jonsen ID, Jorgensen SJ, Winship AJ, Shaffer SA, Bograd SJ, Hazen EL, Foley DG, Breed GA, Harrison AL, Ganong JE, Swithenbank A, Castleton M, Dewar H, Mate BR, Shillinger GL, Schaefer KM, Benson SR, Weise MJ, Henry RW, Costa DP (2011) Tracking apex marine predator movements in a dynamic ocean. Nature 475:86-90 

2. Campbell HA, Beyer HL, Dennis TE, Dwyer RG, Forester JD, Fukuda Y, Lynch C, Hindell MA, Menke N, Morales JM, Richardson C, Rodgers E, Taylor G, Watts ME, Westcott DA (2015) Finding our way: On the sharing and reuse of animal telemetry data in Australasia. Science of The Total Environment 534:79-84

3. Campbell HA, Urbano F, Davidson S, Dettki H, Cagnacci F (2016) A plea for standards in reporting data collected by animal-borne electronic devices. Animal Biotelemetry 4:1-4

4. Dwyer RG, Brooking C, Brimblecombe W, Campbell HA, Hunter J, Watts M, Franklin CE (2015) An open Web-based system for the analysis and sharing of animal tracking data. Animal Biotelemetry 3:1-11

5. Hussey NE, Kessel ST, Aarestrup K, Cooke SJ, Cowley PD, Fisk AT, Harcourt RG, Holland KN, Iverson SJ, Kocik JF, Mills Flemming JE, Whoriskey FG (2015) Aquatic animal telemetry: A panoramic window into
the underwater world. Science 348

6. [IMOS Animal Tracking (2016) The Australian Animal Tracking National Database Web Application. Accessed 30 August 2016.](https://animaltracking.aodn.org.au/)

7. Kays R, Crofoot MC, Jetz W, Wikelski M (2015) Terrestrial animal tracking as an eye on life and planet. Science 348

8. Kranstauber B, Cameron A, Weinzerl R, Fountain T, Tilak S, Wikelski M, Kays R (2011) The Movebank data model for animal tracking. Environmental Modelling & Software 26:834-835

9. [Payne J, Moustahfid H, Mayorga E, Branton R, Mihoff M, Bajona L (2013) A metadata convention for animal acoustic telemetry data.](http://ioostech.googlecode.com/files/AAT%20Metadata%20Convention%20v1.2.pdf)


<!--
### **Reference Disclaimer**

**This document should always be referenced as follows:**

[Moustahfid H., M. Weise, S. Simmons, B. Block, K. Holland, J. Ault, J. Kocik, D. Costa, S. T. Lindley, B. Mate, S. Hayes, C. M. Holbrook, A. Seitz, M. Arendt, J. Payne, B. Mahmoudi, C. Alexander, P. Moore, J. Price, D. Wilson. 2014. Meeting our Nation’s needs for biological and environmental monitoring: Strategic plan and recommendations for a National Telemetry Network (ATN) through U.S. IOOS. U.S. Department of Commerce, NOAA Technical Memorandum NMFS, NOAA-TM-NMFS-SWFSC-534, 7 p.](https://github.com/abirger/animal-telemetry/blob/master/doc/national_atn_sp_draft_final1.pdf?raw=true)

-->