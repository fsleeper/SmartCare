CREATE TABLE appversion
(
   appinfoversion  varchar(30),
   "count"         bigint
);

CREATE TABLE callcenter
(
   casenumber                integer,
   actobjid                  integer,
   creationtime              varchar(23),
   casesource                varchar(25),
   casereasonlevel0          varchar(120),
   casereasonlevel1          varchar(120),
   casereasonlevel2          varchar(120),
   casereasonlevel3          varchar(120),
   casereasonlevel4          varchar(120),
   casetitle                 varchar(120),
   country                   varchar(18),
   language                  varchar(11),
   model                     varchar(40),
   lineup                    varchar(40),
   typeof1stinteraction      varchar(30),
   logcontent1stinteraction  varchar(36000)
);

CREATE TABLE country
(
   environmentinfo_country  varchar(20),
   "count"                  bigint
);

CREATE TABLE exportsongpalopenedbycountry
(
   isocountry        varchar(30),
   englishshortname  varchar(43),
   "count"           bigint
);

CREATE TABLE exportsongpalopenedbycountrybymonth
(
   date              varchar(24),
   isocountry        varchar(30),
   englishshortname  varchar(43),
   "count"           bigint
);

CREATE TABLE exportsongpalopenedbycountrybymonthtranspose
(
   isocountry  varchar(30),
   d201504     bigint,
   d201505     bigint,
   d201506     bigint,
   d201507     bigint,
   d201508     bigint,
   d201509     bigint,
   d201510     bigint
);

CREATE TABLE exportsongpalproduct_productbycountrymonth
(
   createdate   date,
   productname  varchar(21),
   "count"      bigint
);

CREATE TABLE exportsongpalproduct_productbymonth
(
   createdate   date,
   isocountry   varchar(4),
   productname  varchar(21),
   "count"      bigint
);

CREATE TABLE exportsongpalproduct_top10countrybymonth
(
   month             date,
   englishshortname  varchar(43),
   "count"           bigint
);

CREATE TABLE exportsongpalproduct_top10countrybyweek
(
   beginweek   date,
   isocountry  varchar(4),
   "count"     bigint
);

CREATE TABLE exportsongpalproductbydate
(
   createdate  date,
   "count"     bigint
);

CREATE TABLE exportsongpalversionsconnected
(
   modelname          varchar(30),
   connectedcount     bigint,
   notconnectedcount  bigint
);

CREATE TABLE exportsongpalversionsopened
(
   version  varchar(45),
   "count"  bigint
);

CREATE TABLE fh_sbs_get_camera_product_solutions
(
   partnerinfo_partnerid           varchar(36),
   rawappinfo                      varchar(200),
   appinfo_build_platform          varchar(30),
   appinfo_name                    varchar(30),
   appinfo_version                 varchar(30),
   rawenvironmentinfo              varchar(500),
   environmentinfo_country         varchar(20),
   environmentinfo_device_id       varchar(30),
   environmentinfo_language        varchar(36),
   environmentinfo_modelname       varchar(50),
   environmentinfo_os_version      varchar(50),
   environmentinfo_timezoneoffset  varchar(50),
   environmentinfo_region          varchar(30),
   rawcamerainfo                   varchar(500),
   camerainfo_cameracategory       varchar(30),
   camerainfo_firmwareversion      varchar(30),
   camerainfo_lensfirmwareversion  varchar(30),
   camerainfo_lensmodel            varchar(30),
   camerainfo_modelname            varchar(30),
   camerainfo_platformversion      varchar(30),
   camerainfo_pmcainfo             varchar(30),
   camerainfo_settinginfo          varchar(30),
   camerainfo_shootingmode         varchar(30),
   rawproductinfo                  varchar(500),
   productinfo_modelname           varchar(30),
   productinfo_model               varchar(30),
   pagination_category_id          varchar(60),
   pagination_parent_id            varchar(60),
   pagination_count                varchar(30),
   pagination_filter               varchar(60),
   pagination_start                varchar(30),
   objectkey                       varchar(200),
   size                            integer,
   createdatestring                varchar(75),
   id                              integer         identity(0, 1)
);

CREATE TABLE fh_sbs_get_categories
(
   partnerinfo_partnerid           varchar(36),
   rawappinfo                      varchar(200),
   appinfo_build_platform          varchar(30),
   appinfo_name                    varchar(30),
   appinfo_version                 varchar(30),
   rawenvironmentinfo              varchar(500),
   environmentinfo_country         varchar(20),
   environmentinfo_device_id       varchar(30),
   environmentinfo_language        varchar(36),
   environmentinfo_modelname       varchar(50),
   environmentinfo_os_version      varchar(50),
   environmentinfo_timezoneoffset  varchar(50),
   environmentinfo_region          varchar(30),
   rawcamerainfo                   varchar(500),
   camerainfo_cameracategory       varchar(30),
   camerainfo_firmwareversion      varchar(30),
   camerainfo_lensfirmwareversion  varchar(30),
   camerainfo_lensmodel            varchar(30),
   camerainfo_modelname            varchar(30),
   camerainfo_platformversion      varchar(30),
   camerainfo_pmcainfo             varchar(30),
   camerainfo_settinginfo          varchar(30),
   camerainfo_shootingmode         varchar(30),
   rawproductinfo                  varchar(500),
   productinfo_modelname           varchar(30),
   productinfo_model               varchar(30),
   pagination_category_id          varchar(60),
   pagination_parent_id            varchar(60),
   pagination_count                varchar(30),
   pagination_filter               varchar(60),
   pagination_start                varchar(30),
   objectkey                       varchar(200),
   size                            integer,
   createdatestring                varchar(75),
   id                              integer         identity(0, 1)
);

CREATE TABLE fh_sbs_get_products
(
   partnerinfo_partnerid           varchar(36),
   rawappinfo                      varchar(200),
   appinfo_build_platform          varchar(30),
   appinfo_name                    varchar(30),
   appinfo_version                 varchar(30),
   rawenvironmentinfo              varchar(500),
   environmentinfo_country         varchar(20),
   environmentinfo_device_id       varchar(30),
   environmentinfo_language        varchar(36),
   environmentinfo_modelname       varchar(50),
   environmentinfo_os_version      varchar(50),
   environmentinfo_timezoneoffset  varchar(50),
   environmentinfo_region          varchar(30),
   rawcamerainfo                   varchar(500),
   camerainfo_cameracategory       varchar(30),
   camerainfo_firmwareversion      varchar(30),
   camerainfo_lensfirmwareversion  varchar(30),
   camerainfo_lensmodel            varchar(30),
   camerainfo_modelname            varchar(30),
   camerainfo_platformversion      varchar(30),
   camerainfo_pmcainfo             varchar(30),
   camerainfo_settinginfo          varchar(30),
   camerainfo_shootingmode         varchar(30),
   rawproductinfo                  varchar(500),
   productinfo_modelname           varchar(30),
   productinfo_model               varchar(30),
   pagination_category_id          varchar(60),
   pagination_parent_id            varchar(60),
   pagination_count                varchar(30),
   pagination_filter               varchar(60),
   pagination_start                varchar(30),
   objectkey                       varchar(200),
   size                            integer,
   createdatestring                varchar(75),
   id                              integer         identity(0, 1)
);

CREATE TABLE fh_songpal_browse_solutions
(
   partnerinfo_partnerid                 varchar(36),
   appinfo_build_platform                varchar(30),
   appinfo_name                          varchar(30),
   appinfo_version                       varchar(30),
   appinfo_metadata_devicesetupscenario  varchar(30),
   environmentinfo_country               varchar(20),
   environmentinfo_device_id             varchar(30),
   environmentinfo_language              varchar(36),
   environmentinfo_modelname             varchar(50),
   environmentinfo_os_version            varchar(50),
   environmentinfo_timezoneoffset        integer,
   environmentinfo_region                varchar(30),
   productset                            varchar(1000),
   productinfo_modelname                 varchar(50),
   objectkey                             varchar(200),
   size                                  integer,
   createdatestring                      varchar(75),
   id                                    integer          identity(0, 1)
);

CREATE TABLE fh_unknown
(
   json  varchar(65535),
   id    integer           identity(0, 1)
);

CREATE TABLE isocountry
(
   englishshortname  varchar(43),
   alpha2code        varchar(2),
   alpha3code        varchar(3),
   numericcode       integer
);

CREATE TABLE isolanguage
(
   languagefamily  varchar(19),
   languagename    varchar(51),
   nativename      varchar(57),
   iso639_1        varchar(2),
   iso639_2_t      varchar(3),
   iso639_2_b      varchar(3),
   iso639_3        varchar(7),
   iso639_6        varchar(4),
   bnotes          varchar(75)
);

CREATE TABLE mobilemetrics
(
   eventtime                             timestamp,
   arrivaltime                           timestamp,
   event_type                            varchar(50),
   event_timestamp                       bigint,
   arrival_timestamp                     bigint,
   event_version                         varchar(15),
   application                           varchar(1200),
   application_app_id                    varchar(32),
   application_cognito_identity_pool_id  varchar(70),
   application_package_name              varchar(200),
   application_sdk                       varchar(120),
   application_sdk_name                  varchar(120),
   application_sdk_version               varchar(15),
   application_title                     varchar(120),
   application_version_name              varchar(50),
   application_version_code              varchar(15),
   client                                varchar(200),
   client_client_id                      varchar(36),
   client_cognito_id                     varchar(70),
   device                                varchar(1200),
   device_locale                         varchar(200),
   device_locale_code                    varchar(30),
   device_locale_country                 varchar(30),
   device_locale_language                varchar(30),
   device_make                           varchar(50),
   device_model                          varchar(50),
   device_platform                       varchar(200),
   device_platform_name                  varchar(50),
   device_platform_version               varchar(15),
   session                               varchar(200),
   session_session_id                    varchar(36),
   session_start_timestamp               bigint,
   attributes                            varchar(1200),
   metrics                               varchar(1200)
);

CREATE TABLE modelsfromset
(
   modelname  varchar(30)
);

CREATE TABLE partner_info
(
   partnerinfoid  integer        identity(0, 1)
   partnerid      varchar(36)
);

CREATE TABLE rawmobilemetrics
(
   event_type                            varchar(50),
   event_timestamp                       bigint,
   arrival_timestamp                     bigint,
   event_version                         varchar(15),
   application                           varchar(1200),
   application_app_id                    varchar(32),
   application_cognito_identity_pool_id  varchar(70),
   application_package_name              varchar(200),
   application_sdk                       varchar(120),
   application_sdk_name                  varchar(120),
   application_sdk_version               varchar(15),
   application_title                     varchar(120),
   application_version_name              varchar(50),
   application_version_code              varchar(15),
   client                                varchar(200),
   client_client_id                      varchar(36),
   client_cognito_id                     varchar(70),
   device                                varchar(1200),
   device_locale                         varchar(200),
   device_locale_code                    varchar(30),
   device_locale_country                 varchar(30),
   device_locale_language                varchar(30),
   device_make                           varchar(50),
   device_model                          varchar(50),
   device_platform                       varchar(200),
   device_platform_name                  varchar(50),
   device_platform_version               varchar(15),
   session                               varchar(200),
   session_session_id                    varchar(36),
   session_start_timestamp               bigint,
   attributes                            varchar(1200),
   metrics                               varchar(1200)
);

CREATE TABLE rawsbs
(
   id    integer           identity(0, 1),
   json  varchar(20000)
);

CREATE TABLE rawsongpal
(
   id    integer           identity(0, 1),
   json  varchar(20000)
);

CREATE TABLE request
(
   requestid         bigint,
   request           varchar(65000),
   receiveddatetime  timestamp
);

CREATE TABLE request_app_info
(
   requestid       bigint,
   build_platform  varchar(20),
   name            varchar(30),
   version         varchar(40)
);

CREATE TABLE request_device_status
(
   requestid                   bigint,
   brightness                  integer,
   isfromqrscan                boolean,
   modelname                   varchar(50),
   isnetworkconnected          boolean,
   areparentalcontrolsenabled  boolean,
   volume                      integer
);

CREATE TABLE request_displays
(
   requestid   integer,
   density     varchar(50000),
   densitydpi  varchar(50000),
   displayid   varchar(50000),
   height      varchar(50000),
   width       varchar(50000)
);

CREATE TABLE request_environment_info
(
   requestid       bigint,
   country         varchar(11),
   device_id       varchar(36),
   language        varchar(25),
   modelname       varchar(50),
   os_version      varchar(50),
   timezoneoffset  integer
);

CREATE TABLE request_installed_apps
(
   requestid  integer,
   label      varchar(50000),
   state      varchar(50000),
   datatype   varchar(50000)
);

CREATE TABLE request_networks
(
   requestid  integer,
   available  varchar(50000),
   connected  varchar(50000),
   subtype    varchar(50000),
   type       varchar(50000)
);

CREATE TABLE request_partner_info
(
   requestid  bigint,
   partnerid  varchar(36)
);

CREATE TABLE requestlog
(
   requestid  integer,
   request    varchar(50000),
   timestamp  timestamp
);

CREATE TABLE sbs
(
   partnerinfo_partnerid           varchar(36),
   appinfo_build_platform          varchar(30),
   appinfo_name                    varchar(30),
   appinfo_version                 varchar(30),
   environmentinfo_country         varchar(20),
   environmentinfo_device_id       varchar(30),
   environmentinfo_language        varchar(36),
   environmentinfo_modelname       varchar(50),
   environmentinfo_os_version      varchar(50),
   environmentinfo_timezoneoffset  varchar(50),
   environmentinfo_region          varchar(30),
   camerainfo_cameracategory       varchar(30),
   camerainfo_firmwareversion      varchar(30),
   camerainfo_lensfirmwareversion  varchar(30),
   camerainfo_lensmodel            varchar(30),
   camerainfo_modelname            varchar(30),
   camerainfo_platformversion      varchar(30),
   camerainfo_pmcainfo             varchar(30),
   camerainfo_settinginfo          varchar(30),
   camerainfo_shootingmode         varchar(30),
   productinfo_modelname           varchar(30),
   pagination_category_id          varchar(60),
   pagination_count                varchar(30),
   pagination_filter               varchar(60),
   pagination_start                varchar(30)
);

CREATE TABLE sbs_appinfo_build_platform
(
   appinfo_build_platform  varchar(7)
);

CREATE TABLE sbs_appinfo_build_platform_loaded
(
   appinfo_build_platform  varchar(45)
);

CREATE TABLE sbs_appinfo_name
(
   appinfo_name  varchar(10)
);

CREATE TABLE sbs_appinfo_name_loaded
(
   appinfo_name  varchar(45)
);

CREATE TABLE sbs_appinfo_version
(
   appinfo_version  varchar(45)
);

CREATE TABLE sbs_camerainfo_cameracategory
(
   camerainfo_cameracategory  varchar(45)
);

CREATE TABLE sbs_camerainfo_firmwareversion
(
   camerainfo_firmwareversion  varchar(45)
);

CREATE TABLE sbs_camerainfo_lensmodel
(
   camerainfo_lensmodel  varchar(45)
);

CREATE TABLE sbs_camerainfo_modelname
(
   camerainfo_modelname  varchar(45)
);

CREATE TABLE sbs_camerainfo_platformversion
(
   camerainfo_platformversion  varchar(45)
);

CREATE TABLE sbs_camerainfo_pmcainfo
(
   camerainfo_pmcainfo  varchar(45)
);

CREATE TABLE sbs_camerainfo_settinginfo
(
   camerainfo_settinginfo  varchar(45)
);

CREATE TABLE sbs_camerainfo_shootingmode
(
   camerainfo_shootingmode  varchar(45)
);

CREATE TABLE sbs_environmentinfo_country
(
   environmentinfo_country  varchar(30)
);

CREATE TABLE sbs_environmentinfo_device_id
(
   environmentinfo_device_id  varchar(45)
);

CREATE TABLE sbs_environmentinfo_language
(
   environmentinfo_language  varchar(54)
);

CREATE TABLE sbs_environmentinfo_modelname
(
   environmentinfo_modelname  varchar(75)
);

CREATE TABLE sbs_environmentinfo_os_version
(
   environmentinfo_os_version  varchar(75)
);

CREATE TABLE sbs_environmentinfo_region
(
   environmentinfo_region  varchar(45)
);

CREATE TABLE sbs_environmentinfo_timezoneoffset
(
   environmentinfo_timezoneoffset  varchar(75)
);

CREATE TABLE sbs_isvalid
(
   id                              integer,
   createdate                      timestamp,
   partnerid                       varchar(54),
   buildplatform                   varchar(45),
   appname                         varchar(45),
   appversion                      varchar(45),
   isocountry                      varchar(30),
   isolanguage                     varchar(54),
   deviceid                        varchar(45),
   modelname                       varchar(75),
   osversion                       varchar(75),
   timezoneoffset                  varchar(75),
   region                          varchar(45),
   camerainfo_cameracategory       varchar(45),
   camerainfo_firmwareversion      varchar(45),
   camerainfo_lensfirmwareversion  varchar(45),
   camerainfo_lensmodel            varchar(45),
   camerainfo_modelname            varchar(45),
   camerainfo_platformversion      varchar(45),
   camerainfo_pmcainfo             varchar(45),
   camerainfo_settinginfo          varchar(45),
   camerainfo_shootingmode         varchar(45),
   productinfo_modelname           varchar(45),
   productinfo_model               varchar(45)
);

CREATE TABLE sbs_pagination_category_id
(
   pagination_category_id  varchar(90)
);

CREATE TABLE sbs_pagination_count
(
   pagination_count  varchar(30)
);

CREATE TABLE sbs_pagination_filter
(
   pagination_count  varchar(30)
);

CREATE TABLE sbs_productinfo_model
(
   productinfo_model  varchar(45)
);

CREATE TABLE sbs_productinfo_modelname
(
   productinfo_modelname  varchar(45)
);

CREATE TABLE sbs_results
(
   isvalid                                 boolean,
   partnerinfo_partnerid                   varchar(54),
   rawappinfo                              varchar(200),
   appinfo_build_platform                  varchar(45),
   appinfo_name                            varchar(45),
   appinfo_version                         varchar(45),
   rawenvironmentinfo                      varchar(500),
   environmentinfo_country                 varchar(30),
   environmentinfo_device_id               varchar(45),
   environmentinfo_language                varchar(54),
   environmentinfo_modelname               varchar(75),
   environmentinfo_os_version              varchar(75),
   environmentinfo_timezoneoffset          varchar(75),
   environmentinfo_region                  varchar(45),
   rawcamerainfo                           varchar(500),
   camerainfo_cameracategory               varchar(45),
   camerainfo_firmwareversion              varchar(45),
   camerainfo_lensfirmwareversion          varchar(45),
   camerainfo_lensmodel                    varchar(45),
   camerainfo_modelname                    varchar(45),
   camerainfo_platformversion              varchar(45),
   camerainfo_pmcainfo                     varchar(45),
   camerainfo_settinginfo                  varchar(45),
   camerainfo_shootingmode                 varchar(45),
   rawproductinfo                          varchar(500),
   productinfo_modelname                   varchar(45),
   productinfo_model                       varchar(45),
   pagination_category_id                  varchar(90),
   pagination_count                        varchar(30),
   pagination_filter                       varchar(90),
   pagination_start                        varchar(45),
   objectkey                               varchar(200),
   size                                    integer,
   createdatestring                        timestamp,
   id                                      integer,
   isvalid_appinfo_build_platform          boolean,
   isvalid_appinfo_name                    boolean,
   isvalid_appinfo_version                 boolean,
   isvalid_environmentinfo_country         boolean,
   isvalid_environmentinfo_device_id       boolean,
   isvalid_environmentinfo_language        boolean,
   isvalid_environmentinfo_modelname       boolean,
   isvalid_environmentinfo_os_version      boolean,
   isvalid_environmentinfo_timezoneoffset  boolean,
   isvalid_environmentinfo_region          boolean
);

CREATE TABLE sbsclean
(
   partnerinfo_partnerid           varchar(36),
   appinfo_build_platform          varchar(30),
   appinfo_name                    varchar(30),
   appinfo_version                 varchar(30),
   environmentinfo_country         varchar(20),
   environmentinfo_device_id       varchar(30),
   environmentinfo_language        varchar(36),
   environmentinfo_modelname       varchar(50),
   environmentinfo_os_version      varchar(50),
   environmentinfo_timezoneoffset  varchar(50),
   environmentinfo_region          varchar(30),
   camerainfo_cameracategory       varchar(30),
   camerainfo_firmwareversion      varchar(30),
   camerainfo_lensfirmwareversion  varchar(30),
   camerainfo_lensmodel            varchar(30),
   camerainfo_modelname            varchar(30),
   camerainfo_platformversion      varchar(30),
   camerainfo_pmcainfo             varchar(30),
   camerainfo_settinginfo          varchar(30),
   camerainfo_shootingmode         varchar(30),
   productinfo_modelname           varchar(30),
   pagination_category_id          varchar(60),
   pagination_count                varchar(30),
   pagination_filter               varchar(60),
   pagination_start                varchar(30)
);

CREATE TABLE sbsprod
(
   partnerinfo_partnerid           varchar(54),
   rawappinfo                      varchar(200),
   appinfo_build_platform          varchar(45),
   appinfo_name                    varchar(45),
   appinfo_version                 varchar(45),
   rawenvironmentinfo              varchar(500),
   environmentinfo_country         varchar(30),
   environmentinfo_device_id       varchar(45),
   environmentinfo_language        varchar(54),
   environmentinfo_modelname       varchar(75),
   environmentinfo_os_version      varchar(75),
   environmentinfo_timezoneoffset  varchar(75),
   environmentinfo_region          varchar(45),
   rawcamerainfo                   varchar(500),
   camerainfo_cameracategory       varchar(45),
   camerainfo_firmwareversion      varchar(45),
   camerainfo_lensfirmwareversion  varchar(45),
   camerainfo_lensmodel            varchar(45),
   camerainfo_modelname            varchar(45),
   camerainfo_platformversion      varchar(45),
   camerainfo_pmcainfo             varchar(45),
   camerainfo_settinginfo          varchar(45),
   camerainfo_shootingmode         varchar(45),
   rawproductinfo                  varchar(500),
   productinfo_modelname           varchar(45),
   productinfo_model               varchar(45),
   pagination_category_id          varchar(90),
   pagination_count                varchar(30),
   pagination_filter               varchar(90),
   pagination_start                varchar(45),
   objectkey                       varchar(200),
   size                            integer,
   createdatestring                timestamp,
   id                              integer
);

CREATE TABLE sbsprodload
(
   partnerinfo_partnerid           varchar(36),
   rawappinfo                      varchar(200),
   appinfo_build_platform          varchar(30),
   appinfo_name                    varchar(30),
   appinfo_version                 varchar(30),
   rawenvironmentinfo              varchar(500),
   environmentinfo_country         varchar(20),
   environmentinfo_device_id       varchar(30),
   environmentinfo_language        varchar(36),
   environmentinfo_modelname       varchar(50),
   environmentinfo_os_version      varchar(50),
   environmentinfo_timezoneoffset  varchar(50),
   environmentinfo_region          varchar(30),
   rawcamerainfo                   varchar(500),
   camerainfo_cameracategory       varchar(30),
   camerainfo_firmwareversion      varchar(30),
   camerainfo_lensfirmwareversion  varchar(30),
   camerainfo_lensmodel            varchar(30),
   camerainfo_modelname            varchar(30),
   camerainfo_platformversion      varchar(30),
   camerainfo_pmcainfo             varchar(30),
   camerainfo_settinginfo          varchar(30),
   camerainfo_shootingmode         varchar(30),
   rawproductinfo                  varchar(500),
   productinfo_modelname           varchar(30),
   productinfo_model               varchar(30),
   pagination_category_id          varchar(60),
   pagination_count                varchar(30),
   pagination_filter               varchar(60),
   pagination_start                varchar(30),
   objectkey                       varchar(200),
   size                            integer,
   createdatestring                varchar(75),
   id                              integer         identity(0, 1)
);

CREATE TABLE seq1000
(
   i  integer
);

CREATE TABLE songpal
(
   id                                    integer,
   partnerinfo_partnerid                 varchar(54),
   appinfo_build_platform                varchar(45),
   appinfo_name                          varchar(45),
   appinfo_version                       varchar(45),
   appinfo_metadata_devicesetupscenario  varchar(45),
   environmentinfo_country               varchar(30),
   environmentinfo_device_id             varchar(45),
   environmentinfo_language              varchar(54),
   environmentinfo_modelname             varchar(75),
   environmentinfo_os_version            varchar(75),
   environmentinfo_timezoneoffset        integer,
   environmentinfo_region                varchar(45),
   productset                            varchar(1000),
   productinfo_modelname                 varchar(75),
   objectkey                             varchar(200),
   size                                  integer,
   createdate                            timestamp
);

CREATE TABLE songpal1026
(
   id                                    integer,
   partnerinfo_partnerid                 varchar(54),
   appinfo_build_platform                varchar(351),
   appinfo_name                          varchar(351),
   appinfo_version                       varchar(351),
   appinfo_metadata_devicesetupscenario  varchar(7),
   environmentinfo_country               varchar(351),
   environmentinfo_device_id             varchar(54),
   environmentinfo_language              varchar(351),
   environmentinfo_modelname             varchar(351),
   environmentinfo_os_version            varchar(351),
   environmentinfo_timezoneoffset        bigint,
   environmentinfo_region                varchar(4),
   productset                            varchar(300),
   createdate                            timestamp
);

CREATE TABLE songpal_appinfo_build_platform
(
   appinfo_build_platform  varchar(7)
);

CREATE TABLE songpal_appinfo_build_platform_loaded
(
   appinfo_build_platform  varchar(45)
);

CREATE TABLE songpal_appinfo_metadata_devicesetupscenario
(
   appinfo_metadata_devicesetupscenario  varchar(45)
);

CREATE TABLE songpal_appinfo_name
(
   appinfo_name  varchar(11)
);

CREATE TABLE songpal_appinfo_name_loaded
(
   appinfo_name  varchar(45)
);

CREATE TABLE songpal_appinfo_version
(
   appinfo_version  varchar(45)
);

CREATE TABLE songpal_appinfo_version_loaded
(
   appinfo_version  varchar(45)
);

CREATE TABLE songpal_environmentinfo_country
(
   environmentinfo_country  varchar(30)
);

CREATE TABLE songpal_environmentinfo_device_id
(
   environmentinfo_device_id  varchar(45)
);

CREATE TABLE songpal_environmentinfo_language
(
   environmentinfo_language  varchar(54)
);

CREATE TABLE songpal_environmentinfo_modelname
(
   environmentinfo_modelname  varchar(75)
);

CREATE TABLE songpal_environmentinfo_modelname_loaded
(
   environmentinfo_modelname  varchar(75)
);

CREATE TABLE songpal_environmentinfo_os_version
(
   environmentinfo_os_version  varchar(75)
);

CREATE TABLE songpal_environmentinfo_os_version_loaded
(
   environmentinfo_os_version  varchar(75)
);

CREATE TABLE songpal_environmentinfo_region
(
   environmentinfo_region  varchar(45)
);

CREATE TABLE songpal_environmentinfo_timezoneoffset
(
   environmentinfo_timezoneoffset  integer
);

CREATE TABLE songpal_isvalid
(
   partnerinfo_partnerid                 varchar(54),
   appinfo_build_platform                varchar(45),
   appinfo_name                          varchar(45),
   appinfo_version                       varchar(45),
   appinfo_metadata_devicesetupscenario  varchar(45),
   environmentinfo_country               varchar(30),
   environmentinfo_device_id             varchar(45),
   environmentinfo_language              varchar(54),
   environmentinfo_modelname             varchar(75),
   environmentinfo_os_version            varchar(75),
   environmentinfo_timezoneoffset        integer,
   environmentinfo_region                varchar(45),
   productinfo_modelname                 varchar(75),
   createdate                            timestamp,
   id                                    integer
);

CREATE TABLE songpal_models
(
   modelname  varchar(30)
);

CREATE TABLE songpal_results
(
   isvalid                                       integer,
   id                                            integer,
   partnerinfo_partnerid                         varchar(54),
   appinfo_build_platform                        varchar(45),
   appinfo_name                                  varchar(45),
   appinfo_version                               varchar(45),
   appinfo_metadata_devicesetupscenario          varchar(45),
   environmentinfo_country                       varchar(30),
   environmentinfo_device_id                     varchar(45),
   environmentinfo_language                      varchar(54),
   environmentinfo_modelname                     varchar(75),
   environmentinfo_os_version                    varchar(75),
   environmentinfo_timezoneoffset                integer,
   environmentinfo_region                        varchar(45),
   productset                                    varchar(1000),
   productinfo_modelname                         varchar(75),
   objectkey                                     varchar(200),
   size                                          integer,
   createdate                                    timestamp,
   isvalid_appinfo_build_platform                integer,
   isvalid_appinfo_name                          integer,
   isvalid_appinfo_version                       integer,
   isvalid_appinfo_metadata_devicesetupscenario  integer,
   isvalid_environmentinfo_country               integer,
   isvalid_environmentinfo_device_id             integer,
   isvalid_environmentinfo_language              integer,
   isvalid_environmentinfo_modelname             integer,
   isvalid_environmentinfo_os_version            integer,
   isvalid_environmentinfo_timezoneoffset        integer,
   isvalid_environmentinfo_region                integer
);

CREATE TABLE songpalclean
(
   id                                    integer          identity(0, 1),
   partnerinfo_partnerid                 varchar(36),
   appinfo_build_platform                varchar(30),
   appinfo_name                          varchar(30),
   appinfo_version                       varchar(30),
   appinfo_metadata_devicesetupscenario  varchar(30),
   environmentinfo_country               varchar(20),
   environmentinfo_device_id             varchar(30),
   environmentinfo_language              varchar(36),
   environmentinfo_modelname             varchar(50),
   environmentinfo_os_version            varchar(50),
   environmentinfo_timezoneoffset        integer,
   environmentinfo_region                varchar(30),
   productset                            varchar(1000)
);

CREATE TABLE songpaldev
(
   partnerinfo_partnerid                 varchar(36),
   appinfo_build_platform                varchar(30),
   appinfo_name                          varchar(30),
   appinfo_version                       varchar(30),
   appinfo_metadata_devicesetupscenario  varchar(30),
   environmentinfo_country               varchar(20),
   environmentinfo_device_id             varchar(30),
   environmentinfo_language              varchar(36),
   environmentinfo_modelname             varchar(50),
   environmentinfo_os_version            varchar(50),
   environmentinfo_timezoneoffset        integer,
   environmentinfo_region                varchar(30),
   productset                            varchar(1000),
   productinfo_modelname                 varchar(50),
   id                                    integer          identity(0, 1)
);

CREATE TABLE songpaldevproductset
(
   id         integer,
   modelname  varchar(30),
   connected  boolean
);

CREATE TABLE songpalload
(
   partnerinfo_partnerid                 varchar(36),
   appinfo_build_platform                varchar(30),
   appinfo_name                          varchar(30),
   appinfo_version                       varchar(30),
   appinfo_metadata_devicesetupscenario  varchar(30),
   environmentinfo_country               varchar(20),
   environmentinfo_device_id             varchar(30),
   environmentinfo_language              varchar(36),
   environmentinfo_modelname             varchar(50),
   environmentinfo_os_version            varchar(50),
   environmentinfo_timezoneoffset        integer,
   environmentinfo_region                varchar(30),
   productset                            varchar(1000),
   productinfo_modelname                 varchar(50),
   objectkey                             varchar(200),
   size                                  integer,
   createdatestring                      varchar(75),
   id                                    integer          identity(0, 1)
);

CREATE TABLE songpalload1026
(
   dynamocontainer_name                  varchar(10),
   dynamocontainer_version               varchar(10),
   dynamocontainer_token                 varchar(127),
   dynamocontainer_timestamp             bigint,
   partnerinfo_partnerid                 varchar(36),
   appinfo_build_platform                varchar(234),
   appinfo_name                          varchar(234),
   appinfo_version                       varchar(234),
   appinfo_metadata_devicesetupscenario  varchar(5),
   environmentinfo_country               varchar(234),
   environmentinfo_language              varchar(234),
   environmentinfo_modelname             varchar(234),
   environmentinfo_os_version            varchar(234),
   environmentinfo_timezoneoffset        bigint,
   environmentinfo_region                varchar(3),
   environmentinfo_device_id             varchar(36),
   productset                            varchar(300),
   id                                    integer         identity(0, 1)
);

CREATE TABLE songpalproduct
(
   partnerinfo_partnerid           varchar(36),
   appinfo_build_platform          varchar(7),
   appinfo_name                    varchar(11),
   appinfo_version                 varchar(51),
   environmentinfo_country         varchar(3),
   environmentinfo_language        varchar(3),
   environmentinfo_modelname       varchar(33),
   environmentinfo_os_version      varchar(69),
   environmentinfo_timezoneoffset  bigint,
   environmentinfo_region          varchar(3),
   environmentinfo_device_id       varchar(36),
   product_productname             varchar(14),
   product_productnamenormalized   varchar(13),
   objectkey                       varchar(81),
   createdate                      varchar(29),
   id                              integer        identity(0, 1)
);

CREATE TABLE songpalproduct_clean
(
   id                     integer,
   createdate             timestamp,
   partnerid              varchar(54),
   buildplatform          varchar(10),
   appname                varchar(16),
   appversion             varchar(76),
   isocountry             varchar(4),
   isolanguage            varchar(4),
   modelname              varchar(49),
   osversion              varchar(103),
   timezoneoffset         bigint,
   region                 varchar(4),
   deviceid               varchar(54),
   productname            varchar(21),
   productnamenormalized  varchar(19),
   objectkey              varchar(81)
);

CREATE TABLE songpalproductset
(
   id               integer,
   modelname        varchar(30),
   connected        boolean,
   sourceconnected  varchar(25),
   isvalid          boolean
);

CREATE TABLE songpalproductset1026
(
   modelname           varchar(234),
   name                varchar(8),
   productid           varchar(8),
   metadata_connected  varchar(5),
   songpalid           integer,
   id                  integer         identity(0, 1)
);

CREATE TABLE songpalproductset_isvalid
(
   id         integer,
   modelname  varchar(30),
   connected  boolean
);

CREATE TABLE songpalproductset_valid
(
   id         integer,
   modelname  varchar(30),
   connected  boolean
);

CREATE TABLE songpalproductsetclean
(
   id         integer,
   modelname  varchar(30),
   connected  boolean
);


COMMIT;
