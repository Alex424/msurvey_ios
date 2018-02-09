//
//  Constants.h
//  MADSurvey
//
//  Created by seniorcoder on 5/29/17.
//  Copyright © 2017 seniorcoder. All rights reserved.
//

//typedef NS_ENUM(NSUInteger, UINavigationType) {
//    UINavigationTypeMainNew,
//    UINavigationTypeMainExisting,
//    UINavigationTypeMainSetting,
//};

//#define kServerUrl                          @"http://192.168.56.5/MADSurvey2/"
#define kServerUrl                          @"http://madfixtures.net/madsurvey2/"

#define UINavigationIDMainNew               @"segue_main_new"
#define UINavigationIDMainExisting          @"segue_main_existing"
#define UINavigationIDMainSetting           @"segue_main_setting"

// existing to submit
#define UINavigationIDExistingSubmit        @"segue_existing_submit"
#define UINavigationIDExistingEdit          @"segue_existing_edit"
#define UINavigationIDEditSubmit            @"segue_edit_submit"
#define UINavigationIDEditDetails           @"segue_edit_details"
#define UINavigationIDEditLobbies           @"segue_edit_lobbies"
#define UINavigationIDEditBanks             @"segue_edit_banks"
#define UINavigationIDEditHallStations      @"segue_edit_hallstations"
#define UINavigationIDEditLanterns          @"segue_edit_lanterns"
#define UINavigationIDEditCars              @"segue_edit_cars"
#define UINavigationIDEditInteriorCars      @"segue_edit_interiorcars"
#define UINavigationIDEditHallEntrances     @"segue_edit_hallentrances"

#define UINavigationIDProjectsItemsSurvey   @"segue_projects_items_survey"
#define UINavigationIDProjectNotes          @"segue_project_notes"
#define UINavigationIDProjectPhotos         @"segue_project_photos"
#define UINavigationIDProjectJpbType        @"segue_project_jpb_type"
#define UINavigationIDProjectNumberBanks        @"segue_project_number_banks"
#define UINavigationIDProjectJobTypeLobbyPanels  @"segue_project_jobtype_lobby_panels"
#define UINavigationIDProjectNumberFloors   @"segue_project_number_floors"
#define UINavigationIDProjectNumberLobbyPanels  @"segue_project_number_lobby_panels"

//lobby
#define UINavigationIDLobbyLocation         @"segue_lobby_location"
#define UINavigationIDLobbyVisibility       @"segue_lobby_visibility"
#define UINavigationIDLobbyMeasurement      @"segue_lobby_measurement"
#define UINavigationIDLobbyFeatures         @"segue_lobby_features"
#define UINavigationIDLobbyNotes            @"segue_lobby_notes"
#define UINavigationIDLobbyPhotos           @"segue_lobby_photos"
//bank
#define UINavigationIDLobbyBankName         @"segue_lobby_bank"
#define UINavigationIDBankNumberCars        @"segue_bank_number_cars"
#define UINavigationIDBankNumberRisers      @"segue_bank_number_risers"
#define UINavigationIDBankNotes             @"segue_bank_notes"
#define UINavigationIDBankPhotos            @"segue_bank_photos"

// hall station
#define UINavigationIDBankFloorDescription      @"segue_bank_floor_description"
#define UINavigationIDHallStation      @"segue_hall_station_start"
#define UINavigationIDHallStationDescription    @"segue_hall_station_description"
#define UINavigationIDHallStationExistingList      @"segue_hall_station_start_existing_list"
#define UINavigationIDHallStationExistingListSameAsMeasure      @"segue_hall_station_start_existing_list_sameas_measure"
#define UINavigationIDHallStationExistingListSameAsLast      @"segue_hall_station_start_existing_list_sameas_last"
#define UINavigationIDHallStationSameAsMeasureReview      @"segue_hall_station_sameas_measure_review"
#define UINavigationIDHallStationNewDescription      @"segue_hall_station_new_desc"
#define UINavigationIDHallStationDescriptionMounting      @"segue_hall_station_desc_mounting"
#define UINavigationIDHallStationMountingMaterial      @"segue_hall_station_mounting_material"
#define UINavigationIDHallStationMaterialMeasure      @"segue_hall_station_material_measure"
#define UINavigationIDHallStationMeasureNotes      @"segue_hall_station_measure_notes"
#define UINavigationIDHallStationSameAsLastReview      @"segue_hall_station_sameaslast_review"
#define UINavigationIDHallStationNotesPhoto      @"segue_hall_station_notes_photo"

#define UINavigationIDHallStationReviewToDesc      @"segue_hall_station_review_desc"
#define UINavigationIDHallStationReviewToMount     @"segue_hall_station_review_mount"
#define UINavigationIDHallStationReviewToWall      @"segue_hall_station_review_wall"
#define UINavigationIDHallStationReviewToNotes     @"segue_hall_station_review_notes"

// hall station to lantern
#define UINavigationIDHallStationLantern      @"segue_hall_station_lantern"


// lantern
#define UINavigationIDLanternNumber         @"segue_lantern_number"
#define UINavigationIDLanternNumMain      @"segue_lantern_num_main"
#define UINavigationIDLanternMainList      @"segue_lantern_main_list"

#define UINavigationIDLanternSameAsMeasurement      @"segue_lantern_sameas_measure"
#define UINavigationIDLanternReview                @"segue_lantern_review"
#define UINavigationIDLanternDesc                  @"segue_lantern_desc"
#define UINavigationIDLanternMounting              @"segue_lantern_mounting"
#define UINavigationIDLanternWallMaterial      @"segue_lantern_wallmaterial"
#define UINavigationIDLanternMeasurements      @"segue_lantern_measurements"
#define UINavigationIDLanternNotes              @"segue_lantern_notes"
#define UINavigationIDLanternPhotos      @"segue_lantern_photos"

#define UINavigationIDLanternReviewToDesc       @"segue_lantern_review_desc"
#define UINavigationIDLanternReviewToMount      @"segue_lantern_review_mount"
#define UINavigationIDLanternReviewToWall       @"segue_lantern_review_wall"
#define UINavigationIDLanternReviewToNotes      @"segue_lantern_review_notes"

#define UINavigationIDLanternSameAsLastSameAsMeasurement       @"segue_lantern_sameaslast_sameasmeasure"

// lantern to car
#define UINavigationIDLanternCar      @"segue_lantern_car"

// car
#define UINavigationIDCarDesc              @"segue_car_desc"
#define UINavigationIDCarLicense              @"segue_car_license"
#define UINavigationIDCarType              @"segue_car_type"
#define UINavigationIDCarBackdoor              @"segue_car_backdoor"
#define UINavigationIDCarDoorCoinciding              @"segue_car_coinciding"
#define UINavigationIDCarPushbuttons              @"segue_car_pushbuttons"
#define UINavigationIDCarTypePushButtons        @"segue_cartype_pushbuttons"
#define UINavigationIDCarDoorMeasurements              @"segue_car_door_measurements"
#define UINavigationIDCarHandrail              @"segue_car_handrail"
#define UINavigationIDCarMeasurements              @"segue_car_measurements"
#define UINavigationIDCarNotes              @"segue_car_notes"
#define UINavigationIDCarPhotos              @"segue_car_photos"

// handrail to notes
#define UINavigationIDCarHandrailToNotes              @"segue_car_handrail_notes"

// car to car_cop number
#define UINavigationIDCarToCarCop      @"segue_car_carcop"

// car cop
#define UINavigationIDCarCopName                    @"segue_carcop_name"
#define UINavigationIDCarCopStyle                   @"segue_carcop_style"
#define UINavigationIDCarCopAppliedMeasurements     @"segue_carcop_applied_measure"
#define UINavigationIDCarCopSwingMeasurements       @"segue_carcop_swing_measure"
#define UINavigationIDCarCopNotesFromApplied                   @"segue_carcop_notes_appl"
#define UINavigationIDCarCopNotesFromSwing                   @"segue_carcop_notes_swing"
#define UINavigationIDCarCopPhotos                  @"segue_carcop_photos"

// car cop to car riding lantern
#define UINavigationIDCarCopToCarRiding                    @"segue_carcop_carriding"

// car riding lantern
#define UINavigationIDCarRidingLanternMounting                    @"segue_carriding_lantern_mounting"
#define UINavigationIDCarRidingLanternMeasure                    @"segue_carriding_lantern_measure"
#define UINavigationIDCarRidingLanternNotes                    @"segue_carriding_lantern_notes"
#define UINavigationIDCarRidingLanternPhotos                    @"segue_carriding_lantern_photos"

// car riding lantern to car separate pi
#define UINavigationIDCarRidingLanternSeparatePI     @"segue_carriding_lantern_separatepi"
#define UINavigationIDCarRidingToPI                    @"segue_carriding_pi"

// car separate pi
#define UINavigationIDCarSeparatePIMounting                    @"segue_carpi_mounting"
#define UINavigationIDCarSeparatePIMeasure                    @"segue_carpi_measure"
#define UINavigationIDCarSeparatePINotes                    @"segue_carpi_notes"
#define UINavigationIDCarSeparatePIPhotos                    @"segue_carpi_photos"

//interior
#define UITestInterior                      @"seque_test_interior"   ///test

#define UINavigationIDInteriorCarDescription    @"segue_interior_car_description"
#define UINavigationIDInteriorCarLicence    @"segue_interior_car_licence"
#define UINavigationIDInteriorCarBackDoor   @"segue_interior_car_back_door"
#define UINavigationIDInteriorCarCopy   @"segue_interior_car_copy"
#define UINavigationIDInteriorCarCopyUnique   @"segue_interior_car_copy_unique"
#define UINavigationIDInteriorCarExistingList   @"segue_interior_car_existing_list"
#define UINavigationIDInteriorCarExisting   @"segue_interior_car_existing"
#define UINavigationIDInteriorCarFlooring   @"segue_interior_car_flooring"
#define UINavigationIDInteriorCarTillerCover        @"segue_interior_car_tiller_cover"
#define UINavigationIDInteriorCarFloorHeight        @"segue_interior_car_floor_height"
#define UINavigationIDInteriorCarCeilingExhaustFan  @"segue_Interior_car_ceiling_exhaust_fan"
#define UINavigationIDInteriorCarCeilingExhaustFanLocation      @"segue_interior_car_ceiling_exhaust_fan_location"
#define UINavigationIDInteriorCarCeilingExhaustFanFrameType      @"segue_interior_car_ceiling_exhaust_fan_frametype"
#define UINavigationIDInteriorCarCeilingFrameType              @"segue_Interior_car_ceiling_frame_type"
#define UINavigationIDInteriorCarCeilingEscapeHatchLocation               @"segue_interior_car_ceiling_escape_hatch_location"
#define UINavigationIDInteriorCarType               @"segue_interior_car_type"
#define UINavigationIDInteriorCarStructure          @"segue_interior_car_structure"
#define UINavigationIDInteriorCarWallType           @"segue_interior_car_wall_type"
#define UINavigationIDInteriorCarOpening            @"segue_interior_car_opening"
#define UINavigationIDInteriorCarCenterMeasurement  @"segue_interior_car_center_measurement"
#define UINavigationIDInteriorCarSingleSideMeasurement      @"segue_interior_car_single_side_measurement"
#define UINavigationIDInteriorCarCenterMeasurementFrontReturnType   @"segue_centermeasure_frontreturntype"
#define UINavigationIDYesSlamPostType               @"segue_yes_slam_post_type"
#define UINavigationIDNoSlamPostType               @"segue_no_slam_post_type"
#define UINavigationIDInteriorCarSlamPostTypeA      @"segue_interior_car_slam_post_type_a"
#define UINavigationIDInteriorCarSlamPostTypeB      @"segue_interior_car_slam_post_type_b"
#define UINavigationIDInteriorCarSlamPostTypeC      @"segue_interior_car_slam_post_type_c"
#define UINavigationIDInteriorCarSlamPostTypeOther      @"segue_interior_car_slam_post_type_other"
#define UINavigationIDInteriorCarTypeAToFront        @"segue_interior_type_a_front"
#define UINavigationIDInteriorCarTypeBToFront        @"segue_interior_type_b_front"
#define UINavigationIDInteriorCarTypeCToFront        @"segue_interior_type_c_front"
#define UINavigationIDInteriorCarTypeOtherToFront        @"segue_interior_type_other_front"

#define UINavigationIDInteriorCarCenterReturnMeasurementsA          @"segue_interior_car_center_return_measurements_a"
#define UINavigationIDInteriorCarSingleSideReturnMeasurementsA          @"segue_interior_car_single_side_return_measurements_a"

#define UINavigationIDInteriorCarCenterReturnMeasurementsB          @"segue_interior_car_center_return_measurements_b"
#define UINavigationIDInteriorCarSingleSideReturnMeasurementsB          @"segue_interior_car_single_side_return_measurements_b"
#define UINavigationIDInteriorCarFrontReturnMeasurementsOther @"segue_interior_car_front_return_measurements_other"

#define UINavigationIDInteriorCarDoorSingleSideAToDoorType @"segue_singleside_a_doortype"
#define UINavigationIDInteriorCarDoorSingleSideBToDoorType @"segue_singleside_b_doortype"

#define UINavigationIDInteriorCenterATransom            @"segue_interior_center_a_transom"
#define UINavigationIDInteriorSingleATransom            @"segue_interior_single_a_transom"
#define UINavigationIDInteriorCenterBTransom            @"segue_interior_center_b_transom"
#define UINavigationIDInteriorSingleBTransom            @"segue_interior_single_b_transom"
#define UINavigationIDInteriorOtherTransom              @"segue_interior_other_transom"

// interior transom
#define UINavigationIDInteriorCarDoorOpeningDirection   @"segue_door_direction"
#define UINavigationIDInteriorCarDoorTypeToTransom1s              @"segue_interior_doortype_to_transom_1s"
#define UINavigationIDInteriorCarDoorTypeToTransom2s              @"segue_interior_doortype_to_transom_2s"

#define UINavigationIDInteriorCarTransom1s              @"segue_interior_transom_1s"
#define UINavigationIDInteriorCarTransom2s              @"segue_interior_transom_2s"
#define UINavigationIDInteriorCarTransomProfile1s              @"segue_interior_transom_profile_1s"
#define UINavigationIDInteriorCarTransomProfile2s              @"segue_interior_transom_profile_2s"
#define UINavigationIDInterior1sCarCopInstalled     @"segue_interior_1s_cop_installed"
#define UINavigationIDInterior2sCarCopInstalled     @"segue_interior_2s_cop_installed"
#define UINavigationIDInteriorDoorTypeLTransom     @"segue_interior_door_type_ltransom"
#define UINavigationIDInteriorOpeningDirectionLTransom     @"segue_interior_opening_direction_ltransom"
#define UINavigationIDInteriorHeader        @"segue_interior_header"
#define UINavigationIDInteriorFlat          @"segue_interior_flat"
#define UINavigationIDInteriorFlatCopInstalled          @"segue_interior_flat_cop_installed"
#define UINavigationIDInteriorCarMainCopReturn      @"segue_interior_car_MainCOP_return"
#define UINavigationIDInteriorCarCopInstalledToAuxCopReturn       @"segue_interior_car_copInstalled_to_AuxCOP_return"
#define UINavigationIDInteriorCarCopInstalledToTransomNotes       @"segue_interior_car_copInstalled_to_transomnotes"
#define UINavigationIDInteriorCarAuxCopReturn       @"segue_interior_car_AuxCOP_return"
#define UINavigationIDINteriorCarTransomNotes       @"segue_ interior_car_transom_notes"
#define UINavigationIDInteriorCarPhotos             @"segue_interior_car_transom_photos"
#define UINavigationIDINteriorCarBackWallClone      @"segue_interior_car_back_wall_clone"
#define UINavigationIDInteriorCarBackWall           @"segue_interior_car_back_wall"
#define UINavigationIDHallEntranceDoorType          @"segue_hall_entrance_door_type"
#define UINavigationIDDoorTypeDontKnow              @"segue_cop_door_type_dontknow"
#define UINavigationIDDoorTypeNormal                @"segue_cop_door_type_other"
#define UINavigationIDHallEntranceCopy              @"segue_hall_entrance_copy"
#define UINavigationIDHallEntranceCopyToDoorType    @"segue_hall_entrance_copy_door_type"
#define UINavigationIDHallEntranceExisting          @"segue_hall_entrance_existing"
#define UINavigationIDHallEntranceExistingToDoorType    @"segue_hall_entrance_existing_door_type"
#define UINavigationIDHallIntranceDirection          @"segue_hallintrance_direction_measurement"
#define UINavigationIDHallInstranceTransomMeasurementCenter     @"segue_hall_instance_transom_measurement_center"
#define UINavigationIDHallInstranceTransomMeasurement1s     @"segue_hall_instance_transom_measurement_1s"
#define UINavigationIDHallInstranceTransomMeasurement2s     @"segue_hall_instance_transom_measurement_2s"
#define UINavigationIDHallInstranceCenterNotes @"segue_hall_intrance_center_notes"
#define UINavigationIDHallInstrance1sNotes @"segue_hall_intrance_1s_notes"
#define UINavigationIDHallInstrance2sNotes @"segue_hall_intrance_2s_notes"
#define UINavigationIDHallInstrancePhotos       @"segue_hall_intrance_photos"
#define UINavigationIDHallEntranceSkipRest    @"segue_skip_rest"
#define UINavigationIDFinal     @"segue_final"
#define UINavigationIDFinal2     @"segue_final2"
#define UINavigationIDReview    @"segue_review"
/* - Navigation END */


// other constants
#define HallInstranceDoorTypeCenter     3
#define HallInstranceDoorType1s         2
#define HallInstranceDoorType2s         1

#define HallEntranceDoorOpeningDirectionLeft    1
#define HallEntranceDoorOpeningDirectionRight   2

#define UIListSelectionColor        [UIColor colorWithRed:237.0/255.0 green:47.0/255.0 blue:59.0/255.0 alpha:1.0]

#define KeyIsHelpGuideShown         @"is_help_shown"
#define KeyIsInfoShown              @"is_info_shown"

#define StatusSubmitted             @"submitted"

#define ProjectSettingUnitsInches       12
#define ProjectSettingUnitsCentimeters  13
#define ProjectJobTypeService           14
#define ProjectJobTypeMod               15
#define LobbyElevatorsVisible           16
#define LobbyElevatorsInvisible         17

#define LobbyLocationCACFRoom           @"CACF Room"
#define LobbyLocationFireRecallPanel    @"Fire Recall Panel"
#define LobbyLocationSecurityDesk       @"Security Desk"
#define LobbyLocationOther              @""

#define TerminalHallStation             @"TERMINAL Hall Station"
#define IntermediateHallStation         @"Intermediate Hall Station"
#define FireOperationStation            @"Fire Operation Station"
#define EPOStation                      @"EPO Statoin"
#define AccessStation                   @"Access Station"
#define SwingServiceHallStation         @"Swing Service Hall Station"
#define SwingServiceTerminalStation     @"Swing Service Terminal Station"

#define FlushMount                      @"Flush Mount"
#define SurfaceMount                    @"Surface Mount"

#define HallStationDryWall              @"Drywall"
#define HallStationPlaster              @"Plaster"
#define HallStationConcrete             @"Concrete"
#define HallStationBrick                @"Brick"
#define HallStationMarble               @"Marble"
#define HallStationGranit               @"Granite"
#define HallStationGlass                @"Glass"
#define HallStationTile                 @"Tile"
#define HallStationMetal                @"Metal"
#define HallStationWood                 @"Wood"

#define EmptyLanternRecordID            10000

#define LanternDescLantern              @"Lantern"
#define LanternDescPILanternCombo       @"PI Lantern Combo"
#define LanternDescPositionIndicator    @"Position Indicator"

#define CarPassengerElevator            @"Passenger Elevator"
#define CarServiceElevator              @"Service Elevator"
#define CarFreightElevator              @"Freight Elevator"

#define CarDoorCoinciding               @"coinciding"
#define CarDoorNonCoinciding            @"non_coinciding"

#define CopStyleApplied                 @"Applied"
#define CopStyleSwing                   @"Swing"
#define CopHingingSideLeft              @"Left"
#define CopHingingSideRight             @"Right"

#define FlooringCeramic                 @"Ceramic"
#define FlooringPorcelain               @"Porcelain"
#define FlooringRubberTiles             @"Rubber Tiles"
#define FlooringMarble                  @"Marble"
#define FlooringGranit                  @"Granite"

#define TypeOfCeilingFrameCeiling       @"Ceiling Mounted"
#define TypeOfCeilingFrameWall          @"Wall Mounted"

#define TypeOfCeilingMountingTypeBolted @"Bolted"
#define TypeOfCeilingMountingTypeWelded @"Welded"

#define TypeOfCarHydraulic              @"Hydraulic"
#define TypeOfCarGeared                 @"Geared"

#define BirdCageYes                     @"Yes"
#define BirdCageNo                      @"No"
#define BirdCageTBD                     @"TBD"

#define ThreePiece                      @"3 piece"
#define FivePiece                       @"5 piece"
#define Hybrid                          @"Hybrid"

#define TypeOfFrontReturnA              @"A"
#define TypeOfFrontReturnB              @"B"
#define TypeOfFrontReturnOther          @"Other"

#define TypeOfSlamPostA                 @"A"
#define TypeOfSlamPostB                 @"B"
#define TypeOfSlamPostC                 @"C"
#define TypeOfSlamPostOther             @"Other"

#define IsThereNewCopYes                @"YES"
#define IsThereNewCopNo                 @"NO"
#define IsThereNewCopDontKnow           @"DON'T KNOW"

#define SettingsKeyYourName             @"key_your_name"
#define SettingsKeyYourEmail            @"key_your_email"
#define SettingsKeyYourCompany          @"key_your_company"
#define SettingsKeyYourPhone            @"key_your_phone"
#define SettingsKeyYourState            @"key_your_state"
#define SettingsKeyUnitsLabel           @"key_units_label"
#define SettingsKeyReport               @"key_report_by_email"
