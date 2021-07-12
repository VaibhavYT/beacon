import 'dart:ffi';

class Queries {
  String registerUser(String name, String email, String password) {
    return '''
        mutation{
          register(user: {name: "$name", credentials: {email: "$email", password: "$password"}})
          {
            _id
            name
            email
          }
        }
    ''';
  }

  String loginAsGuest(String name) {
    return '''
        mutation{
          register(user: {name: "$name"})
          {
            _id
            name
          }
        }
    ''';
  }

  String loginUser(String email, String password) {
    return '''
        mutation{
          login(credentials: {email: "$email", password: "$password"})
        }
    ''';
  }

  String loginUsingID(String id) {
    return '''
        mutation{
          login(id: "$id")
        }
    ''';
  }

  String fetchUserInfo() {
    return '''
      query{
        me{
          _id
          email
          name
          beacons{
            _id
            leader {
              _id
              name
            }
            followers{
              _id
              name
            }
          }
        }
      }
    ''';
  }

  String createBeacon(String title, int expiresAt) {
    return '''
        mutation{
          createBeacon(beacon: {title: "$title", expiresAt: $expiresAt})
          {
            _id
            title
            shortcode
            leader {
              _id
              name
            }
            followers {
              _id
              name
            }
            startsAt
            expiresAt
          }
        }
    ''';
  }

  String updateLeaderLoc(String id, String lat, String lon) {
    return '''
        mutation {
            updateLocation(id: "$id", location: {lat: "$lat", lon:"$lon"}){
              lat
              lon
            }
        }
    ''';
  }

  String joinBeacon(String shortcode) {
    return '''
        mutation {
            joinBeacon(shortcode: "$shortcode"){
              _id
              title
              shortcode
              leader {
                name
                location {
                  lat
                  lon
                }
              }
              followers {
                _id
                name
              }
              startsAt
              expiresAt
            }
        }
    ''';
  }

  String fetchLocationUpdates(String id) {
    return '''
        subscription {
            beaconLocation (id: "$id") {
              lat
              lon
            }
        }
    ''';
  }

  String fetchFollowerUpdates(String id) {
    return '''
        subscription {
            beaconLocation (id: "$id") {
              lat
              lon
            }
        }
    ''';
  }
}
