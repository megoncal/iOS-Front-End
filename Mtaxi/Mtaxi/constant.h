//#ifdef DEBUG
#define cloudBackendURL @"http://localhost:8080/moovt/"
//#else
//#define cloudBackendURL @"http://cloud-backend.moovt.com:8080/moovt/"
//#endif

#define signInURL [cloudBackendURL stringByAppendingString:@"login/authenticateUser"]
#define carTypeURL [cloudBackendURL stringByAppendingString:@"driver/getCarTypeEnum"] 
#define locationSearchURL [cloudBackendURL stringByAppendingString:@"location/search"]
#define getMostFrequentLocationsURL [cloudBackendURL stringByAppendingString:@"location/getMostFrequentLocations"]
#define createRideURL [cloudBackendURL stringByAppendingString:@"ride/createRide"]
#define allRidesURL [cloudBackendURL stringByAppendingString:@"ride/retrievePassengerRides"]
#define rateRideURL [cloudBackendURL stringByAppendingString:@"ride/closeRide"]
#define unassignedRidesURL [cloudBackendURL stringByAppendingString:@"ride/retrieveUnassignedRideInServedArea"]
#define driverRidesURL [cloudBackendURL stringByAppendingString:@"ride/RetrieveAssignedRides"]
#define assignRideURL [cloudBackendURL stringByAppendingString:@"ride/assignRideToDriver"]
#define cancelRideURL [cloudBackendURL stringByAppendingString:@"ride/cancelRide"]
#define retrieveAllRidesURL [cloudBackendURL stringByAppendingString:@"ride/retrievePassengerRides"]
#define loggedUserDetailsURL [cloudBackendURL stringByAppendingString:@"user/retrieveLoggedUserDetails"]
#define signUpURL [cloudBackendURL stringByAppendingString:@"user/createUser"]
#define updateLoggedUserURL [cloudBackendURL stringByAppendingString:@"user/updateLoggedUser"]
